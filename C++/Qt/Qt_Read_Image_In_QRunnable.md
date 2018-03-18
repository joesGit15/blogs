### Read Many Image With QRunnable

#### Code Snippet

The below code snippet run in thread With QRunnable,But sometimes, It has crashed, crash information:assert-data-data-ref-load-1-in-file-image-qpixmap-cpp-line-273

```
bool ReadPixmap(QString imgPath, QPixmap &pixmap)
{
    bool bReadOk = false;
    QString str;
    QImage image;
    QImageReader reader;

    /**
      Use QPixmap::load and QImage::load function,
      if some image fimename has wrong extension,
      it return false.
      eg:rename filename extension as wrong.rename jpg to png
    */
    if(!pixmap.load(imgPath)){ ///< Crash at here

        reader.setFileName(imgPath);
        reader.setDecideFormatFromContent(true);

        if(!reader.canRead()){
            goto _END;
        }

        image = reader.read();
        if(image.isNull()){
            goto _END;
        }

        pixmap = QPixmap::fromImage(image);
        if(pixmap.isNull()){
            goto _END;
        }

    }

    bReadOk = true;
_END:
    if(!bReadOk){
        str = QObject::tr("File: %1 read falied. Error: %2")
            .arg(imgPath)
            .arg(reader.errorString());
        QMessageBox::warning(NULL, QObject::tr("Warning"), str, QMessageBox::Yes);
    }

    return bReadOk;
}

```

#### Crash Info

- [assert-data-data-ref-load-1-in-file-image-qpixmap-cpp-line-273](https://forum.qt.io/topic/82745/assert-data-data-ref-load-1-in-file-image-qpixmap-cpp-line-273)


#### Remove QPixmap::load

** My Way, But not good and best. **

```
bool ReadPixmap(QString imgPath, QPixmap &pixmap)
{
    bool bReadOk = false;
    QString str;
    QImage image;
    QImageReader reader;

    reader.setFileName(imgPath);
    reader.setDecideFormatFromContent(true);

    if(!reader.canRead()){
        goto _END;
    }

    image = reader.read();
    if(image.isNull()){
        goto _END;
    }

    pixmap = QPixmap::fromImage(image);
    if(pixmap.isNull()){
        goto _END;
    }

    bReadOk = true;

_END:
    if(!bReadOk){
        Q_ASSERT(bReadOk);
    }

    return bReadOk;
}

```

---

