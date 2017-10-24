### Write to File with Qt


#### Write Binary to File with Qt

```cpp

void WriteBinaryToFile(QString binaryStr, QString filePath)
{
    QFile file;
    QByteArray ba;

    QStringList ltStrs = binaryStr.split(' ');
    foreach(QString str,ltStrs) {
        ba.append((char)(str.toInt(0,16) & 0xff));
    }

    file.setFileName(filePath);
    if(!file.open(QIODevice::WriteOnly)){
        return;
    }
    
    file.write(ba);
    file.close();
}
```

#### Write plain Text to File with Qt

```
void WritePlainTextToFile(QString plainText, QString filePath)
{
    QFile file;
    QTextStream out;

    file.setFileName(qsFilePath);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Text)){
        return;
    }

    out.setDevice(&file);
    out << plainText;
    file.close();
}
```

#### Write File with Unicode bom

 ```cpp
#include <QCoreApplication>
#include <QString>
#include <QFile>
#include <QTextStream>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QString str = QString(",QString");
    QFile file;
    QTextStream out;

    file.setFileName("a.txt");
    if(!file.open(QIODevice::WriteOnly|QIODevice::Text)){
        qDebug() << file.errorString();
        return 0;
    }

    out.setDevice(&file);
    out.setCodec("UTF-16");   ///< unicode
    out.setGenerateByteOrderMark(true); ///< with bom
    out << str;
    file.close();
    qDebug() << "OK!";

    return a.exec();
}
```

#### How to check(see) it in vim

``` 
 vim see the file hex: %!xxd
     see the text    : %!xxd -r
```

#### Another way to write file

```
ofstream myfile;
myfile.open("a.txt");
myfile << "\xEF\xBB\xBF"; // UTF-8 BOM
myfile << "\xE2\x98\xBB"; // U+263B
myfile.close();
```


```
ofstream myfile;
myfile.open("a.txt");
myfile << "\xFF\xFE"; // UTF-16 BOM
myfile << "\x3B\x26"; // U+263B
myfile.close();
 ```
 
---