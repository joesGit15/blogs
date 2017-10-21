## linux.ls

linux ls命令, 我觉得是所有接触linux系统, 首先学习的命令. 这个命令, 我也早就接触过了. 只是以前是学习类型的. 学了以后, 没有做到学以致用.可惜了. 现在这篇内容,会不定期的根据自己的需求更新自己在工作和生活中, 需要使用到的ls是怎么样的.

### man ls

一定要学会查看帮助文档, man man man 男人一定要靠自己!** man == manual, 手册**

### 使用场景

1. list 文件的时候,根据文件的某些属性进行排序

- -s, --size : print the allocated size of each file, in blocks
- -S : sort by file size
- --sort=WORD : sort by WORD instead of name: none -U, extension -X, size -S, time -t, version -v

```
ls -lhs ///< 显示文件 按照文件大小 从小到大
ls -lhS ///< 显示文件 按照文件大小 从大到小

ls -lh --sort=WORD ///< WORD关键字可以是none -U,extension -X, size -S, time -t, version -V 如下:
1. ls -lh --sort=none or ls -lhU
2. ls -lh --sort=size or ls -lhS
3. ls -lh --sort=time or ls -lht
4. ls -lh --sort=version or ls -lhV
```

---
