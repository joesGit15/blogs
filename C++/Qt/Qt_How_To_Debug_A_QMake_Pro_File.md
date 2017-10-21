对于程序代码,我们经常使用到调试. 可是,对于有些项目的配置文件,比如Qt的Pro文件, 一个项目复杂的话,Pro文件就很容易出错. 此时的Pro文件,如果也能调试的话,那么是十分的快捷方便的.

#### 解决方法

对于Qt的Pro文件,设置程序断点,进行调试,是不可能的,毕竟Pro文件,不是代码文件. 可是我们可以输出变量进行输出调试. 这个是可以的. 使用`message()`函数即可.

```pro
message("123")
message("456")
message("234")
```

直接写在配置文件里面即可. 不要使用分号.
如果是变量的话,可以使用如下的方法, 进行输出.


```pro
QT       += core gui

message($$QT_MAJOR_VERSION)

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
```

#### 扩展阅读

1. qmake Manual
2. Build-in Replace Function

---
