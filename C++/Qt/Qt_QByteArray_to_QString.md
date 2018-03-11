### QByteArray => QString

```cpp
void BarEngine::ByteArrayToString(QByteArray &ba, QString &str)
{
    int i = 0;
    int nCount = ba.count();
    QByteArray bb;
    for(i=0; i < nCount; i++) {
        bb.append( ba.at(i) | 0x0000 );
    }

    str.clear();
    nCount = bb.count();
    for(i=0; i < nCount;) {
        if( bb.at(i) < 0x00a1 ) {
            str += QChar(bb.at(i)); i++; continue;
        } else {
            if( i+1 >= nCount ) {
                //最后一个字节没有配对儿的
                Q_ASSERT(1 == 2);
            } else {
                if( bb.at(i+1) > 0x00a0 ) {
                    str += QChar( ( bb.at(i) << 8 | bb.at(i+1) ) );
                    i = i+2;
                } else {
                    //缺少一个字节进行配对儿
                    Q_ASSERT( 1==2 );
                }
            }
        }
    }
}
```

---

