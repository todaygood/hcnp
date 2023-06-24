
# build kubean 


成功

```bash
[root@pcentos build-kubean]# make kubean-operator
fatal: No names found, cannot describe anything.
echo "Building kubean-operator for arch = linux/amd64"
Building kubean-operator for arch = linux/amd64
export DOCKER_CLI_EXPERIMENTAL=enabled ;\
! ( docker buildx ls | grep kubean-operator-multi-platform-builder ) && docker buildx create --use --platform=linux/amd64 --name kubean-operator-multi-platform-builder ;\
docker buildx build \
                --build-arg kubean_version=unknown \
                --builder kubean-operator-multi-platform-builder \
                --platform linux/amd64 \
                --tag container.io/kubean-ci/kubean-operator:unknown  \
                --tag container.io/kubean-ci/kubean-operator:latest  \
                -f ./build/images/kubean-operator/Dockerfile \
                --load \
                .
kubean-operator-multi-platform-builder *  docker-container                                                           
  kubean-operator-multi-platform-builder0 unix:///var/run/docker.sock inactive                                       linux/amd64*
[+] Building 551.9s (15/15) FINISHED                                                                                                                                  
 => [internal] booting buildkit                                                                                                                                 23.2s
 => => pulling image moby/buildkit:buildx-stable-1                                                                                                              21.9s
 => => creating container buildx_buildkit_kubean-operator-multi-platform-builder0                                                                                1.3s
 => [internal] load build definition from Dockerfile                                                                                                             0.1s
 => => transferring dockerfile: 493B                                                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                                0.1s
 => => transferring context: 2B                                                                                                                                  0.0s
 => [internal] load metadata for docker.io/library/alpine:3.15                                                                                                   5.3s
 => [internal] load metadata for docker.io/library/golang:1.20.4                                                                                                 4.9s
 => [build 1/4] FROM docker.io/library/golang:1.20.4@sha256:690e4135bf2a4571a572bfd5ddfa806b1cb9c3dea0446ebadaf32bc2ea09d4f9                                    94.9s
 => => resolve docker.io/library/golang:1.20.4@sha256:690e4135bf2a4571a572bfd5ddfa806b1cb9c3dea0446ebadaf32bc2ea09d4f9                                           0.1s
 => => sha256:cd56b3199c0c96901ea545187395ab9d886e75aeb4d953f018a21c5782dc9498 156B / 156B                                                                       0.5s
 => => sha256:147e02c24f40116f23669411aa9b2a6b2f964ddce0e045d3933cc4ad19337cb3 100.15MB / 100.15MB                                                              80.6s
 => => sha256:948a624948bad16368a8875d007bc505810d290412e61357e0e44549e775dd3c 86.03MB / 86.03MB                                                                24.4s
 => => sha256:75256935197ed1bb3b994a77c01efa00349b901014448a260fafd9c3719a741d 54.58MB / 54.58MB                                                                36.4s
 => => sha256:6710592d62aa1338ac1c1c363dedc255659f666cc41441c7e0f735c484db10ff 15.76MB / 15.76MB                                                                 6.6s
 => => sha256:bd73737482dd5575526c7207872963479808d979ab2741c321706b8553918474 55.05MB / 55.05MB                                                                20.8s
 => => extracting sha256:bd73737482dd5575526c7207872963479808d979ab2741c321706b8553918474                                                                        7.2s
 => => extracting sha256:6710592d62aa1338ac1c1c363dedc255659f666cc41441c7e0f735c484db10ff                                                                        1.4s
 => => extracting sha256:75256935197ed1bb3b994a77c01efa00349b901014448a260fafd9c3719a741d                                                                        8.4s
 => => extracting sha256:948a624948bad16368a8875d007bc505810d290412e61357e0e44549e775dd3c                                                                        8.1s
 => => extracting sha256:147e02c24f40116f23669411aa9b2a6b2f964ddce0e045d3933cc4ad19337cb3                                                                       13.4s
 => => extracting sha256:cd56b3199c0c96901ea545187395ab9d886e75aeb4d953f018a21c5782dc9498                                                                        0.0s
 => [stage-1 1/3] FROM docker.io/library/alpine:3.15@sha256:3362f865019db5f14ac5154cb0db2c3741ad1cce0416045be422ad4de441b081                                     4.1s
 => => resolve docker.io/library/alpine:3.15@sha256:3362f865019db5f14ac5154cb0db2c3741ad1cce0416045be422ad4de441b081                                             0.1s
 => => sha256:0cdfa0c98ed79707cd91c5dd7ebd282aa2b976d86a9e699d7fc188cdb6be390e 2.83MB / 2.83MB                                                                   2.6s
 => => extracting sha256:0cdfa0c98ed79707cd91c5dd7ebd282aa2b976d86a9e699d7fc188cdb6be390e                                                                        1.1s
 => [internal] load build context                                                                                                                               29.4s
 => => transferring context: 175.16MB                                                                                                                           29.1s
 => [stage-1 2/3] RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories                                                               1.2s
 => [build 2/4] WORKDIR /kubean                                                                                                                                  1.3s
 => [build 3/4] COPY . .                                                                                                                                         8.6s
 => [build 4/4] RUN CGO_ENABLED=0 GOOS=linux go build -mod vendor -o kubean-operator ./cmd/kubean-operator/main.go                                             402.0s
 => [stage-1 3/3] COPY --from=build /kubean/kubean-operator /bin/                                                                                                0.5s
 => exporting to oci image format                                                                                                                               13.5s
 => => exporting layers                                                                                                                                          8.4s
 => => exporting manifest sha256:97665d374e58c45e1c825cdd651e071a5ef3f2058cd244636e8fcb0a49fc2c40                                                                0.0s
 => => exporting config sha256:c765bca634770f95f5ceb24680cf387baa976d7be5705a13e37b2fda775e9c15                                                                  0.0s
 => => sending tarball                                                                                                                                           5.0s
 => importing to docker                                                                                                                                          2.3s
[root@pcentos build-kubean]# docker images | head -n 50 
REPOSITORY                                       TAG                 IMAGE ID       CREATED          SIZE
container.io/kubean-ci/kubean-operator           latest              c765bca63477   17 minutes ago   75.2MB
container.io/kubean-ci/kubean-operator           unknown             c765bca63477   17 minutes ago   75.2MB
```



## issue1 

```bash
[root@pcentos build-kubean]# vim Makefile 
[root@pcentos build-kubean]# make kubean-operator
fatal: No names found, cannot describe anything.
echo "Building kubean-operator for arch = linux/amd64"
Building kubean-operator for arch = linux/amd64
export DOCKER_CLI_EXPERIMENTAL=enabled ;\
! ( docker buildx ls | grep kubean-operator-multi-platform-builder ) && docker buildx create --use --platform=linux/amd64 --name kubean-operator-multi-platform-builder ;\
docker buildx build \
                --build-arg kubean_version=unknown \
                --builder kubean-operator-multi-platform-builder \
                --platform linux/amd64 \
                --tag container.io/kubean-ci/kubean-operator:unknown  \
                --tag container.io/kubean-ci/kubean-operator:latest  \
                -f ./build/images/kubean-operator/Dockerfile \
                --load \
                .
kubean-operator-multi-platform-builder
unknown flag: --builder
See 'docker buildx build --help'.
make: *** [kubean-operator] Error 125
```

###  solution
yum update docker-ce-cli 

会自动安装docker-builder-plugin的rpm 


