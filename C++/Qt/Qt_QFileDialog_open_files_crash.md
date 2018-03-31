#### 问题描述

在使用Qt的`QFileDialog`这个类,来进行文件的打开和选择的时候, 就在调用的时候, 总是发生崩溃. 而且没有任何的提示性的信息. 而且崩溃的概率很高. 也有不崩溃的情况. 这个问题, 从我进入公司, 到现在一直是存在的.因为公司内部使用的是服务器模式的工作环境. 每个人通过终端链接服务器进行工作. 因为服务器环境复杂. 所以我们一直怀疑是权限问题,或者服务器问题. 而且我们也测试了其他机器. 在上面的是好好的,文件打开很正常.但就是除了服务器的环境. 所以这个问题就一直僵持着. 考验着开发人员的忍耐力.

#### 问题分析

这个问题一直放着,没有去解决它. 主要是惯性思维的毛病. 一般的话, 我们调用这个打开文件对话框都是通过接口,设置几个参数.如果在调用接口的地方,出现问题了. 而且接口都是这么写的.着实让人头疼. 这个问题的实质, 就是调用系统资源文件管理器的时候, 出现的问题. 其实, 有的时候, 换一个思路, 问题就解决了. 为什么要调用系统的呢? 有其他的文件对话框吗? 对于Qt,是有的. 所以, **调用Qt自身的文件对话框, 可以根本的解决这个问题**.

#### 代码实现

```cpp
/** 来自Net的一个写法, 主要注意QFileDialog::DontUseNativeDialog,
  不要使用本地的对话框, 也就是使用Qt自身的对话框,打开文件 */
void MainWindow::StActOpenFile()
{
    QStringList ltFilePath;
    QFileDialog dialog(this, tr("Open Files"), qsLastPath,STR_OPEN_FILE);
    dialog.setAcceptMode(QFileDialog::AcceptOpen);  ///< 打开文件? 好像默认就是
    dialog.setModal(QFileDialog::ExistingFiles);
    dialog.setOption(QFileDialog::DontUseNativeDialog); ///< 不是用本地对话框
    dialog.exec();
    ltFilePath = dialog.selectedFiles();

    return;
}

/** 项目中使用 */
void MainWindow::StActOpenFile()
{
    QStringList ltFilePath;
    ltFilePath = QFileDialog::getOpenFileNames( this,
                                                tr("请选择至少一个图像文件"),
                                                m_qsLastPath,
                                                QString(STR_OPEN_FILE),
                                                Q_NULLPTR,
                                                QFileDialog::DontUseNativeDialog);
    return;
}

void MainWindow::StActOpenFloder()
{
    QStringList ltFilePath;
    QString qsFileFloder = QFileDialog::getExistingDirectory(this,
                                                     tr("请选择一个图像文件夹"),
                                                     m_qsLastPath,
                                                     QFileDialog::ShowDirsOnly |
                                                     QFileDialog::DontUseNativeDialog );
    return;
}
```

#### 方案不足

使用这个方案, 因为是调用Qt本身提供的对话框, 语言是英文的. 不过, 我觉得这个是可以设置的. 原先的调用系统本身的, 语言环境是系统的. 所以不用考虑什么. 使用Qt自身的, 就要考虑这些了.有兴趣的童鞋可以自己研究一下. 使用自身的, 崩溃完美消失了.

---
