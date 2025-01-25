#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

component=user

fucn_nodejs

echo -e " $Y Copy MongoDB repo $N "
cp ${script_name}/mango.repo /etc/yum.repos.d/mango.repo

echo -e " $Y install MongoDB client $N "
yum install mongodb-org-shell -y

echo -e " $Y Load schema $N "
mongo --host mongodb-dev.devops91.cloud </app/schema/user.js


