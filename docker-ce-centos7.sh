#!/bin/bash
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
