#! /bin/bash

echo "---- start  : apt-get update & upgrade" ;
sudo apt-get update ;
sudo apt-get upgrade -y ;
echo "---- done   : apt-get update & upgrade" ;

# 必要なパッケージをインストール
list_install=(
  "git"
  "python-dev"
  "python-pip"
  "python-setuptools"
  "libmysqlclient-dev"
  "sed"
)
for i in "${list_install[@]}"
do
  sudo apt-get install -y $i ;
done

echo "Successfully setup" ;

