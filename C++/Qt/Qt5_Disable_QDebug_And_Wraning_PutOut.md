# Qt Disable QDebug And Warning Output

### 如何禁止qDebug的输出

在项目开发的过程中,为了开发方便,我们常常在Qt的Application Output中输出一些内容,慢慢的. 有些qDebug就会被我们遗忘再角落里. 虽然对整个程序影响不大. 但是强迫症的我们,总是很不爽. 下面分享一些方法, 来进行qDebug的屏蔽输出.

### 具体实现

```bash
# 在pro文件中,加入如下代码

DEFINES += QT_NO_WARNING_OUTPUT # 屏蔽警告输出
DEFINES += QT_NO_DEBUG_OUTPUT   # 屏蔽qDebug输出

```
**然后** 一定要 **rebuild all**, 一定要 **rebuild all**, 一定要 **rebuild all**

### 其他扩展阅读

- qmake Manual

### 参考引用

> [163.blog](http://blog.163.com/qimo601@126/blog/static/15822093201332415344103/)
> [亦可追寻](http://www.cnblogs.com/yikezhuixun/p/6061024.html)
