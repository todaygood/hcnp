
name=k3d01
# k3d cluster create $name --registry-config registry.yaml  -v /etc/pastack-registry/cert/:/cert/ --host-alias 192.168.31.247:pastack-registry.paic.com.cn

k3d cluster create $name -c $name.yaml

