# 部署

Kubean 需要运行在一个已存在的 Kubernetes 集群，通过应用 Kubean 提供的标准 CRD 资源和 Kubernetes 内建资源来控制和管理集群的生命周期（安装、卸载、升级、扩容、缩容等）。 Kubean 采用 Kubespray 作为底层技术依赖，一方面简化了集群部署的操作流程，降低了用户的使用门槛。另一方面在 Kubespray 能力基础上增加了集群操作记录、离线版本记录等诸多新特性。

Kubean 运行着多个控制器，这些控制器跟踪 Kubean CRD 对象的变化，并且与底层集群的 API 服务器进行通信来创建 Kubernetes原生资源对象。由以下四个组件构成：

  1. Cluster Controller: 监视 `Cluster Objects`。唯一标识一个集群，拥有集群节点的访问信息、类型信息、部署参数信息，并且关联所有对此集群的操作（`ClusterOperation Objects`）；
  2. ClusterOperation Controller: 监视 `ClusterOperation Objects`。当 `ClusterOperation Object` 被创建时，控制器会组装一个 [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) 去执行 CRD 对象里定义的操作；
  3. Manifest Controller: 监视 `Manifest Objects`。用于记录和维护当前版本的 Kubean 使用和兼容的组件、包及版本；
  4. LocalArtifactSet Controller：监视 `LocalArtifactSet Objects`。用于记录离线包支持的组件及版本信息。


https://github.com/kubean-io/kubean/blob/main/docs/en/concepts/crds.md

自定义操作

https://github.com/kubean-io/kubean/blob/main/docs/en/concepts/custom_action.md


## 问题1：离线部署的介质如何整理？

https://github.com/kubean-io/kubean/blob/main/docs/en/concepts/theory_of_airgapped_package.md

分了三类：
1. docker image 
2. bin
3. debian /rpm package

## 问题2：离线部署

介质上传到minio之后，如何获取？ 

镜像如何修改成本地库的镜像？ 



## 测试在线安装

```bash
[root@pcentos testcase]# ./01-deploy.sh 
-----------------------------------------------------------------------------------------------------
configmap/mini-hosts-conf created
configmap/mini-vars-conf created
cluster.kubean.io/cluster-mini created
clusteroperation.kubean.io/cluster-mini-install-ops created
```

## 原理分析

部署这个动作是使用job  spray-job:v0.6.3 去完成的。


```bash
[root@pcentos k3d]# kubectl  get po -A 
NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
kubean-system   kubean-59687dfd7d-q8krf                     1/1     Running     0          8m32s
kubean-system   kubean-cluster-mini-install-ops-job-b9fjz   1/1     Running     0          4m7s
[root@pcentos k3d]# kubectl  exec -it -n kubean-system  kubean-cluster-mini-install-ops-job-b9fjz -- bash 
kubean-cluster-mini-install-ops-job-b9fjz:/kubespray# ls
CNAME                      Vagrantfile                galaxy.yml                 precheck.yml               setup.cfg
CONTRIBUTING.md            _config.yml                index.html                 recover-control-plane.yml  setup.py
Dockerfile                 ansible.cfg                inventory                  remove-node.yml            test-infra
LICENSE                    cluster-info.yml           kubeconfig.yml             remove-pkgs.yml            tests
Makefile                   cluster.yml                library                    requirements.txt           update-hosts.yml
OWNERS                     code-of-conduct.md         logo                       reset.yml                  upgrade-cluster.yml
OWNERS_ALIASES             contrib                    ping.yml                   roles
README.md                  disable-firewalld.yml      pipeline.Dockerfile        run.rc
RELEASE.md                 enable-repo.yml            playbooks                  scale.yml
SECURITY_CONTACTS          extra_playbooks            plugins                    scripts
kubean-cluster-mini-install-ops-job-b9fjz:/kubespray# pwd
/kubespray
kubean-cluster-mini-install-ops-job-b9fjz:/kubespray# ps aux 
PID   USER     TIME  COMMAND
    1 root      0:00 {entrypoint.sh} /bin/bash /bin/entrypoint.sh
   20 root      0:01 ssh: /root/.ansible/cp/15f0a2497a [mux]
   72 root      1:01 {ansible-playboo} /usr/bin/python3 /usr/bin/ansible-playbook -i /conf/hosts.yml -b --become-user root -e @/conf/group_vars.yml /kubespr
  675 root      0:00 bash
  918 root      0:00 {ansible-playboo} /usr/bin/python3 /usr/bin/ansible-playbook -i /conf/hosts.yml -b --become-user root -e @/conf/group_vars.yml /kubespr
  920 root      0:00 sshpass -d16 ssh -C -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o User="root" -o ConnectTimeout=10 -o Cont
  921 root      0:00 ssh -C -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o User="root" -o ConnectTimeout=10 -o ControlPath="/roo
  922 root      0:00 ps aux
kubean-cluster-mini-install-ops-job-b9fjz:/kubespray# cat /bin/entrypoint.sh 
#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# preinstall
ansible-playbook -i /conf/hosts.yml -b --become-user root -e "@/conf/group_vars.yml" /kubespray/disable-firewalld.yml


# run kubespray
ansible-playbook -i /conf/hosts.yml -b --become-user root -e "@/conf/group_vars.yml" /kubespray/cluster.yml

# postinstall
ansible-playbook -i /conf/hosts.yml -b --become-user root -e "@/conf/group_vars.yml" /kubespray/cluster-info.ymlkubean-cluster-mini-install-ops-job-b9fjz:/kubespray# command terminated with exit code 137
[root@pcentos k3d]# 

```
发现失败了，可能是要求在线

```bash

[root@pcentos ~]# kubectl  get po -A 
NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
kubean-system   kubean-59687dfd7d-q8krf                     1/1     Running     0          33m
kubean-system   kubean-cluster-mini-install-ops-job-b9fjz   0/1     Error       0          28m

TASK [container-engine/runc : download_file | Get the list of working mirrors] ***
ok: [node1]
Sunday 18 June 2023  14:34:57 +0000 (0:00:00.889)       0:17:05.376 *********** 
FAILED - RETRYING: [node1]: download_file | Download item (4 retries left).
FAILED - RETRYING: [node1]: download_file | Download item (3 retries left).
FAILED - RETRYING: [node1]: download_file | Download item (2 retries left).
FAILED - RETRYING: [node1]: download_file | Download item (1 retries left).

TASK [container-engine/runc : download_file | Download item] *******************
fatal: [node1]: FAILED! => {"attempts": 4, "censored": "the output has been hidden due to the fact that 'no_log: true' was specified for this result", "changed": false}
```

参见： https://kubean-io.github.io/kubean/zh/usage/airgap/


## 测试离线安装

[root@pcentos 3.airgap]# pwd
/root/build-kubean/examples/install/3.airgap

### issue1: failed to import docker image 

```bash
+ image_name=/docker.io%cloudnativelabs%kube-router:v1.5.1
+ image_name=/docker.io/cloudnativelabs/kube-router:v1.5.1
+ image_name=pastack-registry.paic.com.cn//docker.io/cloudnativelabs/kube-router:v1.5.1
+ echo 'import offline-images/docker.io%cloudnativelabs%kube-router:v1.5.1 to pastack-registry.paic.com.cn//docker.io/cloudnativelabs/kube-router:v1.5.1'
import offline-images/docker.io%cloudnativelabs%kube-router:v1.5.1 to pastack-registry.paic.com.cn//docker.io/cloudnativelabs/kube-router:v1.5.1
+ docker run -v /cold/ftpuser/kubean-files/images/offline-images:/offline-images quay.io/containers/skopeo copy -a --retry-times=3 dir:offline-images/docker.io%cloudnativelabs%kube-router:v1.5.1 docker://pastack-registry.paic.com.cn//docker.io/cloudnativelabs/kube-router:v1.5.1
time="2023-06-24T04:10:43Z" level=fatal msg="Invalid destination name docker://pastack-registry.paic.com.cn//docker.io/cloudnativelabs/kube-router:v1.5.1: invalid reference format"

```


