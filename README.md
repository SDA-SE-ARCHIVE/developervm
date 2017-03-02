# Introduction
The target of this project is to provide a development environments. It is insecure and not for production environments.

Some highlights:
* The system wide proxy is set
* Tool specific proxy is set, e.g. the javakeystore or the proxy in docker to pull images
* An X-System is installed with a two monitor setup

# Setup
## Process
* Install *latest* [vagrant](https://www.vagrantup.com/downloads.html) and *latest* [virtualbox](https://www.virtualbox.org/wiki/Downloads)
* Clone Vagrantfile via `git clone ssh://git@git.system.local:7999/aems/developervm.git` and store it on C:\developervm;
* Change proxy user and password in proxy.bash
* Open a command line and change directory into it C:\developervm with `cd C:\developervm`
* Set the proxy with your own credentials on the command line `set http_proxy=http://<proxyuser>:<proxypassword>@proxy.system.local:80` and set `https_proxy=http://<proxyuser>:<proxypassword>@proxy.system.local:80`, e.g. 
```
set https_proxy=http://u139376:XyZ21@proxy.system.local:80
set http_proxy=http://u139376:XyZ21@proxy.system.local:80
```
* Start vagrant to setup for example the X-Window System and shut it down `vagrant up & vagrant halt & vagrant up & vagrant provision & vagrant halt`
* Start the VM via virtualbox

In case you would like to start the vm in fullscreen, create a file:
Right click on desktop in windows -> new -> link (Verknüpfung) -> Change the target to `"C:\Program Files\Oracle\VirtualBox\VirtualBox.exe" --startvm DevelopmentBox --fullscreen`. Click next -> name it "DevelopmentBox" -> Click Finish. While system boot (while you see the black screen with just text), click on "Anzeige" -> "Virtueller Monitor 2" -> "Benutzer Host-Monitor 2"

## Language
To use Xfce in English, execute the following command and logout/login afterwards:
```
echo "export LANGUAGE=en_US.utf8
export LANG=en_US.utf8
export LC_ALL=en_US.utf8" > $HOME/.i18n
```

## Login
You can login with the provided user in proxy.bash. The password is the username. Please change the password.

# Provisioning
The user vagrant got a random password and the vagrant ssh-folder has been moved to /home/vagrant/ssh-safe. Please enable the ssh-keys by using the command `mv /home/vagrant/ssh-safe /home/vagrant/.ssh` in the VM.
Afterwards use the command "vagrant provision" to run the bootstrap again.

# Tools
## Visual Studio Code and Eclipse
Start it with the command `code --disable-gpu` to ensure it is displayed correctly. Eclipse can be started with `/opt/eclipse/eclipse`

## Docker
You can use docker with the vagrant user.
For example `docker run hello-world`

## Browser
* Firefox can be started with the normal `firefox` command
* Chromium can only be started with `$HOME/chromium.sh`

## Package Manager
The default package manager on the console is dnf. [Yum Extender (dnf)](http://www.yumex.dk/) offers a GUI, open via ´yumex-dnf´.

# Known Issues
* After using "vagrant up" there is no application shown in virtual box. You need to start virtual box with administration privileges.
* Separate home folder is with an initial user not working in Xfce via vagrant right now
* Error message "Provider 'virtualbox' not found. We'll automatically install it now": Make sure you have latest version of vagrant installed (minimum 1.9)
* While using "vagrant up" the error "vboxmanage.exe machine is already locked for a session" is shown. End any tasks related to Virtual Box in the Windows Task Manager

# Bug Reporting
Please report bugs with:
* Vagrant version (command `vagrant version`)
* Virtualbox version (Hilfe -> Über Virtualbox)
* Screenshot of the error/complete window
* Description of how the error occurred or a provide a screen-cast
