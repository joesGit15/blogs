### QRegExp-url

```cpp
void Class::Fun(QString content)
{
    int i,j,pos = 0;
    QString str;
    QStringList ltUrls;
    int nMinLen = INT_MAX;

    QString tailerPattern = "[^a-zA-Z0-9-._/?=&]";
    QString pattern = "(ht|f)tp(s?)://(([a-zA-Z0-9-._]+(.[a-zA-Z0-9-._]+)+)|localhost)(/?)([a-zA-Z0-9-.?,'/\\+&%$#_]*)?([\\d\\w./%+-=&?:\"',|~;]*)" + tailerPattern;

    QRegExp rx_Tailer(tailerPattern);
    QRegExp rx(pattern);

    rx.setMinimal(true);

    content += " "; ///< add empty place in last position
    pos = 0; ltUrls.clear();
    for (i = 0; (pos = rx.indexIn(content, pos)) != -1; i++){
        str = rx.cap();
        pos += str.length();
        if(rx_Tailer.indexIn(str, str.length() - 1) != -1){
            str.truncate(str.length() - 1);
        }
        ltUrls << str;
    }

    /** 移除重复的内容, 便于后面的替换 */
    for(i=0; i < ltUrls.count(); i++) {
        for(j=i+1; j < ltUrls.count();) {
            if( ltUrls.at(i) == ltUrls.at(j) )
                ltUrls.removeAt(j);
            else
                j++;
        }
    }

    /** 先替换短的字符串, 防止长的包含短的,重复替换 */
    while( ltUrls.count() > 0 ) {
        j = 0; nMinLen = INT_MAX;
        for(i=j; i < ltUrls.count(); i++) {
            str = ltUrls.at(i);
            if( str.length() < nMinLen ) {
                j = i;
                nMinLen = str.length();
            }
        }

        str = ltUrls.at(j);
        ltUrls.removeAt(j);
        content.replace(str, QString("<a href=\"%1\">%1</a>").arg(str));
    }

    content.remove(content.length()-1, 1); ///< remove last empty space
    ui->textBrowser->setText(content);
}
```
---

