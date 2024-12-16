#!/bin/bash

ID=$(id -u)#root user decleration

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[om"

TIMESTAMP=$(date +%F-%H)

LOG_FILE="/tmp/$0-$TIMESTAMP"

echo "Script is executing at $TIMESTAMP" &>> $LOG_FILE 

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 .....$R  failed $N"
        exit 1
    else
        echo -e "$2 ..... $G  success $N"
    fi

}

if [ $ID -ne 0 ]
then
     echo -e " $R error : you are not a root user $N"
     exit 1
else 
     echo  -e " $G you are a root user $N"
fi

dnf module disable nodejs -y &>> $LOG_FILE 

validate $? "disabiling node js"

dnf module enable nodejs:18 -y &>> $LOG_FILE 

validate $? "enable node js"

dnf install nodejs -y &>> $LOG_FILE 

validate $? "install  node js"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOG_FILE 
    validate $? "user added roboshop"
else
     echo -e "$Y already exists $N"
fi

mkdir -p /app &>> $LOG_FILE 

validate $? "app directory creating"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOG_FILE 

validate $? "catalogue zip is downloading"

cd /app &>> $LOG_FILE 

validate $? "change to app directory"

unzip -o /tmp/catalogue.zip &>> $LOG_FILE 

validate $? "unzip catalogue"

# cd /app &>> $LOG_FILE 

# validate $? "change to app directory"

npm install  &>> $LOG_FILE 

validate $? "install dependencies"

cp /c/Users/pnvpr/Devops/SHELL-SCRIPT/roboshop-shell/catalogue.service  /etc/systemd/system/catalogue.service &>> $LOG_FILE #give absolute path where cataogue service is there

validate $? "copied successfully"

systemctl daemon-reload  &>> $LOG_FILE 

validate $? "demon reload"

systemctl enable catalogue &>> $LOG_FILE 


validate $? "enable cataogue"

systemctl start catalogue &>> $LOG_FILE 

validate $? "start cataogue"

cp /c/Users/pnvpr/Devops/SHELL-SCRIPT/roboshop-shell/mongodb.repo  /etc/yum.repos.d/mongo.repo &>> $LOG_FILE 

validate $? "mongo db daata done "

dnf install mongodb-org-shell -y &>> $LOG_FILE

validate $? "shell installation"

mongo --host mongodb.pranitdevops.site </app/schema/catalogue.js &>> $LOG_FILE

validate $? " mongodb schema"











