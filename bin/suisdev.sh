#!/bin/sh
if [ -e ~/.oci/config-suis ]
then
    mv ~/.oci/config ~/.oci/config-tatools
    mv ~/.oci/config-suis ~/.oci/config
    echo "Welcome to suisdev tenancy"
else
    echo "You are already in suisdev tenancy"
fi