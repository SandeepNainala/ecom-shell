#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


print_head "Redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y $>>$logfile  # Install the Redis Repository
func_status_check $?

print_head "Install Redis"  # Install Redis
dnf module enable redis:remi-6.2 -y $>>$logfile # Enable the Redis Module
yum install redis -y $>>$logfile  # Install Redis
func_status_check $?

print_head "Update Redis Configuration"   # Update the Redis Configuration file
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf $>>$logfile # Update the Redis Listen Address
func_status_check $?

print_head "Start Redis"  # Start Redis Service
systemctl enable redis $>>$logfile  # Enable Redis Service
systemctl restart redis $>>$logfile  # Start Redis Service
func_status_check $?