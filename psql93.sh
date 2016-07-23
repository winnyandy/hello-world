#/bin/bash
#----------------------------postgresql config----------------------
rpm -iUvh http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm
yum -y install postgresql93 postgresql93-server postgresql93-contrib postgresql93-libs php php-pgsql
/usr/pgsql-9.3/bin/postgresql93-setup initdb
systemctl start postgresql-9.3.service
systemctl enable postgresql-9.3.service
sed -i "s/#listen_addresses.*/listen_addresses = '*'/g" /var/lib/pgsql/9.3/data/postgresql.conf
sed -i "s/#port=.*/port=5432/g" /var/lib/pgsql/9.3/data/postgresql.conf
systemctl restart postgresql-9.3.service
#----------------postgresql log---------------------
echo "新增資料庫: create database dbname;" >> postgresql_config.log
echo "新增使用者: CREATE USER dic WITH  PASSWORD 'dic';" >> postgresql_config.log
