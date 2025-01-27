#!/bin/bash


script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "${rabbitmq_appuser_password}" ]; then
  echo -e " $R Provide the password for RabbitMQ app user $N "
  exit 1
fi

print_head "RabbitMQ Setup"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$logfile # Install Erlang
func_status_check $?

print_head "Install RabbitMQ and Erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$logfile # Install RabbitMQ
func_status_check $?

print_head "Install RabbitMQ Server"
yum install erlang rabbitmq-server -y &>>$logfile # Install RabbitMQ Server
func_status_check $?

print_head "Start RabbitMQ Server"
systemctl enable rabbitmq-server &>>$logfile # Start RabbitMQ Server
systemctl restart rabbitmq-server &>>$logfile # Start RabbitMQ Server
func_status_check $?

print_head "Create RabbitMQ Application User" # This user is used by the application to connect to RabbitMQ
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$logfile # Create RabbitMQ User
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$logfile # Set Permissions for RabbitMQ User
func_status_check $?
