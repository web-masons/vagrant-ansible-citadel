# Vagrant Ansible Citadel

This project contains a Vagrant based development environment using Ansible. As someone who works in all kinds of different
development environments, I hate when the collide with other projects I might be working on... Here's looking at you Ruby!
This got me into the practice of creating development environments in VMs and never allowing myself to install them on
my MacBook. Less pollution, less conflict. Well, when I decided to give Ansible a spin, I decided I wanted to be able to
do the same thing. So, I created this template that I use for any infrastructure project I need to maintain. I use it as
a seed project for every project / infrastructure that I need to maintain, and then grow it from there.

This project should work successfully on any Linux, Mac or Windows environment capable of running Vagrant and VirtualBox.

By default, this environment installs the AWS CLI and Boto. If you would like to change/update/edit what is installed
by default as your base environment, just edit `ansible/localhost/base/tasks/main.yml`

## Installation

### Dependencies

To use this development environment, you must have Vagrant and VirtualBox installed.

We also recommend using the vagrant plugin "vagrant-vbguest" to prevent the VirtualBox guest additions from getting
out of sync.

```bash
$ vagrant plugin install vagrant-vbguest
```

### Setup

To begin using the environment, you will need to clone it from GitHub. Note, this project uses
submodules, so you will need to clone the repository using the recursive parameter as follows.

```bash
$ git clone --recursive git@github.com:oakensoul/vagrant-ansible-citadel.git
```

If you forget to clone using --recursive, you will need to run the following `git submodule` commands:
```bash
$ git submodule init
$ git submodule update --recursive
```

### Ansible Galaxy

If you have any roles you wish to install inside your vagrant environment from Ansible Galaxy, place them in the
`ansible/localhost/galaxy-requirements.yml` file. For example, if you wished to install GeerlingGuy's Firewall role,
place a section like the following into the yml file.

```bash
# Install GeerlingGuy's Firewall Role
#   https://galaxy.ansible.com/list#/roles/451
#   https://github.com/geerlingguy/ansible-role-firewall
- src: geerlingguy.firewall
```

### Vagrant

Once you have the repository cloned, you need only spin up your Vagrant environment. If you need information about
how to use Vagrant, please see the http://vagrantup.com website. For this documentation, we'll assume you have at
least entry level Vagrant knowledge. If you don't, feel free to use the Issues section of the repository to ask questions.

In order to get Ansible installed inside the Guest VM, you will notice inside the Vagrantfile a section using the
shell provisioner. In case you're curious, we've used this approach to install Ansible as provided by
[Rob Allen](https://github.com/akrabat) in his
[blog post](http://akrabat.com/computing/provisioning-with-ansible-within-the-vagrant-guest/) about such things.

As he mentions, the reason for this is that we don't want to rely on the Host machine to have Ansible installed, that
dirties up your machine with even more stuff to maintain... and it doesn't follow the Infrastructure as Code requirement
of our team!

One thing to note, your project directory is mapped inside the Guest VM in the folder `/vagrant`.

## Automation and Development

Now that you've got your development environment, simply ssh into the Guest VM and off you go. To customize your
dev environment use the included Ansible playbooks, or add new sub modules under the ansible/playbooks folder. If
you've never used Ansible, we would recommend you pause and run through some internet learning on Ansible.

* http://www.ansible.com/get-started
* http://www.ansible.com/resources
* http://docs.ansible.com/intro_getting_started.html

### Create your inventory files

We've copied the most recent (at the time of creation) version of the ec2 dynamic inventory scripts mentioned in the
Ansible documentation. [Example EC2 External Inventory Script](http://docs.ansible.com/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script)

The inventory script is located in ansible/inventory/ec2

It's an executable script, so you can run it by hand to see what it returns for your inventory if you need to figure out
the best ways to target your resources.

You can also manually create your inventory files and place them in the ansible/inventory folder.

### Playbooks

You should create or clone your submodule playbooks into an `ansible/playbooks` folder to keep everything stored together.

### EC2 Provisioning

If you are using EC2 you will likely need to provision an instance. If you are using a datacenter environment, likely
the machine has already been provisioned. It is worth mentioning, this project really doesn't support multiple
developers currently, that is something that will need to be fixed once it works enough to get the project going.

#### Configure AWS CLI
```bash
$ aws configure
```

You will probably want to set your default region to `us-east-1` and your default output format to `json`.

#### MFA Token
If your account requires the use of an MFA token, you will need to create a token using the Amazon Simple Token Service
(STS). Once you've created the token you will need to place the values it returns into environment variables.

The command below asks for your MFA serial number, which can be found on your uses IAM details, and is usually
represented by an `arn:aws:iam:bunchofnumbers:mfa/username`

The mfa token code is generated by your iphone app, or fob, whatever you're using.

```bash
$ aws sts get-session-token --serial-number {serial number here} --token-code {mfa token here}
```

You will receive output that looks something like the following:
```bash
{
    "Credentials": {
        "SecretAccessKey": "IwK1V7ASDFADSFADFASDFASDFadsfasdfasdfadsfasdfasdf45gsdfg", 
        "SessionToken": "AQoDYXdzEGsagALvxo+QSQkIk3qQuJ9SPIs4A/hi+qZJeQBEb4h545yhb45hb45yb45yb4hy54CB8IqUyIyS8r6I4Y/Nu+EoO4Q22GJbumCu1QGE2islfkgjlkKJTSfdgj5lkjW+5aYF", 
        "Expiration": "2015-02-10T13:30:45Z", 
        "AccessKeyId": "ASIAZZ7ZZZZZZZZDFASDFASDFADF"
    }
}
```

This will output a JSON string. You will need to copy the values inside the JSON string into environment variables,
using something like the following:
```bash
$ export AWS_ACCESS_KEY_ID={AccessKeyIdFromResponse}
$ export AWS_SECRET_ACCESS_KEY={SecretAccessKeyFromResponse}
$ export AWS_SECURITY_TOKEN={SessionTokenFromResponse}
```

Note: Hopefully at some point, someone will turn this into some kind of script to make it easier, for now, you just have
to do some manual commands and copy-paste efforts.

#### Private Key
You will need to make sure you have the private key, or create a public/private key placed into the `~/.ssh/` folder
inside the guest VM in order for SSH to function into your VM. Further instructions will be added for this soon.

#### Spin up the EC2 Server

Once you're done, you can now provision your EC2 instance, by running a similar command to the following inside the Guest VM:
```bash
$ ansible-playbook /vagrant/ansible/playbooks/provision-ec2.yml --inventory-file=/vagrant/ansible/inventory/ec2
```

### Installing Software
To install software, or to run any of the playbooks provided by the dev-environment, or its submodules, you'll use
the `ansible-playbook` command.

For example to run the setup playbook against the vagrant environment itself:
```bash
$ ansible-playbook /vagrant/ansible/playbooks/setup.yml --inventory-file=/vagrant/ansible/inventory/local_hosts --connection=local
```

It's much easier to type all that if you go into the directory where the playbook you're trying to run lives.
```bash
$ cd \vagrant\ansible\playbooks
$ ansible-playbook setup.yml --inventory=../inventory/local_hosts --connection=local
```

