vagrant plugin install vagrant-vbguest
vagrant up
vagrant halt

$wshShellObject = New-Object -com WScript.Shell
$userProfileFolder = (get-childitem env:USERPROFILE).Value
$wshShellLink = $wshShellObject.CreateShortcut($userProfileFolder+"\Desktop\SDASE-DeveloperVM.lnk")
$wshShellLink.TargetPath = "C:\Program Files\Oracle\VirtualBox\VirtualBoxVM.exe"
$wshShellLink.Arguments ="--startvm DevelopmentBox --fullscreen"
$wshShellLink.WindowStyle = 1
$wshShellLink.IconLocation = "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe" 
$wshShellLink.Save()

Write-Host "Installation complete. Please click on the shortcut on your desktop to start the DeveloperVM"
