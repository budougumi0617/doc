#gccでC/C++をコンパイルするときに知っておくと便利なこと


  
　　


## アセンブリ出力の解析をしたい


----------


1. gccに-g -sオプションをつける。
2. nmコマンドを利用する
3. lddコマンドでリンクされているライブラリを特定する。





### 参考URL

[gccのアセンブル出力を解析する時は-gオプションが便利](http://nanoappli.com/blog/archives/3899 "gccのアセンブル出力を解析する時は-gオプションが便利")


[nm - コマンド (プログラム) の説明 - Linux コマンド集 一覧表](http://kazmax.zpp.jp/cmd/n/nm.1.html)


[ldd - コマンドがリンクしているライブラリの表示](http://www.ksknet.net/linuxjq/ldd.html "ldd - コマンドがリンクしているライブラリの表示")
