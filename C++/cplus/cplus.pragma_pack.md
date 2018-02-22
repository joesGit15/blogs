#### What's the #pragma pack

这是一个预编译宏, 目前我对于它的认识是: **告诉编译器对于某些结构进行字节对齐使用的.** 目前阶段,几乎不使用, 只是见到了, 有疑问, 先简单学习记录一下初步的了解. 大家可以根据自己的环境, 进行实验测试.

#### 我的理解

```cpp
struct test
{
    char c;
    short s1;
    short s2;
    int i;
};
```

就像这个新结构, 如果使用`sizeof`计算类型的空间大小, 应该返回的是多少呢?
天真的理解是: 9 = 1(char) + 2(short) + 2(short) +4(int);

这是错误的. 我记得学习计算机组成原理的时候, 老师在课堂上提到过计算机内存的字节对齐问题, 因为当时是理论课程, 枯燥乏味. 当时只是有疑惑,可是没有深入研究. 今天应该有个所以然了.

实验中的结果是 12 = 1(char) + 3(补齐) + 2(short) + 2(short) + 4(int);

可以这么理解, 一行存放4个字节, 存放三行.

```cpp
1 * * * // char 
1 1 1 1 // short short
1 1 1 1 // int
```

或者

```cpp
1 * 1 1 // char  short
1 1 * * // short
1 1 1 1 // int
```
到底使用哪种方式补齐的, 这个和原理有关了. 感兴趣的童鞋, 可以继续深入.

编译器的默认对齐字节, 有的说是当前结构的类型中字节最大的那个, 也有的说编译器有默认的. 这个需要测试.

如果想确切对齐字节的大小, 就要使用到这个宏了.

天真通过努力, 也是可以实现自己所想的.

```cpp
#include <iostream>
using namespace std;

#pragma pack(1)//手动将对齐方式修改为1，。所以结果9=1+2+2+4

struct test
{
    char c;
    short s1;
    short s2;
    int i;
};

int main()
{
    cout<<"sizeof(test) == "<<sizeof(test)<<endl;
    return 0;
}
```
