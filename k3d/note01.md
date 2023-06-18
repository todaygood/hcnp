# k3d 文档

k3s 是一个简化版的,带高可用的k8s 发行版；[k3s架构](https://docs.k3s.io/zh/architecture)
k3d 是一个将k3s安装在本地的工具。

## k3s和k3d是啥？

参见[k3d官方文档](https://k3d.io/v5.2.1/usage/commands/k3d_cluster_create/)

https://k3d.io/v5.2.1/usage/exposing_services/

## 安装记录

要求docker-ce版本>=20

```
[root@pcentos ~]# rpm -qa |grep docker
docker-ce-24.0.2-1.el7.x86_64
docker-ce-rootless-extras-24.0.2-1.el7.x86_64
docker-ce-cli-19.03.12-3.el7.x86_64
```

要求runc版本也比较新：

```
[root@pcentos ~]#  runc --version 
runc version 1.1.7
commit: v1.1.7-0-g860f061b
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
```

创建k3s cluster

```bash  
[root@pcentos ~]# k3d cluster create k3d1
INFO[0000] Prep: Network                                
INFO[0000] Created network 'k3d-k3d1'                   
INFO[0000] Created image volume k3d-k3d1-images         
INFO[0000] Starting new tools node...                   
INFO[0000] Starting Node 'k3d-k3d1-tools'               
INFO[0001] Creating node 'k3d-k3d1-server-0'            
INFO[0001] Creating LoadBalancer 'k3d-k3d1-serverlb'    
INFO[0001] Using the k3d-tools node to gather environment information 
INFO[0001] HostIP: using network gateway 172.30.0.1 address 
INFO[0001] Starting cluster 'k3d1'                      
INFO[0001] Starting servers...                          
INFO[0001] Starting Node 'k3d-k3d1-server-0'            
INFO[0012] All agents already running.                  
INFO[0012] Starting helpers...                          
INFO[0012] Starting Node 'k3d-k3d1-serverlb'            
INFO[0019] Injecting records for hostAliases (incl. host.k3d.internal) and for 2 network members into CoreDNS configmap... 
INFO[0021] Cluster 'k3d1' created successfully!         
INFO[0021] You can now use it like this:                
kubectl cluster-info
[root@pcentos ~]# kubectl cluster-info 
Kubernetes master is running at https://0.0.0.0:35823
CoreDNS is running at https://0.0.0.0:35823/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://0.0.0.0:35823/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## kb: 安装k3d之后如何得到kubectl

```bash
[root@pcentos ~]# docker cp aa02c15da33b:/bin/k3s  /usr/bin/kubectl
[root@pcentos ~]# kubectl version 
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
Client Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.4+k3s1", GitCommit:"8d0255af07e95b841952563253d27b0d10bd72f0", GitTreeState:"clean", BuildDate:"2023-04-20T00:33:18Z", GoVersion:"go1.19.8", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.7
Server Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.4+k3s1", GitCommit:"8d0255af07e95b841952563253d27b0d10bd72f0", GitTreeState:"clean", BuildDate:"2023-04-20T00:33:18Z", GoVersion:"go1.19.8", Compiler:"gc", Platform:"linux/amd64"}
```



## trouble-shooting技巧

Create a new k3s cluster with containerized nodes (k3s in docker). Every cluster will consist of one or more containers: 
- 1 (or more) server node container (k3s)
- (optionally) 1 loadbalancer container as the entrypoint to the cluster (nginx)
- (optionally) 1 (or more) agent node containers (k3s)

```bash
      --timestamps   Enable Log timestamps
      --trace        Enable super verbose output (trace logging)
      --verbose      Enable verbose output (debug logging)
```


## registry：k3s 可以使用已有的私有仓库，也可以创建新的私有仓库


```bash
k3d cluster create --registry-use k3d-registry:39869
docker tag  nginx-hujun:1.19 k3d-registry:39869/mynginx:v0.1
docker push k3d-registry:39869/mynginx:v0.1
docker push k3d-registry:39869/mynginx:v0.1
kubectl run mynginx --image k3d-registry:39869/mynginx:v0.1



docker pull nginx:latest
docker tag nginx:latest k3d-registry.localhost:12345/nginx:latest
docker push k3d-registry.localhost:12345/nginx:latest



```

 kubectl run mynginx --image k3d-registry:39869/mynginx:v0.1


## dns 问题: node里面无法解析域名pastack-registry.paic.com.cn



```bash
/ # cat /etc/resolv.conf 
nameserver 127.0.0.11
options ndots:0
/ # ip a 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN group default 
    link/ether 5a:97:c8:18:28:a4 brd ff:ff:ff:ff:ff:ff
    inet 10.42.0.0/32 scope global flannel.1
       valid_lft forever preferred_lft forever
3: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    link/ether e6:51:83:a6:f4:05 brd ff:ff:ff:ff:ff:ff
    inet 10.42.0.1/24 brd 10.42.0.255 scope global cni0
       valid_lft forever preferred_lft forever
5: veth893e6f8d@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default 
    link/ether 5e:21:68:42:95:c4 brd ff:ff:ff:ff:ff:ff link-netns cni-f31967fd-e992-36df-e4f1-8f13538ec51d
6: veth39a8a6aa@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default 
    link/ether ce:a1:1a:e0:66:74 brd ff:ff:ff:ff:ff:ff link-netns cni-56c6cf5f-c1b7-70ce-9485-e81a17f1ee42
7: veth5244f998@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default 
    link/ether 86:ed:5c:25:4b:17 brd ff:ff:ff:ff:ff:ff link-netns cni-6964b104-0ede-4149-ca78-6cd59669449c
8: veth70ec2ad1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default 
    link/ether 76:97:55:6c:34:5a brd ff:ff:ff:ff:ff:ff link-netns cni-b029e82a-ddcc-d96e-a542-46cc9c7485ce
10: veth6891a560@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default 
    link/ether de:3c:0d:ee:a2:9a brd ff:ff:ff:ff:ff:ff link-netns cni-04187f7c-d9df-51c7-3b36-63a1a1d6ff06
11: vethf47738ff@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default 
    link/ether e2:66:c3:e2:93:23 brd ff:ff:ff:ff:ff:ff link-netns cni-308549df-36f0-a3cc-50c6-5f42500255eb
43: eth0@if44: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:1a:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.26.0.3/16 brd 172.26.255.255 scope global eth0
       valid_lft forever preferred_lft forever

/ # crictl images 
IMAGE                                         TAG                    IMAGE ID            SIZE
docker.io/rancher/klipper-helm                v0.7.7-build20230403   86eab2ad7bac2       91.5MB
docker.io/rancher/klipper-lb                  v0.4.3                 613ae033d1f9c       4.28MB
docker.io/rancher/local-path-provisioner      v0.0.24                b29384aeb4b13       14.9MB
docker.io/rancher/mirrored-coredns-coredns    1.10.1                 ead0a4a53df89       16.2MB
docker.io/rancher/mirrored-library-traefik    2.9.4                  288889429becf       38.7MB
docker.io/rancher/mirrored-pause              3.6                    6270bb605e12e       686kB
docker.m.daocloud.io/rancher/mirrored-pause   3.6                    6270bb605e12e       686kB
k3d-registry:39869/mynginx                    v0.1                   0fb0372c4d785       53.5MB       


/ # crictl ps 
CONTAINER           IMAGE               CREATED             STATE               NAME                     ATTEMPT             POD ID              POD
4cc5bf811e405       b29384aeb4b13       4 hours ago         Running             local-path-provisioner   0                   8dca9fd4cc7b7       local-path-provisioner-76d776f6f9-kd9sp
73e9d6f8d8bd8       613ae033d1f9c       4 hours ago         Running             lb-tcp-443               0                   edf3d88e3c124       svclb-traefik-16360729-nkxx9
70261f03102a0       613ae033d1f9c       4 hours ago         Running             lb-tcp-80                0                   edf3d88e3c124       svclb-traefik-16360729-nkxx9
658d7924456af       ead0a4a53df89       4 hours ago         Running             coredns                  0                   a799772b0e4be       coredns-59b4f5bbd5-5xrm5
6adfc92775300       288889429becf       5 hours ago         Running             traefik                  0                   63d066f4a8dad       traefik-56b8c5fb5c-78jtp

/ # find . -name config.toml
./var/lib/rancher/k3s/agent/etc/containerd/config.toml
```

### solution

创建cluster时加参数`--host-alias` 来解决。

```bash
name=k3d02
k3d cluster create $name --registry-config registry.yaml  -v /etc/pastack-registry/cert/:/cert/ --host-alias 192.168.31.247:pastack-registry.paic.com.cn
```


## 切换k8s 环境

```bash
[root@pcentos k3d]# kubectl  config get-contexts
CURRENT   NAME                          CLUSTER           AUTHINFO                NAMESPACE
*         k3d-k3d02                     k3d-k3d02         admin@k3d-k3d02         
          k3d-k3d1                      k3d-k3d1          admin@k3d-k3d1          
          k3d-k3s-default               k3d-k3s-default   admin@k3d-k3s-default   
          kubernetes-admin@kubernetes   kubernetes        kubernetes-admin  

kubectl config use-context 集群名称

```

## 使用registry mirror 


参见 https://docs.k3s.io/zh/installation/private-registry

```bash

Events:
  Type     Reason                  Age               From               Message
  ----     ------                  ----              ----               -------
  Normal   Scheduled               43s               default-scheduler  Successfully assigned kube-system/metrics-server-7b67f64457-nx598 to k3d-k3d02-server-0
  Warning  FailedCreatePodSandBox  4s (x4 over 43s)  kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed to get sandbox image "rancher/mirrored-pause:3.6": failed to pull image "rancher/mirrored-pause:3.6": failed to pull and unpack image "docker.io/rancher/mirrored-pause:3.6": failed to resolve reference "docker.io/rancher/mirrored-pause:3.6": get TLSConfig for registry "https://pastack-registry.paic.com.cn": failed to load CA file: open /etc/docker/cert.d/pastack-registry.paic.com.cn/ca.crt: no such file or directory

Events:
  Type     Reason                  Age                From               Message
  ----     ------                  ----               ----               -------
  Normal   Scheduled               33s                default-scheduler  Successfully assigned kube-system/coredns-59b4f5bbd5-945x7 to k3d-k3d02-server-0
  Warning  FailedCreatePodSandBox  12s (x2 over 29s)  kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed to get sandbox image "rancher/mirrored-pause:3.6": failed to pull image "rancher/mirrored-pause:3.6": failed to pull and unpack image "docker.io/rancher/mirrored-pause:3.6": failed to resolve reference "docker.io/rancher/mirrored-pause:3.6": failed to do request: Head "https://pastack-registry.paic.com.cn/v2/pastack-registry.paic.com.cn/rancher-images/mirrored-pause/manifests/3.6?ns=docker.io": x509: certificate is valid for pastack-registry, extra-pastack-registry, not pastack-registry.paic.com.cn
```

k3s的那些附加yaml
```bash

/var/lib/rancher/k3s/server/manifests # grep image:  * -irn 
coredns.yaml:109:        image: rancher/mirrored-coredns-coredns:1.10.1
local-storage.yaml:70:        image: rancher/local-path-provisioner:v0.0.24
local-storage.yaml:158:        image: rancher/mirrored-library-busybox:1.34.1
metrics-server/metrics-server-deployment.yaml:47:        image: rancher/mirrored-metrics-server:v0.6.2
traefik.yaml:28:    image:

/etc/rancher/k3s # ls
k3s.yaml  registries.yaml
/etc/rancher/k3s # cat registries.yaml 
mirrors:
  docker.io:
    endpoint:
    - https://pastack-registry.paic.com.cn
    rewrite: {}
configs:
  pastack-registry.paic.com.cn:
    auth: null
    tls:
      ca_file: /cert/ca.pem
      cert_file: ""
      key_file: ""
      insecure_skip_verify: false
auths: {}

```


