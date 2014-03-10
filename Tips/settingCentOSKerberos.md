#VirtualBox+CentOS6.5上でKerberosサーバを構築する

Vagrantなどもありますが、今回は全てマニュアルで構築する。

##構成


|ツール|バージョン|
|----|----|
|Virtual Box|4.3.4 r91027|
|CentOS|6.5 64bit minimal|

##Virtual Boxの設定

CentOS-6.5-x86_64-minimal.isoを以下から取得する
[http://isoredirect.centos.org/centos/6/isos/x86_64/](http://isoredirect.centos.org/centos/6/isos/x86_64/)

Virtual Boxマネージャより、「新規」で新たな「Redhat64bit」インスタンスを作成する  
今回は認証サーバなので、「ネットワーク」-「アダプター1」の設定を以下にしておく。

- 「割り当て」-ブリッジアダプター
- 「プロミスキャスモード」-全て許可

また、ストレージとする仮想ディスクは多目にしておくこと。(追加はめんどくさい)  
私は60-100GB程度でいつも作成しています。

コントローラIDEに上記のURLから取得した.isoファイルをマウントしておく。

以上設定後、インスタンスを起動すると、インストール画面になる。      
インストールは一般的なCentOSのインストールと同一なので割愛。  

「ネットワーク名」を決定するとき、左下のネットワーク設定からeth0のauto connectをONにしておくと後がラク。  

##Cent OSの初期設定

自動でネットワークに接続できるにする。
`vi /etc/sysconfig/network-scripts/ifcfg-eth0`

参考例：

```

    DEVICE=eth0
    TYPE=Ethernet
    UUID=a7a64eb7-efc4-4db7-bcb4-c7f8a233ca9d
    ONBOOT=yes
    NM_CONTROLLED=yes
    BOOTPROTO=dhcp
    HWADDR=08:00:27:A1:66:B2
    DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=yes
    IPV6INIT=no
    NAME="System eth0"
```    

インストール時にauto connectをONにしていた場合は不要。  


ファイアウォール無効化。企業内LAN内ではない場合はあとで必ず再設定すること

    /etc/rc.d/init.d/iptables stop
    chkconfig iptables off
    chkconfig --list iptables 

SELinuxも完全無効化。企業内LAN内ではない場合はあとで必ず再設定すること


    vi /etc/sysconfig/selinux

rebootする

これでsshからログインできるようになったはず。

proxy内で操作する場合はyumのproxyを通しておく

    vim /etc/yum.conf
以下を追記

    proxy=http://proxy.server.co.jp:8080
    proxy_username=YOUR_ID
    proxy_password=YOUR_PASSWORD


全体的に一度アップデートをしておくこと。


    yum upudate -y

あとは適宜vimとか入れておくとはかどる  
自分の場合は`yum install vim git`でgithub上の`.vimrc`も`ln -s`しておく

## Kerberosサーバを導入する

必要なパッケージをインストールする。

    yum -y install krb5-server krb5-workstation words portreserve

後はほぼ以下のURLの通りに実行する。

**Kerberos を使ってみる (RHEL/CentOS/Ubuntu編)**
[http://masahir0y.blogspot.jp/2012/12/kerberos-v5.html](http://masahir0y.blogspot.jp/2012/12/kerberos-v5.html)


３つの設定ファイルの設定を行う。

```
　　　　[root@server ~]# cat /var/kerberos/krb5kdc/kadm5.acl
　　　　#*/admin@EXAMPLE.COM    *
　　　　*/admin@SERVER.LOCAL    *
```

```
[root@server ~]# cat /var/kerberos/krb5kdc/kdc.conf
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
# EXAMPLE.COM = {
  SERVER.LOCAL = {
  #master_key_type = aes256-cts
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }

```

```
[root@server ~]# cat /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = SERVER.LOCAL
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 EXAMPLE.COM = {
  kdc = kerberos.example.com
  admin_server = kerberos.example.com
 }
 SERVER.LOCAL = {
     kdc = kerberos.server.local
     admin_server = kerberos.server.local
 }

[domain_realm]
 .example.com = EXAMPLE.COM
 example.com = EXAMPLE.COM
 .server.local = SERVER.LOCAL
 server.local = SERVER.LOCAL

```

次のコマンドでデータベースを作成する。  
このコマンドはかなり時間がかかるので、動作がとまったように見えても、あわてずに待つこと。  

    kdb5_util create -s


````
[root@server ~]# kadmin.local
Authenticating as principal root/admin@SERVER.LOCAL with password.
kadmin.local:  addprinc root/admin
WARNING: no policy specified for root/admin@SERVER.LOCAL; defaulting to no policy
Enter password for principal "root/admin@SERVER.LOCAL":
Re-enter password for principal "root/admin@SERVER.LOCAL":
Principal "root/admin@SERVER.LOCAL" created.
kadmin.local:  addprinc user01
WARNING: no policy specified for user01@SERVER.LOCAL; defaulting to no policy
Enter password for principal "user01@SERVER.LOCAL":
Re-enter password for principal "user01@SERVER.LOCAL":
Principal "user01@SERVER.LOCAL" created.
kadmin.local:  listp
listpols    listprincs
kadmin.local:  listp
listpols    listprincs
kadmin.local:  listprincs
K/M@SERVER.LOCAL
krbtgt/SERVER.LOCAL@SERVER.LOCAL
root/admin@SERVER.LOCAL
user01@SERVER.LOCAL
kadmin.local:  addprinc -randkey kadmin/admin
WARNING: no policy specified for kadmin/admin@SERVER.LOCAL; defaulting to no policy
Principal "kadmin/admin@SERVER.LOCAL" created.
kadmin.local:  addprinc -randkey kadmin/changepw
WARNING: no policy specified for kadmin/changepw@SERVER.LOCAL; defaulting to no policy
Principal "kadmin/changepw@SERVER.LOCAL" created.
kadmin.local:  exit

````

### クライアント側の設定 ###

基本的には`/etc/krb5.conf`と`/etc/hosts`にサーバの情報が記載されていればOK



```
# cat /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = SYSLOG:INFO:LOCAL5
 admin_server = SYSLOG:INFO:LOCAL5

[libdefaults]
 #default_realm = EXAMPLE.COM
 dns_lookup_realm = true
 dns_lookup_kdc = true
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 SERVER.LOCAL = {
  kdc = kerberos.server.local
  admin_server = kerberos.server.local
  default_domain = server.local
  kdc = kerberos
}
[domain_realm]
 .example.com = EXAMPLE.COM
 example.com = EXAMPLE.COM
```


```
# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
***.***.***.*** kerberos.server.local kerberos
```


```
# kinit user01@SERVER.LOCAL
Password for user01@SERVER.LOCAL:
# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: user01@SERVER.LOCAL

Valid starting     Expires            Service principal
03/10/14 16:18:23  03/11/14 16:17:27  krbtgt/SERVER.LOCAL@SERVER.LOCAL
        renew until 03/10/14 16:18:23
```

## 参考
今回は以下のページを参考にさせていただきました。

**Kerberos を使ってみる (RHEL/CentOS/Ubuntu編)**
[http://masahir0y.blogspot.jp/2012/12/kerberos-v5.html](http://masahir0y.blogspot.jp/2012/12/kerberos-v5.html)

**KDCサーバを作る(centos6)**  
[http://web.chaperone.jp/w/index.php?Kerberos%2F%A5%B5%A1%BC%A5%D0](http://web.chaperone.jp/w/index.php?Kerberos%2F%A5%B5%A1%BC%A5%D0)
