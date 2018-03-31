### Write to File with C++

```cpp
#include <iostream.h> 
#include <fstream.h> 

int main() 
{ 
    const char *FILENAME = "myfile.txt"; 

    ofstream fout(FILENAME); 

    cout << "Enter your text: "; 
    char str[100]; 
    cin >> str; 
    fout << "here is your text\n"; 
    fout << str << endl; 

    fout.close(); 

    ifstream fin(FILENAME); 
    char ch; 
    while (fin.get(ch)) {
        cout << ch; 
    }
    fin.close(); 

    return 0; 
} 
```

```cpp
#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <functional>
#include <iostream>
#include <iterator>
#include <vector>

using namespace std;

template <class T>
void print(T & c){
    for( typename T::iterator i = c.begin(); i != c.end(); i++ ){
        std::cout << *i << endl;
    }
}

int main()
{
    vector <int> output_data(10);

    generate(output_data.begin(),output_data.end(),rand);
    transform(output_data.begin(),output_data.end(),
            output_data.begin(),bind2nd(modulus<int>(),10));
    print(output_data);

    ofstream out("data.txt");

    if(!out){
        cout << "Couldn't open output file\n";
        return 0;
    }

    copy(output_data.begin(),output_data.end(),ostream_iterator<int>(out,"\n"));
    out.close();

    ifstream in("data.txt");
    if(!in){
        cout << "Couldn't open input file\n";
        return 0;
    }

    vector<int> input_data((istream_iterator<int>(in)),istream_iterator<int>());
    in.close();

    print(input_data);

    return 0;
}
```

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
