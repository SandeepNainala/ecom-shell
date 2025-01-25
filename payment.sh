#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e " $Y Install Python3 $N "
yum install python36 gcc python3-devel -y

echo -e " $Y Add Application user $N "
useradd ${app_user}

echo -e " $Y Create Application directory $N "
rm -rf /app
mkdir /app

echo -e " $Y Download App content $N "
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e " $Y Unzip App content $N "
cd /app
unzip /tmp/payment.zip

echo -e " $Y Install Python dependencies $N "
pip3.6 install -r requirements.txt

echo -e " $Y Update Config file $N "
cp ${script_name}/payment.service /etc/systemd/system/payment.service

echo -e " $Y Update Config file $N "
systemctl daemon-reload
systemctl enable payment
systemctl restart payment