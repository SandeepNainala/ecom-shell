#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

echo -e " $Y Install maven repos $N "
yum install maven -y

echo -e " $Y Add Application user $N "
useradd roboshop

echo -e " $Y Create Application directory $N "
rm -rf /app
mkdir /app

echo -e " $Y Download App content $N "
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e " $Y Unzip App content $N "
cd /app
unzip /tmp/shipping.zip

echo -e " $Y Install maven dependencies $N "
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e " $Y install MySQL $N "
yum install mysql -y

echo -e " $Y Load schema $N "
mysql -h mysql-dev.devops91.cloud -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e " $Y Copy shipping systemd files $N "
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping