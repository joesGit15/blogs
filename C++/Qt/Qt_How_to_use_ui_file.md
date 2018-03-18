### Ui Designed file

1. In Working, we can use Qt Designer to designe UI;
2. Then, use `uic -o head.h designe.ui` to create ui_header.h file;
3. When use this Ui, First, include head file, then

```
namespace Ui {
    class Edit: public Ui_Form {};
} // namespace Ui
```

```
    QWidget* wgt = new QWidget(this);
    Ui::Edit* it = new Ui::Edit;
    it->setupUi(wgt);
```

---
