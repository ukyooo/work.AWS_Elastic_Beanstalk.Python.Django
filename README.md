AWS Elastic Beanstalk を Python (Django) で動かしてみるワークショップ用
=======================================================================



### 目的

* AWS Elastic Beanstalk を使ったウェブアプリケーション公開までを知る

* Python (Django) の概要を知る

* pip / virtualenv / Fabric を少し知る

* AWS CLI (AWS-ElasticBeanstalk-CLI / ec2-api-tools) を少し知る







----

### 事前準備

----

#### sudo 権限のある環境 (Mac / Linux)

* 無い場合は報告して頂ければ EC2 の環境を用意するので ssh 接続可能なターミナルのみ準備



#### Python 2.7 & pip インストール

* 既にインストール済みであれば作業不要

```
which python2.7 ;

which pip ;

```

* 各自、使用しているパッケージマネージャを利用してインストールする。

##### Mac の場合

* Homebrew 利用の場合
```
# 下記のコマンドで python2.7 & pip の両方がインストールされる。
brew install python ;
```

* MacPorts 利用の場合
```
sudo port -v install python27 ;
sudo port -v install py27-setuptools ;

# 上記のコマンドだけで pip コマンドがインストールされている？されていない場合は下記を実行する。

sudo easy_install pip ;
```



##### Linux の場合

* apt-get 利用の場合 (Debian / Ubuntu / etc.)
```
sudo apt-get install -y python-dev ;
sudo apt-get install -y python-pip ;
sudo apt-get install -y python-setuptools ;
```

* yum (Yellowdog Updater Modified) 利用の場合 (Fedora / etc.)
```
# 下記のコマンドで python2.7 & pip の両方がインストールされる。
sudo yum install -y python27 ;
sudo yum install -y python-pip ;
```



----

#### 各種アカウント作成

##### GitHub

https://github.com/



##### AWS

http://aws.amazon.com/

* ただし、住所情報入力 / クレジットカード情報登録 / 電話確認 が有り、アカウント取得コストが高い為、
依頼を頂ければ一時的にアカウント作成を行います。

* クレジットカード情報登録はするが、今回の内容は無料枠に収まるレベルの為、支払いの請求は無い予定です。




----

###  作業開始

#### AWS User 作成

* AWS Identity and Access Management (IAM) で User (Access Key ID / Secret Access Key) 作成

https://console.aws.amazon.com/iam/

1. 'Users' に遷移して 'Create New Users' をクリックする。
2. 適当な UserName を入力し 'Generate an access key for each User' にチェックを入た状態で 'Create' をクリックする。
3. 'Show User Security Credentials' をクリックして 'Access Key ID' / 'Secret Access Key' をメモする。
4. 作成した UserName を選択し 'Permissions' のタブを開き 'Attach User Policy' をクリックする。
5. 'Select Policy Template' から 'AWS Elastic Beanstalk Full Access' を 'Select' して 'Apply Policy' する。



#### 環境構築

```
# git リポジトリを clone
git clone https://github.com/ukyooo/work.AWS_Elastic_Beanstalk.Python.Django.git work.AWSEBPD ;

cd work.AWSEBPD ;

sh init.sh ;

# virtualenv 起動
. ./tools/venv/bin/activate ;

# eb コマンド設定
PWD=`pwd` ; PYTHON27=`which python2.7` ; alias eb="$PYTHON27 $PWD/tools/AWS-ElasticBeanstalk-CLI-2.5.1/eb/linux/python2.7/eb" ;

# 
pip install -r requirements.txt ;

```

* virtualenv
http://www.virtualenv.org/en/latest/

* virtualenv 起動
```
$ . <virtualenv をインストールしたディレクトリ>/bin/activate ;
```

* virtualenv 終了
```
deactivate ;
```

* pip : Python Package Manager
http://www.pip-installer.org/en/latest/

```
pip freeze > requirements.txt ;
```
```
pip install -r requirements.txt ;
```



### AWS Elastic Beanstalk 

```
eb init ;
```

```
To get your AWS Access Key ID and Secret Access Key,
  visit "https://aws-portal.amazon.com/gp/aws/securityCredentials".
```

```
Enter your AWS Access Key ID: <AWS Access Key ID> <-
```

```
Enter your AWS Secret Access Key: <AWS Secret Access Key > <-
```

```
Select an AWS Elastic Beanstalk service region.
Available service regions are:
1) US East (Virginia)
2) US West (Oregon)
3) US West (North California)
4) EU West (Ireland)
5) Asia Pacific (Singapore)
6) Asia Pacific (Tokyo)
7) Asia Pacific (Sydney)
8) South America (Sao Paulo)
Select (1 to 8): 6 <-
```

```
Enter an AWS Elastic Beanstalk application name: <AWS Elastic Beanstalk Application Name> <-
```

```
Enter an AWS Elastic Beanstalk environment name: <AWS Elastic Beanstalk Environment Name> <-
```

```
Select a solution stack.
Available solution stacks are:
1) 32bit Amazon Linux running PHP 5.4
2) 64bit Amazon Linux running PHP 5.4
3) 32bit Amazon Linux running PHP 5.3
4) 64bit Amazon Linux running PHP 5.3
5) 32bit Amazon Linux running Node.js
6) 64bit Amazon Linux running Node.js
7) 64bit Windows Server 2008 R2 running IIS 7.5
8) 64bit Windows Server 2012 running IIS 8
9) 32bit Amazon Linux running Tomcat 7
10) 64bit Amazon Linux running Tomcat 7
11) 32bit Amazon Linux running Tomcat 6
12) 64bit Amazon Linux running Tomcat 6
13) 32bit Amazon Linux running Python
14) 64bit Amazon Linux running Python
15) 32bit Amazon Linux running Ruby 1.8.7
16) 64bit Amazon Linux running Ruby 1.8.7
17) 32bit Amazon Linux running Ruby 1.9.3
18) 64bit Amazon Linux running Ruby 1.9.3
Select (1 to 18): 14 <-
```

```
Select an environment type.
Available environment types are:
1) LoadBalanced
2) SingleInstance
Select (1 to 2): 1 <-
```

```
Create an RDS DB Instance? [y/n]: y <-
```

```
Create an RDS BD Instance from:
1) [No snapshot]
2) ...
3) ...
4) [Other snapshot]
Select (1 to 4): 1 <-
```

```
Enter an RDS DB master password: <RDS DB Pssword> <-
Retype password to confirm: <RDS DB Pssword> <-
```

```
If you terminate your environment, your RDS DB Instance will be deleted and you will lose your data.
Create snapshot? [y/n]: y <-
```

```
Attach an instance profile (current value is "aws-elasticbeanstalk-ec2-role"):
You IAM user does not have sufficient permission.
User: arn:aws:iam::xxxxxxxxxxxx:user/username is not authorized to perform: iam:ListInstanceProfiles on resource: arn:aws:iam::xxxxxxxxxxxx:instance-profile/
Do you want to proceed without attaching an instance profile? [y/n]: y <-
```

```
Updated AWS Credential file at "$HOME/.elasticbeanstalk/aws_credential_file".
```



* AWS Elastic Beanstalk 起動 (15分程度)
```
eb start ;
```
```
Starting application "(AWS Elastic Beanstalk Application Name)".
Would you like to deploy the latest Git commit to your environment? [y/n]: n <- 
Waiting for environment "workAWSEBPD-env" to launch.

...


```




----

### Python / Django

# install pip

# 

sh init.sh ;

```
Available subcommands:

[django]
    cleanup
    compilemessages
    createcachetable
*   dbshell
    diffsettings
    dumpdata
    flush
    inspectdb
    loaddata
    makemessages
    reset
    runfcgi
*   runserver
    shell
    sql
    sqlall
    sqlclear
    sqlcustom
    sqlflush
    sqlindexes
    sqlinitialdata
    sqlreset
    sqlsequencereset
*   startapp
*   startproject
*   syncdb
*   test
    testserver
    validate
```


### Django プロジェクト作成

* Creates a Django project directory structure for the given project name in the current directory or optionally in the given directory.

```
# $ django-admin.py startproject <ProjectName> <DestinationDirectory> ;
django-admin.py startproject hoge . ;

# manage.py 以外不要
rm __init__.py settings.py urls.py ;

# hoge/settings.py SECRET_KEY を settings/secret.yaml に移行

```

```
```

### Django アプリケーション作成

* Creates a Django app directory structure for the given app name in the current directory or optionally in the given directory.

```
# ProjectDirectory に移動
cd hoge ;

# $ django-admin.py startapp <ApplicationName> ;
django-admin.py startapp fuga ;
django-admin.py startapp piyo ;

cd .. ;

```

```
$ tree hoge
hoge/
├── __init__.py
├── fuga
│   ├── __init__.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
├── piyo
│   ├── __init__.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
├── settings.py
├── urls.py
└── wsgi.py
```

```
django-admin.py syncdb --noinput ;
```


### DB (MySQL)

```
django-admin.py dbshell ;
```




### .ebextensions について









----

### 事後処理

#### AWS Elastic Beanstalk 停止 (10分程度)

```
eb stop ;
```
```
If you terminate your environment, your RDS DB Instance will be deleted and you will lose your data.
Terminate environment? [y/n]: y <-

...

Stop of environment "<AWS Elastic Beanstalk Environment Name>" has completed.
```

#### AWS Elastic Beanstalk 削除

```
eb delete ;
```
```
Delete application? [y/n]: y <-
Deleted application "<AWS Elastic Beanstalk Application Name>".
```

----

