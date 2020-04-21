#!/bin/sh
if [[ -z "${http_proxy}" ]]; then
    echo "proxy is set"
    export http_proxy=http://www-proxy-hqdc.us.oracle.com:80
    export https_proxy=https://www-proxy-hqdc.us.oracle.com:80
    export no_proxy=localhost,127.0.0.0/8,*.local,.us.oracle.com,.oraclecorp.com
    git config --global http.proxy http://www-proxy-hqdc.us.oracle.com:80
    git config --global https.proxy https://www-proxy-hqdc.us.oracle.com:80
else
    echo "proxy is unset"
    unset http_proxy
    unset https_proxy
    unset no_proxy
    git config --global --unset http.proxy
    git config --global --unset https.proxy
fi