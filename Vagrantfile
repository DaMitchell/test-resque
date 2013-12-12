# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    nodes = [
        {:hostname => 'redis-server', :ip => '192.168.2.10', :ram => 512},
        #{:hostname => 'resque-board', :ip => '192.168.2.15', :ram => 320},

        {:hostname => 'worker-a', :ip => '192.168.2.20', :ram => 512}
    ]

    nodes.each do |node|

        config.vm.define node[:hostname] do |node_config|

            memory = node[:ram] ? node[:ram] : 320;

            config.vm.provider 'virtualbox' do |vb|
                vb.customize [
                    'modifyvm', :id,
                    '--memory', memory.to_s
                ]

            end

            node_config.vm.box = 'precise64'
            node_config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

            node_config.vm.hostname = node[:hostname]
            node_config.vm.network 'private_network', ip: node[:ip]

            node_config.vm.provision :puppet do |puppet|
                puppet.facter = {
                    "fqdn" => node[:hostname],
            	}
                puppet.manifests_path = 'puppet/manifests'
                puppet.module_path = 'puppet/modules'
            end
        end
    end
end