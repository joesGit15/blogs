### Error

Qt Creater:console error:Failed to start program. Path or permissions wrong?

### Description

在使用Qt Creater开发的时候,遇到一个奇怪的问题,产生的应用程序无法在Window都运行调试,错误信息如上.经过一系列的尝试和对比其他工程文件,发现是应用程序的名字有问题.

### Ways

通过对比分析和查看,Qt的pro文件,我们知道pro文件的`TARGET`是应用程序的名字,分析得知:在Window下面,应用程序名字含有`update`不区分大小写的,只要含有这个英文的关键词,应用程序自动就被Window赋予了必须使用管理员权限,才能打开的限制,导致必须输入密码才可以.自己建立一个文本文件,重命名为含有update的可执行程序,就可以验证了.

```
Qt5.7 windows 

pro file:TARGET = XXXupdateXX
```

Window 真是一个弱智的方法.

---

