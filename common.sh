#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

print_head() {
  echo -e "$Y =================== $1 =================== $N"
  echo -e "$Y =================== $1 =================== $N" &>>$log_file
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
    cp ${script_name}/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$log_file
    func_status_check $?

    print_head "Install MongoDB repo"
    yum install mongodb-org -y &>>$log_file
    func_status_check $?

    print_head "Start MongoDB"
    mongo --host mongodb-dev.devops91.cloud </app/schema/${component}.js &>>$log_file
    func_status_check $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then

    print_head " install MySQL "
    yum install mysql -y &>>$log_file
    func_status_check $?

    print_head " Load schema "
    mysql -h mysql-dev.devops91.cloud -uroot -p${mysql_root_password} < /app/schema/shipping.sql  &>>$log_file
    func_status_check $?
  fi
}

func_app_prereq(){

  print_head " Add Application user "
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>/tmp/roboshop.log
  fi
  func_status_check $?

  print_head " Create Application directory "
  rm -rf /app &>>$log_file
  mkdir /app  &>>$log_file
  func_status_check $?

  print_head " Download App content "
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_status_check $?

  print_head " Unzip App content "
  cd /app
  unzip /tmp/${component}.zip &>>$log_file
  func_status_check $?
}

func_systemd_setup(){

  print_head " Copy ${component} systemd files "
  cp ${script_name}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_status_check $?

  print_head " start ${component}  systemd files "
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_status_check $?

}

func_nodejs(){

  print_head "Configure nodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status_check $?

  print_head "Install NodeJs"
  yum install nodejs -y &>>$log_file
  func_status_check $?

  func_app_prereq

  print_head "Install node dependencies"
  npm install &>>$log_file
  func_status_check $?

  func_schema_setup
  func_systemd_setup
}


func_java(){

  print_head  " Install maven repository "
  yum install maven -y &>>$log_file

  func_status_check $?

  func_app_prereq

  print_head " Install maven dependencies "
  mvn clean package &>>$log_file

  func_status_check $?

  mv target/${component}-1.0.jar ${component}.jar &>>$log_file

  func_schema_setup
  func_systemd_setup

}

func_python() {
  print_head "Install Python3"
  yum install python36 gcc python3-devel -y &>>$log_file # This will install the python3 & python3-devel packages
  func_status_check $?

  func_app_prereq # This function will create a application user & directory and download the application code

  print_head "Install Python dependencies"
  pip3.6 install -r requirements.txt &>>$log_file # This will install the dependencies from requirements.txt file
  func_status_check $? # This will check the exit status of the previous command

  print_head "Update App Configuration"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_name}/${component}.service &>>$log_file # This will replace the password in the file
  func_status_check $?


  func_systemd_setup # This function will setup the systemd service for the component
}