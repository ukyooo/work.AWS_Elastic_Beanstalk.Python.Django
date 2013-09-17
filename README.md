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

----

#### git コマンドをインストール

#### mysql (mysql-client) コマンドをインストール

#### patch コマンドをインストール

#### GNU sed コマンドをインストール

##### Mac の場合

* Mac にプリインストールされている sed は BSD sed の為、

###### Homebrew 利用の場合

```
brew install gnu-sed ;
alias sed='gsed' ;
```

###### MacPorts 利用の場合

```
sudo port install gsed ;
alias sed='gsed' ;
```



#### Python 2.7 / pip インストール

* 既にインストール済みであれば作業不要

```
which python2.7 ;

which pip ;

which mysql ;

```

* 各自、使用しているパッケージマネージャを利用してインストールする。

##### Mac の場合

###### Homebrew 利用の場合

```
# 下記のコマンドで python2.7 & pip の両方がインストールされる。
brew install python ;

brew install mysql ;
```

###### MacPorts 利用の場合

```
sudo port -v install python27 ;
sudo port -v install py27-setuptools ;
# 上記のコマンドだけで pip コマンドがインストールされている？されていない場合は下記を実行する。
sudo easy_install pip ;
```

##### Linux の場合

###### apt-get 利用の場合 (Debian / Ubuntu / etc.)

```
sudo apt-get install -y python-dev ;
sudo apt-get install -y python-pip ;
sudo apt-get install -y python-setuptools ;
sudo apt-get install -y mysql-server ;
sudo apt-get install -y libmysqlclient-dev ;
sudo apt-get install -y libmysqlclient-dev ;
```

###### yum (Yellowdog Updater Modified) 利用の場合 (Fedora / etc.)

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

### 作業開始

* そもそも AWS Elastic Beanstalk とは何かの説明の前に下記の作業を進めて頂きます。

#### 環境構築

* git リポジトリを clone

```
git clone https://github.com/ukyooo/work.AWS_Elastic_Beanstalk.Python.Django.git work.AWSEBPD ;

cd work.AWSEBPD ;
```

* ディレクトリの中身

```
.
├── .gitignore

├── .ebextensions
│   └── .config

├── .elasticbeanstalk
│   ├── ...
│   └── ...

├── README.md

├── fabfile.py

├── install_tools.sh

├── project_sample
│   ├── ...
│   └── ...

├── requirements.txt

├── scripts
│   ├── ...
│   └── ...

├── settings
│   ├── config.yaml
│   └── secret.yaml.template

├── statics

└── templates

```

* 必要なツールをインストール
```
# virtualenv や AWS の CLI tool などをインストール
sh install_tools.sh ;
```

* eb コマンド設定
```
PWD=`pwd` ; PYTHON27=`which python2.7` ; alias eb="$PYTHON27 $PWD/tools/AWS-ElasticBeanstalk-CLI-2.5.1/eb/linux/python2.7/eb" ;
```

* シークレット情報管理 yaml ファイル作成
```
cp settings/secret.yaml.template settings/secret.yaml ;
```
【注意】
今回、シークレット情報を yaml ファイルで管理して読み込んで使う方法を取りますが、
シークレット情報を何らかの手段で秘匿する方法については触れません。

----

#### AWS User 作成

* AWS Identity and Access Management (IAM) で User (Access Key ID / Secret Access Key) 作成

https://console.aws.amazon.com/iam/

1. 'Users' に遷移して 'Create New Users' をクリックする。
2. 適当な UserName を入力し 'Generate an access key for each User' にチェックを入た状態で 'Create' をクリックする。
3. 'Show User Security Credentials' をクリックして 'Access Key ID' / 'Secret Access Key' をメモする。
```
# settings/secret.yaml
aws:
  # AWS Access Key ID
  access_key: '' <-
  # AWS Secret Access Key
  secret_key: '' <-
```
4. 作成した UserName を選択し 'Permissions' のタブを開き 'Attach User Policy' をクリックする。
5. 'Select Policy Template' から 'AWS Elastic Beanstalk Full Access' を 'Select' して 'Apply Policy' する。

----

#### AWS Elastic Beanstalk 設定

```
eb init ;
```
```
To get your AWS Access Key ID and Secret Access Key,
  visit "https://aws-portal.amazon.com/gp/aws/securityCredentials".
```
* AWS Access Key ID / AWS Secret Access Key を入力
```
Enter your AWS Access Key ID: <AWS Access Key ID>           # <-
Enter your AWS Secret Access Key: <AWS Secret Access Key>   # <-
```
* region 選択
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
Select (1 to 8): 6 # <- 6) Asia Pacific (Tokyo)
```
* アプリケーション名を入力
```
Enter an AWS Elastic Beanstalk application name: <AWS Elastic Beanstalk Application Name> # <-
```
* 環境名を入力 (例 : production / staging / development など)
```
Enter an AWS Elastic Beanstalk environment name: <AWS Elastic Beanstalk Environment Name> # <-
```
* solution stack 選択
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
Select (1 to 18): 14 # <- 14) 64bit Amazon Linux running Python
```
```
Select an environment type.
Available environment types are:
1) LoadBalanced
2) SingleInstance
Select (1 to 2): 1 # <- 1) LoadBalanced
```
```
Create an RDS DB Instance? [y/n]: y # <- Yes
```
```
Create an RDS BD Instance from:
1) [No snapshot]
2) ...
3) ...
4) [Other snapshot]
Select (1 to 4): 1 # <- 1) [No snapshot]
```
* settings/secret.yaml の databases.common.default.PASSWORD に記録
```
Enter an RDS DB master password: <RDS DB Pssword> # <-
Retype password to confirm: <RDS DB Pssword>      # <-
```
```
If you terminate your environment, your RDS DB Instance will be deleted and you will lose your data.
Create snapshot? [y/n]: y # <- Yes
```
```
Attach an instance profile (current value is "aws-elasticbeanstalk-ec2-role"):
You IAM user does not have sufficient permission.
User: arn:aws:iam::xxxxxxxxxxxx:user/username is not authorized to perform: iam:ListInstanceProfiles on resource: arn:aws:iam::xxxxxxxxxxxx:instance-profile/
Do you want to proceed without attaching an instance profile? [y/n]: y # <- Yes
```
```
Updated AWS Credential file at "$HOME/.elasticbeanstalk/aws_credential_file".
```

----

#### AWS Elastic Beanstalk 起動

* AWS Elastic Beanstalk 起動 (15分程度)
```
eb start ;
```
```
Starting application "(AWS Elastic Beanstalk Application Name)".
Would you like to deploy the latest Git commit to your environment? [y/n]: n # <- No : まだデプロイしない為
Waiting for environment "<AWS Elastic Beanstalk Environment Name>" to launch.

YYYY-MM-DD hh:mm:ss INFO  createEnvironment is starting.
YYYY-MM-DD hh:mm:ss INFO  Using <> as Amazon S3 storage bucket for environment data.
YYYY-MM-DD hh:mm:ss INFO  Created load balancer named: <xxxx>
YYYY-MM-DD hh:mm:ss INFO  Created security group named: <xxxx>
YYYY-MM-DD hh:mm:ss INFO  Created Auto Scaling launch configuration named: <xxxx>
YYYY-MM-DD hh:mm:ss INFO  Creating RDS database named: <DB Instance Identifier>. This may take a few minutes.
YYYY-MM-DD hh:mm:ss INFO  Created RDS database named: <DB Instance Identifier>
YYYY-MM-DD hh:mm:ss INFO  Waiting for EC2 instances to launch. This may take a few minutes.
YYYY-MM-DD hh:mm:ss INFO  Created Auto Scaling group named: <xxxx>
YYYY-MM-DD hh:mm:ss INFO  Created Auto Scaling group policy named: <xxxx>
YYYY-MM-DD hh:mm:ss INFO  Created Auto Scaling group policy named: <xxxx>
YYYY-MM-DD hh:mm:ss INFO  Created CloudWatch alarm named: <xxxx>
YYYY-MM-DD hh:mm:ss INFO  Created CloudWatch alarm named: <xxxx>

```

----

#### AWS Elastic Beanstalk とは

http://aws.amazon.com/jp/elasticbeanstalk/

EC2 (Amazon Elastic Cloud Compute)
S3 (Amazon Simple Storage Service)
SNS (Amazon Simple Notification Service)
ELB (Elastic Load Balancing)
Auto Scaling 



----

#### Python / Django

* Python 2.7.x or 3.0.x
* Django 1.3.3 or 1.4.1

* 今回 : Python 2.7.x + Django 1.4.1



##### pip & virtualenv

* pip : Python Package Manager
http://www.pip-installer.org/en/latest/

* virtualenv : pip でインストールしたパッケージのバージョンを仮想環境単位に管理
http://www.virtualenv.org/en/latest/



* virtualenv 設定
```
# $ virtualenv <virtualenv の環境を格納するディレクトリ> ;
# $ sh install_tools.sh で実行済みの為、skip
```

* virtualenv 起動
```
# $ . <virtualenv の環境を格納したディレクトリ>/bin/activate ;
. ./tools/venv/bin/activate ;
```

* 今回使用する Python パッケージをインストール
```
cat requirements.txt ;

# Django (1.4.1) / MySQL-python (1.2.3) をインストール
pip install -r requirements.txt ;

pip install PyYAML ;

pip install Fabric ;

# Output all currently installed packages (exact versions) to stdout
pip freeze > requirements.txt ;

git diff requirements.txt ;

```

----

#### Django

```
django-admin.py -h ;
```
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

##### Django プロジェクト作成

* Creates a Django project directory structure for the given project name in the current directory or optionally in the given directory.
* 'hoge' というプロジェクトを作成
```
# $ django-admin.py startproject <ProjectName> <DestinationDirectory> ;
django-admin.py startproject hoge . ;
```

* startproject (Django 1.4.1 の場合) を実行してできたファイル
```
$ git status ;
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
# hoge/
# manage.py
```
* ./manage.py は django-admin.py と同じように Django 管理コマンドだが、 ./manage.py はプロジェクト別に追加したモジュール等で機能追加される。
http://docs.djangoproject.jp/en/latest/ref/django-admin.html
```
django-admin.py -h ;

python ./manage.py -h ;

```


```
$ tree hoge/
hoge/
├── __init__.py
├── settings.py
├── urls.py
└── wsgi.py
```



----

##### Django アプリケーション作成

* Creates a Django app directory structure for the given app name in the current directory or optionally in the given directory.

```
# ProjectDirectory に移動
cd hoge ;

# $ django-admin.py startapp <ApplicationName> ;
django-admin.py startapp fuga ;
django-admin.py startapp piyo ;

cd .. ;

```

* hoge Project のディレクトリ構成
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

----

##### Django settings 編集

https://docs.djangoproject.com/en/1.4/topics/settings/

* settings/secret.yaml を読み込むように修整
```
```
```
patch -s ... ... ;
```

* DATABASES を SETTINGS_SECRET から設定されるように修整
```
@@ -9,16 +41,8 @@

 MANAGERS = ADMINS

-DATABASES = {
-    'default': {
-        'ENGINE': 'django.db.backends.', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
-        'NAME': '',                      # Or path to database file if using sqlite3.
-        'USER': '',                      # Not used with sqlite3.
-        'PASSWORD': '',                  # Not used with sqlite3.
-        'HOST': '',                      # Set to empty string for localhost. Not used with sqlite3.
-        'PORT': '',                      # Set to empty string for default. Not used with sqlite3.
-    }
-}
+RUN_MODE = 'common' # debug / development / staging / production / etc.
+DATABASES = SETTINGS_SECRET['databases'][RUN_MODE]

 # Hosts/domain names that are valid for this site; required if DEBUG is False
 # See https://docs.djangoproject.com/en/1.4/ref/settings/#allowed-hosts
```
```
patch -s ... ... ;
```

* hoge/settings.py SECRET_KEY を settings/secret.yaml の django.secret_key に移行
```
 # Make this unique, and don't share it with anybody.
-SECRET_KEY = '******************************************************'
+SECRET_KEY = SETTINGS_SECRET['django']['secret_key']
```

----

##### AWS Elastic Beanstalk 起動状況確認

https://console.aws.amazon.com/elasticbeanstalk/
https://console.aws.amazon.com/elasticbeanstalk/?region=ap-northeast-1

----

##### Django DB 作成 (AWS Elastic Beanstalk / RDS 確認)


* RDS (Amazon Relational Database Service)
https://console.aws.amazon.com/rds/

* settings/secret.yaml の databases.common.default に
```
      'ENGINE':   'django.db.backends.mysql'
      'NAME':     'ebdb'
      'USER':     'ebroot'
      'PORT':     3306
      'HOST':     '<RDS Endpoint>'
      'PASSWORD': '<RDS Password>'
```

```
# django-admin.py dbshell ;
python ./manage.py dbshell ;

# django-admin.py syncdb --noinput ;
python ./manage.py syncdb --noinput ;
```



##### Django View 作成

```
hoge/urls.py
```
```
hoge/fuga/views.py
```

##### .ebextensions について

##### デプロイ

```
git aws.push ;
```

##### Django 管理ツール / staff_user / super_user について



##### Django Models 作成









----

### 作業終了 / 事後処理

#### AWS Elastic Beanstalk 停止 (10分程度)

```
eb stop ;
```
```
If you terminate your environment, your RDS DB Instance will be deleted and you will lose your data.
Terminate environment? [y/n]: y # <- Yes

...

Stop of environment "<AWS Elastic Beanstalk Environment Name>" has completed.
```

#### AWS Elastic Beanstalk 削除

```
eb delete ;
```
```
Delete application? [y/n]: y # <- Yes
Deleted application "<AWS Elastic Beanstalk Application Name>".
```

#### virtualenv 停止

```
deactivate ;
```

----

