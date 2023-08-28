source common.sh
print_head "configuring Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "install Nodejs repos"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add application user"
id roboshop &>>${LOG}
if [$? -ne 0]
then
useradd roboshop &>>${LOG}
fi
status_check

print_head "making directory"
mkdir -p /app &>>${LOG}
status_check

print_head "Downloading app content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "cleanup old content "
rm -rf /app/* &>>${LOG}
status_check

print_head "Extracting app content"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "installing nodejs dependecies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "configure catalogue.service"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "Demon reload"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Eanable catalogue"
systemctl enable catalogue &>>${LOG}
status_check

print_head "Start Catalogue"
systemctl start catalogue &>>${LOG}
status_check

print_head "Configure mongo repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Install mongo client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "load schema"
mongo --host mongodb-dev.devopsroboshop.online </app/schema/catalogue.js &>>${LOG}
status_check