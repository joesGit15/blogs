#### Application Menu

Application menu in different operator systems has different designed style. like Windows and Mac os, they are different.In the code, we can use different Macro ,eg:Q_OS_MAC and Q_OS_WIN

```
#ifdef Q_OS_MAC
void MainWindow::InitMenu()
{
    QMenuBar* mBar = menuBar();

    QMenu* mApp   = new QMenu(tr("App"),this);
    QMenu* mFile  = new QMenu(tr("&File"),this);

    mBar->addMenu(mApp);
    mBar->addMenu(mFile);

    /** In Mac,We should to set action role */
    QAction* actAbout = new QAction(tr("&About"),this);
    actAbout->setMenuRole(QAction::AboutRole);

    QAction* actSetApp = new QAction(tr("&Preference..."),this);
    actSetApp->setMenuRole(QAction::PreferencesRole);

    mApp->addAction(actAbout);
    mApp->addAction(actSetApp);

    QAction* actOpen = new QAction(tr("&Open Video Files..."),this);
    mFile->addAction(actOpen);

    connect(actOpen,&QAction::triggered,_player,&Player::StOpen);
    connect(actSetApp,&QAction::triggered,this,&MainWindow::StShowSetDlg);
}
#else
void MainWindow::InitMenu()
{
    QMenuBar* mBar = menuBar();

    QMenu* mFile  = new QMenu(tr("&File"),this);
    QMenu* mSet   = new QMenu(tr("&Setting"),this);
    QMenu* mAbout = new QMenu(tr("&About"),this);

    QAction* actOpen = new QAction(tr("&Open Video Files..."),this);
    QAction* actExit = new QAction(tr("&Exit out"),this);

    mFile->addAction(actOpen);
    mFile->addSeparator();
    mFile->addAction(actExit);

    QAction* actSetApp = new QAction(tr("&Setting App..."),this);
    mSet->addAction(actSetApp);

    mBar->addMenu(mFile);
    mBar->addMenu(mSet);
    mBar->addMenu(mAbout);

    connect(actOpen,&QAction::triggered,_player,&Player::StOpen);
    connect(actExit,&QAction::triggered,this,[=](){close();});
    connect(actSetApp,&QAction::triggered,this,&MainWindow::StShowSetDlg);
}
#endif
```

---
