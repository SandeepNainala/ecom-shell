#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e " $Y configuring nodeJS repos $N "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e " $Y Installing nodeJS repos $N "
yum install nodejs -y

echo -e " $Y Add Application user $N "
useradd ${app_user}

echo -e " $Y Create Application directory $N "
rm -rf /app
mkdir /app

echo -e " $Y Download App content $N "
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e " $Y unzip app content $N "
unzip /tmp/catalogue.zip

echo -e " $Y Install node packages $N "
npm install

echo -e " $Y Copy catalogue systemd files $N "
cp ${script_name}/catalogue.service /etc/systemd/system/catalogue.service

echo -e " $Y Start catalogue service $N "
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e " $Y Copy mongoDB repo  $N "
cp ${script_name}/mongodb.repo /etc/yum.repos.d/mongodb.repo

echo -e " $Y Install MongoDB repo $N "
yum install mongodb-org -y
mongo --host mongodb-dev.devops91.cloud </app/schema/catalogue.js