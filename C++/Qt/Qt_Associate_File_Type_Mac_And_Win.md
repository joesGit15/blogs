## Win Registry

### Question

One day, my boss want me to finish one function which let the users can double click project file(\*.opr) to startup application easy and quickly. oh, This function is very common, Just like double clicked the Microsoft Word Document(\*doc,\*docx), then, we can startup Micrsoft Word Application to edit frich text. Ok, let's do it.

1. Win And Mac OS use the different way to associated file type.
2. Now the App only process one project at same time. if use the double click to open opr file. how to do when opend one project now?
3. Current App mode is single-one mode.

### How

When we get the new task about program, First to think about it. What's i will finish? Did i do it before? How i should to do ? If you think nothing, There is better way to get the answer from internet for you.

I think nothing. But, I know it is associate windows registry in Windows OS and List.Info file In Mac OS. So, I want to know how to finished it use the C++ or Qt. I also searched some documents about how to read/write registry with Qt. I was feel better that time. But when i tried all ways what them said, they are both failed. I spend half of the day, but not working. Their blogs not have the good introduction.

Now, I get the right answer from blogs of cnblogs.com. cnblogs.com is bester web site bout the programe than others.

### Done

I used Qt frame to finished it. if you know `QSettings` classes, it will be very easy, if not, please to see thw Qt help manual about the `QSettings` class at first.

```cpp
/** some include file */
#ifdef Q_OS_WIN
#include <QSettings>
#endif

#ifdef Q_OS_WIN
void checkWinRegistry()
{
    QString val;
    QString exePath = qApp->applicationFilePath();
    exePath.replace("/", "\\");

    QSettings regType("HKEY_CURRENT_USER\\SOFTWARE\\Classes\\.abc",
                                   QSettings::NativeFormat);
    QSettings regIcon("HKEY_CURRENT_USER\\SOFTWARE\\Classes\\.abc\\DefaultIcon",
                                   QSettings::NativeFormat);
    QSettings regShell("HKEY_CURRENT_USER\\SOFTWARE\\Classes\\.abc\\Shell\\Open\\Command",
                                   QSettings::NativeFormat);

    /** . means default value, you can also use the "Default" string */
    if("" != regType.value(".").toString()){
        regType.setValue(".","");
    }

    /** 0 使用当前程序内置图标 */
    val = exePath + ",0";
    if(val != regIcon.value(".").toString()){
        regIcon.setValue(".",val);
    }

    val = exePath + " \"%1\"";
    if(val != regShell.value(".").toString()){
        regShell.setValue(".",val);
    }
}
#endif

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    checkWinRegistry();

    /** if you want to get the file path, please use argv[1], if argc >= 2 */
    QString text;
    text = QString::number(argc);
    text += "\n";
    for(int i=0; i<argc; i++){
        text += QString(argv[i]);///< This way to get the QString may be is unreadable code. eg, include chinese language, we should use `QStringList ltArguments = a.arguments();`
        text += "\n";
    }

    Widget w(text);
    w.show();

    return a.exec();
}
```

### Compared

if you don't clear about my way. Now, you could to see the following images about How to associate file type in QtCreater. we know that double *.pro file, we can startup QtCreater application to programing. How ?

1. In Windows we can use `Ctrl+R` and input `regedit`, `Enter` to open the windows registry editer.
2. Let we find `HKEY_CURRENT_USER\SOFTWARE\Classes\.pro`, you can see what keys and values under this item;
![01.png](http://images2015.cnblogs.com/blog/635602/201705/635602-20170530201351664-790392082.png)
3. Then let we find `HKEY_CURRENT_USER\SOFTWARE\Classes\QtProject.QtCreator.pro`, what keys and values under this item;
![02.png](http://images2015.cnblogs.com/blog/635602/201705/635602-20170530201417633-89332624.png)
4. There are other file type of qt.
![03.png](http://images2015.cnblogs.com/blog/635602/201705/635602-20170530201439664-1248449806.png)

Compared and to finished your work by try and try.


## Associate Aile Aype An Aac As

> [personal Blogs](https://pjw.io/article/2013/06/19/add-icon-for-qt-app-in-mac-os-x/)
> [qt.io](http://doc.qt.io/qt-5/platform-notes-ios.html)
> [stackoverflow](https://stackoverflow.com/questions/16856753/add-entries-to-info-plist-in-qt)
> [Qt Mac Release](http://www.tuicool.com/articles/6zq2ErI)
> [stackoverflow](https://stackoverflow.com/questions/6716200/how-to-open-a-particular-file-with-my-qt-application-on-mac-when-i-double-click)
> [qt.io](http://doc.qt.io/qt-4.8/mac-differences.html)
> [Info.plist Mac](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html)
> [stackoverflow:overriding Mac app file associations via CFBundleDocumentTypes in info.plist](https://stackoverflow.com/questions/26643721/overriding-mac-app-file-associations-via-cfbundledocumenttypes-in-info-plist)


### Reference

> [wikipedia Windows Registry](https://en.m.wikipedia.org/wiki/Windows_Registry)
> [support windows registry](https://support.microsoft.com/en-us/help/256986/windows-registry-information-for-advanced-users)
> [wikipedia Registry cleaner](https://en.m.wikipedia.org/wiki/Registry_cleaner)
> [知乎:为什么Win要有注册表,而Unix其他系统不需要](https://www.zhihu.com/question/20443070)
> [win注册表详解](http://blog.sina.com.cn/s/blog_4d41e2690100q33v.html)
> [c# cnblogs](http://www.cnblogs.com/chenxizhang/p/3256692.html)
> [vc cnblogs](http://www.cnblogs.com/RascallySnake/archive/2013/03/01/2939102.html)
> [Qt Win wiki.qt.io](https://wiki.qt.io/Assigning_a_file_type_to_an_Application_on_Windows)
> [Qt Mac stackoverflow](http://stackoverflow.com/questions/28222787/mac-os-x-file-association-works-but-file-icon-not-changed)
> [Qt Mac csdn](http://bbs.csdn.net/topics/390475911?page=1)
> [Mac And Win csdn](http://blog.csdn.net/esonpo/article/details/8920689)

---
