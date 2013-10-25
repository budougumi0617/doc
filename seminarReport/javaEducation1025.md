# Java研修 第4回#



----------

プログラム言語Java

----------

質問


----------


単なるintですむ箇所では、オブジェクトは多くのオーバーヘッドをもたらすかもしれません、とありますが、どのようなオーバーヘッドでしょうか。

**インスタンス`Integer.valueOf()`が毎回呼ばれる。また、四則演算を行うたびにインスタンスを参照するためのメソッドが呼ばれてしまう。**

----------

Characterクラスは、new Character(数値）のコンストラクタを持たないのですね。C言語では、unsigned charが0～255の範囲という事を利用して、画像のRGB値を保存するのにunsigned char型をよく利用したのですが、javaではchar型は文字を表現するという目的でしか使わない、という事でよろしいでしょうか。

**JavaではCharはあくまで文字を表現するためのクラスである。そのため、JavaではC/C++にないByte型が用意されている。**  
ただし、**符号なし**2バイト整数として、インクリメントなどは行える。

----------


`new Integer('あ'); `という書き方はエラーにならず、`'あ'=12354`の値が生成されるのに、`new Character(12354)`という書き方はエラーになります。
逆に、`Character c = 12354; `という書き方はエラーにならないのに、`Integer x = 'あ'; `という書き方はエラーになります。
なぜでしょうか？

言語仕様。ボクシング変換はシンタックスシュガーなので。


----------

    Integer i = new Integer(1);  
    Integer i = Integer.valueOf(1);


だと、後者のほうがが良いという風に説明から読み取れたがそれで正しいでしょうか。  
どちらも作られるオブジェクトは1つのように感じますが、  
これは、2回以上呼ばれた時に、後者だと同じオブジェクトが呼ばれるからリソースの節約や速度向上につながる、ということでしょうか。  


`Integer i = Integer.valueOf(1);`が正しい。

----------



equalsはオブジェクトを比較する場合、フィールドの値、メソッド、内部クラスなど、修飾子やオブジェクト全ての内容の同一性をチェックしますか？


同値性のみ検査している。同じ値を表しているかを確認している。

----------



”Boolean.parseBoolean”が”ｔRue”などの大小混合文字を”true”と解釈するメリットが分かりません。前後にスペースが入るだけでも”false”と解釈されてしまいました。大小混合に利便性を感じないのですがメリットがあるのであれば知りたいです。
"NaNはどういったときに使いますか？∞
"
"タイトル文字というのがどのような文字なのかピンときていないのですが、日本語と英語にもタイトル文字はありますか？
"
"ボクシング変換のメリットについてです。
「データ自体のバリューを知りたい場合、ボクシング変更をする必要はなく、
データを動作したい（共通メソッドを利用など）場合、ボクシング変更をしたほうがやりやすい」
とはメリットですか？"
"「ボクシング変換は十分なメモリがない場合、失敗する可能性があることを～」とありますが、Integerオブジェクトなどの作成にそこまでメモリが必要なのでしょうか？
＃ボクシング（アンボクシング）だからメモリを消費するということでしょうか。"
ある型のある値の範囲に対するボクシング変換は、常に同じオブジェクトになるように要求されるとあります。その範囲内のキャッシュされたラッパーオブジェクト同士の比較には「==」が使用できますが、範囲外のラッパーオブジェクトは別のオブジェクトとして生成されるため、「==」では正しく比較が行えません。このことから、ラッパーオブジェクトの比較は常に「equals()」を用いるべきでしょうか？
"なぜJavaはオーバーフローを避けるつくりにしたのでしょうか。
これによって、intなどの計算がオーバーフローしたかどうかを確認しづらくなっているような気がします。"
"float型、double型の計算結果がNaNになったとき、例外をスローしないのはなぜですか。
"
"浮動小数点算術の厳密性が有効に働く例を教えてください。
"
"floatの等価演算についてです。
よくあるのは、5.0/2.0の結果は2.4xxxxxとなり、２回の計算結果を比較するとfalseが返してくれる。
対応としていつも小数点以後n桁まで四捨五入して再比較しますが、それより良い方法はないですか。"
「括弧（）は、Java言語では必要とされていません。」とは、CやC++では括弧がないとコンパイルエラーになるような式でもJavaでは括弧が必要ないという意味でしょうか？だとすると、どのような具体例がありますか？
「すべてのメソッドがabstractであれば、その１つが任意に選択されます。」というのの意味がとれませんでした。どのメソッドが選択されるかわからない、という意味でしょうか？すると、メソッド呼び出しに曖昧さが残ると思うのですが。
"Switch文内のdefaultケースには例外処理を入れるのは標準的なのでしょうか
"
"業務でもSwitch文でFALLTHROUGH(わざとbreakしない)を利用することはありますか？
明示的にコメントで意図的に行っていることを書けば利用しても良いのでしょうか？"
do-whileはループ本体を少なくとも一度は実行したいときに使えるということですが、ループ本体を一度でも実行したいというのはどのようなケースでしょうか？未だに実装でここはdo-whileで書こうと思ったことがありません。
"do-while文は実際に利用したことや見たことがありません。また、今回の練習問題でもdo-while文を適用させたいようなケースはありませんでした。
do-while文のように「必ず1回は何かをやりたい場合」というのが実際にあるのでしょうか。また、 while文でも少し処理を工夫すればdo-whileと同じ動きをするプログラムが、できると思われますが、do-while文にする ような判断はどのようにすればよいのでしょうか。"
"ラベル付きのbreak文、continue文は一般的に使用されるものなのでしょうか？
C/C++では、コード内の制御の流れが不明瞭になってしまうため、goto文の使用を控えていました。Javaではgoto文が使えない代わりに、ラベル付きのbreak文、continue文が使えますが、これらの文も多用しすぎると制御の流れが不明瞭になってしまう可能性があると思います。"
"ジェネリック型との併用を意図して（ジェネリックでPrimitive型の利用を意図して）ボクシング/アンボクシング変換は実現された機能のように読めました。メソッド引数の変換などもあるようですが、その他に主要な使用機会はありますか。
"
"「基本データ型の値をボクシングにより参照型へ変換した場合には、同じ値に対して同じインスタンスの参照が返される仕様が理想ですが、
現実的ではありません」とありますが、どういう理由でその仕様が困難なのでしょうか。"
"事前に用意されたインスタンスを返すとありますが、これらのインスタンスはどのタイミングで生成されるのですか？
"
自らでIterableインタフェースを実装する場合と、機能の近いコレクションを拡張する場合のふたつが設計で考えられたとき、どちらを選ぶのが効率的でしょうか。＃レビューでの説明負担や、第三者の可読性も加味した上で
ジェネリッククラスの宣言にて、public,privateを付けないですか？ネットを調べたら、なにもつけない　又はpublicをつけるのがあります。ジェネリックという名前付けから考えると、publicをつけるのは相応しいと思いますが．．．
"ジェネリック型の型変数E, K, V, Tなどの使い分けは実際どのようなものでしょうか。
"
"なぜ”&”で区切るのでしょうか。
クラス宣言時同様にimplimentでよいように思えます。異なる表記をする必要性やメリットがあるのでしょうか。"
"「ネストしている型が内部クラスならば。。。」ここの説明は、ジェネリック型の内部クラスをジェネリックとして宣言する必要がないという理解は正しいですか？
"
"ジェネリック型をネストさせることは避けた方がいいのでしょうか。
"
"「そして、いつも通り、隠ぺいを避けるべきです」の隠ぺいとはどういう意味でしょうか。
この場合の隠蔽は カプセル化におけるフィールド等の隠蔽 とは違うものであると認識しているが、たとえばこのケース以外での「いつも通り行うべき隠ぺい」の例はどんなものがありますでしょうか。"
"ジェネリック型と、ワイルドカードの意味の違いや使い分けがよくわかりません。
例えば<E extends Number>は「Numberかその拡張であるどれか」、<? extends Number>は「Numberかその拡張であれば何でも」、というイメージで合っていますか？"
「上限境界」「下限境界」「(非)境界ワイルドカード」という用語が出てきて、そのあとも頻繁に出てきますが、「境界」という言葉をどうイメージすればいいのでしょうか。「境界」と聞くと「あいだ」「さかい」というイメージなのですが。
"上限境界がObjectなのとObject型なのとが実際どう違うのか分かりません。つまり、List<?>とList<Object>との違いを教えてほしいです。
"
SingleLinkQueue<? Extends Number> numbers = new SingleLinkQueue<Number>();でaddメソッドが不正になる理由がよくわかりません。なぜnullしか追加できないのでしょうか？
「普通は、入力パラメータは下限境界ワイルドカードを使用し、戻り値と出力パラメータは上限境界ワイルドカードを使用します」についてです。入力時に下限境界何度なく理解できますが、「戻り値と出力時に上限ワイルドカードを使用する」あまりイメージができなく、例とかはありますでしょうか？
"上限境界と異なり下限境界の場合にadd()できる理由はなぜでしょうか？
"
"型変数を２つ使ってジェネリックメソッドを定義するケースはよくあるのでしょうか。自分には、かなりややこしいことをしているように感じます。
"
このコード例のtoArray(T[] arr)メソッドについて、実行時の検査に依存している、との説明がありました。実行時にならないとエラーがわからないということは、このコード自体があまり良いコードでないように思えます。このページのコード例は現実的なコードではないということでしょうか。
「しかし、メソッド本体は、実際には型Object[]のローカルへんすを扱っており。。。したがって、Object[]変数を使用してその問題を回避しています」についてです。型の制限をまずしないと、互換性によるの問題が生じるから、ここのやりかたは、ジェネリックメソッドに対して不可欠ですか？
"「単純なメソッド名だけを使用する呼び出しをパラメータ化できない」理由は何でしょうか？
"
"ワイルドカードが不明な型を表していて、コンパイラーはどのように型をチェックするのでしょうか？
また、ワールドカードの使いどころを教えてください。"
"「キャプチャ変換が187頁の9.4節で説明した他の型変換を補完しています」とありますが、他の型変換、とは何でしょうか。
"
「もし、それが本当に検査したい事ならば、パラメータ化された型をそのイレイジャで置き換える事ができます。」の意味が分かりませんでした。その直前に、「実行時には、パラメータ化された型はそのイレイジャで置き換えられています。」と書いてありますが？
「ジェネリック化する」とは、例えばObject型を利用したクラスをジェネリック型を使ったクラスに改造する、という意味であっていますか？ここでの「スーパークラスである既存のクラスをジェネリック化できます。」というのは、文脈からいうと逆のように見えるのですが。
"例外型をジェネリック型にすることは許されていないとありますが、何故でしょうか？
(ジェネリック型を用いた場合、コンパイル時にイレイジャによって型の情報が消されてしまうため、複数の型を指定したcatch節の区別が出来ないことが原因でしょうか？)"
"開発規模やリリース物の種類にも依存するとは思いますが、どの程度の頻度で例外を作成することになりますか？
既存例外をラップして返しているだけのような独自例外も多いような気がします。"
最後の一行に「他のcatch節は実行されません」、例えば、２つの例外が含まれている対象に対して、最初のcatch節からしかキャッチされないということは、catch文を書くときに重要度順で書く必要があるということでしょうか？
"アプリケーションでログを残す処理を入れる際に、
try{
何かの処理
}catch(Exception e){//←例外を限定しない
 ログを出力する処理
}とするのは設計上良くないでしょうか？
例外を限定すると、それ以外の例外が発生したときにログに残らないのでデバッグが捗らないのではないかと思うのですが。"
"アサーションの詳細式がThrowableのときはどういうときでしょうか。
"
"「事前条件」に満たさない場合は、後のコードはすべて実行されないでしょうか？そうすると、次のアクションがなくなってプログラムが動かなくなる気がします.
"
"public String toString()とありますが、Stringクラスのスーパークラスである
CharSequenceのメソッドに、Stringが定義されているのが、少し不思議です。
これは、普通自分でクラス設計する際には出てこないような
特殊なケースとして判断して良いのでしょうか。"
"Lengthをフィールドにしないのはなぜでしょうか。
"
indexOfの性能についてです。indexOfはstringの先頭から対象を探索することは、最も単純なアルゴリズムを使っていて、たくさん使うと性能が落ちる気がします。そのときにオーバーライトほうが良いですか？
"関数表を見ると、Byte型とShort型からString型への変換にはキャストが必要なように見えますが、その認識でよろしいでしょうか。
その場合、なぜこの二つの型のみ関数が用意されてないのでしょうか。"
例えばあるメソッドで入力文字列(str)が数字かどうか判定したい場合、Integer.parseInt(str)をTry～Catchで囲む方法と、正規表現で"^[0-9]*$"のパターンと比較する方法がありますが、どちらがパフォーマンスとしては良いのでしょうか？
"「デフォルトの境界は不透明です。つまり、入力シーケンスに対するはっきりとした境界に見えます。」とはどういう意味でしょうか。
"
StringBufferとStringBuliderの使い分けについてです。StringBufferはスレッドセーブなデータ構造のため、同じタイミングに複数のところから書き込むソースでしたら「StringBuffer」を使い、一般的にはStringBuilderを使うことでしょうか？
C++のテンプレートのように、型変数に対して、実際の型が指定されるごとに、その型を適用したコードが生成されることはないとありますが、Javaではテンプレートメタプログラミングのようなことはできないと考えて良いでしょうか？
"ジェネリックコンストラクタとはどのようなときに使用しますか？
引数のT型のXはどのように扱われるのですか？"
"ワイルドカードキャプチャによる恩恵を教えてください。
"