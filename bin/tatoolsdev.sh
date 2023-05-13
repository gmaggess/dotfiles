#!/bin/sh
if [ -e ~/.oci/config-tatools ]
then
    mv ~/.oci/config ~/.oci/config-suis
    mv ~/.oci/config-tatools ~/.oci/config
    echo "Welcome to tatoolsdev tenancy"
else
    echo "You are already in tatoolsdev tenancy"
fi