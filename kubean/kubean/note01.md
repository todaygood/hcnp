
```bash
[root@pcentos k3d]# kubectl  get po -A 
NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
kube-system     coredns-59b4f5bbd5-r6pkr                    1/1     Running     0          12m
kube-system     local-path-provisioner-76d776f6f9-k8g26     1/1     Running     0          12m
kube-system     metrics-server-7b67f64457-xsdhl             1/1     Running     0          12m
kube-system     helm-install-traefik-crd-bmrsg              0/1     Completed   0          12m
kube-system     svclb-traefik-78aecaa4-clltd                2/2     Running     0          11m
kube-system     svclb-traefik-78aecaa4-vf6j8                2/2     Running     0          11m
kube-system     helm-install-traefik-mlxhb                  0/1     Completed   0          12m
kube-system     svclb-traefik-78aecaa4-6bk45                2/2     Running     0          11m
kube-system     traefik-56b8c5fb5c-pxdt9                    1/1     Running     0          11m
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
kube-system     coredns-59b4f5bbd5-r6pkr                    1/1     Running     0          36m
kube-system     local-path-provisioner-76d776f6f9-k8g26     1/1     Running     0          36m
kube-system     metrics-server-7b67f64457-xsdhl             1/1     Running     0          36m
kube-system     helm-install-traefik-crd-bmrsg              0/1     Completed   0          36m
kube-system     svclb-traefik-78aecaa4-clltd                2/2     Running     0          35m
kube-system     svclb-traefik-78aecaa4-vf6j8                2/2     Running     0          35m
kube-system     helm-install-traefik-mlxhb                  0/1     Completed   0          36m
kube-system     svclb-traefik-78aecaa4-6bk45                2/2     Running     0          35m
kube-system     traefik-56b8c5fb5c-pxdt9                    1/1     Running     0          35m
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


