#### 问题起源

在使用Qt框架的时候, 经常发现一些构造函数 `*parent = 0` 这样的代码. 时间长了, 就觉的疑惑了. 一个指针不是等于`NULL`吗? 这样写, 行得通吗? 自己测试一下就可以了.

#### 测试代码

```cpp
#include <iostream>

using namespace std;

int main()
{
    int * npt = 0;

    if( 0 == npt ){
        cout << "npt == 0" << endl; ///< 输出
    }

    if( NULL == npt ){
        cout << "npt == NULL" << endl; ///< 输出
    }

    char * cpt = NULL;

    if( 0 == cpt ){
        cout << "cpt == 0" << endl; ///< 输出
    }

    if( NULL == cpt ){
        cout << "cpt == NULL" << endl; ///< 输出
    }

    return 0;
}
```
#### 调试结果

*npt 0x0 int** 看到,指针的value是个16进制的0.


#### 结果分析

四句if的判断都有输出. 也就是说`0`和`NULL`是没有区别的. 难道NULL这个宏的数值就是0. Qt IDE中的`NULL`宏代码如下:

```javascript
/* A null pointer constant.  */
#if defined (_STDDEF_H) || defined (__need_NULL)
#undef NULL		//in case <stdio.h> has defined it.
#if defined(__GNUG__) && __GNUG__ >= 3
#define NULL __null
#else   //G++
#ifndef __cplusplus
#define NULL ((void *)0)
#else   //C++
#ifndef _WIN64
#define NULL 0
#else
#define NULL 0LL
#endif  //W64
#endif  //C++
#endif  //G++
#endif	//NULL not defined and <stddef.h> or need NULL.
#undef	__need_NULL
```

`NULL` 确实有0这么一说.

#### 权威文档

接着看一下[cplus](http:://cplusplus.com)的null介绍:

> 1. **C**: A null-pointer constant is an integral constant expression that evaluates to zero (like 0 or 0L), or the cast of such value to type void* (like (void*)0).
> 2. **C++98**: A null-pointer constant is an integral constant expression that evaluates to zero (such as 0 or 0L).
> 3. **C++11** : A null-pointer constant is either an integral constant expression that evaluates to zero (such as 0 or 0L), or a value of type nullptr_t (such as nullptr).
>
A null pointer constant can be converted to any pointer type (or pointer-to-member type), which acquires a null pointer value. This is a special value that indicates that the pointer is not pointing to any object

#### 再次疑惑

为什么是0 ? 0有什么特殊含义吗? 什么时候用0? 什么时候用MULL?

#### 路人观点

###### 路人甲

看<高质量C编程>:指针变量的零值是“空” （记为 NULL ） 。尽管 NULL 的值与 0 相同，但是两者意义不同。假设指针变量的名字为 p ，它与零值比较的标准 if 语句如下：

```cpp
if (p == NULL)   // p 与 NULL 显式比较，强调 p 是指针变量
if (p != NULL)  
不要写成
if (p == 0)   //  容易让人误解 p 是整型变量
if (p != 0)  
或者
if (p)      //  容易让人误解 p 是布尔变量
if (!p)  
```

我想说, 我一般不会这样命名...

###### 路人乙

由于c++收紧的类型检查规则，使用普通的0而不是NULL带来的问题会少一点，如果你觉得一定要用NULL，使用

```cpp
const int NULL = 0;
```

0 是任何平台都通用的，而NULL有可能重定义。

实际的情况是 0 是任何平台都通用的，有没有那个系统不把0当保留地址???，而NULL有可能重定义。 类的默认构造函数中需把指针变量初始化，如果写NULL的话必须先在头文件中定义NULL，或是包含相关的库，这就可能带来问题。 c++11,统一为nullptr . 在c语言环境下，由于不存在函数重载等问题，直接将NULL定义为一个void*的指针就可以完美的解决一切问题。但是在c++环境下情况就变得复杂起来， 首先我们不能写这样的代码`FILE* fp = (void*)0;`将void*直接赋值给一个指针是不合法的，编译器会报错。 我们只能这样写代码

```cpp
FILE* fp = (FILE*)0;  
// or  
FILE* fp = 0;  
```
所以在c++下面，NULL就被直接定义为一个整型 0。  在大多数情况下这并不会产生什么问题，但是万一有重载或者模板推导的时候，编译器就无法给出正确结果了。比如下面的情形：
```cpp
void call_back_process(CCObject* target, void* data);  
bind(call_back_process, target, NULL);   // error 函数类型是void* ，但是我们绑定的是一个整型 0   
```

所以 C倾向于NULL, C++倾向于0, 更新的C++倾向与nullptr.

嗯...,也就是说, 分语言考虑了.

###### 路人丙

google提的建议是为了他们自己的需求而设计的, 不同的场合下, 编程规范会不同, 是正常的. 编程规范不是坏东西，反对“教条化”也不是坏事. 但是在反对那些大师的“教条”前先问问自己, 是否明白了那些建议及教条背后的理由？ 自己是否有足够充分的理由不听从对方的建议？ 你在google预设的环境下使用NULL不会出问题, 不代表在其他环境下不会出问题，因为标准沒有给予你任何保证, 但是使用0不会出错却是标准给予的保证. 考虑到可移植性，我会选择0而不是NULL. 虽然使用NULL在大部分环境下都不会出事，但是这毕竟是不被标准支援的行为. 所以c++11又引入了一个关键字－－nullptr. 直接用nullptr就好了，保证安全，而且意义清楚，也方便overload.

```cpp

void f(char const \*ptr); // \*为markdown转义
void f(int v);

f(NULL);  //which function will be called?
f(nullptr); //first function is called
```
很厉害的说服力...

###### 路人丁

C++如果重载int版本和地址版本，实参用NULL总是调用int版本
```cpp
#include <iostream>
void foo(int){}
void foo(int*){}

int main()
{
    foo(0);       ///< foo(int)
    foo(NULL);    ///< foo(int),NG
    foo((int*)0); ///< foo(int*)
    foo(nullptr); ///< foo(int*), C++ 0x
    return 0;
}
```
重载的时候, 需要考虑一下...

#### 我的决定

对于, 婆说婆有理, 每个人都很对. 我的决定是, 问问领导, 问问团队的人员使用的什么. 和自己的开发团队保持一致就可以了. ( 没想到, 本来一个很小的疑惑, 引出来这么多的考虑. 烦死了... )

#### 参考引用
> 1. [博客园 fly1988happy: NULL指针、零指针、野针](http://www.cnblogs.com/fly1988happy/archive/2012/04/16/2452021.html)
> 2. [csdn 论坛](http://bbs.csdn.net/topics/390542598?page=1)
> 3. [国外论坛](http://www.c-faq.com/null/nullor0.html)
> 4. [cplusplus](http://www.cplusplus.com)

---
