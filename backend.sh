#!bin/bash
# check USER is root user not 
USERID=$(id -u)
TIMESTAM=$(date +%F-+%H-%M-%-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAM.log
echo "Please enter db password...."
read -s mysql_root_password
#colors 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
        if [ $1 -ne 0 ]
        then 
            echo -e "$2.... $R Failur $N"
            exit
        else
                echo -e "$2.... $G Success $N"
        fi        



}

if [ $USERID -ne 0 ]
    then
        echo "Please run this script with root access"
    else
        echo "You are supper user"
    fi

 dnf module disable nodejs -y &>>$LOGFILE
 VALIDATE $? "Disabling default nodejs version"   

 dnf module enable nodejs:20 -y &>>$LOGFILE
 VALIDATE $? "Enable module nodejs:20 version "

 dnf install nodejs -y &>>$LOGFILE
 VALIDATE $? "installing  nodejs"
    
useradd expense &>>$LOGFILE
VALIDATE $? "creating expense user" 