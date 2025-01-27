#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "$Y =================== $* =================== $N"
}

func_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e " $G SUCCESS $N "
  else
    echo -e " $R FAILURE $N "
    echo "Refer the log file for more info: /tmp/roboshop.log"
    exit 1
  fi

}

func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
    print_head "Copy mongoDB repo file"
    cp ${script_name}/mongodb.repo /etc/yum.repos.d/mongodb.repo
    func_status_check $?

    print_head "Install MongoDB repo"
    yum install mongodb-org -y
    func_status_check $?

    print_head "Start MongoDB"
    mongo --host mongodb-dev.devops91.cloud </app/schema/${component}.js
    func_status_check $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then

    print_head " install MySQL "
    yum install mysql -y
    func_status_check $?

    print_head " Load schema "
    mysql -h mysql-dev.devops91.cloud -uroot -p${mysql_root_password} < /app/schema/shipping.sql
    func_status_check $?
  fi
}

func_app_prereq(){

  print_head " Add Application user "
  useradd ${app_user} >/tmp/roboshop.log
  func_status_check $?

  print_head " Create Application directory "
  rm -rf /app
  mkdir /app
  func_status_check $?

  print_head " Download App content "
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  func_status_check $?

  print_head " Unzip App content "
  cd /app
  unzip /tmp/${component}.zip
  func_status_check $?
}

func_systemd_setup(){

  print_head " Copy ${component} systemd files "
  cp ${script_name}/${component}.service /etc/systemd/system/${component}.service
  func_status_check $?

  print_head " start ${component}  systemd files "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_status_check $?

}

func_nodejs(){

  print_head "Configure nodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_status_check $?

  print_head "Install NodeJs"
  yum install nodejs -y
  func_status_check $?

  func_app_prereq

  print_head "Install node dependencies"
  npm install
  func_status_check $?

  func_schema_setup
  func_systemd_setup
}


func_java(){

  print_head  " Install maven repository "
  yum install maven -y >/tmp/roboshop.log

  func_status_check $?

  func_app_prereq

  print_head " Install maven dependencies "
  mvn clean package

  func_status_check $?

  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup
  func_systemd_setup

}