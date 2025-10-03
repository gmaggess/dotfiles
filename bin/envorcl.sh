#!/bin/sh
export HTTP_PROXY=http://www-proxy-hqdc.us.oracle.com:80
export HTTPS_PROXY=$HTTP_PROXY
export FTP_PROXY=$HTTP_PROXY
export ALL_PROXY=$HTTP_PROXY
export NO_PROXY=localhost,127.0.0.1,.alm.oraclecorp.com,alm.oraclecorp.com,.oraclecorp.com,.us.oracle.com,.oraclevpn.com,192.168.0.0/16
export http_proxy=$HTTP_PROXY
export https_proxy=$HTTP_PROXY
export ftp_proxy=$HTTP_PROXY
export no_proxy=$NO_PROXY

npm config set registry https://artifacthub-phx.oci.oraclecorp.com/api/npm/npmjs-remote
npm config set @oracle:registry=https://artifacthub-phx.oci.oraclecorp.com/api/npm/npmjs-registry

npm config set email george.maggessy@oracle.com
npm config set proxy http://www-proxy-hqdc.us.oracle.com:80
npm config set https-proxy http://www-proxy-hqdc.us.oracle.com:80
npm config set noproxy localhost,127.0.0.1,.alm.oraclecorp.com,alm.oraclecorp.com,.oraclecorp.com,.us.oracle.com,.oraclevpn.com,192.168.0.0/16

# yarn config set proxy $http_proxy --silent
# yarn config set https-proxy $http_proxy --silent
# yarn config set no-proxy $no_proxy --silent
# yarn config set strict-ssl false --silent

git config --global http.proxy http://www-proxy-hqdc.us.oracle.com:80
git config --global https.proxy https://www-proxy-hqdc.us.oracle.com:80

yes | cp -rf ~/.docker/config.json.orcl ~/.docker/config.json
yes | cp -rf ~/.gemrc.orcl ~/.gemrc

rm -f ~/Library/Application\ Support/Sublime\ Text/Packages/User/Package\ Control.sublime-settings
cp -rf ~/Library/Application\ Support/Sublime\ Text/Packages/User/Package\ Control.orcl.sublime-settings ~/Library/Application\ Support/Sublime\ Text/Packages/User/Package\ Control.sublime-settings


echo "ORACLE mode on"