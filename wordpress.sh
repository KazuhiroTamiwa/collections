# 変数定義 => MySQLの設定で必須
database=wordpress
user=hogehoge
password=hogehoge
host_name=localhost



# yumで必要なものインストール
yum -y install httpd mysql-server php php-mysql wget


# ポート開放
service iptables restart
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT


# Apacheの起動、自動起動設定
service httpd restart
chkconfig httpd on


# PHPの設定ファイルのバックアップ、timezoneの設定
cp /etc/php.ini /etc/php.ini.org
sed -i -e "s/date\.timezone =/date\.timezone = Asia\/Tokyo/g" /etc/php.ini
#設定を反映
service httpd restart


# Wordpressのダウンロードと解凍
wget http://ja.wordpress.org/wordpress-4.3-ja.tar.gz
tar zxvf wordpress-4.3-ja.tar.gz


# Wordpressファイルを/var/www/配下にコピーし、apacheで読み込めむ
cp -r wordpress /var/www/
chown -R apache.apache /var/www/wordpress

# /etc/httpd/conf/httpd.confのバックアップと編集
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.org
sed -i -e "s/\/var\/www\/html/\/var\/www\/wordpress/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/Directory \//Directory \/var\/www\/wordpress/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf

#Apachenのバージョン非表示
sed -i -e "s/ServerTokens OS/ServerTokens Prod/g" /etc/httpd/conf/httpd.conf



# MySQLの起動と設定
service mysqld start
chkconfig mysqld on
mysql -u root  -e "create database $database"
mysql -u root  -e "grant all privileges on $database.* to $user@$host_name identified by '$password'"



# wp-config.phpのバックアップ
# Wordpressへデータベースの設定を書き込む
cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

sed -i -e "s/define('DB_NAME', 'database_name_here')/define('DB_NAME', '$database')/g" /var/www/wordpress/wp-config.php
sed -i -e "s/define('DB_USER', 'username_here')/define('DB_USER', '$user')/g" /var/www/wordpress/wp-config.php
sed -i -e "s/define('DB_PASSWORD', 'password_here')/define('DB_PASSWORD', '$password')/g" /var/www/wordpress/wp-config.php
sed -i -e "s/define('DB_HOST', 'localhost')/define('DB_HOST', '$host_name')/g" /var/www/wordpress/wp-config.php
sed -i -e "s/define('DB_CHARSET', 'utf8')/define('DB_CHARSET', 'utf8')/g" /var/www/wordpress/wp-config.php


# httpd.confの反映
service httpd restart
