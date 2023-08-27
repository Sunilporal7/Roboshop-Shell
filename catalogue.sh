script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m configuring Nodejs repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}

echo -e "\e[35m install Nodejs repos\e[0m"
yum install nodejs -y &>>${LOG}

echo -e "\e[35m Add application user\e[0m"
useradd roboshop &>>${LOG}

echo -e "\e[35m making directory\e[0m"
mkdir -p /app &>>${LOG}

echo -e "\e[35m Downloading app content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}

echo -e "\e[cleanup old content \e[0m"
rm -rf /app/* &>>${LOG}

echo -e "\e[Extracting app content\e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}

echo -e "\e[35m making directory\e[0m"
cd /app &>>${LOG}


npm install &>>${LOG}


cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}


systemctl daemon-reload &>>${LOG}


systemctl enable catalogue &>>${LOG}


systemctl start catalogue &>>${LOG}


cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}


yum install mongodb-org-shell -y &>>${LOG}


mongo --host mongodb-dev.devopsroboshop.online </app/schema/catalogue.js &>>${LOG}