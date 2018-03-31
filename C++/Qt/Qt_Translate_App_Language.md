1. Adding new language file name in `app.pro` file.
```
TRANSLATIONS += lg_ch.ts \
                lg_en.ts \
                lg_new.ts
```
2. Running terminal command:`lupdate app.pro`,to update the ts files. and general lg_new.ts file in the project directory.
3. Booting the translate tool,run terminal command:`linguist`
4. Opening ts file. and to translate. when finished translate,don't forget to publish it. then, you will get the `lg_new.qm` file.
5. Moving all the translated qm files to same directpry under pro path. and add them to Qt Resources file.
6. Using the translated file in your program.
```
void MainWindow::StActionLanguageEnglish()
{
    _pTranslator->load(":/lg/language/lg_en.qm");
    qApp->installTranslator(_pTranslator);
}
```

That's All.

---
