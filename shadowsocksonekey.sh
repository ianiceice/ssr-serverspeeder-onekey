#!/bin/bash
location=~+
echo "$location"
chkconfig iptables off;
echo "########################欢迎使用shadowsocks搭建到优化一键安装脚本包#########################"
read -p "即将安装锐速 是否需要更换内核（如果对内核不熟建议更换） :[y/n]"  syskel
if [[ "$syskel" = "y" ]] ; then 
    echo "开始更换锐速兼容内核" 
	rpm -ivh http://soft.91yun.org/ISO/Linux/CentOS/kernel/kernel-firmware-2.6.32-504.3.3.el6.noarch.rpm;
	rpm -ivh http://soft.91yun.org/ISO/Linux/CentOS/kernel/kernel-2.6.32-504.3.3.el6.x86_64.rpm --force;
	read -p "更换内核成功！ 要进行下一步请重启 ：是否重启？（重启后请重新运行脚本）[y/n]"  rebootfig
	if [[ "$rebootfig" = y ]] ; then 
		reboot;
		exit;
	fi
fi 

read -p "即将安装锐速、ss并优化 是否安装 :[y/n]"  syskel
if [[ "$syskel" = "y" ]] ; then 
    echo "开始安装锐速" 
	cd /root
	wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh;
	echo "########################优化内核参数#########################"
	sed -i "s/rsc=\"[0-1]\"/rsc=\"1\"/g" /serverspeeder/etc/config;
	sed -i "s/gso=\"[0-1]\"/gso=\"1\"/g" /serverspeeder/etc/config;
	sed -i "s/maxmode=\"[0-1]\"/maxmode=\"1\"/g" /serverspeeder/etc/config;
	sed -i "s/advinacc=\"[0-1]\"/advinacc=\"1\"/g" /serverspeeder/etc/config;
	sed -i '$a\* soft nofile 51200' /etc/security/limits.conf;
	sed -i '$a\* hard nofile 51200' /etc/security/limits.conf;
	sed -i '$a\ulimit -SHn 51200' /etc/profile;
	service serverSpeeder restart;
	cat $location/sysctl >> /etc/sysctl.conf;
	sysctl -p;
fi 
echo "system update .."
yum install update > log 2>&1;
echo "shadowsocks one key install ....."
echo "install shadowsocks"
cd /root;
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh
chmod +x shadowsocksR.sh
./shadowsocksR.sh 2>&1 | tee shadowsocksR.log
echo "install is succeed! "