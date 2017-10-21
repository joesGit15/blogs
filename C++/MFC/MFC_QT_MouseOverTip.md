#### Qt鼠标提示分析说明

    关于鼠标停留在控件上面,显示提示内容的方法. 对于Qt来说, Qt的某一个控件类, 如果属于GUI的, 那么这个控件类会有一个`setToolTip(QString text)`的方法. 顾名思义, 这个方法就是设置鼠标停留显示内容的.也可能一开始, 我就接触的Qt, 觉得这个方法很人性化. 感觉也是非常符合设计常理的.

#### MFC鼠标提示分析说明

    可是,当我了解到MFC的时候, MFC框架却是提供了一个专门的`CToolTipCtrl`类, 来统一管理鼠标的提示.按照MFC的思想, 它把鼠标提示的任务, 规划在了单独的一个模块儿中. 用的时候,感觉还是灰常的别扭的.如果哪个控件想显示鼠标提示内容, 那么通过调用这个类的方法, 把自己的ID和想要显示的内容, 设置给这个类.
#### QT And MFC 对比分析

    同一个功能需求, 同一个设计语言. 不同的框架, 会采用不同的设计理念, 不同的设计方法.
    
    对于以上2个框架的设计差别. Qt把这个功能通过一个方法, 渗透进每一个GUI的类里面. 如果, 这个类的一个对象想实现这个功能, 那么直接通过对象调用这个方法,即可. 也就是说, 通过Qt, 实现这个功能, 不用考虑这个功能会不会破坏我的模块儿. 因为没有其他东西的加入. 都是属于控件类自己的东西. 添加修改不影响其他地方, 所以不必担心会不会破坏现有的应用程序的模块儿.至少在这一点上面, 我觉得是优势所在.即使Qt 自己也有一个`QToolTip`的类, 但是该类的功能是设计鼠标提示的样式的.一般鼠标提示都属于跟随系统的默认样式, 不会使用到这个类.

    那么再来思考MFC, MFC是单独提供了一个`CToolTipCtrl`类来管理所有的鼠标提示.这是什么思想? 在我看来,这是一种系统思想.站在系统的角度, 鼠标提示, 这是一个模块儿, 我要使用一个模块儿, 来管理所有需要鼠标提示的部分. 在使用MFC的解决方法的时候, 我需要考虑, 这个`CToolTipCtrl`类的对象, 放在哪里? 如果其他模块也使用了这个类, 我是否需要把指针传递到这个模块儿. 如果,有多个这样对象, 也是可以的吗?总之, 使用MFC的时候, 它让我考虑了很多东西. 虽然说, 这个类不复杂, 但是, 我在只想实现某个功能的时候, Qt给我了一个对象的方法, 而MFC给我了一个类, 你说, 是了解自己的方法快一些, 还是了解一个类快一些?

#### 代码实现

    通过对比分析, 我是比较倾向于Qt的这种自我的设计思想. 这也体现了Qt的优雅和简洁.

##### Qt实现鼠标提示
    
    直接通过对象调用`setToolTip(QString text)`的方法即可, 如果想美化样式, 可以查看`QToolTip`的类说明.如此的简洁优雅.

##### MFC显示鼠标提示

    这个方法是网上他人的, 本人确实没有系统的学习MFC, 只是基础而已.上面的分析, 如果错误,还请留言指正.

```cpp
CToolTipCtrl    m_Mytip;    ///< 对话框对应的类中添加对象

/** OnInitDialog 函数中 */
m_Mytip.Create(this);
m_Mytip.AddTool( GetDlgItem(IDC_BUTTON0), "tool tip text" ); 
m_Mytip.AddTool( GetDlgItem(IDC_BUTTON1), "tool tip text" ); 
m_Mytip.AddTool( GetDlgItem(IDC_BUTTON2), "tool tip text" ); 
m_Mytip.SetDelayTime(200);                  //设置延迟
m_Mytip.SetTipTextColor( RGB(0,0,255) );    //设置提示文本的颜色
m_Mytip.SetTipBkColor( RGB(255,255,255));   //设置提示框的背景颜色
m_Mytip.Activate(TRUE);                     //设置是否启用提示

/** 然后在类向导中添加PreTranslateMessage消息响应函数 */
BOOL CXXXDlg::PreTranslateMessage(MSG* pMsg)
{
// TODO: Add your specialized code here and/or call the base class
  if(pMsg->message==WM_MOUSEMOVE)
  m_Mytip.RelayEvent(pMsg);
return CDialog::PreTranslateMessage(pMsg);
}
```

    (⊙o⊙)…, 我怎么感觉这么复杂...

#### 总结

    对于Qt来说, 我觉得Qt把常用的功能封装的十分的简洁. 如果要是想实现复杂的功能, 还是需要一番功夫的. 而MFC是吧简单的和复杂的统一在一起了. 就单纯这个鼠标提示来说. 两者的差距还是很大的.我个人还是倾向于Qt.
