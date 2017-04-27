#!/bin/bash

#MAINTAINER Signal Iduna <methoden-standards@signal-iduna.de>

# fix bug "cannot reconstruct rpm from disk files"
rm -rf /var/lib/rpm/__db.00*
rpmdb --rebuilddb

dnf upgrade -y
dnf install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)

if [ ! -e /home/$user ]; then

    #Install everything via dnf in one command to enhance speed
    dnf install -y keepass libreoffice galculator ntp java-1.8.0-openjdk maven gradle \
	git gitk subversion meld pidgin shutter nodejs chromium ansible firefox xorg-x11-server-Xvfb \
	gcc make dkms dnf-plugins-core wget langpacks-de wget unzip vim nano zsh openssl

	groupadd -g 1002 $user
	useradd -u 1002 --gid 1002 -m -p willNotBeUsed -s /bin/zsh $user

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

	echo "$user:$user" | chpasswd
	echo "$user ALL=PASSWD: ALL" > /etc/sudoers.d/$user-nopasswd

	# provides ZSH Settings / Plugins / etc
	su - $user -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	echo -e '\n#si requested alias' >> /home/$user/.zshrc
	echo 'alias eclipse="/opt/eclipse/eclipse 2> /dev/null &"' >> /home/$user/.zshrc
	echo 'alias code="function f() { code $* --disable-gpu; };f"' >> /home/$user/.zshrc
	sed -i 's/robbyrussell/bira/g' /home/$user/.zshrc

	chown -R 1002:1002 /home/$user
fi

# Language DE
echo "%_install_langs C:en:en_US:en_US.UTF-8:de_DE.UTF-8" > /etc/rpm/macros.image-language-conf
dnf reinstall -y glibc-common
localectl set-locale LANG=de_DE.UTF-8
localectl --no-convert set-x11-keymap de
if [ ! -e /home/$user/.i18n ]; then
	echo "export LANGUAGE=en_US.utf8" > /home/$user/.i18n
	echo "export LANG=en_US.utf8" >> /home/$user/.i18n
	echo "export LC_ALL=en_US.utf8" >> /home/$user/.i18n
fi

#Docker
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


# Guest additions
cd /tmp
VBoxGuestAdditions_VERSION=5.1.18
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

# Fix nslookups
cat /etc/nsswitch.conf | grep -v ^hosts > /etc/tmpnsswitch.conf
echo "hosts:      files dns myhostname" >> /etc/tmpnsswitch.conf
mv -f /etc/tmpnsswitch.conf /etc/nsswitch.conf
sudo systemctl restart network.service

echo "chromium-browser --proxy-pac-url=http://proxy.system.local/accelerated_pac_base.pac --disable-gpu" > /home/$user/chromium.sh
chmod 555 /home/$user/chromium.sh

curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
npm config set https-proxy $https_proxy
npm config set http-proxy $http_proxy

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
echo "JAVA_HOME=/etc/alternatives/java_sdk" > /etc/profile.d/java.sh
echo "PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile.d/java.sh
source /etc/profile.d/java.sh

if [ ! -e /opt/eclipse ]; then
	cd /opt/
	wget -O eclipse-dsl-neon-3-linux-gtk-x86_64.tar.gz 'http://spu.system.local/dezentral/eclipse/4.6-neon/eclipse-dsl-neon-3-linux-gtk-x86_64.tar.gz'
	tar xfvz eclipse-dsl-neon-3-linux-gtk-x86_64.tar.gz
	mv eclipse eclipse-dsl-neon # allow multiple versions
	ln -s eclipse-dsl-neon eclipse
	rm -f eclipse-dsl-neon-3-linux-gtk-x86_64.tar.gz
	
	echo "PATH=/opt/eclipse/:$PATH" >> /etc/profile.d/java.sh
	cd ~
	chown -R $user /opt/eclipse 
	echo "-Djava.net.useSystemProxies=true" >> /opt/eclipse/eclipse.ini
fi

# Typings
npm install typings --global

echo "{\"registryURL\": \"https://api.typings.org\", \"proxy\": \"$http_proxy\", \"rejectUnauthorized\": false}" >> /home/$user/.typings.rc


#/usr/lib/jvm/java-openjdk/bin/keytool -import -trustcacerts -alias SI -file /etc/pki/ca-trust/source/anchors/proxy.crt -keystore /etc/ssl/certs/java/cacerts
cp $JAVA_HOME/jre/lib/security/cacerts certs.munger
keytool -importkeystore -srckeystore $JAVA_HOME/jre/lib/security/cacerts -destkeystore certs.munger -srcstorepass changeit -deststorepass changeit -noprompt &>/dev/null
keytool -importcert -file /etc/pki/ca-trust/source/anchors/proxy.crt -keystore certs.munger -storepass changeit -noprompt -trustcacerts &>/dev/null

#NTP
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
