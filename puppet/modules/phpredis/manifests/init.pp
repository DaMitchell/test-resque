class phpredis (
    $version = '2.2.4'
)
{
    $tempDirectory = '/tmp/phpredis-dev'
    $zipName = "phpredis-${version}"

    file { $tempDirectory :
        ensure => 'directory'
    }

    exec { 'phpredis-wget-source' :
        command => "wget -O ${zipName}.tar.gz https://github.com/nicolasff/phpredis/archive/${version}.tar.gz",
        cwd => $tempDirectory,
        require => File[$tempDirectory],
    }

    exec { 'phpredis-extract-source' :
        command => "tar -zxvf ${zipName}.tar.gz",
        cwd => $tempDirectory,
        require => Exec['phpredis-wget-source'],
    }

    exec { 'phpredis-phpize-configure-make-install' :
        command => 'phpize && ./configure && make install',
        cwd => "${tempDirectory}/${zipName}",
        require => [Package['make'], Package['php5-dev'], Exec['phpredis-extract-source']],
    }

    file { '/etc/php5/conf.d/redis.ini':
        source => "puppet:///modules/phpredis/redis.ini",
        require => Exec['phpredis-phpize-configure-make-install'],
    }
}