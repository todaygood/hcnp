#!/bin/bash

#set -e

docker stop pastack-registry
docker rm pastack-registry

rm -fr  /etc/pastack-registry

echo "---------------------------------------------------------------------------------"
echo "#docker ps -a |grep -i pastack-registry"
docker ps -a  |grep -i pastack-registry
echo "---------------------------------------------------------------------------------"
