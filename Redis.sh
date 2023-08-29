source common.sh
print_head "setup Redis repos"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
status_check

print_head "Enabling Redis 6.2 dnf module"
yum module enable redis:remi-6.2 -y &>>${LOG}
status_check

print_head "Redis install "
yum install redis -y &>>${LOG}
status_check

print_head "update Redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG}
status_check

systemctl enable Redis &>>${LOG}
status_check

systemctl start Redis &>>${LOG}
status_check