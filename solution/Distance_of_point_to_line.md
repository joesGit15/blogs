### How to get the distance of one point to line

```
#define TWOPOINTDISTANCE(pt1, pt2) (sqrt((float)(pt1.x() - pt2.x()) * (pt1.x() - pt2.x()) + (pt1.y() - pt2.y()) * (pt1.y() - pt2.y())))

double Line::PtToLineDistance(QPoint pt)
{
    double fRetVar = -1.0;
    double f;
    f = TWOPOINTDISTANCE( p1(), p2() );
    if(f < 1e-10){
        return 1e29;
    }

    //已知三点，求得三边，再利用海伦公式求面积：S=根号下p*(p-a)*(p-b)*(p-c),其中p=(a+b+c)/2.再根据面积算得pt到直线的距离
    fRetVar = 2 * sqrt( (TWOPOINTDISTANCE(pt, p1()) + TWOPOINTDISTANCE(pt, p2()) + TWOPOINTDISTANCE(p1(), p2())) / 2 *
                        ( (TWOPOINTDISTANCE(pt, p1()) + TWOPOINTDISTANCE(pt, p2()) + TWOPOINTDISTANCE(p1(), p2()) ) / 2 - TWOPOINTDISTANCE(pt, p1())) *
                        ( (TWOPOINTDISTANCE(pt, p1()) + TWOPOINTDISTANCE(pt, p2()) + TWOPOINTDISTANCE(p1(), p2()) ) / 2 - TWOPOINTDISTANCE(pt, p2())) *
                        ( (TWOPOINTDISTANCE(pt, p1()) + TWOPOINTDISTANCE(pt, p2()) + TWOPOINTDISTANCE(p1(), p2()) ) / 2 - TWOPOINTDISTANCE(p1(), p2()) )) / f;

    return fRetVar;
}
```

---
