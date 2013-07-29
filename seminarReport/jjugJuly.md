## プログラム・アジェンダ

---------------

**「Project Lambdaの基礎」(19:00～19:30)**  
櫻庭祐一
Java SE 8 はプログラミングスタイルが変化してしまうほどの大きな変化があるといっても過言ではありません。
その中心にあるのが、Project LambdaのLambda式です。
そこで、本セッションではLambda式の基本的な部分に焦点を当てて解説します。
これを聞けば、後半の実装編の準備になるはずです。
 
「Lambda と invokedynamic の蜜月」(19:30～21:00)
宮川拓
Java SE 7 で追加された invokedynamic 命令、これまでは JRuby 等の動的言語処理系のみで使われていましたが、
Java SE 8 では Java プログラム中のラムダ式をコンパイルするのにも使われるようになります。
このセクションでは、 invokedynamic を使ったラムダ式の評価戦略やパフォーマンスについてご紹介します。
 



「Project Lambdaの基礎」

プロジェクトラムダで変更になったもの
　Lambda式
　その他の文法の変更
　API

Lambda式が導入するにあたって、メソッド参照やStreamなどのに変更が入った。


Lambdaは無名クラスの記述とインスタンシエーションの簡易記法。
無名クラスを書くのはめんどくさい。冗長的である。
例：runnable()とか書くのはめんどくさい。
Runnable task = new Runnable(){
	publlic void run(){
		dosomething();
	}
}

Java8からは以下のように記載できる。

Runnable task = () -> dosomething();

関数型インターフェースで実装すべきメソッド
Lambda式はジェネリクスが戻り値でもだいじょうぶ。


Lambda式的な記述
（ 引数 ） -> { 式 }


引数の型、単一処理ならば、波カッコとreturnは省略可能。

comp = new Coparator<>(){
	public Integer compare(Integer x, Integer y){
		return x - y;
	}
}

comp = (x, y) -> x - y;


Lambdaの注意
アンダーバーは引数に使えない。


ローカル変数が一度しか代入されない場合、
実質的にfinalとみなされる。

実質的にfinalなので、再代入は不可能。
実質的finalなので、Lambda式内での変更も不可能。

無名クラスのthisは自分自身
lambda式のthisは外側のthis
thisのスコープが違うので、気をつけること。
InterfaceのDefalt実装のメソッドと同名の場合、注意する。


## まとめ


関数型IFを実装した無名クラスのインスタンシエーション
型推論：実行時にならないと型が分からない
パフォーマンス　無名クラスより速い #クラスローディングがないので。
実行時に動的にクラスが作成され、ロードされる。

---------------

## 「Lambda と invokedynamic の蜜月」

--------------
スライド資料  
[http://www.slideshare.net/miyakawataku/lambda-meets-invokedynamic](http://www.slideshare.net/miyakawataku/lambda-meets-invokedynamic)

lambda式の実行はinvokedynamicで実現される。


論点整理


静的構造をみると以下のようになっている。

関数型インターフェース
↑implements
ラムダのクラス
↑instance-of
ラムダのインターフェース

mainからnewしてラムダ式を実行する。


ラムダクラスの実行時生成
匿名クラスがコンパイル時に生成されるのに対し、
ラムダのクラスは実行時に生成される。

匿名クラスは「外側のクラス名$連番」という名前で、コンパイラによってclassが生成される。
同等のラムダをコンパイルしても、対応するClassファイルは生成されない。

ラムダのクラスの生成タイミング
ラムダクラスはJVM上のどこかで生成される。。。
lambdaでgetClassしてみると、Lambda$$Lambda$1という名前が得られる。
LoadClass()してみると
LoadClass()→Null
ラムダ式実行
LoadClass()→呼べた！

ラムダ式が実行されたときにJVMによってClassが生成されている。

ラムダ式を含むプログラムsのクラスファイルをjavapコマンドで逆アセンブルしてみる。


lambda$0のようなstaticメソッドが生成されている。
ラムダの処理の中身はlambda$0というメソッドに記述されます。
ラムダ式の実行はinvokedynamic命令の呼び出しになっている。

invokedynamicの復習
本来はJRubyなどのJava以外の言語処理系のためにJavaSE7で追加されたメソッド。
SE6までの、invokevirtual,invokeinterfaceなどと異なり、呼び出し時に動的に処理ができる。

どんも呼び出し命令でも、手順は大体同じ。

receiver.doSomething(arg0, arg1)
レシーバのあとに引数がスタックに積まれる。
スタックを処理して最後に戻り値が積まれる。

SE6までの呼び出し命令はいずれもJavaに密。
メソッドは再定義されない、
名前や引数が決定していれば、一意に決まる。

JRE6以前では、Java言語にない気候（メソッド再定義など）を実現するために、処理系が呼び出しに介入。
そのため、JVMによる実行時最適化が効きづらい。


SE7移行ではinvokedynamicを使って、処理系を介さずに呼び出せるようになった。
invokedynamicするために、呼び出し元(CallSite)ごとに、ブートストラップメソッドで
呼び出し先の関数ポインタ(MethodHandle)を紐付け、登録する。



ブートストラップメソッド
staticである必要がある。
Lookup：MethodHandleのファクトリ
String：「メソッド名」だが、使わなくても可
MethodType：invokedynamicの引数型と戻り値方
任意個数の定数

これらがあれば、実行時にメソッドを特定できる。

ブートストラップメソッドの戻り値
MethodHandleの初期値が紐付けられたCallsite


ラムダ式の実行は紐付けられているブートストラップメソッドを見れば、実際の動作がわかる。


ラムダ式の実行のinvokedynamicは
LambdaMetaFactoryのmetFactoryメソッドがブートストラップメソッドとして紐づいている。
ラムダのクラスを生成するブートストラップなので、
1度実行したあとは、無名クラスが生成される、



LambdaMetaFactoryのmetaFactoryシグネチャの情報を元にラムダのクラスを生成
・引数をフィールドに格納するコンストラクタ
・処理本体のメソッドを呼び出すSAM実装
ラムダをインスタンス化するMethodHandleを生成、CallSiteに紐付け
SAM。。。interface内で唯一実装しなければいけないメソッド


最終的に実行される処理

metaFactoryがLambda$1クラスを生成。
ラムダ式の実装部分は <invokedynamic : new Lambda$1(delta)>;


結局やっていることは匿名クラスと（ほぼ）同じ。
ラムダで生成されるクラスはstaticクラスの場合がある。

なぜinvokedynamicを使ってまで匿名クラスのようなことをするのか？

クラスファイルが少なくなるおかげで、起動が速くなるかもしれない。

JVMがLambdaMetaFactoryを独自に実装することで、最適なインスタンス生成の方法を選択できるようになる。
これが一番大事！JVMごとにカスタマイズできる。

Java SE 8では、StreamAPIの採用によって、プログラム中で全面的にラムダ式が利用されることが、
想定されている。
そのため、クラスファイルのクラスローディング


インスタンス生成戦略の選択

LambdaMetaFactoryはJVMのAPIなので、JVMの都合の良い方法でインスタンスが生成できる。
１つのラムダ式ごとに１つのクラスを生成。
外部の値を参照しないラムダであれば、シングルトンインスタンスを生成すればよい。

外側の変数に依存していない場合、ラムダ式はシングルトンインスタンスを戻す。

その他の戦略
１つの関数型インタフェースごとに１つのクラスを生成。
リフレクション経由で処理本体を呼びだす。
（将来的には）MethodHandleを関数型インタフェースに直接ラップする機構を用意して、それを使う


ラムダの直列化

関数型インタフェースがsirializableを拡張している場合、ラムダの
インスタンスは直列化できる必要がある。
直列化（ラムダ-バイト列）、非直列化（バイト列→ラムダ）したとき、
元のラムダと同じように機能しなければならない。

ラムダのクラスが実行時に生成されるとき、
どうしたら直列化、非直列化できるのか
writeReplace/readResolveを使って実現ｓちえいる。

直列化の流れ
ラムダの場合は、writeReplaceがCallされ、serialicedLambdaの中にある、
静的な情報をdefaultObjectとして渡している。
バイト列を非直列化する場合は、  
一度ラムダインスタンスの前にserialicedLambdaインスタンスが生成される。  
これに対してreadResolveが呼ばれることで、deserializedLambda（ラムダ式を含むクラス）が生成、invokedynamicされる。




## 所感
今回は（自分が未熟なせいで）だいぶ突っ込んだ内容だと感じた。  
可読性や冗長性だけでなく、パフォーマンスへの言及も多く、  
lambda式の利用方法と享受する利益についても解説されていたのよかった。

Java SE 8のLambdaを勉強しようと参加したが、  
まずJava SE 7の仕様自体をわかっていなかった。  
まだJRubyなどJVM上で動く多言語を使うメリットもわかっていない。  
ScalaやLISP利用者だとLambdaは入りやすいらしい。  
ハイブリッドプログラミングのサポートが充実していく中で、  
数種類の言語だけではこの先SEとしてやっていけないのかなといった危機感も持った。


