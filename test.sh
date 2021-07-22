#!/bin/sh
# Make sure to have all nodes time synchronized by for example using ntp !!
ANSIBLE_USER=
ANSIBLE_USER_PASSWORD=

# for Ubuntu uncomment this
apt update
apt upgrade --yes
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt update
apt install ansible-base --yes
apt install git --yes
adduser --home /var/lib/ansible --gecos "" --disabled-password $ANSIBLE_USER
echo $ANSIBLE_USER:$ANSIBLE_USER_PASSWORD | chpasswd
usermod -aG sudo $ANSIBLE_USER

# for CentOS uncomment this
# yum update --yes
# yum install epel-release --yes
# yum install ansible --yes
# yum install git --yes
# adduser --home /var/lib/ansible $ANSIBLE_USER
# echo $ANSIBLE_USER:$ANSIBLE_USER_PASSWORD | chpasswd
# usermod -aG wheel $ANSIBLE_USER


# create folder for stuff we need
mkdir -p /var/log/ansible/roles


ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general

cd /var/log/ansible/roles
git clone https://github.com/KiSchnelle/role_nvidia.git

cd /var/log/ansible
cp /var/log/ansible/roles/role_nvidia/run.yml .
ansible-playbook run.yml --user=$ANSIBLE_USER --extra-vars "ansible_sudo_pass=$ANSIBLE_USER_PASSWORD" >> log_role_nvidia.txt

cd /var/log/ansible

