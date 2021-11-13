#!/bin/sh
export HTTP_PROXY=http://www-proxy.us.oracle.com:80
export HTTPS_PROXY=http://www-proxy.us.oracle.com:80
export FTP_PROXY=http://www-proxy.us.oracle.com:80
export NO_PROXY=localhost,127.0.0.0/8,*.local,.us.oracle.com,.oraclecorp.com

npm config set registry https://artifactory-slc.oraclecorp.com/artifactory/api/npm/npmjs-remote
npm config set email george.maggessy@oracle.com
npm config set proxy http://www-proxy-hqdc.us.oracle.com:80
npm config set https-proxy http://www-proxy-hqdc.us.oracle.com:80
npm config set noproxy localhost,127.0.0.1,.us.oracle.com,.oraclecorp.com

yarn config set proxy $http_proxy --silent
yarn config set https-proxy $http_proxy --silent
yarn config set no-proxy $no_proxy --silent
yarn config set strict-ssl false --silent

git config --global http.proxy http://www-proxy-hqdc.us.oracle.com:80
git config --global https.proxy https://www-proxy-hqdc.us.oracle.com:80

echo "ORACLE mode on"