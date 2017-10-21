## Qt keys

- qmake Manual
    - Building Common Project Types

```pro
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

VERSION = 01.00.00

# change the nama of the binary, if it is build in debug mode
CONFIG(debug, debug|release) {
     mac: TARGET = $$join(TARGET,,,_debug)
     win32: TARGET = $$join(TARGET,,,d)
}

#define the directory, where the binary is placed
RCC_DIR     = ./tmp
UI_DIR     = ./tmp

CONFIG(debug, debug|release) {
    DESTDIR     = ../debug
    OBJECTS_DIR = ./tmp/debug
    MOC_DIR     = ./tmp/moc/debug
}
else {
    DESTDIR     = ../release
    OBJECTS_DIR = ./tmp/release
    MOC_DIR     = ./tmp/moc/release
}
```

```txt
.
├── build-fileTypeAssociateapp-Desktop_Qt_5_7_0_MinGW_32bit-Debug
│   ├── debug
│   ├── fileTypeAssociateapp_resource.rc
│   ├── fileTypeAssociateappd_resource.rc
│   ├── Makefile
│   ├── Makefile.Debug
│   ├── Makefile.Release
│   ├── release
│   └── tmp
│       ├── debug
│       │   ├── fileTypeAssociateappd_resource_res.o
│       │   ├── main.o
│       │   ├── moc_widget.o
│       │   └── widget.o
│       ├── moc
│       │   ├── debug
│       │   │   └── moc_widget.cpp
│       │   └── release
│       └── release
├── debug
│   └── fileTypeAssociateappd.exe
├── fileTypeAssociateapp
│   ├── fileTypeAssociateapp.pro
│   ├── fileTypeAssociateapp.pro.user
│   ├── main.cpp
│   ├── widget.cpp
│   └── widget.h
├── registereditorfiletype
│   ├── _RegisterFileTypes.gidoc
│   ├── documentwindow.cpp
│   ├── documentwindow.h
│   ├── images
│   │   ├── copy.png
│   │   ├── cut.png
│   │   ├── new.png
│   │   ├── open.png
│   │   ├── paste.png
│   │   └── save.png
│   ├── license.txt
│   ├── main.cpp
│   ├── mainwindow.cpp
│   ├── mainwindow.h
│   ├── mdichild.cpp
│   ├── mdichild.h
│   ├── RegisterFileTypes.pro
│   ├── RegisterFileTypes.pro.user
│   └── RegisterFileTypes.qrc
└── release
```

---
