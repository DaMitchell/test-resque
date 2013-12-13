node /^worker.*/
{
    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

    exec { 'apt-get update':
        command => 'apt-get update --fix-missing',
    }

    Exec["apt-get update"] -> Package <| |>

    package { ['make', 'php5-dev', 'git', 'curl'] :
        ensure => "installed",
    }

    class { 'php': }

    class { 'pcntl': }
    class { 'phpredis': }

    $fresquePath = '/usr/lib'

    exec { 'clone-fresque':
        command => 'git clone git://github.com/kamisama/Fresque.git',
        cwd => $fresquePath,
        creates => "${fresquePath}/Fresque/fresque",
        require => [Package['git']],
    }

    file { '/usr/bin/fresque':
        ensure => link,
        target => "${fresquePath}/Fresque/fresque",
        require => [Exec['clone-fresque']],
    }

    #get composer
    exec{ 'get-composer':
        command => 'curl -sS https://getcomposer.org/installer | php',
        cwd => "${fresquePath}/Fresque",
        creates => "${fresquePath}/Fresque/composer.phar",
        require => [Exec['clone-fresque'], Package['curl'], Package['php']],
    }

    #run a composer install
    exec{ 'composer-install':
        command => 'php ./composer.phar install --no-dev',
        cwd => "${fresquePath}/Fresque",
        creates => "${fresquePath}/Fresque/vendor/autoload.php",
        require => [Exec['get-composer']],
    }
}