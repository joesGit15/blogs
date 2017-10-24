### Customize QVariant

```
#include <QCoreApplication>
#include <QVariant>
#include <QDebug>

struct Str{
    int num;
    bool flag;
};

Q_DECLARE_METATYPE(Str)

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

#if 0
    Str* pst = new Str;
    pst->num = 13;
    pst->flag = true;
    QVariant var;
    var.setValue(static_cast<void*>(pst));
    void* vptr = var.value<void *>();
    Str* ptr = static_cast<Str*>(vptr);
    qDebug() << ptr->num << "--" << ptr->flag;
    delete ptr;
#else
    Str str;
    str.flag = false;
    str.num = 14;

    QVariant var;
    var.setValue(str);

    Str tmp = var.value<Str>();
    qDebug() << tmp.flag << "--" << tmp.num;
#endif

    return a.exec();
}
```

---