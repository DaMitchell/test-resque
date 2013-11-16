node /^worker.*/
{
    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

    exec { 'apt-get update':
        command => 'apt-get update --fix-missing',
    }

    Exec["apt-get update"] -> Package <| |>

    class { 'php': }
}