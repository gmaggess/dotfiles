#!/bin/sh
if [[ -z "${http_proxy}" ]]; then
    export http_proxy=http://www-proxy-hqdc.us.oracle.com:80
    export https_proxy=http://www-proxy-hqdc.us.oracle.com:80
    export no_proxy=localhost,127.0.0.0/8,*.local,.us.oracle.com,.oraclecorp.com

    npm config set registry https://artifactory-slc.oraclecorp.com/artifactory/api/npm/npmjs-remote
    npm config set email george.maggessy@oracle.com
    npm config set proxy http://www-proxy-hqdc.us.oracle.com:80
    npm config set https-proxy http://www-proxy-hqdc.us.oracle.com:80
    npm config set noproxy localhost,127.0.0.1,.us.oracle.com,.oraclecorp.com

    git config --global http.proxy http://www-proxy-hqdc.us.oracle.com:80
    git config --global https.proxy https://www-proxy-hqdc.us.oracle.com:80

    echo "ORACLE mode on"
else
    unset http_proxy
    unset https_proxy
    unset no_proxy

    npm config set registry https://registry.npmjs.com/
    npm config set email george.maggessy@gmail.com
    npm config delete proxy
    npm config delete https-proxy
    npm config delete noproxy

    git config --global --unset http.proxy
    git config --global --unset https.proxy

    echo "PERSONAL mode on"
fi