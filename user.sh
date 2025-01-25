#!/bin/bash

script_path=$(dirname $0)
source ${script_path}/common.sh

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"


echo -e " $Y Configure nodeJs repos $N "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e " $Y Install NodeJs  $N "
dnf install nodejs -y

echo -e " $Y Add Application user $N "
useradd ${app_user}

echo -e " $Y Add Application Diretory $N "
rm -rf /app
mkdir /app

echo -e " $Y Download App content $N "
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

echo -e " $Y Unzip App content $N "
cd /app
unzip /tmp/user.zip

echo -e " $Y Install node dependencies $N "
npm install


echo -e " $Y Create App directory $N "
cp $script_path/user.service /etc/systemd/system/user.service

echo -e " $Y Start user service $N "
systemctl daemon-reload
systemctl start user
systemctl enable user

echo -e " $Y Copy MongoDB repo $N "
cp /home/centos/ecom-shell/mango.repo /etc/yum.repos.d/mango.repo

echo -e " $Y install MongoDB client $N "
yum install mongodb-org-shell -y

echo -e " $Y Load schema $N "
mongo --host mongodb-dev.devops91.cloud </app/schema/user.js


