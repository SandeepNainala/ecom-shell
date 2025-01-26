#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo -e " $R Provide MySQL root password $N "
  exit 1
fi

component="shipping"

schema_setup=mysql

func_java
