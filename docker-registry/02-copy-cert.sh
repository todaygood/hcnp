#!/bin/bash 

echo "copy root certificat into docker registry dir"
install -D  -p cert/ca.pem  /etc/docker/certs.d/pastack-registry.paic.com.cn/ca.crt

echo "----------------------------------------------------------------------"
echo "#ls /etc/docker/certs.d/pastack-registry.paic.com.cn/"
ls /etc/docker/certs.d/pastack-registry.paic.com.cn/
echo "----------------------------------------------------------------------"
