#! /bin/bash

APT_GET=`which apt-get ;`

if [ ! $PIP ]; then
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
)
for i in "${list_install[@]}"
do
  sudo apt-get install -y $i ;
done

# 必要なツールを tools 配下にインストール
sh install_tools.sh ;

# eb コマンド設定
PWD=`pwd` ;
PYTHON27=`which python2.7` ;
alias eb="$PYTHON27 $PWD/tools/AWS-ElasticBeanstalk-CLI-2.5.1/eb/linux/python2.7/eb" ;

echo "Successfully setup" ;

