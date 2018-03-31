### How to restart QtApplication

As we know, Restarting Application means to exit current application, then to call another application.  So, let's see how exit of one application.

#### Qt Application

```
int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    Widget w;
    w.show()
    return app.exec();
}
```

The code snippet,last line `return app.exec()` let Qt application in main event loop. if you want to exit main event loop, Just call` QCoreApplication::exit(int);` or ` QCoreApplication::quit();`

`QApplication` has one property called `quitOnLastWindowClosed`, it means the application will exit after last window closed.

About how to close all windows, we can use ` QApplication::closeAllWindows()`, It is better way for using `quit` to exit application. That way, We can let all windows object revice close event, and do some thing before destroy.

#### Call another Application

In Qt, It is better let `QProcess` to do this. It let another application to run and not has father-son relationship.
```
QProcess::startDetached(qApp->applicationFilePath(), QStringList());
```

if applicationFilePath not continues space char, we can use
```
QProcess::startDetached(qApp->applicationFilePath());
```

#### Example one

```
qApp->quit();
QProcess::startDetached(qApp->applicationFilePath(), QStringList());
```
or
```
qApp->closeAllWindow();
QProcess::startDetached(qApp->applicationFilePath(), QStringList());
```

#### Example two

```
/**773 = 'r'+'e'+'s'+'t'+'a'+'r'+'t' */
qApp->exit(773);
```

```
int main(int argc, char** argv)
{
    int ret = app.exec();
    if (ret == 773) {
        QProcess::startDetached(qApp->applicationFilePath(), QStringList());
        return 0;
    }
    return ret;
}
```


---

