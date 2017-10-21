### Description

How to get vertical line cross one point which out of line in line.

```
QPoint Line::VerticalPoint(QPoint pt)
{
    QPointF ptCross = pt;
    double dtY = static_cast<double>(y1() - y2());
    double dtX = static_cast<double>(x1() - x2());
    double k,b,m;
    /**  0 = kx +b -y;  对应垂线方程为 -x -ky + m = 0;(mm为系数) */
    if(abs(dtX - 0) < 1e-10){
        ptCross = QPointF(x1(),pt.y());
        goto _END;
    }

    if(abs(dtY - 0) < 1e-10){
        ptCross = QPointF(pt.x(),y1());
        goto _END;
    }

    k = dtY/dtX;
    b = (y1()-k*x1());
    m = pt.x() + k*pt.y();

    ptCross.setX((m-k*b)/(k*k + 1));
    ptCross.setY(k*ptCross.x()+b);

_END:
    return ptCross.toPoint();
}
#endif
```
---
