#/bin/bash
#systemctl stop NetworkManager
#systemctl disable NetworkManager
systemctl stop firewalld
systemctl disable firewalld
systemctl restart iptables
systemctl enable iptables

echo -e "#!/bin/bash

iptables -F
iptables -X
iptables -Z

iptables -P INPUT  DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 2222 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT

iptables-save > /etc/sysconfig/iptables" > firewall.sh
sh firewall.sh
systemctl restart iptables
#-----------------------------selinux config---------------------
sed -i "s/SELINUX=.*/SELINUX=permissive/g" /etc/selinux/config
#-----------------------------sshd config---------------------
sed -i "s/#Port.*/Port 2222/g" /etc/ssh/sshd_config
semanage port -a -t ssh_port_t -p tcp 2222
systemctl restart sshd
systemctl enable sshd
#-----------------------------httpd config---------------------
yum install httpd -y
systemctl start httpd
systemctl enable httpd
sed -i "s/UserDir.*/UserDir www/g" /etc/httpd/conf.d/userdir.conf
sed -i "s/<Directory.*/<Directory \"\/home\/*\/www\">/g" /etc/httpd/conf.d/userdir.conf
systemctl restart httpd
mkdir /etc/skel/www
#----------------------------vsftpd config----------------------
yum install vsftpd -y
systemctl start vsftpd
systemctl enable vsftpd
sed -i "s/anonymous_enable.*/anonymous_enable=NO/g" /etc/vsftpd/vsftpd.conf
sed -i "s/#chroot_local.*/chroot_local_user=YES/g" /etc/vsftpd/vsftpd.conf
sed -i "s/#chroot_list_enable.*/chroot_list_enable=YES/g" /etc/vsftpd/vsftpd.conf
sed -i "s/#chroot_list_file.*/chroot_list_file=\/etc\/vsftpd\/chroot_list/g" /etc/vsftpd/vsftpd.conf
sed -i "s/listen_ipv6=YES.*/#listen_ipv6=YES/g" /etc/vsftpd/vsftpd.conf
echo "use_localtime=YES" >> /etc/vsftpd/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf
touch /etc/vsftpd/chroot_list
systemctl restart vsftpd
#----------------status log---------------------
iptables-save > iptables.log
systemctl status NetworkManager |grep Loaded>> status.log
systemctl status NetworkManager |grep Active>> status.log
systemctl status firewalld |grep Loaded>> status.log
systemctl status firewalld |grep Active>> status.log
systemctl status iptables |grep Loaded>> status.log
systemctl status iptables |grep Active>> status.log
systemctl status httpd |grep Loaded>> status.log
systemctl status httpd |grep Active>> status.log
systemctl status vsftpd |grep Loaded>> status.log
systemctl status vsftpd |grep Active>> status.log
