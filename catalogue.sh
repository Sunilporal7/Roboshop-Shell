source common.sh
echo -e "\e[35m configuring Nodejs repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

echo -e "\e[35m install Nodejs repos\e[0m"
yum install nodejs -y &>>${LOG}
status_check

echo -e "\e[35m Add application user\e[0m"
useradd roboshop &>>${LOG}
status_check

echo -e "\e[35m making directory\e[0m"
mkdir -p /app &>>${LOG}
status_check

echo -e "\e[35m Downloading app content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[cleanup old content \e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[Extracting app content\e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m installing nodejs dependecies\e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

echo -e "\e[35m configure catalogue.service\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

echo -e "\e[35m Demon reload\e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[35m Eanable catalogue\e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[35m Start Catalogue\e[0m"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\Configure mongo repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

echo -e "\e[35m Install mongo client \e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[35m load schema\e[0m"
mongo --host mongodb-dev.devopsroboshop.online </app/schema/catalogue.js &>>${LOG}
status_check