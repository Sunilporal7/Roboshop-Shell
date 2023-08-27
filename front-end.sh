source common.sh
echo -e "\e[35m install nginx\e[0m"
yum install nginx -y &>>${LOG}
status_check

echo -e "\e[35m enable nginx\e[0m"
systemctl enable nginx &>>${LOG}
status_check

echo -e "\e[35m start nginx\e[0m"
systemctl start nginx &>>${LOG}
status_check

echo -e "\e[35m remove nginx old file\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

echo -e "\e[35m copy nginx old file\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html &>>${LOG}
status_check

echo -e "\e[35m unzip frontend\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
status_check

echo -e "\e[35m copy nginx config file\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

systemctl restart nginx &>>${LOG}
status_check