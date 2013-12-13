class pcntl (
    $version = '5.3.10'
)
{
    $tempDirectory = '/tmp/pcntl-dev'
    $zipName = "php-${version}"

    file { $tempDirectory :
        ensure => 'directory'
    }

    exec { 'pcntl-wget-source' :
        command => "wget -O ${zipName}.tar.gz http://php.net/get/php-${version}.tar.gz/from/this/mirror",
        cwd => $tempDirectory,
        require => File[$tempDirectory],
    }

    exec { 'pcntl-extract-source' :
        command => "tar -zxvf ${zipName}.tar.gz",
        cwd => $tempDirectory,
        require => Exec['pcntl-wget-source'],
    }

    exec { 'pcntl-phpize-configure-make-install' :
        command => 'phpize && ./configure && make install',
        cwd => "${tempDirectory}/${zipName}/ext/pcntl",
        require => [Package['make'], Package['php5-dev'], Exec['pcntl-extract-source']],
    }

    file { '/etc/php5/conf.d/pcntl.ini':
        source => "puppet:///modules/pcntl/pcntl.ini",
        require => Exec['pcntl-phpize-configure-make-install'],
    }
}