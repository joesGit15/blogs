### How to Judge Convex Polygons(凸多边形)

#### First: To Determine three points relation

Compute the Area Meter to determine three points relation: clockwise/anticlockwise or collinear 

平面上的三点P1(x1,y1),P2(x2,y2),P3(x3,y3)的面积量：`S(P1,P2,P3) = (x1-x3)*(y2-y3) - (y1-y3)*(x2-x3)`当S为正时P1P2P3逆时针，当S为负时P1P2P3顺时针，当S为0时P1P2P3三点共线。
  
**Notes:**：由于图像坐标的原因，顺时针是指Y->X的旋转方向    

```
-----> X
|
V
Y    
``` 

```
int ComputeThreePointAreaMeter(int x1, int y1, int x2, int y2, int x3, int y3)
{
    return (x1 - x3) * (y2 - y3) - (y1 - y3) * (x2 - x3);    
}
```

#### Second: How to Judge

对于多变性，边数大于2的，都属于多变性。判断多边形为凸多边形的方法，就是以此（按照一个方向）计算每条边的面积量，当所有边的面积量都是相同符号的时候，那么这个多边形就是凸多边形。

对于三角形：一条边和这条边对应的顶点，共有三个点，这时候分别计算每条边的面积量即可。
对于四边形：四边形可以拆分成两个三角形，然后同上计算；
对于五边形：同样是拆分成三角形，即可计算；
...

---
