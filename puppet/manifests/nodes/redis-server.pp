node /^redis-server.*/
{
    class { "redis":
        version => "latest"
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