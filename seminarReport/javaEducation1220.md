# Java研修 第6回#



----------

プログラム言語Java

----------

質問





----------

「notifyは、次の条件のときに適用できる…」、機能の拡張を考えると、nofityAllを使用しないほうが良いではないですか？
最初はwaitのスレッドが少ないしスレッドの条件が異なるのでnotifyAllを使用したが、機能の拡張により（ルール守れなくなったり…）notifyAllが適用できななくなることはあると思います。(12月はこの質問から）


**一般には`NotifyAll()`を使用する。ムダにスレッドを起動するが、仕様は正しい可能性が高い。**

スレッドは一度に高々ひとつしかおきない。
複数のスレッドがwait()しているときは全てのスレッドがロックを持っていない。
```java
synchronized void foo() {
    while(!condition){
        wait();
    }

```


----------


notifyを使う例を教えてほしいです。

----------
デッドロックは設計で回避すべきとの記載ですが、実装後のテスト工程で検出するための手段はないのでしょうか

**テスト工程で検出するにはいくつか条件が必要**

- 経験者に設計・実装してもらう
- 自動テストができる
- 繰り返し実行できる
- デッドロックが出た状態で停止し、デバッグできる

Javaの場合はJVM起動時にRemote Debugモードで起動しておくと、別のPCからデバッグできる。

----------
スレッドのキャンセル処理は、高い優先順位（最優先）で設定したほうが良いですか？
（interruptを無視するかどうかを判断するにはどうすべきですか）

**interruputを監視するか、あるいは別の手段で割込を取得するかは設計次第。**


----------
interruptedの使用場面を詳しく教えてほしいです。割り込みに応答する前に何らかの後処理を行う必要がある場合はどういう場合でしょうか。

**interruptを利用して別スレッドとやり取りする際は双方の設計を考慮する必要がある。いきなりinterruptを使用されるかもしれないという点を十分思慮すること。**

----------
型longとdouble以外の変数への読み書きはアトミックである事を保証しており、データの破壊を防ぐために同期をとってアクセスされる必要がない、とは、longとdoubleは破壊される事があるので同期を取るべきである、ということでしょうか？

**システムが32bitのDataBus場合、Double型は64bitを32bitずつ2組に分けてメモリに読み書きするため、同時に書き込んだ値がマージされて出力されてしまうかもしれない。**

----------
モニターロックとは何でしょうか。



----------
volatile修飾子は、C言語では最適化を抑制するオブジェクトの宣言で、用途が全く違うように見えるのですが、何か関連はありますか？

**Javaのvolatileは書き込むときは必ずCPUのキャッシュだけではなく、メモリまで書き込む。読み込むときも必ずメモリまで行って読み込む**  
**C言語のvolatileはコンパイラが冗長と判断したコードを最適化して削除してしまうのを防ぐ**  
**Javaも最適化を防ぐという意味はある。ただし、C言語以上の機能はある。**

```c
*x = 1;
if (*x != !){ //コンパイラは冗長と思うが、参照先がレジスタなどの場合は必要
}
```

----------
「問題は、共有されているオブジェクトが普遍である一方で、共有されたオブジェクトへのアクセスに使用される参照自身が共有されて、たいていは変更可能です。」
このあたりの意味がいまいちとれません。

**クラスは不変と宣言していてもfinalではない場合、必ずしも同じ値がとれるとは限らない**
**メモリモデルが確立されたのは1.5以降。**
**final privat Y y = new Y(100); Y { int x; Y(int x){ this.x = x;}}などは少なくともxが100になっていることは保証される。**

----------
特定のスレッドの優先度を一番高くする方法がありますが、この方法と直前の「既存のスレッドはsetMaxPriority呼び出しによる影響を受けません」は矛盾しているように思えます。スレッドグループを最初に定義したスレッドでないと、保証でいないのではないでしょうか？

**その通り（前提が省略されている）**

----------
stopは使わない、という認識でよいでしょうか？

**その通り**




----------


練習問題14.03

スリープしてはいけない。＃衝突しないから。
テストとしては、1万回10加算するようなスレッドを10個作って、全てのカウンタが10万になっているかとか。


練習問題14.08
IDを生成したり、Hashを比較して若いほうのロックをとるとか。

練習問題14.09
定期的に現状を報告するようになっていないと意味がない。

ThreadPool
While()の条件式で使うBoolはVolatileしておくこと。
事前に用意した`END`をstop()がされたときに10こdispatch()しておく。
各スレッドは与えられたRunnableが`END`だった場合は終了する。

```java
final Runnable END = new Ruunable(){
                          run(){
                          }
                     };
```


----------


----------
アノテーションは、複数のクラスが同じ意味のfieldを持たせるときにも使えるでしょうか？単純に、重複の定義をしたくないときもあると考えています。

**定義しただけでは意味がない。それを処理するプログラムを自分たちで作成しなければあまり意味がない。**

----------
アノテーションは、なぜメソッド形式で定義するようにしたのでしょうか。
アノテーションのメソッドが引数を持つケースが見られないので、
フィールド形式が自然と思うのですが、なぜそうしなかったのでしょうか。

**アノテーションがメソッド形式のほうがアノテーション情報を処理する仕組みを自作するとき便利**

----------
本来はプロジェクトでアノテーション型やClassInfoを作成して、ドキュメントとしての書式を統一したりしたほうがよろしいのでしょうか？
＃私が関わったプロジェクトやプログラムではそこまでしているコードはありませんでしたが。。。

**チームにとって利益が見込めるかどうか。アノテーションを作成するだけではコメントと違いがない。アノテーションを効果的に開発プロセス内で利用できる状態になって初めて有益になる。**

----------
アノテーション型は自分自身の型の要素を持つ事は許されていないとあり、*3でそれは無限再帰を防ぐための制約と説明されています。しかし、クラス型に対して同様な無限再帰を防ぐことは行われていないとありますが、これは何故でしょうか？

**？？？**

----------
「最後に、アノテーションに関して可能性のある他の問題は～」とありますが、
ここで「Java言語の特殊な方言」というのは、アノテーションを利用したフレームワーク等のようなものを意図しているのでしょうか。

**処理を追加するのは問題ないが、Javaの文法を改変するような変更は許されない。**

----------

リフレクションが必要なときとはいつでしょうか？privateなメソッドをテストしたいときぐらいしか使う用途が思いつきません。

**実行中に動的に変更されるような場合や、メソッドの情報を動的に取得したい場合など。。。？**  
**JUnitもリフレクションを利用している。プラグインフレームワークの開発などはクラス名だけ設計されていればクラスロードできる。**  
**Proxyクラスは重宝する。どのインターフェースのメソッドが何回呼ばれたかetc**

----------

＃isSynthetic()メソッドの説明
合成型のイメージができませんでした。ビルド時にできるものだとは思うのですが、何か例などはありますか

**内部（外部）クラスから外部（内部）クラスのインスタンスにアクセスするメソッドや、ジェネリクスで生成されるCompareTo<Foo t>{}メソッドのCompareTo<Foo t>など**

	public int CompareTo(Object o) {
		return compareTo((Foo) o)
	}

----------
歴史的理由により、ClassはMemberを実装していないとありますが、
どういう歴史的経緯なのでしょうか？昔はClassはメンバーとすることはできなかった、というわけではないと思っているのですが。

**昔はClassはメンバーではなかった。メンバー定義にネストしたクラス、ネストしたインターフェースが登場したのはJava1.1時代から**

----------

Finalフィールドを強制的に変更するようなコードを業務で用いることはありますか？どちらかというと、製品のコードよりも、ユニットテストで使うことが多そうな気がしますが。


**その通り。**

----------

finalフィールドへの変更が見えることが保障されません、とありますがここでいう見えることとはどういう意味ですか？ちなみにstatic finalフィールドはリフレクションを用いても変更できませんか？

**他のプログラムからは見えない。定数変数（P40）はインライン展開されるので、変数ではなく値が埋め込まれるから。**

static final fieldを変更する際はmodifierを利用して無理やりアクセス修飾子を変更する。

----------

getUpperBoundsとgetLowerBoundsは上限境界と下限境界のType配列を返すとありますが、配列ということは複数返ってくることがあるということでしょうか。上限境界と下限境界が複数になる場合とは、どんな例がありますか？

----------
「配列の暗黙のlengthは、実際のフィールドではありません。」とはどういう意味でしょうか

**lengthは別の場所にある配列の長さを持ってきている**

----------

Objectなどの基本的なクラスをロードする前から起動しているブートストラップクラスローダはどのように動いているのでしょうか？Javaではないのですか？

**別の言語で書かれている。コンパイラは最初はC。以降はJavaで作成される。**

----------

streamForメソッドの実装が分かりません。クラスの名前とクラスパスの情報が必要ですが、クラスパスはどのように取得すればいいでしょうか？

**streamFor()をきちんと実装しないとクラスロードできない**  
**自分で作成したfindClassが呼ばれているかデバッグ文を入れてしっかり確認すること。**

----------

例として出ているコマンドラインのオプションとクラスローダーのメソッド呼び出しとの対応づけがよくわかりません。それぞれどういうことをしているのでしょうか。

**コマンドラインオプションについてはmanを参照**

----------

　@Deprecatedアノテーションの目的は、将来的に@deprecated Javadocタグを
置き換えることです。つまりコンパイラがソースコード上のコメントを解析して何らかの振る舞いを行うこと自体がコンパイラが行うべき処理ではない＝@Deprecatedアノテーションの箇所はコンパイル後のバイトコードになんら変更を与えないという意味でしょうか？


----------
