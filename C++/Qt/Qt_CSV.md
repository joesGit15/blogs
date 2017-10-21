This page discusses various available options for working with csv documents in your Qt application. Please also read the general considerations outlined on the Handling Document Formats page.

#### Using QxtCsvModel

###### intro

The QxtCsvModel class provides a QAbstractTableModel for CSV Files. This is perhaps the easiest way possible to read and write csv files without having to parse the csv format to something qt can understand. It's as simple as using one line of code, for example the following reads the csv file:

```cpp
csvmodel->setSource(fileName);
```

###### Building libqxt

QxtCsvModel is a part of libqxt so just to use QxtCsvModel you'll need to build this library. It won't be that hard. instructions(指令) are all provided. However, the download link that they provide in their main page does not support Qt 5 as of this writing (23 April 2013). You'll need to go to the downloads page, select the "branches" tab and download the zip file of the master branch.

A novice-friendly(新手朋友) step-by-step guide to building and getting libqxt to work can be found here. The following example will be using the build as done in that guide.

###### Example: Mini csv Program

Mini csv program is built with Qt 5.0.2 MinGW, but should probably work with Qt 4. Download from here . The only thing you would need to do to get it working is fix the links to the dynamic library. I built it in C:/Qt/libqxt-libqxt-Qt5/ so I directed it there. Below is a snipet of the project file:

```cpp
win32:CONFIG (release, debug|release): LIBS ''= -LC:/Qt/libqxt-Qt5/lib/ -lqxtcore
else:win32:CONFIG (debug, debug|release): LIBS''= -LC:/Qt/libqxt-Qt5/lib/ -lqxtcore
 
INCLUDEPATH ''= C:/Qt/libqxt-Qt5/src/core
DEPENDPATH''= C:/Qt/libqxt-Qt5/src/core
Well, you're also suppose to add the following lines to your qmake project file:

 CONFIG ''= qxt
 QXT''= core gui
…but it doesn't seem to make much of a difference here… or any of the examples I've tried…
```

I can now call the class like so:

```cpp
#include <QxtCsvModel>
```
The functionality provided is very very basic. If you wish to probe deeper to what this class can do, check the QxtCsvModel documentation .

CSV reader from QtSimplify(Read CSV Only)

[not to access](http://qtsimplify.blogspot.com/2013/02/dealing-with-csv-files-easy-way.html)

#### Reference

> [qtwiki](http://wiki.qt.io/Handling_CSV)
> [github](https://github.com/iamantony/qtcsv)
> [stackoverflow](http://stackoverflow.com/questions/22802491/create-csv-file-in-c-in-qt)
> [wikipedia](https://en.wikipedia.org/wiki/Comma-separated_values)

---
