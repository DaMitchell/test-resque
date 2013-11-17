class pcntl (
    $version = '5.3.10'
)
{
    package { ['make', 'php5-dev'] :
        ensure => "installed",
    }

    $tempDirectory = '/tmp/pcntl-dev'
    $zipName = "php-${version}"

    file { $tempDirectory :
        ensure => 'directory'
    }

    exec { 'wget-source' :
        command => "wget -O ${zipName}.tar.gz http://php.net/get/php-${version}.tar.gz/from/this/mirror",
        cwd => $tempDirectory,
        require => File[$tempDirectory],
    }

    exec { 'extract-source' :
        command => "tar -zxvf ${zipName}.tar.gz",
        cwd => $tempDirectory,
        require => Exec['wget-source'],
    }

    exec { 'phpize-configure-make-install' :
        command => 'phpize && ./configure && make install',
        cwd => "${tempDirectory}/${zipName}/ext/pcntl",
        require => [Package['php5-dev'], Exec['extract-source']],
    }

    file { '/etc/php5/conf.d/pcntl.ini':
        source => "puppet:///modules/pcntl/pcntl.ini",
        require => Exec['phpize-configure-make-install'],
    }
}