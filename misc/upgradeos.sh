#/bin/bash

BACKUP_DIR=/etc/yum.repos.d.bkp/

echo "Is the chosen ISO placed in the default location /home/cellusys?: (y/n)"
read answer
if [ ${answer} == "y" ]
then
    echo "Create a directory to mount to in /mnt/: "
    read dir
    echo "Creating directory..."
    sudo mkdir -p /mnt/${dir}
    echo "Please enter the full name of the ISO:"
    read iso
    echo "mounting ISO..."
    sudo mount -o loop,ro ${iso} /mnt/${dir}
elif [ ${answer} == "n" ]
then
    echo "Please specify the full path to the ISO:"
    read path
    pushd ${path}
    pwd
    echo "Create a directory to mount to in /mnt/: "
    read dir
    echo "Creating directory..."
    sudo mkdir -p /mnt/${dir}
    echo "Please enter the full name of the ISO:"
    read iso
    echo "mounting ISO..."
    sudo mount -o loop,ro ${iso} /mnt/${dir}
fi

echo "Backing up and moving repos..."
if [ ! -d ${BACKUP_DIR} ]
then
    sudo mkdir -p ${BACKUP_DIR}
fi
cd /etc/yum.repos.d/
sudo mv * ${BACKUP_DIR}
sudo touch CentOS-Media.repo
echo "Populating Media repo..."
echo "# CentOS-Media.repo
#
#  This repo can be used with mounted DVD media, verify the mount point for
#  CentOS-7.  You can use this repo and yum to install items directly off the
#  DVD ISO that we release.
#
# To use this repo, put in your DVD and use it with the other repos too:
#  yum --enablerepo=c7-media [command]
#
# or for ONLY the media repo, do this:
#
#  yum --disablerepo=\* --enablerepo=c7-media [command]

[c7-media]
name=CentOS-$releasever - Media
baseurl=file:///mnt/centos-upgrade
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7" | sudo tee -a CentOS-Media.repo

echo "Cleaning cached packages..."
sudo yum clean all

echo "Verifying access to repo..."
sudo yum repolist

echo "Updating to newest version..."
sudo yum update -y

echo "Verifying Version..."
cat /etc/centos-release

echo "If possible reboot so that new kernel will be used"
