# Java研修 第3回#



----------

プログラム言語Java

----------

質問


----------


----------
なぜ`super.clone()`をしなければいけないのか。  

[http://funini.com/kei/java/clone.shtml](http://funini.com/kei/java/clone.shtml)


----------
次回（9月）は、練習問題３．９から。
練習問題3.11「気づかれること無くメトリクスに関して不正を行える」＝「もともとの設計者に気づかれること無く」という意味でしょうか？
「SortDoubleのセキュリティホール」を少なくともひとつ見つけなさい。
「セキュリティホール」になりうる、状況を具体的に教えてください、またどういった設計で防御すればよいのでしょうか？
「この場合ソートアルゴリズムの作成者はmainを書かないと想定してください。」＝つまり、「privateメンバーに直接はアクセスできない」という意味でしょうか


----------




----------


練習問題3.12　「どのようなオブジェクト型でもソートできる」＝
sortメソッドの引数を「Object配列」にすればよいのでしょうか？
「オブジェクトの比較をするのに＜は使用できないとしてオブジェクトの順序を表す方法をどのように提供しますか」Comparableインタフェースを実装してcompareToを使用しますか？


----------


Javaはインターフェースの多重継承を許可していますが、クラスは単一継承のみ許可しています。そのため、複数のクラスの実装を継承する事ができません。Rubyでは、Mix-inという仕組みによってそれを回避していますが、Javaでもそのような方法はあるのでしょうか？

**コンポジションをしてラップメソッドを定義する。**  
**Go言語だとコンポジションしたいクラスのインスタンスを持つだけでラップメソッドを宣言しなくてもコンポジションインスタンスのメソッドが呼ばれる。**


    Class Z impliments X, Y{
        X objX = new Ximpl();
        Y objY = new Yimpl();
        fooMethod(){
           Ximpl.fooMethod();
        }
    } 


----------


「インターフェースの定数フィールドは暗黙にpublicかつstaticかつfinal」とは、「変更不可能な定数フィールドを持たせることができる」という意味ですよね？

**その通りです。**

----------




----------

インターフェース定数は、修飾子に何もつけないとデフォルトでstaticになるとありますが、非staticのインターフェース定数はできない、ということでよいでしょうか。


**その通りです。**

----------



----------
定数の継承についての問題です。スーパーインタフェースとサブインタフェースにて同じ名前の定数があり、スーパーインタフェースと
サブインタフェース両方を実現するクラスがその名前の定数（super.変数を明示しない場合）利用するときにサブインタフェースのほうを利用するでしょうか？

**その通りです。**

----------

Attributedにiterableを実装するのは間違い、としていますが、このインターフェースではiteratorを利用して実装することが前提のインタフェースである印象を受けます。必ずこのインターフェースでは属性を利用するためのitratorを返すという意味があると思われるのに、iterableを実装することがなぜ間違なのでしょうか。これも、clonableと同様、マーカインターフェースとしての役割があるからなのでしょうか。

**iterableであることはインターフェースとして指定しているが、`Attr`の何を返却するのかはImplする側がきめることなので、インターフェース内で実装するのは間違いである。**

----------


練習問題4.3
LinkedListクラスはインタフェースであるべきですか?
LinkedListメソッドをオブジェクトごとにカスタマイズする場合にはインターフェースであるべきです。
テキストp500のJavaのコレクション型階層の下位階層の一つであるListの下のLinkedListインタフェースはどのような設計思想、
恩恵を利用して使用するものですか？


----------




----------


練習問題4.4の「インタフェースのみを使用して、コレクションクラス階層を設計しなさい」という問題の意図に対する解答は下記の方法で正しいでしょうか？

    import java.util.*; 
    
    public interface Collection<E> extends Iterable<E>{
    boolean add(E e);
    boolean addAll(Collection<? extends E> c);
    void clear(); 
    boolean contains(Object o); 
    boolean containsAll(Collection<?> c);
    boolean equals (Object o);
    int hashCode();
    boolean isEmpty(); 
    Iterable<P> iterator(); ←また、これが構文エラーとなる　：なぜでしょうか？
    boolean remove(Object o); 
    boolean removeAll(Collection<?> c);
    boolean retainAll(Collection<?> c);
    int size();
    Object[] toArray();
    <T> T[] toArray(T[] a); 
    }


**問題が悪いので余談**  
`Set`インターフェースはある種のマーカーインターフェース。  
`Collection`に機能の追加はしておらず、契約の追加しかされていない  
＃要素に重複を許さないという追加契約


----------



----------



練習問題4.5 次に型がインタフェース、抽象クラス、具象クラスのどれで表現するべきかを考えなさい
練習問題4.6↑の各問題に対する仮定をどのように変更するとあなたの答えが変更されますか？
(a)Ｎ分木のノード：TreeNode　　　　　
A) 抽象クラス
実装をTreeNode用途ごとに選ぶ状況ではインタフェース
フィールドをTreeNodeで流用したいから抽象クラス

(b)特定の順番　深さ優先
　　　　　　　　幅優先　TreeWalker
B)インターフェース
実装をTreeWalker用途ごとに選ぶ状況ではインタフェース
流用するなら抽象クラス

(c)グラフィックシステムにより描画可能なオブジェクトのためのDrawable

C)インターフェース
描画可能なオブジェクトごとに実装するのではなく
流用するのであれば抽象クラス

(d)グラフィックデスクトップから実行できるプログラムのためのApplication

D)具象クラス

(d)のapplicationを流用するのならインタフェースか抽象クラス

で解答は正しいでしょうか？

**想定によっていろいろ。**


----------


----------


クラスをネストすることによるメリットがよく理解できませんでした。
「型の構成やスコープを論理的に関連したグループにまとめる」ことが
ネストクラスの利点とありますが、
これはを実現するにはpackageなどの仕組みでは不十分なのでしょうか？

**Xクラスが存在しないならば、Yクラスが不要な場合などは、内部クラスにするなどの設計方針がとれる。**


----------



----------


staticのネストしたクラスと内部クラスの違いがよく分かりません。
Permissionsクラスは普通の内部クラスとして宣言してはいけないのでしょうか？
static修飾子がついたメンバはオブジェクト間で共有されるものという認識なのですが、Permissionsクラス内のメンバはインスタンスが持つ値ですし内部クラスでいいと思うのですが。。。

**内Stat部クラスは外部の外部】クラスがKurofune.outer.**


----------


----------


内部クラスをインポートして使用できるとありますが、
BackAccountクラスの例でいうと、Permissionクラスのオブジェクトには
BackAccountクラスのメンバ変数（number、balance）はないという認識でよいですか？


----------


----------


this.new (内部クラス名)という書き方を初めて知りました。ところで、この書き方で、この内部クラスをnewする事はできたのですが、super.new (スーパークラスの内部クラス名)と書くと、エラーになりました。superを使ってこの書き方はできないのでしょうか？

**できない。**


----------


内部クラス宣言のstaticメンバーの制約はなぜでしょうか。
Final staticフィールド以外のstaticフィールドを持てても問題ないかと思います。

**1.1リリース時にスコープがきめられなかったので、割り切りで禁止になりました。**  
＃スコープ：システム全体でstaticなのか、共通の外部クラスを持つ内部クラス同士のみでstaticなのか。


----------


Outerのサブクラスでは無いのにOuterのオブジェクトのコンストラクタを呼ばなければいけないのならば、最初からOuterもしくはOuterを拡張したクラスの内部クラスとして宣言したほうがいいと思うのですが、内部クラスだけを拡張したクラスを作るということはあるのでしょうか？テキストにも極力さけるべきとありますが、これは間違った設計なのでやらないほうが良いという例で説明してますか？

**その理解で間違いない。浸透していないセンテンスなので、使う際は参考文献を記載しておいたほうがよいかも。**


----------


他の関係ない内部クラスを拡張するような設計は極力さけるべきとの記載ですが、逆にこれが有効となるようなケースがあるのでしょうか。

**あまりない。内部クラスなのに、外に公開して継承もさせるというのはあまり設計方針上選ばれない。**

----------


サンプルコードでHelperクラスがUnknownを拡張しない場合に、incrementメソッドをthis.x++とすると、エラーでコンパイルできません。普通のx++もしくはHost.this.x++だとHostクラスのxをインクリメントできます。内部クラスの中ではエンクロージングクラス内で宣言されているすべての名前がスコープ内にあるはずですが、this.xではどうしてエラーになるのでしょうか？

**`this`は内部クラスとしての自分なので、外部クラスを探索しない。**  
探索はスーパークラスを探索しに行く。また、メソッドの場合はメソッド名のみで探索をする。
もしスーパークラスにシグネチャが異なるメソッドがあった場合、エンクロージングクラスの探索はされないので、`EnclosingClass.this.method()`などとして呼び出す。


----------


ローカル内部クラスの使いシーンは良くわかりません。サブスレッドの新規処理に使われますか？

**どうしてもメソッドの外にクラスを見せたくないとき…？たしかに使う機会は非常に少ない。**

----------


----------



無名内部クラスのメリットがよくわかりません。簡潔なクラスの見た目を良くする、ということだけですか。

**外部から呼ぶ必要がない（名前をつける必要がない）場合など**

----------




----------

「HighSpeedPrinter内で定義された…その新たなサブクラスからクラスPrinterは何も影響を受けません」。その意味は、
HighSpeedPrinterのSerialPortはPrinterのSerialPortを継承できていないことでしょうか？

**例文の場合は`HighSpeedPrinter`クラスで`SerealPort`を（同じクラス名で）拡張しても`Printer`クラスは影響を受けないということ。**

----------


「インタフェース内にネストしているクラスやインタフェースはpublicでかつstaticです」とありますが、staticにしたくない場合は、ネストせずにインタフェースの外部で定義するしかないのでしょうか。

**おそらく`new outer.Inner()`でできるが、あまりインターフェースの中でクラスを定義することはない。**


----------


リフレクションを使用した場合、ローカル内部クラスはNInnerという名前で見えるということでよろしいでしょうか。

**`Outer$Ninner`というカタチで見える。メソッドごとに同じ名前のローカル内部クラスを宣言できるため。**


----------


enumのアクセス修飾子はpublicか付けないかのどちらか、と書いてありますが、そのクラス内でしか使用しない場合はprivateでもいいのではないのでしょうか？

**トップクラスの`enum`型の場合のみ。ネストした`enum`ならば`private`でもかまわない。**

----------

----------


enumに明示的にfinalと宣言できない理由はこの後すぐに説明する、と書いてありますが、テキストのどの部分がその説明にあたるのでしょうか？


`public final enum XXX`と宣言できない理由はP137 L9参照  
サブクラスが宣言される可能性があるので`final`宣言できない。

----------

----------


java.lang.Enumクラスのように循環したクラスを自分で定義するような場面はありますか？
Enumクラスの利便性はわかるのですが、循環クラスにしたことで享受するメリットがよくわかりませんでした。


**複雑なのであまり設計では用いない。**  

    class X extends Enum<X>
    //ジェネリック型は T extends Enum<T>を許すので、言語仕様上では解決できる。

----------

----------


enumを使用すべきか否か。という点において、複雑でなければ（複数の）定数はenumで表現するほうが良いと感じまして、それは良いのですが、アプリケーションのエラー内容とエラーコードなどを格納するような定数クラスもenum化することは特に問題ないでしょうか。
（enumの要素一つに、READ_ERROR（”0001”,”読み込みエラーです”) ;と定義する等。）

**`enum`型に対して情報やメソッドなどは積極的に付加するべき。**  
`enum`型で`swicth()`や`if-else`をする部分が減っていく

----------


enum定数固有の振る舞いを持つenum定数を宣言している場合は、enumを使用すべきか否か考慮が必要とありますが、その判断は何を目安にすれば良いでしょうか。

**上記と同様。**

----------


enumは、enumerated typeから来ているとのことですが、こちらはどう読むのが正しいのでしょうか。イーナム、またはエナム、という言い方を聞いたことがあります。


**好きなほうで。。。**

----------



----------


トップレベルのクラスはenum型であっても必ずファイルを分ける必要があるのでしょうか。分けずに１つのファイルで書いたときどのような
デメリットがあるのでしょうか。


**`public`だったならばファイルを分けなければいけない（クラス定義と同様）**
`public`でないならば同梱してもよおいが、トップレベルは通常ファイルを分ける

----------



----------


「enum 定数をシリアライズする場合には、name フィールドだけがシ
リアライズされます。他のフィールドは一切シリアライズされません」とありますが、この変更によってどんなことが変化したのでしょうか。


**特に気にせず使用することができる。リリース5.0からはenumのシリアライズは他のクラスなどとは別のシリアライズと変更された。**

----------



----------


`public static <E extends Enum<E>> EnumSet<E> of(E first, E... rest)`
可変長引数メソッドを定義しているのに、5こまでの固定長引数メソッドも用意されています。
可変長引数メソッドを定義してあるときでも、ある程度の固定長引数メソッドは用意するべきなのでしょうか？
＃特定の引数の数のときに最適化ができるならば、固定数のメソッドを用意する。という認識でよろしいでしょうか。

**使用頻度が高い固定長引数のものは用意しておくと処理が早い。**

----------


enumをインターフェースを実装する形式で定義することもできるとありますが、定数特有の振る舞いを抽象メソッドとして定義する方法とインターフェースで定義する方法では何が違うのでしょうか？

**抽象メソッドならば、他のクラスが実装できる。**
**インターフェースということは継承した別のインターフェースで拡張ができる。**

----------

----------



Eclipseで実装後、外部ツールのCheckStyleで静的解析を行うと「タブ」に対して警告が出てきます。Javaコードではタブをりようするのは本来あまり望ましくないのでしょうか。

**特に気にしない。Go言語は標準の整形ツールが入っている。**

----------


7.1.4 識別子　の４行から、「今日世界で書かれているほとんどの文字を使用できます」。
Π（パイ）を使うのか考えられるが、実際に日本語などの識別子を使うシーンはありますでしょうか？


**使用言語圏の広さ的に可読性が低くなるので業務ではオススメしない**

----------



----------


整数型でさまざまに使われているのは、int型であると感じていますが、配列を使わない時の数値や、shortで収まると思われる数をカウントするときなどは、
shortは使ったりはしないのでしょうか。

**Javaの数値代入は基本的に`int`型。`short`で定義すると毎回ボクシングやキャストが必要になる**

----------


`Integer`サイズ以上の配列を利用したい場合どうすればよいのでしょうか

**独自クラスを作成する必要がある**

----------


配列が示す配列要素の変更許可の管理をJavaでサポートしない理由はありますか。C++ではconst int * const intArrayと配列要素の変更も制限できるので、技術的にはJavaでも可能だとおもうのですが。

**配列要素の変更を許さない場合は`Collection`で対応することになる。**


----------


無名配列は変数名をついてないので、newして一回使ったらもう使えないですか？

**どうしても使用したい場合は関数内でどこかへ`return`するしかない。**

----------



