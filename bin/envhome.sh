#!/bin/sh
unset http_proxy
unset https_proxy
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

echo "PERSONAL mode on"