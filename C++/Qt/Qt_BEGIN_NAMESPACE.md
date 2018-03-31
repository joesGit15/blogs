#### 问题

阅读Qt的Demo源码的时候,经常在头文件中, 声明类型的部分有以下这样的代码:

```cpp
class MyClassA;    ///< 自定义类的声明

QT_BEGIN_NAMESPACE
class QCheckBox;   ///< Qt内部类的声明
class QComboBox;
QT_END_NAMESPACE
```

这个宏的真实面貌如下:
```cpp
///< 由于现阶段,我看不懂. 所以, 好奇的童鞋, 请在Qt creator中代码部分,直接 F2. 本人就不粘贴代码了.
```

#### 具体作用

> 1. [Qt.io 官方解释](http://wiki.qt.io/Qt_In_Namespace)
> 2. [开源中国博客](https://my.oschina.net/xiangxw/blog/10927)

#### 现阶段理解

这个问题,对于目前我这种小兵来说, 有点难以理解, 暂且挂起, 等待未来的我回来, 在补充...(抱歉,客官)

---
