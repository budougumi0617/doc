C++で変数名を取得する。  
実行中に構造体などの変数名を知りたかったため。


```cpp
#include <iostream>
#include <stdio.h>
#include <string.h>

// For get variable name.
#define TO_STRING(VariableName) # VariableName
static const int MAXLENGTH = 256;

typedef struct {
    char charArray[MAXLENGTH];
} FooStructure;

typedef struct {
    int value;
    FooStructure fooSt;
    FooStructure *pFooSt;
} TestMacroStructure;

int main(int argc, char *argv[]) {
    int value = 3;

    // Get variable name
    std::string str = TO_STRING(value);

    // Display variable name.
    std::cout << str << std::endl;
    TestMacroStructure checkMacro;
    std::cout << TO_STRING( nfa_increment_references_msg) << std::endl;
    std::cout << TO_STRING( nfa_increment_references_msg.path ) << std::endl;
    std::cout << TO_STRING( checkMacro.value) << std::endl;
    std::cout << TO_STRING( checkMacro.fooSt) << std::endl;
    std::cout << TO_STRING( checkMacro.fooSt.charArray) << std::endl;
    std::cout << TO_STRING( checkMacro.pFooSt->charArray) << std::endl;


    return 0;
} 
```

make後の出力結果は以下の通り。  

```bsh
budougumi0617@SERVER:~/> ./getVariableName
value
checkMacro.value
checkMacro.fooSt
checkMacro.fooSt.charArray
checkMacro.pFooSt->charArray
```


----------

## 参考URL
**変数名取得マクロ**  
[http://faithandbrave.hateblo.jp/entry/20071116/1195228361](http://faithandbrave.hateblo.jp/entry/20071116/1195228361)
