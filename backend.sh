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
            echo -e "$2.... $R Failre $N"
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
    
# useradd expense &>>$LOGFILE
# VALIDATE $? "creating expense user" 

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense  &>>$LOGFILE
    VALIDATE $? "Creating expense user"
 else
  echo -e "Expense user already created ..... $Y SKIPPING $N"
fi


# mkdir -p /app if dir pesent ingone otherwise creating

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading backend code"



cd /app &>>$LOGFILE
rm -rf /app/* # removing exiting code 

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracted backend code........."

npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependence..............."

#vim /etc/systemd/system/backend.service not for script
#create backend.service file
#D:\devops\dwas-78sec\repos\backend.service

cp  D:/devops/dwas-78sec/repos/backend.service  /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "copied backend service.."


systemctl daemon-reload &>>$LOGFILE
VALIDATE $? " daemon-reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Starting backend "
systemctl enable backend &>>$LOGFILE
VALIDATE $? "enable  backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql"

mysql -h db.aws79s.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading..."

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restaring backend"


