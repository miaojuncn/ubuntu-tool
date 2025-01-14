FROM ubuntu:22.04

# COPY ossutil restic /usr/local/bin/

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt update && \
    apt install -y vim openssl ssh telnet wget curl \
    net-tools traceroute tcpdump sysstat git \
    zip iputils-ping iproute2 rsync make \
    mysql-server redis netcat dnsutils tree nodejs npm maven && \
    apt autoclean && apt autoremove -y && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd && \
    mkdir -p /var/run/sshd && \
    sed -i '$i<mirror>\n<id>alimaven</id>\n<name>aliyun maven</name>\n<url>https://maven.aliyun.com/repository/public</url>\n<mirrorOf>central</mirrorOf>\n</mirror>' /etc/maven/settings.xml && \
    npm config set registry https://registry.npmmirror.com

ADD run.sh /run.sh

EXPOSE 22

ENTRYPOINT ["/run.sh"]
