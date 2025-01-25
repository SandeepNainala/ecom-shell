#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e " $Y Disabling MySQL default version $N "
dnf module disable mysql -y

echo -e " $Y copy MySQL repo file $N "
cp ${script_name}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e " $ Y Install MySQL $N "
dnf install mysql-community-server -y

echo -e " $Y Start MySQL $N "
systemctl enable mysqld
systemctl start mysqld

echo -e " $Y Get Default Password $N "
mysql_secure_installation --set-root-pass RoboShop@1

