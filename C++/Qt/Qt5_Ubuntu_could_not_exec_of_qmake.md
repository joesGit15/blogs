#### Description

Today, I want to run `qmake` command in terminal, but, it has error message such **qmake: could not exec ‘/usr/lib/x86_64-linux-gnu/qt4/bin/qmake’: No such file or directory"**. I know the system has the wrong search path. But, how to correct it?

#### Ways.

From the [CSDN](blog.csdn.net/zhuquan945/article/details/52818786), He said i should to insert this line content "/home/xxx/Qt5.8.0/5.8/gcc_64/bin" before this file "/usr/lib/x86_64-linux-gnu/qt-default/qtchooser/default.conf". so, i goto the directory and to saw the file. but, it is a link file. it points to "/usr/share/qtchooser/qt4-x86_64-linux-gnu.conf".

If you try to modify the "default.conf" file, the system will tell you can not do that. so, in fact, **you should to modify "qt4-x86_64-linux-gnu.conf" file under /usr/share/qtchooser/.** at the same time, there has "qt5-x86_64-linux-gnu.conf" file under the same directory. they have the same content.

#### other

I also tried to modify .bashrc file, and want to add the `qmake` path to PATH environment variable, but, it not work.

---
