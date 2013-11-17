node /^worker.*/
{
    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

    exec { 'apt-get update':
        command => 'apt-get update --fix-missing',
    }

    Exec["apt-get update"] -> Package <| |>

    package { ['make', 'php5-dev'] :
        ensure => "installed",
    }

    class { 'php': }

    class { 'pcntl': }
    class { 'phpredis': }
}