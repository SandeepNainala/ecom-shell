#!/bin/bash

app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_nodejs(){
  echo -e " $Y Configure nodeJs repos $N "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e " $Y Install NodeJs  $N "
  dnf install nodejs -y

  echo -e " $Y Add Application user $N "
  useradd ${app_user}

  echo -e " $Y Add Application Diretory $N "
  rm -rf /app
  mkdir /app

  echo -e " $Y Download App content $N "
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  echo -e " $Y Unzip App content $N "
  cd /app
  unzip /tmp/${component}.zip

  echo -e " $Y Install node dependencies $N "
  npm install

  echo -e " $Y Create App directory $N "
  cp ${script_name}/${component}.service /etc/systemd/system/${component}.service

  echo -e " $Y Start cart service $N "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}