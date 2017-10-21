#### 需求说明

客户端接收到服务器传送过来的图像数据,客户端通过对图像进行旋转和反转操作. 然后把这个旋转和反转的数据上传到服务器. 客户端在接收图像的时候, 也会下载以前的旋转和反转参数, 然后客户端根据这些数据对图形自动进行旋转和反转. 这是一个图像的矫正问题. 有大量的图像, 图像的有可能是旋转的,反转的.使用之前需要旋正和反正.

#### 问题分析

初步分析,感觉很简单. 我只要记录旋转角度和反转状态,上传到服务器, 然后下载,根据参数做变化. 不知道你考虑到 **旋转和反转的顺序问题木有?**, 对于一张图像, **先旋转,后反转 和 先反转,后旋转**是不同的. 还需要考虑的是, 把这2类型的参数上传到服务器, 下次, 下载的时候, 我是先用旋转参数好呢? 还是先用反转参数呢?  一些问题是存在数学规律的, 找到规律就可以迎刃而解.

旋转分为 顺时针和逆时针, 每次90度. 顺时针则+90, 逆时针则-90
反转分为 水平反转和垂直反转, 以及不反转 3种状态, 我们使用枚举类型 H_FILP,V_FLIP, NO_FLIP

对于反转, 我们得到如下规律:
1. 同一方向翻转两次, 相当于没有翻转, 也就是 水平反转2次,等于没有反转. 垂直相同.
2. 两次不同的翻转,相当于图像旋转180度. 也就是, 水平反转一次, 然后垂直反转一次, 等价于图像(顺时针)旋转了180度
3. 当上一次没有旋转的时候, 这一次是H,就是H,是V就是V.

对于旋转, 我们得到如下规律:
1. 分为顺时针(左旋), 逆时针(右旋), 每次旋转分为90度.
2. 旋转的时候, 如果存在翻转, 那么翻转的方向就要改变.

#### 伪代码实现

```cpp

/** 反转状态 */
enum FLIP_STATE
{
    NO_FLIP = 0,    ///< 没有反转
    H_FLIP,         ///< 水平反转
    V_FLIP          ///< 垂直反转
};

/** 主要使用的变量(可以是类的成员变量) */
int m_nOldRotate;           ///< Old 纪录初始旋转的参数,图像顺时针旋转0,90,180,270, 用于旋转和翻转的还原
FLIP_STATE m_oldFlipState;
int m_nRotate;              ///< 记录旋转的参数,图像顺时针旋转0,90,180,270
FLIP_STATE m_flipState;

m_imShowData:   就来图像的信息类的对象

/** 水平反转事件 */
void OnHorFlip()
{
    /** 反转前 */

    /** 如果上一次状态是没有反转, 那么就把反转状态设置为水平反转 */
    if ( NO_FLIP == m_imShowData.m_flipState     ){m_imShowData.m_flipState = H_FLIP;}

    /** 如果上一次状态是水平反转, 那么2次水平反转, 就是没有反转 */
    else if ( H_FLIP == m_imShowData.m_flipState ){m_imShowData.m_flipState = NO_FLIP;}

    /** 如果上一次状态是垂直反转, 也就是上一次是垂直,这次我要水平了, 那么两次不同方向的反转,
     等价于 旋转180度, 反转设置为没有反转 */
    else if ( V_FLIP == m_imShowData.m_flipState )
    {
        m_imShowData.m_nRotate = (m_imShowData.m_nRotate + 180) % 360;
        m_imShowData.m_flipState = NO_FLIP;
    }

    /** 将图像水平旋转 */
    OperateImage(HOR_FLIP);
}

/** 垂直反转事件 */
void OnVerFlip()
{
    /** 垂直反转和水平是类似的逻辑, 请自行思考. */
    if ( NO_FLIP == m_imShowData.m_flipState     ){m_imShowData.m_flipState = V_FLIP;}
    else if ( V_FLIP == m_imShowData.m_flipState ){m_imShowData.m_flipState = NO_FLIP;}
    else if ( H_FLIP == m_imShowData.m_flipState )
    {
        m_imShowData.m_nRotate = (m_imShowData.m_nRotate + 180) % 360;
        m_imShowData.m_flipState = NO_FLIP;
    }
    OperateImage(VER_FLIP);
}

/** 逆时针旋转事件 */
void OnLRotate() 
{
    if ( m_imShowData.m_flipState != NO_FLIP )
    {
        m_imShowData.m_flipState = (m_imShowData.m_flipState == H_FLIP) ? V_FLIP : H_FLIP;
    }
    m_imShowData.m_nRotate = (m_imShowData.m_nRotate - 90) % (-360);
    OperateImage(LEFT_ROTATE);
}

/** 顺时针旋转事件 */
void OnRRotate() 
{
    /** 如果存在反转, 则反之方向,要发生变化 */
    if ( m_imShowData.m_flipState != NO_FLIP )
    {
        m_imShowData.m_flipState = (m_imShowData.m_flipState == H_FLIP) ? V_FLIP : H_FLIP;
    }
    /** 旋转参数累加, 不做解释 */
    m_imShowData.m_nRotate = (m_imShowData.m_nRotate + 90) % 360;
    OperateImage(RIGHT_ROTATE);
}

/** 
此函数只用于从引擎获得旋转和翻转数据以后,对原始图像进行调整使用:
获得的 旋转和翻转两个参数, 先旋转后翻转和先翻转后旋转着两种情况是不一样的.
经过测试, 应该先旋转后翻转.
*/
void SetImgRotateFlip( ImgShowData &img )
{
    int nTimes = img.m_nRotate / 90;
    while(nTimes > 0)
    {
        OperateImage(RIGHT_ROTATE);
        nTimes--;
    }

    if( img.m_flipState == H_FLIP ){OperateImage(HOR_FLIP);}
    else if( img.m_flipState == V_FLIP ){OperateImage(VER_FLIP);}
}

/** 还原很简单, 重新赋值, 调用上面的函数即可 */
void OnRevert()
{
    m_imShowData.m_nRotate = m_imShowData.m_nOldRotate;
    m_imShowData.m_flipState = m_imShowData.m_oldFlipState;
    SetImgRotateFlip(m_imShowData);
}

/*
 * 最后说一下,上传, 直接上传参数数值即可. 只是,服务器对于旋转存储的都是顺时针的数值, 也就是0,90,180,270. 
 * 客户端,因为存在逆时针, 所以,最后需要把逆时针的数值, 转化到顺时针, 即,逆时针的补角即可.
 */
```

#### 小结

在一个坑蹲的时间长了. 这块儿地方, 才会被你改变.

---


