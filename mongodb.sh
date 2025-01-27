#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "MongoDB Installation"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$logfile   # Copy the MongoDB Repo file
func_status_check $?

print_head "Install MongoDB"
yum install mongodb-org -y &>>$logfile  # Install MongoDB Server
func_status_check $?

sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf $>>$logfile  # Update the MongoDB Listen Address from
func_status_check $?

print_head "Start MongoDB" # Start MongoDB Service
systemctl enable mongod
systemctl restart mongod
func_status_check $?


