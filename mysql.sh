#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo -e " $R Provide MySQL Root Password $N "
  exit 1
fi

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
mysql_secure_installation --set-root-pass $mysql_root_password

