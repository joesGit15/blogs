#### 界面布局

起初,计算机的交互是通过输入的代码进行的, 慢慢的有了图形之后, 就开始了图形界面的交互. 目前来说还有语音交互, 视频交互等多媒体的交互. 不管哪一种交互, 最终在计算机的角度都是信号的输入和信号的输出.计算机只明白01这样的二进制的信号.

#### Qt界面布局

对于Qt来说, Qt专门有布局系统`Layout Management`, 布局系统里面包含了各种各样的布局类, 适用于多种多样的布局需求, 基本有:`QBoxLayout, QButtonLayout, QFormLayout, QGraphicsAnchor, QGraphicsAnchortLayout, QGridLayout, QGroupBox, QHBoxLayout, QLayout, QLayoutItem, QSizePolicy, QSpacertItem, QStackedWidget, QVBoxLayout, QWidgetItem`. 这里我不进行详细的使用说明了. 可以通过Qt的帮助文档进行了解. 很丰富的布局类, 虽然很多, 可是20%的类, 已经基本可以代替80%的布局需求了. 当然,这些类使用起来也是非常的便捷的.

#### MFC界面布局

对于MFC来说, 最基本的布局, 就是在设计的时候,把窗体固定大小, 然后,控件摆放到具体位置.这是最简单的. 如果窗体大小变化的话.那么控件就要动态的变换大小了.关于这样的需求, 就要使用一个第三方的布局宏,来控制.对,是第三方的.MFC没有关于这方面的布局类.也许这就是他已经老的原因吧.有很多的东西已经老了.就我看来,MFC基本已经不适合现在的社会软件的发展了.

#### Qt 和 MFC 的对比

一个是随着时代在发展, Qt的宗旨是 统一所有的设备. 而MFC已经老了, 而且只能在win上面. 不是我这个花花公子所喜欢的. 不多说了, 请参考下面的链接.

> [MFC EASYSIZE 使用](http://blog.csdn.net/arcsinsin/article/details/16413017)
> [MFC EASYSIZE 使用](http://blog.163.com/weidao_xue/blog/static/204541046201221613010199/)
> [EasySize 发源地](https://www.codeproject.com/articles/1657/easysize-dialog-resizing-in-no-time)

---
