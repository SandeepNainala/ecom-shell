R="\e[31m"
G="\e[32m"
Y="\e[33m"
C="\e[36m"
N="\e[0m"

echo -e " $Y Install Redis repos $N "
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e " $Y Install Redis repos $N "
yum module enable redis:remi-6.2 -y
yum install redis -y

echo -e " $Y Update Redis Listen address $N "
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf

echo -e " $Y Start Redis service $N "
systemctl enable redis
systemctl start redis