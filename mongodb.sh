source common.sh

print_head "copy Mongo DB Repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "install Mongo DB"
yum install mongodb-org -y &>>$(LOG)
status_check

systemctl enable mongod &>>$(LOG)
status_check

systemctl start mongod &>>$(LOG)
status_check

print_head "update Mongo DB listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$(LOG)
status_check

systemctl restart mongod &>>$(LOG)
status_check