$user = Read-Host 'Please enter your username (unumber)'
$proxypass = Read-Host 'Please enter your proxy password'
$proxy="http://" + $user + ":" + $proxypass + "@" + "proxy2.system.local:80"
Set-InternetProxy -proxy $proxy 
cat proxy.template.bash | %{$_ -replace "PASSWORD",$proxypass } | %{$_ -replace "USERUNUMBER",$user} | Set-Content  proxy.bash

vagrant up
vagrant halt
vagrant up
vagrant provision
vagrant halt

$wshShellObject = New-Object -com WScript.Shell
$userProfileFolder = (get-childitem env:USERPROFILE).Value
$wshShellLink = $wshShellObject.CreateShortcut($userProfileFolder+"\Desktop\DeveloperVM.lnk") 
$wshShellLink.TargetPath = "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
$wshShellLink.Arguments ="--startvm DevelopmentBox --fullscreen"
$wshShellLink.WindowStyle = 1
$wshShellLink.IconLocation = "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe" 
$wshShellLink.Save()

Write-Host "Installation complete. Please click on the shortcut on your desktop to start the DeveloperVM"