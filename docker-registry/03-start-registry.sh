#!/bin/bash

#set -e

# Pull registry:2 image and run it
if [[ `docker ps | grep pastack-registry | wc -l` > 0 ]]; then
  docker stop pastack-registry
  docker rm pastack-registry
fi

echo "boot registry container with pastack-registry cert and private key."
mkdir -p /etc/pastack-registry
cp -a cert   /etc/pastack-registry

docker run -d -v /var/lib/docker-registry:/var/lib/registry \
       -v /etc/pastack-registry/cert:/cert \
       -e REGISTRY_STORAGE_DELETE_ENABLED="true" \
       -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
       -e REGISTRY_HTTP_TLS_CERTIFICATE=/cert/pastack-registry.pem  \
       -e REGISTRY_HTTP_TLS_KEY=/cert/pastack-registry-key.pem  \
       -p 443:443 \
       --restart=always --name pastack-registry  \
       registry:2

echo "---------------------------------------------------------------------------------"
echo "#docker ps  |grep -i pastack-registry"
docker ps  |grep -i pastack-registry
echo "---------------------------------------------------------------------------------"
