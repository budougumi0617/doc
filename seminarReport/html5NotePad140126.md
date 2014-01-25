# [HTML5][作業メモ]ドットインストールでHTML5の勉強を始めてみた。

HTML5の知識が必要となったので、dotInstallを用いて学習を行う。  
まずは開発環境の整備から。今回作成した開発環境は以下のとおり。

* OS: Mac OSX
* IDE: NetBeans 7.4(Java EE)
* Chrome: 32.0.1700.77
* JDK: 1.7.0_45
* git: 1.8.3.4

NetBeansを選んだ理由はHTML5、JavaFXを安定して利用できそうだから。また、同様の理由でNetBeasのインストールではJavaEEのプリセットを選択した。

---

### 開発環境作成の手順

下記リンク先の情報を参考にNetbeansをインストール  
このとき、予めローカルにgitリポジトリがあると、プロジェクトをそのまま構成管理ツール上で利用できる。

[HTML5の製作環境としてNetBeans IDEを使ってみる](http://tomotomosnippet.blogspot.jp/2011/05/html5netbeans-ide.html)  
[HTML5アプリケーションの開始](https://netbeans.org/kb/docs/webclient/html5-gettingstarted_ja.html)

----

### 動作確認

環境構築後は下記のコードを写経して、簡単にフォームを作成。

[HTML5 #01 メモ帳の画面を作る](http://dotinstall.com/lessons/memo_html5/2301)


空のHTML5プロジェクトを作ったならば、以下のようなindex.htmlを作成する。
Webブラウザでフォームを動作を確認して、完成。
NetBeansではChromeを利用してリアルタイムプレビューを行うことができた。

````html
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html lang="ja">
    <head>
        <title>HTML5を使ったメモ帳</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width">
    </head>
    <body>
        <h1>メモ帳</h1>
        <textarea id="memo" rows="10" cols="40" name="40"></textarea>
        <p><input type="button" id="save" value="Save"> <input type="button" id="clear" value="Clear">
        </p>
    </body>
</html>
````

このドットインストールは全８回なので、適宜続きを行ってみる。
