#! /bin/bash

if [ ! `which apt-get ;` ]; then
  echo "NG : not exists apt-get command."
  exit 1
fi

echo "---- start  : apt-get update & upgrade" ;
sudo apt-get update ;
sudo apt-get upgrade -y ;
echo "---- done   : apt-get update & upgrade" ;

# 必要なパッケージをインストール
list_install=(
  "git"
  "patch"
  "python-dev"
  "python-pip"
  "python-setuptools"
  "libmysqlclient-dev"
  "sed"
  "unzip"
  "tree"
  "ruby-full"
)
for i in "${list_install[@]}"
do
  sudo apt-get install -y $i ;
done

# mysql-server をインストール
# sudo apt-get install -y mysql-server ;
# パスワード設定が必要なので手動でインストールする。

# 必要なツールを tools 配下にインストール
sh install_tools.sh ;

echo "Successfully setup" ;

