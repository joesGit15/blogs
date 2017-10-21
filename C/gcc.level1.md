### 简单介绍gcc And make 的使用

#### 基本编译

```bash
gcc a.c b.c -o exeName
```
#### 分步编译

```bash
gcc -c a.c -o a.o
gcc a.o b.c -o main.o 
```

#### 使用Makefile编译

```bash
vi Makefile #建立Makefile文件，必须是这个格式
```
##### make 内容如下

```bash
hello.out:max.o min.o hello.c   #最上面的是main入口，main需要什么文件，列举出来，然后新行，tab，开始写gcc命令
    gcc max.o min.o hello.c -o hello.out
max.o:max.c #上面需要max.o的目标文件，所以接下是这个文件的生产。
    gcc -c max.c
min.o:min.c
    gcc -c min.c
```

##### 保存退出，直接make命令
make
