# Introduction
The target of this project is to provide a development environments. It is insecure and not for production environments.
This README gives an overview, more information are in the [wiki](http://wiki.system.local/display/OTA/DeveloperVM).

Some highlights:
* The system wide proxy is set
* Tool specific proxy is set, e.g. the javakeystore or the proxy in docker to pull images
* An X-System is installed with a two monitor setup

# Setup
## Process
* Install [vagrant](https://www.vagrantup.com/downloads.html) (2.0.4) and [virtualbox](https://www.virtualbox.org/wiki/Downloads) (5.2.10)
* Clone Vagrantfile via `git clone ssh://git@git.system.local:7999/aems/developervm.git` and store it on C:\developervm;
* Open Powershell (Windows-Key -> Powershell (x86))
* Change directory into it C:\developervm with `cd C:\developervm`
* Execute .\setup.ps1 and enter your u-number and former proxy (proxy is right now deprecated)
* Start the VM via virtualbox

In case you would like to start the vm in fullscreen, create a file:
Right click on desktop in windows -> new -> link (Verknüpfung) -> Change the target to `"C:\Program Files\Oracle\VirtualBox\VirtualBox.exe" --startvm DevelopmentBox --fullscreen`. Click next -> name it "DevelopmentBox" -> Click Finish. While system boot (while you see the black screen with just text), click on "Anzeige" -> "Virtueller Monitor 2" -> "Benutzer Host-Monitor 2"

## Login
You can login with the provided user number you entered while execute setup.ps1. The password is the 'start1'. Please change the password via `passwd` in the terminal.

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

## Update / Migration path

To __update__ your development box you have to call the script /usr/local/bin/update_devbox_tags.bash with sudo permissions.

`sudo /usr/local/bin/update_devbox_tags.bash` or `sudo /usr/local/bin/update_devbox_tags.bash --perform-update` depends on the current version of your update script.

The update performes package-, kernel- and SI proprietary configuration updates. (remark: if you have the new version of the update script you have to call it with option --perform-update)


To __migrate__ the box means lift up your Fedora OS release version to the next release version if possible. This process takes a while. During tests an average execution time of 45 - 60 minutes was measured. Before migrating make sure our system is up to date. Please follow the instructions to update your development box.

After updating your system your update script /usr/local/bin/update_devbox_tags.bash script will be updated too - you can call it without any options. A help should be displayed similar like this ...

Update DeveloperBox for packages and configuration stuff. Displays information and related ...

```-h, --help   display this help and exit
-i, --info   display OS major version and update options
--fetch-updatescript   fetches the most current version of this update script from scm
--perform-update   standard developer box update including packages and configuration
--perform-os-update   performs OS update
```

To migrate your system to the next available version issue following command

`sudo  /usr/local/bin/update_devbox_tags.bash --perform-os-update`

From now on the script requires an option to do anything but print help. As stated above to update your system call the script additionally with --perform-update option. To migrate please call it with --perform-os-update option. again - keep in mind that this requires time and in progress your box will be rebooted!

Right now the max. support Fedora Release Version is 27.

# Known Issues
See [Wiki-Page](http://wiki.system.local/display/OTA/DeveloperVM).

# Bug Reporting
Please report bugs with:
* Vagrant version (command `vagrant version`)
* Virtualbox version (Hilfe -> Über Virtualbox)
* Screenshot of the error/complete window
* Description of how the error occurred or a provide a screen-cast
