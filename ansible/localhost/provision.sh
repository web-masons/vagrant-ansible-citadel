#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "Installing Ansible:"
    export DEBIAN_FRONTEND=noninteractive

    echo "  1/5. Update apt"
    apt-get update -qq

#    echo "  2/5. Install software-properties-common"
#    apt-get install -qq software-properties-common &> /dev/null || exit 1

    echo "  2/5. Install python-software-properties"
    apt-get install -qq python-software-properties &> /dev/null || exit 1

    echo "  3/5. Add Ansible PPA"
    apt-add-repository ppa:ansible/ansible &> /dev/null || exit 1

    echo "  4/5. Update apt to grab new PPA info for Ansible"
    apt-get update -qq

    echo "  5/5. Install Ansible"
    apt-get install -qq ansible &> /dev/null || exit 1

    echo "Ansible installed"
fi

cd /vagrant/ansible
ansible-playbook localhost/vagrant.yml --inventory-file=inventory/vagrant.ini --connection=local

# Install Geerlinguy's Firewall role since we'll use it for port forwarding and basic firewall setup
# At some point convert this over to using something like "ansible-galaxy install -r requirements.yml"
# instead -- e.g. http://docs.ansible.com/galaxy.html

# I hate that we have to use force to reinstall, the galaxy command isn't idempotent
# sudo ansible-galaxy install --force -r localhost/galaxy-requirements.yml