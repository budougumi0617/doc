# 第8回Jenkins勉強会



----------


日時：2013/12/20(金) 19:00-21:00  
場所：ヤフー株式会社 11Fセミナールーム


----------

#### 発表内容 ####
#### 通常発表 ####
川口さん：「2013年をJenkinsの歩み」
[http://www.slideshare.net/kohsuke/ss-29339493](http://www.slideshare.net/kohsuke/ss-29339493)

ヤフー石川さん：「Jenkins始めました。Yahoo! JapanのCI/CD」

株式会社シフト玉川さん：Jenkinsエンタープライズについて
[http://www.slideshare.net/hirokotamagawa/20131220-8jenkins-jenkins-enterprise](http://www.slideshare.net/hirokotamagawa/20131220-8jenkins-jenkins-enterprise)

#### LT ####

@akiko_pusuさん：おひとりさま～の1年後。発表者のその後を語る
[http://www.slideshare.net/akiko_pusu/20131220-jenkinsakiko-pusu](http://www.slideshare.net/akiko_pusu/20131220-jenkinsakiko-pusu)

@superbrothersさん：Jenkins With Docker
[http://techblog.yahoo.co.jp/event/jenkins-with-docker/](http://techblog.yahoo.co.jp/event/jenkins-with-docker/)

----------

## 川口さん：「2013年をJenkinsの歩み」 ##

最初は1人で始めたJenkinsも
今年でJenkinsリポジトリ1090人がコミットした。1人平均20コミット。64commit/Day

Google/Microsoftでもplugin開発を行っている。

約18万のスレーブがJenkinsの計算ノードとなっている。


----------

### jenkinsの今年の大きな変化 ###

デプロイがWinstoneからjetty://に変更になった。

コアではCredentialsプラグインを開発した。(鍵情報の一元化)

今までは各Pluginが個別に認証情報を持っていたが、一括管理できるようになった。

GitPluginの2.0メジャーリリース。

Git設定画面の簡略可。通常使わない機能は拡張オプションに格下げした。

Cloudbees。ジョブの階層構造化。リペレット（文芸的）ビルドの実施。

**リペレットビルド**  
新規のジョブを作るとき
README.mdにbuildというセクションを書いておくとJenkinsが認識できる。

README.mdが記載されているGithubのリポジトリのURLを使って、文芸的ビルドで新規ジョブを使うと、構成管理の指定とURLだけで勝手にビルドができる。
また、ブランチを作成すると、ブランチも自動的にビルドにしてくれる。


----------

####大規模ビルドに対応####

今まではスレーブが多くなると、200スレーブで800スレッド必要だった。
今はsshやエグゼキューターの調整で、200スレッドにまでさげた。
マスターのjarキャッシュ方法も変更した。

**マスター/スレーブの通信改善。**  
メモリ処理の変更。大規模テストレポート。HTTPセッションや遅延ロードの改良。


----------

#### 安定性 ####

Jenkinsの結合テスト
複数OS環境でのJenkinsの起動の対応
Dockerによる外部サービスとの連携テスト


----------

アジャイルアカデミーのワークショップにも協力
[http://event.shoeisha.jp/aa/20140305/](http://event.shoeisha.jp/aa/20140305/)

----------

**JoCC** 
多くのJnekinsをコントロール。マスターのマスター。
社内のJenkinsを管理し、スレーブの管理など。


----------

MacOSXのハック。仮想化をCloudbeesで開発。  
MacOSXを起動。ZFSの利用。  
ワークスペースのクローンをして複数スレーブで平行実行。  
ワークスペース内に変更があると、差分だけ保存する。  
[http://pages.cloudbees.com/iOS_OSX_SignUp.html](http://pages.cloudbees.com/iOS_OSX_SignUp.html)



----------

## ヤフー石川さん：「Jenkins始めました。Yahoo! JapanのCI/CD」 ##


マーケティングソリューション事業部のインフラ業務担当。広告などのサービスを担う。

Yahoo!を見るときに右側に出てきたりする広告。

広告には2種類ある。

ディスプレイアウトネットワーク型の広告が今回のテーマ。
年齢や地域情報による最適化。

広告は膨大なリクエストをさばく必要があり、多くのサーバと開発者が必要。


----------


Ops2名＋Jenkinsで運用

プロも配信は9割以上を自動運用


社内GithubエンタープライズをJenkinsがフックすることで構成管理に登録、各種

マスター：3台
slave：マスターマイに約110台
ジョブ数　約３００
プラグインはgit/github, coverity, rudeckなど


----------

###道のり


数名の有志によるボトムアップ活動

組織化→エバンジェリスト集団


----------


独自のビルドスクリプトによる、統一したビルドライン

基本的には継続的デリバリーに書いてあるパイプライン構成に準拠。

ワンクリックでデプロイ可能。

## 管理職の理解や強力なサポートもあってCI+CDが達成できた。 ##

手動時：2日→自動化により数時間にまで短縮


----------

### トラブル事例と課題について。

・連携にSCMポーリングを使っていたため、Githubエンタープライズに負荷集中
→ポーリングマストダイで解決！

・予算のある部署はSlave調達すぐできるけど、弱小部署はお金が。。。
→仮想感想の有効化！Jcloudsプラグインで解決！
OpenStackベースの社内PaaSとの連携で物理サーバ不要。

ビルド終了で仮想サーバも自動削除
→クラウド側のリソースも節約。


----------

### その他の課題



1. 細かいフロー（リリース、ジョブ数増加）
2. テストコード（テストコード不足）
3. もっと高度なデプロイに挑戦
4. 全社的にはまだまだ普及できていない
5. 他の部への伝承や教育


----------
### まとめ ###

CI+CDに大切な２つのこと

#### エバンジェリストたち ####
ボトムアップは大変。重要性を周囲に伝え、回りを巻き込んでいくひとが必要。
従来のプロセスや考え方を変える必要がある。

#### ルールや議論はほどほどで、まずはやってみること ####
JFDI精神！
縛り付けてやる気を削いでもしょうがない。


Yahoo!の私たちの部署は人募集してるから、CIとかしたい人は入ってね！



----------


###　質疑応答

Web Hookよりポーリングがいい場合って？
PushしまくるとWeb Hookがムダに多くなるので。。。（クアイエットうんちゃらプラグインで抑えられる）

3,4年前からボトムアップを始めている。

テストが不十分なところとは？
一番はテストを書く文化がないところや画面周りのテストが不十分。Seleniumなどは推進している。

----------

## 株式会社シフト玉川さん：Jenkinsエンタープライズ by cloudbees ##
第三者認証を行う会社。  
マニュアル実行でテストを行っている。  
会社以外のコミュニティではJenkinsユーザー会とSTAR

**Jenkins有償版JEBCとは？**  
[http://www.cloudbees.com/jenkins/enterprise](http://www.cloudbees.com/jenkins/enterprise)

- サポートあり。
- 有償版独自プラグインが使える
- 川口さんを含むプロ集団がサポートしてくれる。



----------

### JEBSの特徴：テクニカルサポート ###
OSS版の約8割のコードに貢献したメンバーのサポート
（当然OSS版やコアの部分もサポートしてくれる）


----------
### 豊富なプラグイン ###

- 稼働率向上
- 大規模開発向けのプラグイン
- セキュリティ向上機能
- リソース最適化


----------
### 稼働率向上 ###
- マスターが落ちたときにスタンバイ機が自動的に起動
	- Jenkins Operation Center
- ジョブをフォルダに入れて階層管理。
	- フォルダごとコピーしてフォルダごとに環境変数を変えて類似ジョブ量産。
- テンプレートプラグイン
	- テンプレートで作成したジョブを記憶しているため、テンプレを変更すると全てに対応する。	


----------

###Folderプラグイン  


- ジョブを作る際にフォルダーが選択できる。  
- フォルダーができるので、どんどんフォルダー内に追加していく。  
	- フォルダーに設定した環境変数はフォルダ内のジョブ全てに適応される。  
- ビルドフローもフォルダと同時にコピーできるので、ビルドパイプラインを簡単に他のチームに展開できる。


----------

###テンプレートプラグイン  
#### ビルダーテンプレート  
ジョブの中のビルド手順をテンプレート化できる。  
ジョブの種類から選べる。  
Attributeでパラメータを追加できる。name属性とか、ID属性とか  
既存ジョブにも適用できる。  
「ビルド手順の追加」で「テンプレート」を適用できる。


#### ジョブテンプレート
ジョブ全体のテンプレート。  
まずどのジョブを元に作成するか選ぶ  
ジョブの設定をXMLで作れる。変数にしたい部分を設定してテンプレ化。  
新規作成ジョブを作成しようとすると、ジョブの種類の中にテンプレが出てくる。  
設定画面がXMLで設定した変数のみのシンプルなジョブが作成される。



----------

### セキュリティ向上系の機能

- Role-Base Access Contorol Plugin
	- 権限の割り当てをもっと柔軟に。チームへの権限委譲
- セキュアコピープラグイン
	- 複数のJenkins間で成果物を安全にやり取り
	- ユーザーが自由にDLできない
- カスタムアップデートセンター
	- アップデートセンターを自社で持つことができる。
	- プラグインのインストール管理やバージョン制限など、プラグインの統制をすることができる。



----------

- Even Scheduler Plugin
	- スレーブの割り当てアルゴリズムの変更
	- 「このジョブをやったことあるスレーブ」から「今空いているスレーブ」へ
- VMware vCenter Auto-Scaling Plugin
	- VMware vCenterのマシンプールから自動的にスレーブを生成、割り当て
	- ビルド前後の初期化やスナップショットのリストアなども可能
- Skip Next Build Plugin	
	- 指定した時間はビルドを禁止できるプラグイン


Jenkins Boot Camp 翔泳社の「Agile アカデミー」の一環で開講。
次回は3/5(水) 
1日かけて「ジョブ書いたことない人」でもビルドパイプラインくらいまでできるようになる。


----------


----------

## @akiko_pusuさん：おひとりさま～の1年後。発表者のその後を語る ##

発表して変わらないこと、変わったこと

Jenkinsの立ち位置が変わった。
パートナー会社によりジョブ管理ツールが到来。Jenkins不要説。。。？

「自動化して嬉しがる」時期は終わった  
「自動化を意識する」時期に入った。  
Jenkinsに期待すること！自動化のスタートアップを支援すること  
手順の妥当性を繰り返し検証・ジョブが確立すればどこで実行してもかまわない。  
それ以上改善や修正がないジョブはいらない。リソースのムダ。  

## 執事の方向性 ##
サーバのセットアップ・テストにフォーカス  
内製システム/業務アプリのテストにフォーカス。  
定常情報システム業務の自動化。



----------
### まとめ ###
Jenkinsの立ち位置が変わった。スタートアップを加速する。

自動化できないことにこそ、みんなの時間を割きましょう。

----------

## @superbrothersさん：Jenkins With Docker ##


Yahoo!入社5年目

### Dockerとは ###
LXCベースの軽量仮想化  
コピーオンライトのファイルシステム

仮想マシンと比べて軽量！


----------

Jenkinsでジョブごとにクリーンな実行環境を一瞬で作ることができる。

ジョブの中でdocker runを実行・コンテナ作成後テスト実行。その後コンテナ廃棄。

Dockerを使うことでクリーンな環境が一瞬で手に入る。

JenkinsとDockerを組み合わせると工夫しだいでおもしろいかも！！




----------

----------


### 所感 ###
とりあえずうちの会社で誰か早くエバンジェリストになってー！

XP入れ替えに乗じてGETしたPCにマスター一台モグリで動かしているだけの自分からしたら輝かしい世界でした。  
懇親会にも参加させていただいたけど、技術的な話よりまずは既存プロセスにかかわっている人たちのアレルギーをどう下げるかという話がメイン

サーバ連携テストとかやっているので、DockerとかChef絡めたビルドはぜひ挑戦してみたい。  
まぁまずはLinux上のJenkinsでビルド通せるようにしないといけないんだけど。X11連携、X11連携