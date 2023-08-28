source common.sh

print_head "configure NodeJs Repo"
yum install nginx -y &>>${LOG}
status_check

print_head "Enabling Nginx"
systemctl enable nginx &>>${LOG}
status_check

print_head "start nginx"
systemctl start nginx &>>${LOG}
status_check

print_head "remove nginx old file"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "copy nginx old file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html &>>${LOG}
status_check

print_head "unzip frontend"
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "copy nginx config file"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

systemctl restart nginx &>>${LOG}
status_check