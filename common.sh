#!/bin/bash

app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "$Y =================== $* =================== $N"
}

schema_func(){
  echo -e " $Y Copy mongoDB repo  $N "
  cp ${script_name}/mongodb.repo /etc/yum.repos.d/mongodb.repo

  echo -e " $Y Install MongoDB repo $N "
  yum install mongodb-org -y

  echo -e " $Y Start MongoDB $N "
  mongo --host mongodb-dev.devops91.cloud </app/schema/${component}.js
}


func_nodejs(){

  print_head "Configure nodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install NodeJs"
  dnf install nodejs -y

  print_head "Add Application user"
  useradd ${app_user}

  print_head "Add Application Diretory"
  rm -rf /app
  mkdir /app

  print_head "Download App content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  print_head "Unzip App content"
  cd /app
  unzip /tmp/${component}.zip

  print_head "Install node dependencies"
  npm install

  print_head "Create App directory"
  cp ${script_name}/${component}.service /etc/systemd/system/${component}.service

  print_head "Start cart service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  schema_func
}