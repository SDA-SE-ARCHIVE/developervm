#!/bin/bash

#MAINTAINER Signal Iduna <methoden-standards@signal-iduna.de>

if [ ! -e /home/$user ]; then
	groupadd -g 1002 $user
	useradd -u 1002 --gid 1002 -m -p willNotBeUsed -s /bin/bash $user

#In case you want to use a seperate home partion, you need to evaluate how this can work	
#mv /home/$user /tmp
#(
#			echo o # Create a new empty DOS partition table
#			echo n # Add a new partition
#			echo p # Primary partition
#			echo 1 # Partition number
#			echo   # First sector (Accept default: 1)
#			echo   # Last sector (Accept default: varies)
#			echo w # Write changes
#	) | sudo fdisk /dev/sdb
#	mkdir /home/$user
#	mkfs.ext4 /dev/sdb1
#	echo "/dev/sdb1 /home/$user ext4 defaults 1 1" >> /etc/fstab
#	mount -a
#	rsync -a /tmp/$user/ /home/$user
	
	dnf install -y openssl

	chown -R 1002:1002 /home/$user
	
	echo "$user:$user" | chpasswd
	echo "$user ALL=NOPASSWD: ALL" > /etc/sudoers.d/$user-nopasswd
fi

rpm --rebuilddb
dnf upgrade -y

# Language DE
echo "%_install_langs C:en:en_US:en_US.UTF-8:de_DE.UTF-8" > /etc/rpm/macros.image-language-conf
dnf install -y langpacks-de 
dnf reinstall -y glibc-common
localectl set-locale LANG=de_DE.UTF-8
localectl --no-convert set-x11-keymap de

#Docker
dnf -y install dnf-plugins-core wget
dnf config-manager \
    --add-repo \
    https://docs.docker.com/engine/installation/linux/repo_files/fedora/docker.repo
wget -O docker-engine-1.12.6-1.fc24.x86_64.rpm http://yum.dockerproject.org/repo/main/fedora/24/Packages/docker-engine-1.12.6-1.fc24.x86_64.rpm
wget -O docker-engine-selinux-1.12.6-1.fc24.noarch.rpm http://yum.dockerproject.org/repo/main/fedora/24/Packages/docker-engine-selinux-1.12.6-1.fc24.noarch.rpm
dnf install -y docker-engine-1.12.6-1.fc24.x86_64.rpm docker-engine-selinux-1.12.6-1.fc24.noarch.rpm
dnf makecache fast
groupadd docker
gpasswd -a $user docker
mkdir -p /etc/systemd/system/docker.service.d
echo "[Service]
Environment=\"HTTP_PROXY=$http_proxy\" \"NO_PROXY=$no_proxy\"
ExecStart=
ExecStart=/usr/bin/dockerd --insecure-registry app416020.system.local:5000 --bip 172.18.0.1/17
" >> /etc/systemd/system/docker.service.d/docker.conf
systemctl enable docker
systemctl restart docker


# Generall system tools
dnf install -y wget unzip vim nano zsh

# Guest additions
dnf install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r) gcc make dkms
cd /tmp
VBoxGuestAdditions_VERSION=5.1.14
wget http://download.virtualbox.org/virtualbox/$VBoxGuestAdditions_VERSION/VBoxGuestAdditions_$VBoxGuestAdditions_VERSION.iso
mount -o loop /tmp/VBoxGuestAdditions_$VBoxGuestAdditions_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run 
umount /mnt
rm -f /tmp/VBoxGuestAdditions_$VBoxGuestAdditions_VERSION.iso

# Install X-Window System
#dnf groupinstall -y "Fedora Workstation"
#gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'de')]"
dnf group install -y "Xfce Desktop"
dnf install -y @xfce
systemctl set-default graphical.target
mkdir .config/
timedatectl set-timezone Europe/Berlin

# Headless X-Window System
dnf install -y xorg-x11-server-Xvfb

# Fix nslookups
cat /etc/nsswitch.conf | grep -v ^hosts > /etc/tmpnsswitch.conf
echo "hosts:      files mdns4_minimal dns myhostname" >> /etc/tmpnsswitch.conf
mv -f /etc/tmpnsswitch.conf /etc/nsswitch.conf
sudo systemctl restart network.service

dnf install -y chromium ansible firefox
echo "chromium-browser --proxy-pac-url=http://proxy.system.local/accelerated_pac_base.pac --disable-web-security --disable-gpu" > /home/$user/chromium.sh
chmod 555 /home/$user/chromium.sh

curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
dnf install -y nodejs
npm config set https-proxy $https_proxy
npm config set http-proxy $http_proxy

dnf install -y git gitk subversion meld pidgin shutter

dnf install -y maven gradle
mkdir /home/$user/.m2/
echo '
<settings>
 <mirrors>
  <mirror>
   <id>signaliduna.repo</id>
   <name>Proxy for SIGNAL IDUNA</name>
   <url>http://m2repo.system.local/content/groups/full</url>
   <mirrorOf>*,!sonar</mirrorOf>
  </mirror>
 </mirrors>
</settings>
' > /home/$user/.m2/settings.xml

if [ ! -e visualStudioCode.rpm ]; then
	wget -O visualStudioCode.rpm https://go.microsoft.com/fwlink/?LinkID=760867
fi
dnf install -y visualStudioCode.rpm

#Java
dnf install -y java-1.8.0-openjdk
echo "JAVA_HOME=/etc/alternatives/java_sdk" > /etc/profile.d/java.sh
echo "PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile.d/java.sh
source /etc/profile.d/java.sh

if [ ! -e /opt/eclipse ]; then
	cd /opt/
	wget -O eclipse-dsl-neon-2-linux-gtk-x86_64.tar.gz 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/2/eclipse-dsl-neon-2-linux-gtk-x86_64.tar.gz&r=1'
	tar xfvz eclipse-dsl-neon-2-linux-gtk-x86_64.tar.gz
	#rm -f eclipse-dsl-neon-2-linux-gtk-x86_64.tar.gz
	echo "PATH=/opt/eclipse/bin/bin:$PATH" >> /etc/profile.d/java.sh
	cd ~
	chown -R $user /opt/eclipse 
	echo "-Djava.net.useSystemProxies=true" >> /opt/eclipse/eclipse.ini
fi

# keepass
dnf install -y keepass

#/usr/lib/jvm/java-openjdk/bin/keytool -import -trustcacerts -alias SI -file /etc/pki/ca-trust/source/anchors/proxy.crt -keystore /etc/ssl/certs/java/cacerts
cp $JAVA_HOME/jre/lib/security/cacerts certs.munger
keytool -importkeystore -srckeystore $JAVA_HOME/jre/lib/security/cacerts -destkeystore certs.munger -srcstorepass changeit -deststorepass changeit -noprompt &>/dev/null
keytool -importcert -file /etc/pki/ca-trust/source/anchors/proxy.crt -keystore certs.munger -storepass changeit -noprompt -trustcacerts &>/dev/null

#NTP
dnf install -y ntp
ntpdate ntp.system.local
cat /etc/ntp.conf | grep -v ^server > /tmp/ntp.conf
mv -f /tmp/ntp.conf /etc/ntp.conf
echo "server ntp.system.local" >> /etc/ntp.conf
systemctl enable ntpd.service

# make vagrant unuseable
if [ -e /home/vagrant/.ssh ]; then
	mv /home/vagrant/.ssh /home/vagrant/ssh_safe
	RANDOM_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
	echo "vagrant:$RANDOM_PASSWORD" | chpasswd
fi

dnf clean all
chown -R $user:$user /home/$user
chmod 700 /home/$user