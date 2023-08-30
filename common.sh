script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check(){
if [ $? -eq 0 ];
then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo -e "\e[31m FAILURE\e[0m"
  fi
  }

print_head () {
  echo -e "\e[1m $1 \e[0m"
}

Nodejs(){
print_head "configuring Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "install Nodejs repos"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add application user"
id roboshop &>>${LOG}
if [ $? -ne 0 ]
then
useradd roboshop &>>${LOG}
fi
status_check

print_head "making directory"
mkdir -p /app &>>${LOG}
status_check

print_head "Downloading app content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
status_check

print_head "cleanup old content "
rm -rf /app/* &>>${LOG}
status_check

print_head "Extracting app content"
cd /app &>>${LOG}
unzip /tmp/${component}.zip &>>${LOG}
status_check

print_head "installing nodejs dependecies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "configure ${component}.service"
cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
status_check

print_head "Demon reload"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Eanable ${component}"
systemctl enable ${component} &>>${LOG}
status_check

print_head "Start ${component}"
systemctl start ${component} &>>${LOG}
status_check

if [ ${schema_load} == "true" ]
then
 print_head "Configure mongo repo"
 cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
 status_check

 print_head "Install mongo client"
 yum install mongodb-org-shell -y &>>${LOG}
 status_check

 print_head "load schema"
 mongo --host mongodb-dev.devopsroboshop.online </app/schema/${component}.js &>>${LOG}
 status_check
fi
}