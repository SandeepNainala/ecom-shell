#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo -e " $R Provide MySQL Root Password $N "
  exit 1
fi

print_head "MySQL Installation"
dnf module disable mysql -y &>>$log_file # Disable the default MySQL module
func_status_check $?

print_head "Setup MySQL Repository"
cp ${script_name}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file # Copy the MySQL Repo file
func_status_check $?

print_head "Install MySQL"
dnf install mysql-community-server -y &>>$log_file # Install MySQL
func_status_check $?

print_head "Start MySQL"
systemctl enable mysqld &>>$log_file # Start MySQL
systemctl restart mysqld &>>$log_file # Start MySQL
func_status_check $?

print_head "Update MySQL Configuration"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file # Secure MySQL Installation
func_status_check $?

