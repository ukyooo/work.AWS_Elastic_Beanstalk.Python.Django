AWS Elastic Beanstalk を Python (Django) で動かしてみるワークショップ用
=======================================================================



### 目的

* AWS Elastic Beanstalk を使ったウェブアプリケーション公開までを知る

* Python (Django) の概要を知る

* pip / virtualenv / Fabric を少し知る

* AWS CLI (AWS-ElasticBeanstalk-CLI / ec2-api-tools) を少し知る





----

### 事前確認

* AWS アカウントを持っていない かつ 作らない人は？

* windows を使っている人は ssh client は何を使用しているか？

* その ssh client で identity file を使用した ssh 方法は？



----

### 事前準備

#### ssh を利用できる環境

* 各自、普段使用している ssh client で OK

#### 各種アカウント作成

##### GitHub

https://github.com/

* 本リポジトリを clone する為に使用

##### AWS

http://aws.amazon.com/

* ただし、住所情報入力 / クレジットカード情報登録 / 電話確認 が有り、アカウント取得コストが高い為、
依頼を頂ければ一時的にアカウント作成を行います。

* クレジットカード情報登録はするが、今回の内容は無料枠に収まるレベルの為、支払いの請求は無い予定です。



----

### 作業開始

* そもそも AWS Elastic Beanstalk とは何かの説明の前に下記の作業を進めて頂きます。



#### 環境作成

##### 作業環境用 EC2 のインスタンスを立ち上げ

https://console.aws.amazon.com/ec2/
https://console.aws.amazon.com/ec2/v2/home?region=ap-northeast-1#Instances:

* region は Asia Pacific (Tokyo) を利用

* 'Launch Instance' を click

* 'Ubuntu Server 13.04 - ami-6b26ab6a (64-bit)' の 'Select' を click

* 'Next: Configure Instance Details' を click

* 'Next: Add Storagels' を click

* 'Next: Tag Instance' を click



###### 'Tag Instance' の設定

* 今回、こちらから AWS のアカウントを貸し与えた方々は以下のイメージで設定してください。個人の AWS アカウントの方は適当で問題ありません。

Key   | Value
------|------
Name  | work.(UserName)

* 'Next: Configure Security Group' を click



###### 'Security Group' の設定

* 下記のように設定

Protocol        | Type  | Port Range (Code) | Source
----------------|-------|-------------------|--------
SSH             | TCP   | 22                | My IP
Custom TCP Rule | TCP   | 8000-8200         | My IP
Custom UDP Rule | TCP   | 8000-8200         | My IP
HTTP            | TCP   | 80                | Anywhere

* 'Add Rule' を click し設定を追加

* 上記のように設定が完了したら 'Review and Launch' を click

* 'Launch' を click



###### 'Select an existing key pair or create a new key pair'

* 'Create a new key pair' を選択

* 'Key pair name' を適当に入力

* 'Download Key Pair' を click し private key file (identity file) をダウンロードし各自のローカルに保存して管理

* 'Launch Instances' を click

* 'View Instances' を click

* 'Statusn Checks' が '... checks passed' になれば OK



* MEMO : 起動した EC2 インスタンスの 'Public DNS' をメモしておく。



----

##### 作業環境用 EC2 に ssh ログイン

###### Mac / Linux の場合

```
chmod 400 <private key file (identity file)>
```

```
ssh -i <private key file (identity file)> ubuntu@<Public DNS> ;
```



###### Windows の場合

* @TODO : あとで書く



----

#### 作業環境構築

* git をインストール

```
sudo apt-get install -y git ;
```

* git リポジトリを clone

```
git clone https://github.com/ukyooo/work.AWS_Elastic_Beanstalk.Python.Django.git app ;
```

* リポジトリを落としたディレクトリに移動

```
cd app ;
```

* 必要なパッケージをインストールなど

```
./setup.sh ;
```

* 再起動

```
sudo shutdown -r now ;
```

* ディレクトリの中身を確認

* mysql-server をインストール

```
sudo apt-get install -y mysql-server ;
```

パスワードは適当に設定し忘れないようにメモをしておく。

* シークレット情報管理 yaml ファイル作成

```
cp settings/secret.yaml.template settings/secret.yaml ;
```

【注意】
今回、シークレット情報を yaml ファイルで管理して読み込んで使う方法を取りますが、
シークレット情報を何らかの手段で秘匿する方法については触れません。



----

#### AWS IAM 設定

* AWS Identity and Access Management (IAM) で User (Access Key ID / Secret Access Key) 作成

https://console.aws.amazon.com/iam/



----

##### AWS User 作成

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

##### AWS Role 作成

1. 'Roles' に遷移して 'Create New Role' をクリックする。
2. 適当な RoleName を入力し 'Continue' をクリックする。
3. 'Select Role Type' -> 'AWS Service Roles' -> 'Amazon EC2' を 'Select' する。
4. 'Set Permissions' -> 'Select Policy Template' -> 'Amazon S3 Full Access' を 'Select' する。
5. 'Continue' をクリックする。
6. 'Create Role' をクリックする。

* これを利用することに依り Beanstalk の EC2 インスタンスのログ (access / error) を定期的に S3 にアップロードする権限が与えられる。



----

#### AWS Elastic Beanstalk 起動

https://console.aws.amazon.com/elasticbeanstalk



##### Web 実行

* 今回、やりません。



----

##### CLI 実行

* 作業環境で下記を実行

* eb コマンド設定

```
PWD=`pwd` ; PYTHON27=`which python2.7` ; alias eb="$PYTHON27 $PWD/tools/AWS-ElasticBeanstalk-CLI-2.5.1/eb/linux/python2.7/eb" ;
```

* eb init 実行

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
```
Enter an AWS Elastic Beanstalk application name: app-<UserName> # <- 今回
```

* 環境名を入力 (例 : production / staging / development など)

```
Enter an AWS Elastic Beanstalk environment name: <AWS Elastic Beanstalk Environment Name> # <-
```
```
Enter an AWS Elastic Beanstalk environment name: app-<UserName>-env # <- 今回
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

* 上記ファイルに AWS AccessKey / AWS SecretKey / RDS Master Password が保存される。



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
ELB (Elastic Load Balancing)
autoscaling
cloudwatch
cloudformation
S3 (Amazon Simple Storage Service)
SNS (Amazon Simple Notification Service)



----

#### Python / Django

* Python 2.7.x or 3.0.x

* Django 1.3.3 or 1.4.1

* 今回は Python 2.7.x + Django 1.4.1 の組み合わせを使用



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


```
git add manage.py hoge ;
git commit -m "update" ;
```

```
# -*- coding: utf-8 -*-
```


```
ifconfig eth0 ;
```

```
eth0      Link encap:Ethernet  HWaddr XX:XX:XX:XX:XX:XX
          inet addr:172.XX.XX.X  Bcast:172.XX.XX.255  Mask:255.255.240.0
          ^^^^^^^^^^^^^^^^^^^^^

          ...

```

```
python manage.py runserver <eth0 inet addr>:8000
```





```
$ git diff ;
```
```
diff --git a/hoge/settings.py b/hoge/settings.py
index ef4065f..4fa3544 100644
--- a/hoge/settings.py
+++ b/hoge/settings.py
@@ -1,3 +1,5 @@
+# -*- coding: utf-8 -*-
+
 # Django settings for hoge project.

 DEBUG = True
@@ -116,9 +118,9 @@ INSTALLED_APPS = (
     'django.contrib.messages',
     'django.contrib.staticfiles',
     # Uncomment the next line to enable the admin:
-    # 'django.contrib.admin',
+    'django.contrib.admin',
     # Uncomment the next line to enable admin documentation:
-    # 'django.contrib.admindocs',
+    'django.contrib.admindocs',
 )

 # A sample logging configuration. The only tangible logging
diff --git a/hoge/urls.py b/hoge/urls.py
index 1bee51c..e64720e 100644
--- a/hoge/urls.py
+++ b/hoge/urls.py
@@ -1,8 +1,11 @@
+# -*- coding: utf-8 -*-
+
 from django.conf.urls import patterns, include, url

 # Uncomment the next two lines to enable the admin:
-# from django.contrib import admin
-# admin.autodiscover()
+from django.contrib import admin
+from django.contrib import admindocs
+admin.autodiscover()

 urlpatterns = patterns('',
     # Examples:
@@ -10,8 +13,8 @@ urlpatterns = patterns('',
     # url(r'^hoge/', include('hoge.foo.urls')),

     # Uncomment the admin/doc line below to enable admin documentation:
-    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
+    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

     # Uncomment the next line to enable the admin:
-    # url(r'^admin/', include(admin.site.urls)),
+    url(r'^admin/', include(admin.site.urls)),
 )
```




----

##### Django settings 編集

https://docs.djangoproject.com/en/1.4/topics/settings/

https://console.aws.amazon.com/rds/



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



* debug 用 DB を local に作成

```
mysql -h localhost -u root -p"xxxxxxxx" -e "CREATE DATABASE hoge ;" ;
```



```
# django-admin.py dbshell ;
python ./manage.py dbshell ;
```
```
mysql> SHOW TABLES ;
```

```
# django-admin.py syncdb --noinput ;
python ./manage.py syncdb --noinput ;
```

# django-admin.py dbshell ;
python ./manage.py dbshell ;
```
```
mysql> SHOW TABLES ;
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

### おまけ

#### GNU sed コマンドをインストール

今回、 Mac で sed を使おうと思ったら思い通りに動かず、
調べてみたら Mac にプリインストールされている sed は BSD sed の為だったので、
GNU sed をインストールする方法をメモ

##### Mac の場合

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

----



