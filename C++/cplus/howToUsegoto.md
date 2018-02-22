看到,网上很多人对于goto的询问, 因为本身在工作中经常使用到,所以写下此文, 如有错误, 请指出.

本人写博文的时候主要从事C++工作

对于`goto`的态度,本人目前成长如下:

#### 学生时代 

老师课堂上说,goto语句容易把程序的顺序逻辑结构扰乱. 由于是学生, 所以你懂的. 听老师的, 而且自己网上看了, 多数人也是反对使用goto的.*备注:*学生时代, 你也懂的, 根本没有考虑工程性. 很少使用goto, 也没有goto发挥的余地.

#### 我的师傅

工作以后的,第一位师傅, 三星十年C语言图像算法工程师. 教育我说, 要学会在程序中使用goto. 不理解, 和她讨论了以前老师的一些想法.她当时举例大概如下:

```cpp

#define FREE(p) {if(NULL!=(p){free(p);(p)=NULL;}}

void fun()
{
    int *p = NULL;
    int *p1 = NULL;
    int *p2 = NULL;
    
    p = (int *)malloc(sizeof(int) * 10);
    if( NULL == p ){goto _END;}
    p1 = (int *)malloc(sizeof(int) * 10);
    if( NULL == p1 ){goto _END;}
    p2 = (int *)malloc(sizeof(int) * 10);
    if( NULL == p2 ){goto _END;}
    
_END:
    FREE(p);
    FREE(p1);
    FREE(p2);
}
``` 

当时,我也没有太理解. 目前理解了. 师傅是C语言,经常和内存打交道. 师傅当时的解释:对比上下代码

```cpp

#define FREE(p) {if(NULL!=(p){free(p);(p)=NULL;}}

void fun()
{
    int *p = NULL;
    int *p1 = NULL;
    int *p2 = NULL;
    
    p = (int *)malloc(sizeof(int) * 10);
    if( NULL == p )
    {
        return;
    }
    p1 = (int *)malloc(sizeof(int) * 10);
    if( NULL == p1 )
    {
        FREE(p);
        return;
    }
    p2 = (int *)malloc(sizeof(int) * 10);
    if( NULL == p2 )
    {
       FREE(p);
       FREE(p1);
       return;
    }
    
    /*...*/
}

```

也许你会认为这只是几个malloc, 你太天真了. 其实对于她们C开发, 有的时候, 函数体会很长, 而期间有一些函数会出错, 对于出错了, 怎么办? 使用goto, 来协定一个错误处理机制, 错误的处理, 也就是例子中内存的回收,统一放在函数的尾部, 不容易遗漏. 一旦某个地方出错了, 直接返回尾部即可.这是在调用malloc函数的时候, 其实, 自己写的函数, 也并不一定总是返回正确的结果. 那么如果函数一层一层嵌套的比较深了, 一个统一的错误处理机制是非常重要的, 尤其是在团队开发的时候. 目前,我所在的团队, 都是按照这个标准. 我们团队函数的基本模型如下:

```cpp

int foo(int *p)
{
    int nRet = -1;

    /** goto _END;  */

    if( 0 > foo1() ){goto _END;}

    nRet = 1;//只有当程序运行到底部,这里的时候, 这个函数才属于正常的运行完毕, 中间有任何的错误, 就会goto跳过这一步.
_END:
    return nRet;
}


//那么,我们来一次深层嵌套

int main()
{
    int nRet = -1;

    if( 0 > foo() ){goto _END;}

_END:
    return nRet;
}

```

我这里仅仅采用了三层函数嵌套, 其实试想一下, 往往开发中, 我们会发现, 函数嵌套, 会在不知不觉中, 让我们都蛋疼的事情.

#### 我的使用

师傅是C语言, 当时列举的例子是和内存相关的. 而我工作中主要是C++, 我们知道C++有new 和 delete, 这两个函数是相对于C的malloc 是比较安全. 由于目光短浅, 师傅的强制要求, 自己心里还有些不爽, 甚至和师傅进行了一次激烈的讨论. 因为我没有按照师傅的来. 师傅在检查我代码的时候, 批评了好几次. 拿自己的天真挑战师傅的经验. 肯定是失败的.

在慢慢的使用过程中, 我才体会到goto的强大魅力.有的时候,我们在程序中, 会有这样的逻辑.

```cpp

int foo()
{
    if( 条件1  )
    {
        if( 条件2  )
        {
            if( 条件3 )
            {
                /** ...  */
            }
        }
        else if( 条件4 )
        {

        }else
        {
            /**...*/
        }
    }
    else if( 条件4 )
    {
        /**...*/
    }
}

```

对于这样的程序逻辑, 你觉得可读性很强吗? 对于程序中的if else, 我是可笑又可恨, 我记得有些人甚至批判过if else, 能把你的思路绕晕了. if else的深层嵌套, 在goto这里, 可以优化成一层, 将其扁平化处理

```cpp
int foo()
{
    int nRet = -1;

    if( 条件1 )
    {
        /** do some thing */
        goto _OK;
    }

    if( 条件2 )
    {
        /** do some thing */
        goto _FAILED
    }

    if( 条件3 )
    {
        /** do some thing */
        goto _OK;
    }

    if( 条件4 )
    {
        /** do some thing */
        goto _OK;
    }

_OK:
    nRet = 1;

_FAILED:
    return nRet;
}
```
上下两部分不能完全对应, 我只是举个例子.也就是说, goto可以处理复杂的if else.

#### 使用goto注意事项

上面两个goto例子, 一个是师傅经常使用的, 一个是我慢慢体会到的. 当然了,师傅在上.goto很灵活, 会用的人, 能把goto的威力发挥出来, 就想只有孙悟空才可以发挥金箍棒的威力一样. 使用过程中, 需注意如下:

1. 细心的应该发现, 我们所使用的地方,都是在一个函数内部.也就是说, goto, 只在函数内部,** 千万千万千万别goto到其他函数内部. **
2. 使用goto, 编译器有时候, 会报出变量定义问题. 在一个代码作用域中, 所有变量的声明定义必须在第一个goto的前面. 我们团队一般要求,统一函数头部. 注意作用域的理解.

```cpp
int foo()
{
    int nRet = -1;

    if( 条件1 )
    {
        /** do some thing */
        goto _OK;
    }

    int num;//报错, 应该移动到前面
    if( 条件2 )
    {
        /** do some thing */
        goto _FAILED
    }

    if( 条件3 )
    {
        int num3;//不报错, 因为在{}这个作用域, 是在goto的前面
        /** do some thing */
        goto _OK;
    }

    if( 条件4 )
    {
        /** do some thing */
        goto _OK;
    }

_OK:
    nRet = 1;

_FAILED:
    return nRet;

```

#### 坚定使用goto

体会到了goto的魅力, 我还没有坚定我的信念,知道我碰到了一些远古级别的代码的时候, 我笑了, 他们也在使用goto.

#### 自我评鉴goto

这个世界上, 总是存在这么一个现象, 有人说好, 必定有人说坏. 说好的人能列举一大堆好的例子, 不好的依然. 对于goto,我想说, 会用的, 把他用好, 不会用的. 可以使用自己认为好的方法. 方法有很多, 我们的目的只有一个, 写出安全的代码, 和清晰的程序逻辑. 只要能达到这个目标, 什么方法都可以.

### goto使用总结

1. 团队开发协定函数的错误反馈机制
2. goto处理if else的多层嵌套, 将其扁平化处理.

---
