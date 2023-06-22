docker rm -f registry-web

mkdir -p /opt/registry-web/

docker run -v $(pwd)/conf/registry-web.yml:/conf/config.yml:ro \
           -e REGISTRY_TRUST_ANY_SSL=true   -v /opt/registry-web/db:/data --add-host pastack-registry.paic.com.cn:192.168.31.247 \
		              -idt -p 8080:8080 --link pastack-registry --name registry-web docker.m.daocloud.io/hyper/docker-registry-web




#-v $(pwd)/conf/auth.key:/conf/auth.key -v $(pwd)/db:/data --add-host pastack-registry.paic.com.cn:192.168.31.247 \
