### Qt4 设置应用程序图标

1. 将一个ico图标放在资源文件夹下;
2. 然后建立txt，输入 `IDI_ICON1 DISCARABLE “myico.ico”`;
3. 保存文件,将其后缀改为.rc;
4. 然后，在项目目录pro的文件里加入 `RC_FILE += myico.rc`;

直接运行程序，这样MainWindows窗口图标的左上角的图标和debug里面的可执行程序的图标就变了。我的天啊,这是要累死人的节奏.

### Qt5 Win 设置应用程序图标 

1. 将一个ico图标放在资源文件夹下,假设取名:**myApp.ico**
2. pro的文件里加入 `RC_ICONS = myiApp.ico`;

直接运行程序，这样MainWindows窗口图标的左上角的图标和debug里面的可执行程序的图标就变了。我的天啊,步骤少了一半儿啊.

### Qt5 Mac Setting Application Icon

Qt Help manual hot key `Setting Application Icon` include win,mac,linux.

In Mac, 

1. Download ico file;
2. Using Mac App tool `IconKit` to create all size icon files in `app.iconset` folder(you can rename it);
3. Using Mac command tool `iconutil -c icns app.iconset` to create app.icns file;
4. Adding `ICON = app.icns` to `pro` file;
5. Removing debug folder and to rebuilding project. 

That is all.

#### 附加问题描述

这是刚接触Qt的时候,遇到的一个小问题,如下:

同学编写的小程序里，建立了资源文件夹，并在里面加入了（ico,png图片）而且在MainWindows窗口属性的windowsIcon的属性里，设置了图片。本以为这样就可以设置debug里面的exe的应用程序的图标。但是，现实的情况是，程序里面的图标变了，但debug里面的没有变。

#### 解决方法：

通过我们的多次尝试，这个问题算是初步解决了。

- 我们怀疑是设置冲突问题，也就是说资源文件和独自创建的ico冲突了。所以，我们把资源文件删除了.使用【】里面的方式设置，成功。
- 然后我们又把资源文件加上，而那个ico文件没有加入。重新构建，成功。

### How to set Qt Application Icon in Linux

you can to read below links and reference.

1. Setting Application in linux, Qt Help manual keyword `Setting Application Icon`
2. [Desktop Entry](https://specifications.freedesktop.org/desktop-entry-spec/latest/index.html)
3. [Icon theme](https://www.freedesktop.org/wiki/Specifications/icon-theme-spec/)

#### In my Ubuntu

we can to see how the QtCreater to set the application icon.

```
/home/joe/.local/share/applications/DigiaQt-qtcreator-community.desktop
/home/joe/.local/share/icons/hicolor
tree .
.
├── 128x128
│   └── apps
│       └── QtProject-qtcreator.png
├── 16x16
│   └── apps
│       └── QtProject-qtcreator.png
├── 24x24
│   └── apps
│       └── QtProject-qtcreator.png
├── 256x256
│   └── apps
│       └── QtProject-qtcreator.png
├── 32x32
│   └── apps
│       └── QtProject-qtcreator.png
├── 48x48
│   └── apps
│       └── QtProject-qtcreator.png
├── 512x512
│   └── apps
│       └── QtProject-qtcreator.png
└── 64x64
    └── apps
        └── QtProject-qtcreator.png
```

or

```
/usr/share/applications/     /** has many desktop file */
/usr/share/icons/hicolor    /** has all app icons */
```

---
