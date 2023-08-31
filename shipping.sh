source common.sh

if [ -z "${root_mysql_password}" ]
 then
 echo "variable mysql root password is nedded"
 exit
fi

component=shipping
schema_load=true
schema_type=mysql

maven
