node /^redis-server.*/
{
    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

    exec { 'apt-get update':
        command => 'apt-get update --fix-missing',
    }

    Exec["apt-get update"] -> Package <| |>

    class { "redis":
        version => "latest",
        source => "puppet:///modules/redis-conf/redis.conf"
    }

    class { 'nodejs':
        version => 'v0.10.22',
    }

    package { 'redis-commander':
        ensure   => present,
        provider => 'npm',
    }

    #exec { 'run-redis-commander':
    #    command => 'redis-commander',
    #    path => '/usr/local/node/node-v0.10.22/bin/',
    #    require => Package['redis-commander'],
    #}
}