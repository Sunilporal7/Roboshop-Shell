source common.sh

if [ -z "${roboshop_rabbitmq_password}"  ]; then
  echo "variable roboshop_rabbitmq_password is missing"
  exit
fi

print_head "configuring erlang yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${LOG}
status_check

print_head "configuring rabbitmq yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG}
status_check

print_head "install rabbitmq server  "
yum install rabbitmq-server -y &>>${LOG}
status_check

print_head "enable rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "start rabbitmq server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "add application user"
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
status_check

print_head "add permission to user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check
