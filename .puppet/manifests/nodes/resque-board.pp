node /^resque-board.*/
{
    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

    exec { 'apt-get update':
        command => 'apt-get update --fix-missing',
    }

    Exec["apt-get update"] -> Package <| |>

    package { ['git'] :
        ensure => "installed",
    }

    class { 'apache':
    }

    class { 'php': }

    php::module { "curl": }
    php::module { "mcrypt": }

    #pull down resqueboard
    $resqueBoardDirectory = '/usr/lib/resqueboard'

    file { $resqueBoardDirectory :
        ensure => 'directory',
    }

    exec { 'clone-resqueboard':
        command => 'git clone https://github.com/kamisama/ResqueBoard.git',
        cwd => $resqueBoardDirectory,
        creates => "${resqueBoardDirectory}/ResqueBoard/composer.json",
        require => [File[$resqueBoardDirectory], Package['git']],
    }

    #get composer
    exec{ 'get-composer':
        command => 'curl -sS https://getcomposer.org/installer | php',
        cwd => "${resqueBoardDirectory}/ResqueBoard",
        creates => "${resqueBoardDirectory}/ResqueBoard/composer.phar",
        require => [Exec['clone-resqueboard'], Package['curl'], Package['php']],
    }
    #run a composer install
    exec{ 'composer-install':
        command => 'php ./composer.phar install --no-dev',
        cwd => "${resqueBoardDirectory}/ResqueBoard",
        creates => "${resqueBoardDirectory}/ResqueBoard/vendor/autoload.php",
        require => [Exec['get-composer']],
    }

#    exec{ 'composer-update':
#        command => 'php ./composer.phar update',
#        cwd => "${resqueBoardDirectory}/ResqueBoard",
#        onlyif => ["test -f ${resqueBoardDirectory}/ResqueBoard/composer.phar"],
#    }

    #install mongo
    class { 'mongodb': }

    #install node
    class { 'nodejs':
        version => 'v0.10.22',
    }

    #install cube
    package { 'cube':
        ensure   => present,
        provider => 'npm',
    }
    #update cube config

    #install apache
    #setup vhost


}