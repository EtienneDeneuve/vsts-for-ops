#!/bin/bash -eux

while getopts ":i:h:d:u:p" opt; do
  case $opt in
    i) inputpasswd="$OPTARG"
    ;;
    h) DBHOSTALLOW="$OPTARG"
    ;;
    d) DBNAME="$OPTARG"
    ;;
    u) DBPROJECTUSER="$OPTARG"
    ;;
    p) DBPROJECTPWD="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo ${inputpasswd}
echo ${DBHOSTALLOW}
echo ${DBNAME}
echo ${DBPROJECTUSER}
echo ${DBPROJECTPWD}

# Set root password
sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password password "${inputpasswd}"'
sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password_again password "${inputpasswd}"'

# Install MySQL Server
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server-5.7

mysql -u root -proot -e "use mysql; UPDATE user SET authentication_string=PASSWORD('$inputpasswd') WHERE User='root'; flush privileges;"

echo "Creating DB Users and granting privileges with already collected information...\n"

mysql -u root -p$inputpasswd <<MYSQL_SCRIPT 
CREATE DATABASE $DBNAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON $DBNAME.* TO '$DBPROJECTUSER'@'$DBHOSTALLOW' IDENTIFIED BY '$DBPROJECTPWD';
FLUSH PRIVILEGES;
MYSQL_SCRIPT