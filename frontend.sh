#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=frontend


print_head "Installing Nginx"
yum install nginx -y &>>$logfile  # Install Nginx
func_staus_check $?

print_head "Download Frontend Content"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$logfile # Copy the Nginx RoboShop Configuration
func_staus_check $?

print_head "Update Nginx Configuration"
rm -rf /usr/share/nginx/html/*  $>>$logfile   # Remove the default Nginx RoboShop Configuration
func_staus_check $?

print_head "Start Nginx Service"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$logfile  # Download the Frontend Archive
func_staus_check $?

print_head "Extract Frontend Archive"
cd /usr/share/nginx/html &>>$logfile  # Extract the Frontend Archive
unzip /tmp/${component}.zip &>>$logfile # Extract the Frontend Archive
func_staus_check $?

print_head "Update Nginx Configuration"
systemctl enable nginx &>>$logfile  # Start Nginx Service
systemctl restart nginx   # Restart Nginx Service
func_staus_check $?

