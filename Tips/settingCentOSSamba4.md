CentOS6.4+Samba4.1.2でSMB+Kerberos認証のファイル共有サーバを構築する

Kerberos認証を利用したファイル共有サーバを構築します。
基本的には次のサイト様の手順に従って行えばできるので、設定ファイルなどの例が不要な方は、直接URL先を参考にしてください。
ひとつ言うと、すでに何らかの環境を変更済みのLinuxに追加よりも、OSインストール直後の環境のほうが手詰まりなく作業ができました。

**Samba4でのActive Directory構築**
[http://www.oss-d.net/samba4/ad](http://www.oss-d.net/samba4/ad)

環境情報

|ツール|バージョン|
|----|----|
|Virtual Box|4.3.4 r91027|
|CentOS|6.4 64bit|
|Samba|4.1.2|
|Krbserver|Samba同梱のもの|

その他

|----|----|
|IP| 10.XXX.YYY.ZZZ|
|ドメイン| KERBEROS.LOCAL|
|ホスト名（FQDN）| server.kerberos.local|

CentOSはあらかじめVirtual Box上に構築済みとします。


## Samba4.Xパッケージをインストール
Samba4.X系のパッケージはパッケージ内にKerberos機能も搭載しています。
そこで今回は既存のADや構築済みのKerberos認証を用いず、Samba4.X系のパッケージを利用して表題の環境を構築します。
既存のLDAP,Active Directoryを用いてSMBサーバを構築したい時は別方法を参照すること。

[http://ftp.samba.org/pub/samba/stable/](http://ftp.samba.org/pub/samba/stable/)

`wget`などでtarファイルを取得し解凍、`./configure`,`make`,`make install`を行います。

```
wget  http://ftp.samba.org/pub/samba/stable/samba-4.1.2.tar.gz
tar zxvf samba-4.1.2.tar.gz
cd samba-4.1.2
./configure --enable-debug --enable-selftest
make
make install
```

**`yum install samba`ではないので、各種設定ファイルの場所が微妙に異なるのを注意してください。**
**また、既にSambaをyum install済みの環境で試すのオススメしません。**

## Sambaの設定

新規ドメインとしてSamba4サーバを構築するデータベースの設定を行います。

```
# /usr/local/samba/bin/samba-tool domain provision
Realm: server.kerberos.local                       
 Domain [sever]:server                       
 Server Role (dc, member, standalone) [dc]:dc 
 DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERNAL]:
 DNS forwarder IP address (write 'none' to disable forwarding) [10.XXX.YYY.ZZZ]:
Administrator password:                   
Retype password:
```

Sambaを起動して、動作確認をします。
以降、`yum install samba`で導入した際のパスと一部異なる点を注意してください。

```
# /usr/local/samba/sbin/samba
# /usr/local/samba/sbin/samba -V
Version 4.1.2
# /usr/local/samba/bin/smbclient --version
Version 4.1.2
```


## ネットワークの設定

DHCP環境下、かつDNSと異なるドメイン名を利用する際は`ifcfg-eth0`に`PEERDNS=no`を設定し、`/etc/resolv.conf`に`domain`を記載しておく。

```
# cat /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
UUID=XXXXXXXXXXXXXXXXXXXXXXXXXXX
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=dhcp
HWADDR=XXXXXXXXXXXXXXXXXXXXXXXXX
DEFROUTE=yes
PEERDNS=no
PEERROUTES=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
NAME="System eth0"
```

```
# cat /etc/resolv.conf
# Generated by NetworkManager
domain kerberos.local
nameserver 127.0.0.1
nameserver 10.XXX.YYY.ZZZ
```


smb.confへ下記を設定します。

```
# vim /usr/local/samba/etc/smb.conf
dns forwarder = 10.XXX.YYY.1
```

hostsファイルも修正しておきます。

```
# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.XXX.YYY.ZZZ server.kerberos.local server

```

設定が正しく出来ていれば次のコマンドで以下の結果が得られます。

```
# host -t SRV _ldap._tcp.kerberos.local
_ldap._tcp.kerberos.local has SRV record 0 100 389 server.kerberos.local.

```



##共有フォルダの設定

共有用のフォルダを設定します。

```
# mkddir -m 777 /data/share
# mkddir -m 777 /data/secondShare
# vim /usr/local/samba/etc/smb.conf
```

```
# cat /usr/local/samba/etc/smb.conf
# Global parameters
[global]
        workgroup = KERBEROS
        realm = KERBEROS.LOCAL
        netbios name = SERVER
        server role = active directory domain controller
        dns forwarder = 10.XXX.YYY.ZZZ

[netlogon]
        path = /usr/local/samba/var/locks/sysvol/kerberos.local/scripts
        read only = No

[sysvol]
        path = /usr/local/samba/var/locks/sysvol
        read only = No

[test]
         path = /data/test
         comment = Test Share
         read only = No

[share]
         path  = /data/share
         read only = No

[secondShare]
         path = /data/secondShare
         read only = No

```

## Kerberos認証の設定

以下のようになっていなかったら、修正しておいてください。

```
# cat /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = KERBEROS.LOCAL
 dns_lookup_realm = false
 dns_lookup_kdc = true
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 KERBEROS.LOCAL = {
  kdc = server.kerberos.local
  admin_server = server.kerberos.local
 }

[domain_realm]
 .kerberos.local = KERBEROS.LOCAL
 kerberos.local = KERBEROS.LOCAL
```




## 自動起動の設定

以下、設定ファイルを作成します。

```
# vim /etc/init.d/samba4
# cat /etc/init.d/samba4
#! /bin/bash
#
# samba4       Bring up/down samba4 service
#
# chkconfig: - 90 10
# description: Activates/Deactivates all samba4 interfaces configured to \
#              start at boot time.
#
### BEGIN INIT INFO
# Provides:
# Should-Start:
# Short-Description: Bring up/down samba4
# Description: Bring up/down samba4
### END INIT INFO
# Source function library.
. /etc/init.d/functions

if [ -f /etc/sysconfig/samba4 ]; then
    . /etc/sysconfig/samba4
fi

CWD=$(pwd)
prog="samba4"

start() {
      # Attach irda device
      echo -n $"Starting $prog: "
    /usr/local/samba/sbin/samba
    sleep 2
    if ps ax | grep -v "grep" | grep -q /samba/sbin/samba ; then success $"samba4 startup"; else failure $"samba4 startup"; fi
      echo
}
stop() {
      # Stop service.
      echo -n $"Shutting down $prog: "
    killall samba
    sleep 2
    if ps ax | grep -v "grep" | grep -q /samba/sbin/samba ; then failure $"samba4 shutdown"; else success $"samba4 shutdown"; fi
      echo
}
status() {
    /usr/local/samba/sbin/samba --show-build
}

# See how we were called.
case "$1" in
start)
    start
      ;;
stop)
    stop
      ;;
status)
    status irattach
    ;;
restart|reload)
    stop
    start
    ;;
*)
      echo $"Usage: $0 {start|stop|restart|status}"
      exit 1
esac

exit 0
```


作成したファイルに実行権限を付加し、自動起動をONにしておきます。

```
# chmod 0755 /etc/init.d/samba4
# ln -s /etc/init.d/samba4 /etc/rc3.d/S80samba4 
# chkconfig --add samba4
# chkconfig --level 35 samba4 on
```

# ユーザーの追加

まずSambaの起動を確認、もし起動していなかった場合は、startしてください。

```
/etc/init.d/samba4 status
/etc/init.d/samba4 start
```

samba-toolを用いてユーザーを追加します。
**これでActive Directoryにもユーザが追加できています。**

```
/usr/local/samba/bin/samba-tool user add user01
/usr/local/samba/bin/samba-tool user add user02
/usr/local/samba/bin/samba-tool user add user03
```

# 動作確認
ここまで正しく設定できているならば、次の確認コマンドで以下のような結果が得られます。


```
# /usr/local/samba/bin/samba-tool user list
Administrator
krbtgt
user01
user02
user03
Guest
```

```
# /usr/local/samba/bin/smbclient -L localhost -U%
Domain=[KERBEROS] OS=[Unix] Server=[Samba 4.1.2]

        Sharename       Type      Comment
        ---------       ----      -------
        IPC$            IPC       IPC Service (Samba 4.1.2)
        secondShare     Disk
        share           Disk
        sysvol          Disk
        netlogon        Disk
Domain=[KERBEROS] OS=[Unix] Server=[Samba 4.1.2]

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------

```

上記の結果が得られない場合はsmb.confなどを見直してください。


別クライアントからファイル共有を試してみます。

```
:~> cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.XXX.YYY.ZZZ server.kerberos.local server
```


**`default_realm`が違うと失敗しやすいです。**

```
yshimizu@RPP2D117C:~> cat /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = SYSLOG:INFO:LOCAL5
 admin_server = SYSLOG:INFO:LOCAL5

[libdefaults]
 default_realm = KERBEROS.LOCAL
 dns_lookup_realm = true
 dns_lookup_kdc = true
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 KERBEROS.LOCAL = {
  kdc = server.kerberos.local
  admin_server = server.kerberos.local
  default_domain = kerberos.local
  kdc = server
 }
[domain_realm]
 .kerberos.local = KRBEROS.LOCAL
 kerberos.local = KERBEROS.LOCAL
```

実際にKrb5認証を用いて共有フォルダをマウントします。

```
# kinit user03@KERBEROS.LOCAL
Password for user03@KERBEROS.LOCAL:
Warning: Your password will expire in 41 days on Mon Apr 21 17:20:55 2014
```

```
# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: user03@KERBEROS.LOCAL

Valid starting     Expires            Service principal
03/11/14 11:28:41  03/11/14 21:28:41  krbtgt/KERBEROS.LOCAL@KERBEROS.LOCAL
        renew until 03/18/14 11:27:39
```

```
# mount.cifs //server/share ./share -o sec=krb5
# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: user03@KERBEROS.LOCAL

Valid starting     Expires            Service principal
03/11/14 11:28:41  03/11/14 21:28:41  krbtgt/KERBEROS.LOCAL@KERBEROS.LOCAL
        renew until 03/18/14 11:27:39
03/11/14 11:31:20  03/11/14 21:28:41  cifs/kurofune@KERBEROS.LOCAL
        renew until 03/18/14 11:27:39
```



## 参考にしたサイト ##

**Samba4でのActive Directory構築**  
[http://www.oss-d.net/samba4/ad](http://www.oss-d.net/samba4/ad)