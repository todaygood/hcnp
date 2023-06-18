FROM nginx:1.24-bullseye


RUN sed -i 's/deb.debian.org/mirrors.huaweicloud.com/g' /etc/apt/sources.list ;\
    sed -i 's|security.debian.org/debian-security|mirrors.huaweicloud.com/debian-security|g' /etc/apt/sources.list ; \
	sed -i '35,41s/^#//'  /etc/bash.bashrc 

RUN apt-get update && apt-get install -y \
    bash-completion\
    vim \
	bind9-dnsutils iproute2  

RUN echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
