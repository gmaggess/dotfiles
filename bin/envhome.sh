#!/bin/sh
unset HTTP_PROXY
unset HTTPS_PROXY
unset FTP_PROXY
unset NO_PROXY

unset ALL_PROXY
unset http_proxy
unset https_proxy
unset ftp_proxy
unset no_proxy

npm config set registry https://registry.npmjs.com/
npm config set email george.maggessy@gmail.com
npm config delete proxy
npm config delete https-proxy
npm config delete noproxy

yarn config delete proxy
yarn config delete https-proxy
yarn config delete no-proxy
yarn config delete strict-ssl
yarn config set no-proxy true

git config --global --unset http.proxy
git config --global --unset https.proxy

rm -f ~/.gemrc
cp -rf ~/.gemrc.home ~/.gemrc

echo "PERSONAL mode on"