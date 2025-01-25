#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=cart

func_nodejs
