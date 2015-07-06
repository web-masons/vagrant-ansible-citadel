# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Get rid of that pesky "stdin: is not a tty" error
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Hashicorp standard Ubuntu 12.04 LTS 64-bit box
    config.vm.define "precise64", autostart: false do |precise64|
      precise64.vm.box = "hashicorp/precise64"

      # Change some default options for better experience
      precise64.vm.provider :virtualbox do |vb|
          # Sets VM name + millis when started
          vb.name = "ansible-citadel-precise64" + "-" + Time.now.to_f.to_i.to_s

          # Allocate memory to the box
          vb.memory = 1024

          # Prevent VirtualBox from using up all of your CPU, limiting to 25% of CPU
          vb.customize ["modifyvm", :id, "--cpuexecutioncap", "25"]
      end
    end

    # Standard Ubuntu 14.04 LTS 64-bit box
    config.vm.define "trusty64", primary: true do |trusty64|
      trusty64.vm.box = "ubuntu/trusty64"

      # Change some default options for better experience
      trusty64.vm.provider :virtualbox do |vb|
          # Sets VM name + millis when started
          vb.name = "ansible-citadel-trusty64" + "-" + Time.now.to_f.to_i.to_s

          # Allocate memory to the box
          vb.memory = 1024

          # Prevent VirtualBox from using up all of your CPU, limiting to 25% of CPU
          vb.customize ["modifyvm", :id, "--cpuexecutioncap", "25"]
      end
    end

    # We're going to use the shell provider to install Ansible so that we can run
    # it within the Guest VM, not outside
    config.vm.provision :shell,
        :privileged => true,
        :keep_color => true,
        :inline => "export PYTHONUNBUFFERED=1 && export ANSIBLE_FORCE_COLOR=1 && cd /vagrant/ansible/localhost && ./provision.sh"
end
