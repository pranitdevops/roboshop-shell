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

cp mongodb.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

validate $? "coppied mongodb repo successfully"

dnf install mongodb-org -y  &>> $LOG_FILE

validate $? "installed mongodb successfuly" 

systemctl enable mongod &>> $LOG_FILE

validate $? "enabled mongodb successfuly" 

systemctl start mongod &>> $LOG_FILE

validate $? "start mongodb successfuly" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG_FILE

validate $? "SED changes are done"

systemctl restart mongod &>> $LOG_FILE

validate $? "Restart mongodb is"









