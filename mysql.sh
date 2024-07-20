#!bin/bash
# check USER is root user not 
USERID=$(id -u)
TIMESTAM=$(date +%F-+%H-%M-%-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAM.log

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


        #Install MySQL Server 8.0.x
        dnf install mysql-server -y &>>LOGFILE
        VALIDATE $? "Insatll of mysql server"

       # enable MySQL Service
         systemctl enable mysqld &>>LOGFILE
          VALIDATE $? "Enabling of mysql server"

         # enable start Service
        systemctl start mysqld
        VALIDATE $? "start of mysql server"

        
        # mysql_secure_installation --set-root-pass ExpenseApp@1
        # VALIDATE $? "SETTING-UP ROOT PASSWORD"

        #Below code will be useful for "idempotent" nature
        mysql -h db.aws79s.online -uroot -pExpenseApp@1 -e 'SHOW DATABASES;'  &>>LOGFILE
        if [ $? -ne 0]
        then 

            mysql_secure_installation  --set-root-pass  ExpenseApp@1
            VALIDATE $?  "Mysql Root password Setup"
         else

         echo -e "MYSQL Root passord is already setup ...$Y Skipping $N"

fi

