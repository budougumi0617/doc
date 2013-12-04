# JJUGナイトセミナー 「JavaEE特集」#



----------


12/17にJJUGナイトセミナー。
jenkinsの川口さんをゲストで招く



----------

[スライド資料](http://www.slideshare.net/agetsuma/jjug-11-cdi)

Dependency Inteli

JavaEEでシステムを構築するとWeb3層構造になる。
最上位層は全ての階層に依存しているので、ユニットテストがしにくい。
テストのないレガシーコードが増え続ける。

インターフェースをつくり、DIコンテナでnewして注入

DIすることでクラス間の依存性と、テストが作りやすくなった。


----------


ロジックと実装は別層（クラス）に切り分けておきたい

ビジネスロジックは特定技術に依存したくない


----------

EJBとの使い分け
EJBの宣言的トランザクションがCDIでもできるようになった

CDIはWeb構築に、EJBは基幹システムで使うのがよろしい。




----------


### おっぴろげ DevOps ###


なぜかJavaEEの導入事例が少ない。。。
なので、グリーでの導入事例を公開する

Glass fishを用いてREST APIベースのジョブワーカーを作成した

開発-テスト-リリース＆デプロイ-運用
サンプルコードは以下に
bit.ly/jjug-camellia

Lombok使うと@getterとアノテーションするだけでメソッドが自動生成される

JAXBを使うとJSONやXMLにアウトプットを加工してくれる。


mavenのfailsafe-pluginを使ってUTとITを切り分ける

コンテナを用いるテストは重たいのでできるだけUTに寄せたい。


JPAでEntityManagerをラップしてUTする。

JMockitでモックを作成する。

gitとMavenのrelease-pluginでリリース。

リリースは全てJenkins。UT, IT, Development Deploy, Staging Deploy, Production Deploy
Build pipeline plugin

clone workspace SCM pluginを利用することでUTを実施した時のコードをITに用いることができる。


----------

無停止デプロイ

二つglassfishのインスタンスがある。
Reverse Proxyで二つのプロジェクトを切り替えている。

asadmiコマンドを利用するときにenabled=falseにしておくとdasのみにデプロイできる。



----------
運用

asadmin set-log-levelsで動的にログレベルを変更できる。

出力されるログはglassfishhのバージョンによって二種類
UniformLogFormatter、ODLLogFormatter。

監視はJMXを利用する。

