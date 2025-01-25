#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue

func_nodejs

echo -e " $Y Copy mongoDB repo  $N "
cp ${script_name}/mongodb.repo /etc/yum.repos.d/mongodb.repo

echo -e " $Y Install MongoDB repo $N "
yum install mongodb-org -y
mongo --host mongodb-dev.devops91.cloud </app/schema/catalogue.js