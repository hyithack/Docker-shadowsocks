# Docker-shadowsocks
### Docker-shadowsocks

#### 1.Docker一键下载脚本-CentOS 7.6

```bash
[root@Docker ~]#vim docker-ce-centos7.sh
i#!/bin/bash
COLOR="echo -e \\033[1;31m"
END="\033[m"
VERSION="19.03.9-3.el7"
wget -P /etc/yum.repos.d/ https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo  || { ${COLOR}"互联网连接失败，请检查网络配置!"${END};exit; }
yum clean all 
yum -y install docker-ce-$VERSION docker-ce-cli-$VERSION || { ${COLOR}"Base,Extras的yum源失败,请检查yum源配置"${END};exit; }
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
 "registry-mirrors": ["https://si7y70hh.mirror.aliyuncs.com"]
 }
EOF

systemctl restart docker
docker version && ${COLOR}"Docker安装成功"${END} || ${COLOR}"Docker安装失败"${END}
```

#### 2.Docker-compose下载安装

GItHub项目地址:https://github.com/docker/compose/releases/tag/1.29.2

##### 2.1 下载Docker-compose放入/usr/local/bin/并修改名称为docker-compose

```bash
#使用wget下载
wget https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64
```

```bash
#改名
mv docker-compose-Linux-x86_64 docker-compose
```

```bash
#移动
mv docker-compose /usr/local/bin
```

```bash
#给予执行权限
chmod +x /usr/local/bin/docker-compose
```

```bash
#检测compose是否安装成功
[root@docker ~]# docker-compose -v
docker-compose version 1.29.2, build 5becea4c
```

#### 3.拉取镜像

```bash
docker pull teddysun/shadowsocks-libev
```

#### 4.Docker启动Shadowsocks

```bash
#创建/etc/shadowsocks-libev目录
mkdir /etc/shadowsocks-libev -p
#使用docker默认启动
docker run -d -p 9000:9000 -p 9000:9000/udp --name ss-libev --restart=always -v /etc/shadowsocks-libev:/etc/shadowsocks-libev teddysun/shadowsocks-libev
```

#### 5.使用Docker-compose启动

```bash
#创建/etc/shadowsocks-libev目录
mkdir /etc/shadowsocks-libev -p
#创建ss-libev目录并且进入
mkdir ss-libev
cd ss-libev
#编写Docker-compose.yml文件
vim docker-compose.yml
version: "3.8"
services:
  shadowsocks:
    container_name: ss-libev
    image: teddysun/shadowsocks-libev
    ports:
      - "12341:9000"
      - "12341:9000/udp"
    restart: always
    volumes:
      - /etc/shadowsocks-libev:/etc/shadowsocks-libev
```

```bash
#启动前先在宿主机创建json配置文件
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":12341,
    "password":"password0",
    "timeout":300,
    "method":"aes-256-gcm",
    "fast_open":false,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp"
}
EOF
```

```bash
#使用docker-compose启动
docker-compose up -d  
```
