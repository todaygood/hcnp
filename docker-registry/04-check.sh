#!/bin/bash

#set -e

echo "---------------------------------------------------------------------------------"
echo "#docker ps  |grep -i pastack-registry"
docker ps  |grep -i pastack-registry

echo "#docker push pastack-registry.paic.com.cn/rancher/mirrored-pause:3.6"
docker push pastack-registry.paic.com.cn/rancher/mirrored-pause:3.6
echo "---------------------------------------------------------------------------------"
