#/bin/bash
#----------------------------postgresql config----------------------
rpm -iUvh https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
yum -y install postgresql95 postgresql95-server postgresql95-contrib postgresql95-libs php php-pgsql
/usr/pgsql-9.5/bin/postgresql95-setup initdb
systemctl start postgresql-9.5.service
systemctl enable postgresql-9.5.service
sed -i "s/#listen_addresses.*/listen_addresses = '*'/g" /var/lib/pgsql/9.5/data/postgresql.conf
sed -i "s/#port=.*/port=5432/g" /var/lib/pgsql/9.5/data/postgresql.conf
sed -i "79a local   all             postgres                              trust" /var/lib/pgsql/9.5/data/pg_hba.conf
sed -i "81c local   all             all                                     md5" /var/lib/pgsql/9.5/data/pg_hba.conf
sed -i "83c host    all             all             127.0.0.1/32            md5" /var/lib/pgsql/9.5/data/pg_hba.conf
sed -i "85c host    all             all             ::1/128                 md5" /var/lib/pgsql/9.5/data/pg_hba.conf
systemctl restart postgresql-9.5.service
#----------------postgresql log---------------------
echo "新增資料庫: create database dbname;" >> postgresql_config.log
echo "新增使用者: CREATE USER dic WITH  PASSWORD 'dic';" >> postgresql_config.log
