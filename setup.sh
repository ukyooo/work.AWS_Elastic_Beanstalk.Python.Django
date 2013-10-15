#! /bin/sh

sudo apt-get update ;
sudo apt-get upgrade -y ;

# 必要なパッケージをインストール
list_install=("git" "python-dev" "python-pip" "python-setuptools" "mysql-server" "libmysqlclient-dev" "sed")
for i in "${list_install[@]}"
do
  sudo apt-get install -y $i ;
done

