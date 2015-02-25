# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # Get rid of that pesky "stdin: is not a tty" error
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Hashicorp standard Ubuntu 12.04 LTS 64-bit box
    config.vm.box = "hashicorp/precise64"

    # Forward SSH keys to the Guest VM
    config.ssh.forward_agent = true

    # Change some default options for better experience, up memory and change VM name
    config.vm.provider :virtualbox do |vb|
        # Sets VM name equal to the parent directory + millis when started
        vb.name = Dir.pwd().split("/")[-1] + "-" + Time.now.to_f.to_i.to_s
        vb.memory = 2048
    end

    # We're going to use the shell provider to install Ansible so that we can run
    # it within the Guest VM, not outside
    config.vm.provision :shell,
        :privileged => true,
        :keep_color => true,
        :inline => "export PYTHONUNBUFFERED=1 && export ANSIBLE_FORCE_COLOR=1 && cd /vagrant/ansible/localhost && ./provision.sh"
end

