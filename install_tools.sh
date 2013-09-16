#! /bin/sh

PWD=`pwd ;`
PIP=`which pip ;`
PYTHON27=`which python2.7 ;`
VIRTUALENV=`which virtualenv ;`

if [ ! $PIP ]; then
  echo "NG : not exists pip command. please install pip command."
  exit 1
fi

if [ ! $PYTHON27 ]; then
  echo "NG : not exists Python 2.7 command. please install Python 2.7 command."
  exit 1
fi

# 必要なツールを格納するディレクトリを作成
if [ ! -d tools ]; then
  echo "mkdir tools"
  mkdir tools ;
else
  echo "already mkdir tools"
fi

# virtualenv インストール
if [ ! $VIRTUALENV ]; then
  echo "install virtualenv : Please enter the password for 'sudo' " ;
  sudo pip install --upgrade virtualenv ;
fi

# virtualenv 設定
if [ ! -d tools/venv ]; then
  virtualenv --python=$PYTHON27 $PWD/tools/venv ;
fi

cd tools ;

# eb コマンドをインストール
if [ ! -d AWS-ElasticBeanstalk-CLI-2.5.1 ]; then
  wget https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.5.1.zip ;
  unzip AWS-ElasticBeanstalk-CLI-2.5.1.zip ;
  rm AWS-ElasticBeanstalk-CLI-2.5.1.zip ;
fi

# ec2-api-tools をインストール
if [ ! -d ec2-api-tools-* ]; then
  wget http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip ;
  unzip ec2-api-tools.zip ;
  rm ec2-api-tools.zip ;
fi

cd .. ;

echo "Successfully installed tools" ;

