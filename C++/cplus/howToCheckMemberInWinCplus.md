#### 实例说明

下面这个实例代码, 快速举例了在Win32应用程序下,对于内存的泄漏检查. 其中的原理,目前本人还是不太的理解. 只是记录了使用方法. 以后,看情况,会更新的.

```cpp

#ifdef _WIN32

    #define _ENABLE_MY_MEMLEAK_CHECK 

    #include <crtdbg.h>
    #include <afxdlgs.h>

    inline void EnableMemLeakCheck()
    {
        _CrtSetDbgFlag(_CrtSetDbgFlag(_CRTDBG_REPORT_FLAG) | _CRTDBG_LEAK_CHECK_DF);
    }

#else

    #undef _ENABLE_MY_MEMLEAK_CHECK

#endif 

#include <stdio.h>
#include <stdlib.h>

int main(int argc,char **argv)
{

#ifdef _ENABLE_MY_MEMLEAK_CHECK
    EnableMemLeakCheck();       /** 先使这一句执行,如果有内存遗漏的情况,那么在VS,IDE输出的部分, 会有数字的输出 */
    //_CrtSetBreakAlloc(560);   /** 然后,注释上面的一句代码, 执行这一句代码. 把对应的数字填写进去, 就可以定位内存的遗漏了. */
#endif

    char *pszOne = NULL;
    char *pszTwo = NULL;
    pszOne = (char *)malloc( sizeof(char) * 100 );
    if ( NULL == pszOne );
    //error;
    pszTwo = (char *)malloc( sizeof(char) * 100 );
    if ( NULL == pszTwo );
    //error;
    free(pszTwo);
    printf("OK!\n");
    return 0;
}
```

#### 方法总结

方法都有不足的. 这种方法好像只能在Win平台下的VS中使用. 方法不可能十分的精确. 最保险的还是写代码的时候,认真一些.
