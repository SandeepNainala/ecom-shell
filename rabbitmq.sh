#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

echo -e " $Y Setup Erlang repos $N "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e " $Y Setup RabbitMQ repos $N "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e " $Y Install RabbitMQ and erlang $N "
yum install erlang rabbitmq-server -y

echo -e " $Y Start rabbitMQ server $N "
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e " $Y Create App user in RabbitMQ $N "
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
