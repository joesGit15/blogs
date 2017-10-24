### Division of Line Segment

```
/**  */
void Line::EqualDivision(int nCount, QLineF fline, QList<QPointF> *ltPts)
{
    Q_ASSERT(0 != ltPts);
    QPointF p1,p2;
    float x,y,xStep,yStep,nStepLen;

    ltPts->clear();
    if(nCount<=1){
        return;
    }

    p1 = fline.p1();
    p2 = fline.p2();
    if(p1.x() == p2.x() && p1.y() == p2.y()){
        return;
    }

    nStepLen = fline.length()/nCount;
    for(int i=1; i<nCount; i++){
        x = (i*nStepLen*p2.x() + (nCount-i)*nStepLen*p1.x())/fline.length();
        y = (i*nStepLen*p2.y() + (nCount-i)*nStepLen*p1.y())/fline.length();
        ltPts->append(QPointF(x,y));
    }
}
```

### Reference

> [math-only-math.com](http://www.math-only-math.com/division-of-line-segment.html)

---