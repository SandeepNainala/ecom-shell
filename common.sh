#!/bin/bash

app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "$Y =================== $* =================== $N"
}

func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
    print_head "Copy mongoDB repo file"
    cp ${script_name}/mongodb.repo /etc/yum.repos.d/mongodb.repo

    print_head "Install MongoDB repo"
    yum install mongodb-org -y

    print_head "Start MongoDB"
    mongo --host mongodb-dev.devops91.cloud </app/schema/${component}.js
  fi
  if [ "${schema_setup}" == "mysql" ]; then

    print_head " install MySQL "
    yum install mysql -y

    print_head " Load schema "
    mysql -h mysql-dev.devops91.cloud -uroot -p${mysql_root_password} < /app/schema/shipping.sql
  fi
}

func_app_prereq(){

  print_head " Add Application user "
  useradd ${app_user}

  print_head " Create Application directory "
  rm -rf /app
  mkdir /app

  print_head " Download App content "
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  print_head " Unzip App content "
  cd /app
  unzip /tmp/${component}.zip
}

func_systemd_setup(){

  print_head " Copy ${component} systemd files "
  cp ${script_name}/${component}.service /etc/systemd/system/${component}.service

  print_head " start ${component}  systemd files "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}

func_nodejs(){

  print_head "Configure nodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install NodeJs"
  dnf install nodejs -y

  func_app_prereq

  print_head "Install node dependencies"
  npm install

  func_schema_setup
  func_systemd_setup
}


func_java(){

  print_head  " Install maven repository "
  yum install maven -y

  func_app_prereq

  print_head " Install maven dependencies "
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup
  func_systemd_setup

}