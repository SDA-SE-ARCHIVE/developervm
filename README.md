# CURRENT ISSUES
* if you try to upgrade your developer box from fedora version X to the next version X + 1 please close all applications (like firefox) because otherwise it could harm the update process.

# Introduction
The target of this project is to provide a development environments. It is insecure and not for production environments.
This README gives an overview.

# Setup
## Process
* Install [vagrant](https://www.vagrantup.com/downloads.html) (2.2.0) and [virtualbox](https://www.virtualbox.org/wiki/Downloads) (5.2)
* Clone Vagrantfile via `git clone ssh://git@github.com/SDA-SE/developervm.git` and store it on C:\developervm;
* Open Powershell (Windows-Key -> Powershell (x86))
* Change directory into it C:\developervm with `cd C:\developervm`
* Execute `.\setup.ps1`
* Start the VM via Desktop link or directly via VirtualBox.

## Login
You can login with the provided username you entered while execute `setup.ps1`. The initial password is 'start1'. Please change the password via `passwd` in the terminal.

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

### REMARKS:
Its strongly recommended to close all applications before to start the update.

To __update__ your development box you have to call the script /usr/local/bin/update_devbox_tags.bash with sudo permissions.

`sudo /usr/local/bin/update_devbox_tags.bash` or `sudo /usr/local/bin/update_devbox_tags.bash --perform-update` depends on the current version of your update script.

The update performes package-, kernel- and configuration updates. (remark: if you have the new version of the update script you have to call it with option --perform-update)


To __migrate__ the box means lift up your Fedora OS release version to the next release version if possible. This process takes a while. During tests an average execution time of 45 - 60 minutes was measured. Before migrating make sure our system is up to date. Please follow the instructions to update your development box.

After updating your system your update script /usr/local/bin/update_devbox_tags.bash script will be updated too - you can call it without any options. A help should be displayed similar like this ...

Update DeveloperBox for packages and configuration stuff. Displays information and related ...

```-h, --help   display this help and exit
-i, --info   display OS major version and update options
--fetch-updatescript   fetches the most current version of this update script from scm
--perform-update   standard developer box update including packages and configuration
--perform-os-update   performs OS update
```

__Before migration__ to the next supported OS level an __box update__ with ```--perform-update``` __is mandatory__.

To migrate your system to the next available version issue following command

`sudo  /usr/local/bin/update_devbox_tags.bash --perform-os-update`

From now on the script requires an option to do anything but print help. As stated above to update your system call the script additionally with --perform-update option. To migrate please call it with --perform-os-update option. again - keep in mind that this requires time and in progress your box will be rebooted!

Right now the max. support Fedora Release Version is 28.

### REMARKS:
Its strongly recommended to close all applications before to start the update.

# Known Issues
See [Wiki-Page](http://wiki.system.local/display/OTA/DeveloperVM).

# Bug Reporting
Please report bugs with:
* Vagrant version (command `vagrant version`)
* Virtualbox version (Hilfe -> Über Virtualbox)
* Screenshot of the error/complete window
* Description of how the error occurred or a provide a screen-cast
