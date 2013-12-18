## Windows Server 2012 R2 Essentialsを利用してVM上にActive Directoryサーバを構築する。





----------


### インストール ###

  
#### 準備 ####
##　VirtualBoxのバージョンは4.3以上にしておくこと！
VirtualBoxの4.2以前ではWindows8系のOSをサポートしていないので、まずアップデートをしておく。  
**Oracle、最新版となるVirtualBox 4.3をリリース - Windows 8.1をサポート**
[http://news.mynavi.jp/news/2013/10/16/194/](http://news.mynavi.jp/news/2013/10/16/194/)

今回実施した環境は以下の通り。

ＶＭサーバ（物理PC）のOS : Windows 7 Professional SP1(64b)
VirtualBox：4.3.4
VMで立ち上げるOS: Windows Server 2012 R2 Essentials(64bit)



1. VitualBoxのマネージャーで「新規」ボタン押下
2.  「タイプ」を「Microsoft Windows」、バージョンを「Windows 2012(64bit)」に指定。今回は「名前」を「win2012」とする。
3.  メモリサイズなどは後で変更できるので適当に
4.  仮想ドライブの容量は追加が面倒なので、100Gくらい用意しておく
5.  インスタンスができるまで適当な値で設定する。
6.  完成したインスタンス「win2012」を選択し、「設定」ボタンを押下
7.  新しく開いたダイアログから「ストレージ」を選択
8.  コントローラ：IDEの横にある+CDボタンで.isoを追加する。
9.  追加した.isoを選択して「属性」が「IDEプライマリマスタ」であることを確認
10.  次に「ネットワーク」を押下する。
11.  「アダプター１」の「割り当て」を「NAT」から「ブリッジアダプター」に変更
12.  「高度」を押下してセクションを開き、「プロミスキャスモード」を「全て許可」に変更
13.  （11、12の操作でVMサーバ以外にもアクセスできるようになったはず。）
14.  「システム」を押下し、「プロセッサー数」を変更するなど、適宜調整
15.  「設定」ダイアログを「OK」押下で閉じる
16. win2012サーバを「起動」させる。

以上の手順を踏むことで、VirtualBox上の準備は終了。

#### Windows Server 2012 essentialsのインストール ####
下記PDFの手順を参考にOSの初回起動を終える。

[http://download.microsoft.com/download/8/0/8/808AC0BA-BA9B-4D65-8F00-E36E0A037D8B/WSE2012_StepByStepGuide_ja.pdf](http://download.microsoft.com/download/8/0/8/808AC0BA-BA9B-4D65-8F00-E36E0A037D8B/WSE2012_StepByStepGuide_ja.pdf)  
PDFリンク元  
[http://www.microsoft.com/ja-jp/server-cloud/windows-server-essentials/technical-documentation.aspx](http://www.microsoft.com/ja-jp/server-cloud/windows-server-essentials/technical-documentation.aspx)

**P26 手順10.の内容を後で変更することは出来ないので注意すること**  
会社名は問題ないが、内部ドメイン名がADサーバのレルムに、サーバ名がAD上でこのPCのサーバ名になる。
本文書では、「内部ドメイン名：KERBEROS」、「サーバ名：win2012」とする。

以降、Windows Updateなどが選択できるので、PDFに習って実施しておく。  


#### ファイル共有機能を追加する。####

あらかじめ、共有用のファイルを作成しておくこと

1. サーバマネージャを開く。（これは良く使うので、起動後、タスクバーに出てくるアイコンを右クリックし、「タスクバーにピン留めする」をしておくとラク）
2. 左側のアイコン列から「ファイルサービスと記憶域サービス」を押下
3. アイコン列の隣に出現する列から共有を押下
4. 共有されているファイル一覧表示される
5. 一覧の既存のファイルが無い部分で右クリックを押下するとメニューが出てくるので、「新しい共有．．．」を押下する。
6. 登録画面に習って追加共有フォルダを追加する。（今回はshare）

#### グループポリシーを変更する。 ####
1. サーバマネージャを開く。（これは良く使うので、起動後、タスクバーに出てくるアイコンを右クリックし、「タスクバーにピン留めする」をしておくとラク）
2. 右上の「ツール」を押下し、「グループポリシーの管理」を押下する。
3. マネージャが開く
4. 左列のツリーを展開すると「KERBEROS.LOCAL」以下に「Default Group Polycy」が設定されている。
5. 「KERBEROS.LOCAL」を右クリックし、「このドメインにGPOを作成し、このコンテナーにリンクする」を押下
6. 新しいGPOへのリンクが追加される。（ここではtestPolicyという名前で作成）
7. 「Default Group Polycy」を右クリックし、「リンクの有効化」のチェックを無効にする。
8. 「testPolicy」を右クリックし、「リンクの有効化」をチェック、さらに編集を押下
9. 「グループポリシー管理エディター」が起動する
10. 「コンピューターの構成」→「ポリシー」→「Widnowsの設定」→「セキュリティの設定」→「アカウントの設定」を確認する
11. 各種設定が未定義状態なので、設定しておく。

主に設定すべき項目と今回構築した設定は以下の通り。

- パスワードの設定
	- パスワードの長さ：4
	- パスワードの変更禁止期間：0(無期限)
	- パスワードの有効期間：900
	- パスワードの履歴を記録する：0(無記録)
	- 暗号化を元に戻れる状態でパスワードを保存する：無効
	- 複雑さの要件を満たす必要があるパスワード：無効
- アカウントの設定
	- アカウントのロックアウトのしきい値：0回ログオンに失敗
	- ロックアカウント　カウンターのリセット：未定義
	- ロックアウト期間：未定義
- Kerberosの設定
	- コンピューターの時計の同期の最長トレランス：30分
	- サービスチケットの最長有効期間：60分
	- チケットの最長有効期間：1時間
	- ユーザーチケットを更新できる最長有効期間：34日
	- ユーザーログオンの制限を強制する：無効
 
なお、全ての項目でダブルクリックを押下すると新規ダイアログが現れる。  
新規ダイアログには「セキュリティーポリシーの設定」タブと「説明」タブがあるので、各種項目が意味する内容の詳細は「説明」タブの内容を参照のこと。

#### ADユーザーを追加する。 ####
1. サーバマネージャを開く。
2. 右上の「ツール」を押下し、「Active Directory ユーザーとコンピューター」を押下する。
3. 新しいダイアログが開き、ADサーバのマネージャが起動する（これも良く使うので、起動後、タスクバーに出てくるアイコンを右クリックし、「タスクバーにピン留めする」をしておくとラク）
4. 左列からKERBEROS.LOCAL→Usersを選択する。
5. Essentialsが追加したユーザーが見えるはず。
6. 右上にある新規ユーザー追加ボタンより、新たなユーザーを行う。(今回はuser01)


#### 確認 ####
Linuxからマウントを試みる。あらかじめwin2012上でipconfigを行ってIPを確認しておくこと。(今回win2012サーバーのIPは123.123.123.10とする)


	
	LINUXCLIENT:~/tmp>cat /etc/hosts
	# File: hosts
	# Dynamically created by nicConfig - do not modify.
	# Original moved to hosts_last
	# IP-Address   Full-Qualified-Hostname   Short-Hostname
	127.0.0.1      localhost
	127.0.0.2      linux.local               linux
	123.123.123.20   LINUXCLIENT   LINUXCLIENT
	LINUXCLIENT:~/tmp>cat /etc/krb5.conf
	
	[libdefaults]
	 default_realm = KERBEROS.LOCAL
	 dns_lookup_realm = true
	 dns_lookup_kdc = true
	 ticket_lifetime = 24h
	 renew_lifetime = 7d
	 forwardable = true
	
	[realms]	
	 KERBEROS.LOCAL = {
	  kdc = win2012.kerberos.local
	  admin_server = win2012.kerberos.local
	  default_domain = kerberos.local
	  kdc = win2012
	 }
	
	[domain_realm]
	 .kerberos.local = KERBEROS.LOCAL
	 kerberos.local = KERBEROS.LOCAL
	LINUXCLIENT:~/tmp>ls
	jmdb_ext.txt  krb5-client-1.9.1-24.9.1.x86_64.rpm  share
	LINUXCLIENT:~/tmp>kinit user01@KERBEROS.LOCAL
	Password for user01@KERBEROS.LOCAL:
	LINUXCLIENT:~/tmp>klist
	Ticket cache: FILE:/tmp/krb5cc_0
	Default principal: user01@KERBEROS.LOCAL
	
	Valid starting     Expires            Service principal
	12/17/13 22:42:23  12/17/13 23:42:32  krbtgt/KERBEROS.LOCAL@KERBEROS.LOCAL
	        renew until 12/24/13 22:42:23
	LINUXCLIENT:~/tmp>mount.cifs //win2012/secondShare ./share -o sec=krb5i
	LINUXCLIENT:~/tmp>ls share/
	existFileInDir2.txt  list  mountSuccess2.txt
	LINUXCLIENT:~/tmp>kdestroy
	LINUXCLIENT:~/tmp>umount share/
	LINUXCLIENT:~/tmp>ls share/
	LINUXCLIENT:~/tmp>

----------

#### 参考 ####
  
**Windows Server 2012 Essentials テクニカル ドキュメント**
[http://www.microsoft.com/ja-jp/server-cloud/windows-server-essentials/technical-documentation.aspx](http://www.microsoft.com/ja-jp/server-cloud/windows-server-essentials/technical-documentation.aspx)

**Active Directoryを設定し、検証環境を構築しよう (1/3)**
[http://www.atmarkit.co.jp/ait/articles/1301/16/news011.html](http://www.atmarkit.co.jp/ait/articles/1301/16/news011.html "Active Directoryを設定し、検証環境を構築しよう (1/3)")

**Hyper-V over SMB の展開**  
[http://technet.microsoft.com/ja-jp/library/jj134187.aspx](http://technet.microsoft.com/ja-jp/library/jj134187.aspx)

**Active Directory ドメインユーザーのアカウントポリシー （1/3）**
[http://www.edifist.co.jp/onepoint/Password_policy.html](http://www.edifist.co.jp/onepoint/Password_policy.html)