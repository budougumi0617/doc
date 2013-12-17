#【Java】デバッグ用にダミーファイルを生成する。


----------

テスト時にわざわざファイルを用意するのが、めんどくさい。  
そんなときはPrintWiterクラスで文字列を流し込んだダミーファイルを用意する。


----------

以下ソースコード


```Java
public static void createFile(String fileName) {
	try {
	file = new File(fileName);
	pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
		pw.println("Today max tmp is ");
		pw.println(10);
		pw.println("test Test file FILE ");
		pw.println("testTestfileFILE");
		pw.println("testTestfileFILE");
		pw.println(".");
		pw.close();
	} catch (IOException e) {
		System.out.println(e);
	}
}
```

