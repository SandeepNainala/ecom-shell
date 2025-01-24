#!/bin/bash

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
useradd roboshop

echo -e " $Y Add Application Diretory $N "
mkdir /app

echo -e " $Y Download App content $N "
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

echo -e " $Y Unzip App content $N "
cd /app
unzip /tmp/cart.zip

echo -e " $Y Install node dependencies $N "
npm install


echo -e " $Y Create App directory $N "
cp /home/centos/ecom-shell/cart.service /etc/systemd/system/cart.service

echo -e " $Y Start user service $N "
systemctl daemon-reload
systemctl start user
systemctl enable user