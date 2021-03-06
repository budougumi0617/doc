# Pythonの学習メモ


----------

dotinstallで基礎的な文法を学習する。


## Python入門 (全31回)  
Googleなどで採用されている、シンプルで習得がしやすいオブジェクト指向言語、Pythonについて学んでいきます。

http://dotinstall.com/lessons/basic_python



----------

日本語を利用するときは冒頭に`#coding UTF-8`を記載しておく。  
**en**codingではない点に注意する。

```python
#coding UTF-8

print "hello World"
def MyFunction(param, ...)
```


----------

###変数の利用方法

変数名は1文字目が_か英字で。大文字小文字は区別される  
二文字目以降は英数字_を利用できる。  
予約語と同じ名前は利用できない。


代入は他の言語と同じように`=`を利用する。

```python
#coding UTF-8

msg = "hello World" 
print msg

```


###データ型

Pythonにおけるデータ型は数値、要素列、真偽値、none、関数、オブジェクトがある。  
要素列の種類は以下の通り  

- 文字列 :文字が並んだもの
- リスト　:　データが並んだもの
- タプル ：データが並んだもの**（変更不可）**
- セット ：データが並んだもの**（重複不可）**
- 辞書　:　キーと値がセットになったもの**(Map()のようなもの)**　　

タプルとセットについては、他の言語ではあまり使わない用語。


----------


###数値の演算

数値は整数、少数、複素数をサポート。  
通常の四則演算と剰余が行える。  
べき乗も出来る。  
小数が含まれる場合は結果も小数となる。  
小数を含む計算で切り捨て計算をしたい場合は`//`を利用する。


```python
#coding UTF-8
 
print 3 ** 3 # 3の3乗 result : 9
print 10 // 3.0 # result : 3.0  

```


----------

### 文字列を扱う ###
文字列は\`や\"で囲む。  
Escapeシーケンスを利用して\\\`と書くのは他の言語と同一。

```python
#coding UTF-8
 
print `it\`s pen` 

```

また`"""`で囲むことで複数行にまたがる文字列も扱うことができる。
ユニコードを利用するときは`"`のまえに`u`を付ける

```python
#coding UTF-8
 
print u"こんにちは！" 

```


----------


### 文字列の操作 ###

```python
#coding UTF-8

#連結は算術のように実施できる。
print "hello" + " world"

#繰り返しも算術のように実施できる。
print u"hoge" * 10

#文字列長を出力できる。
print len("abcdefg")

```



----------

### 部分文字列の切り出し、検索の仕方 ###

文字列変数の後ろに[start:end]で切り出したい範囲を指定する  
`print s[1:5]`など。`s[1:-2]`の場合は2文字目から最後から-2文字目まで。

またfind関数があるので、`find(str)`とすることで、`str`で指定した文字列の先頭位置を知ることができる。


----------

### 文字列と数値の相互変換 ###
キャストのようにすることで変換が可能。

```python
#encoding: UTF-8
#file name /src/09.py
#caluculate string and int or float

print 5 + int("5")

age = 20

print "i am " + str(age) + " years old"

```



----------

### リスト操作を扱う ###
リスト操作でも要素の型を意識せずに挿入や変更ができる。

```python
#encoding: UTF-8
#file name src/10.py
#list

a = [1, 2, "a", 4, 5.5]
b = list([3,5])

print a
print b

#len + len + * [] [start:end]
print len(a)
a[2:4]  = ["b", "c"]
print a
print a * 5

```


### リスト操作その２ ###

`foo.reverse()`で逆順にしたり、  
`range()`関数で生成したりすることが出来る。

```python
#encoding: UTF-8
#file name src/11.py
#list

a = [1, 2, "a", 4, 5.5]
b = list([3,5])

print a
a.reverse()
print a
print 4 in a
b = range(3, 10) # 3から10の間の数値列
print b
b = range(3, 10, 2) # 3から10の間を２つ飛ばしで。
print b

```


----------

### リスト操作その3 ###

文字列は`foo.split("/")`で簡単に分割できる    
また、配列は`"-".join(foo)`で連結したりすることが出来る。




----------
### セット（集合型） ###

重複がsetされることはない。  
論理演算が可能  
`^`はNAND


```python
# coding: UTF-8
# file name 14.py
# set type

a = set(["taguchi", "Tom", "dotinstall", "taguchi"])
b = set(["taguchi", "Tom", "sasaki"])

print a

print a - b

print a & b

print a | b

print a ^ b
```



----------
### 辞書型の利用 ###

mapのようなものを作成する  
あとから値の変更も可能  


```python
# coding: UTF-8
# file name 15.py
# dictionary type (key value)


a = {"taguchi":200, "fkoji":300, "dotinstall":500}

print a["fkoji"]

a["fkoji"] = 5000

print a
```

`a.items(), a.keys()`などで内容を表示することができる。

```python 
# coding: UTF-8
# file name 16.py
# dictionary type (key value)

a = {"taguchi":200, "fkoji":300, "dotinstall":500}

print "sasaki" in a

# keys, values, items
print a.keys()
print a.values()
print a.items()
```


----------
### printの応用 ###

NativeCの`printf()`のような表示も可能。  
辞書型を利用するとデータを取り出すことも出来る。

```python
# coding: UTF-8
# file name 17.py
# dictionary type (key value)


a = 10
b = "taguchi"
c = {"taguchi":100, "fkoji":200}

print "my age is %d" % a
print "%5d" %a
print "my name is %s" % b
print "%s is %d years old" % (b, a)
print "%(taguchi)d" % c
```


```python
# coding: UTF-8
# file name 18.py
# if statement

#can use <= >= < > == !=

score = 70

if score >= 80:
  print "pass!"
  print "check"
print "finished check"

```


----------
### if条件を使った処理 ###

`NativeC`のような`if{}`はスペースで行う。  
下記のサンプルコードでは`if`ステートメントに含まれているのは二つ目の`print`までである。  

```python
# coding: UTF-8
# file name 18.py
# if statement

#can use <= >= < > == !=

score = 70

if score >= 80:
  print "pass!"
  print "check"
print "finished check"

```


----------

比較的自由な体裁で`if`文を書くことができる。

```python
# coding: UTF-8
# file name 18.py
# if statement

#can use <= >= < > == !=

score = 70

if score >= 80:
  print "pass!"
  print "check"
else :
  print "not pass!"

print "finished check"

print "pass!" if score >= 80 else "not pass!"

if score >= 80:
  print "OK!"
elif score >= 60:
  print "so so"
else :
  print "oh..."

if 40 < score < 60:
  print "..."
```
  