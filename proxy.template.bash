#!/bin/bash

user="USERUNUMBER"
proxypass="PASSWORD"

curl -X GET "http://git.system.local/projects/SDA/repos/docker-base-images/raw/proxy.crt?at=refs%2Fheads%2Fcentos7" --output  /etc/pki/ca-trust/source/anchors/proxy.crt
curl -X GET "http://git.system.local/projects/SDA/repos/docker-base-images/raw/si_root.crt?at=refs%2Fheads%2Fcentos7" --output  /etc/pki/ca-trust/source/anchors/si_root.crt

echo "
export http_proxy=http://$user:$proxypass@proxy.system.local:80
export https_proxy=http://$user:$proxypass@proxy.system.local:80
export ftp_proxy=http://$user:$proxypass@proxy.system.local:80
export rsync_proxy=http://$user:$proxypass@proxy.system.local:80
export no_proxy=localhost,127.0.0.1,.system.local,.system-a.local
export user=$user
export proxypass=$proxypass
" > /etc/profile.d/proxy.sh
source /etc/profile.d/proxy.sh

update-ca-trust extract

# Allow sudo
echo 'Defaults env_keep += "http_proxy https_proxy ftp_proxy no_proxy"' >> /etc/sudoers.d/sudo-proxy
