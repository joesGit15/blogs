### How to use mouse to moving windows of not have title bar?

```cpp
#include "widget.h"

#include <QMouseEvent>

Widget::Widget(QWidget *parent)
    : QWidget(parent)
{
    this->setWindowFlags(Qt::FramelessWindowHint);
}

Widget::~Widget()
{

}

void Widget::mousePressEvent(QMouseEvent *event)
{
    QPoint winPt   = this->pos();
    QPoint mousePt = event->globalPos();

    _dtPt = mousePt - winPt;
}

void Widget::mouseMoveEvent(QMouseEvent *event)
{
    this->move(event->globalPos() - _dtPt);
}

```

---
