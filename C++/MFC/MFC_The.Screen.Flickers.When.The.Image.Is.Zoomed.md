#### 问题描述

当初写MFC也是不情愿的. 既然写了,遇到一些问题. 解决也废了一切功夫.所以简单的记录一下. 这个问题,也就是使用MFC显示图像的时候, 放缩图像的过程中, 图像会一闪一闪的. 这个问题的本质是界面的刷新问题.当初对于MFC的界面刷新是不理解的.所以当初的问题产生的根源, 已经记不清楚了
记得当时是已经采用了双缓冲机制的. 在网上找了很多的文章, 看了好多. 如下:

#### 搜索到的资源

- [csdn](http://bbs.csdn.net/topics/390280791)
- [csdn](http://blog.csdn.net/xjujun/article/details/7833201)
- [cnblogs](http://www.cnblogs.com/renyuan/p/3474802.html)
- [tuicool](http://www.tuicool.com/articles/zuiAru)
- [blog.163](http://blog.163.com/tefei_2008/blog/static/115728004200955102717900/)
- [wenku.baidu](https://www.baidu.com/baidu?tn=monline_3_dg&ie=utf-8&wd=OnEraseBkgnd)

#### 解决方法

对于我的问题, 最终解决方法：添加消息函数：OnEraseBkgnd. 折腾了大半天, 就这样就解决了.

---
