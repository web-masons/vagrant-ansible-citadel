#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "Configuring the Server:"
    export DEBIAN_FRONTEND=noninteractive

    echo "  1/7. Update apt"
    apt-get update -qq &> /dev/null || exit 1

    echo "  2/7. Install python-software-properties python-apt python-pycurl"
    apt-get install -qq python-software-properties python-apt python-pycurl &> /dev/null || exit 1

    echo "  3/7. Add Ansible PPA"
    apt-add-repository ppa:ansible/ansible &> /dev/null || exit 1

    echo "  4/7. Update apt to grab new PPA info for Ansible"
    apt-get update -qq &> /dev/null || exit 1

    echo "  5/7. Install Ansible"
    apt-get install -qq ansible &> /dev/null || exit 1

    echo "  6/7. Remove auto-installed packages that are no longer required"
    apt-get -y autoremove &> /dev/null || exit 1

    echo "  7/7. Upgrading all packages"
    apt-get -y dist-upgrade &> /dev/null || exit 1

fi

cd /vagrant/ansible
ansible-playbook localhost/vagrant.yml --inventory-file=inventory/vagrant.ini --connection=local
