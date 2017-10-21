1. 
```
find /tmp -name core -type f -print | xargs /bin/rm -f
```
Find  files  named core in or below the directory /tmp and delete them.  Note that this will
work incorrectly if there are any filenames containing newlines or spaces.

2. 
```
find /tmp -name core -type f -print0 | xargs -0 /bin/rm -f
```
Find files named core in or below the directory /tmp and delete them,  processing  filenames
in such a way that file or directory names containing spaces or newlines are correctly han‐
dled.

3. 
```
find /tmp -depth -name core -type f -delete
```
Find files named core in or below the directory /tmp and delete them, but  more  efficiently
than in the previous example (because we avoid the need to use fork(2) and exec(2) to launch
rm and we don't need the extra xargs process).

4. 
```
cut -d: -f1 < /etc/passwd | sort | xargs echo
```
Generates a compact listing of all the users on the system.

5. 
```
xargs sh -c 'emacs "$@" < /dev/tty' emacs
```
Launches the minimum number of copies of Emacs needed, one after  the  other,  to  edit  the
files  listed  on  xargs' standard input.  This example achieves the same effect as BSD's -o
option, but in a more flexible and portable way.

6. 
```
: find . -name "*.txt" | xargs ls -l
: find . -name "*.jpg" -type f -print | xargs tar -cvzf my_pictures.tar.gz
: find . -name "*.txt" | xargs -n1 -i ls -l {}
: find . -name "*.txt" | xargs -n1 -i cp {} ./backup/
: ls *.txt | xargs -i mv {} {}_.backup
: ls | grep ".bak" | xargs -I{} ls {}
: ls | grep ".bak" | xargs -I{} rm {}
: ls | xargs -n 3 echo
```

7. 
```
: echo des_dir1 des_dir2 des_dir3 | xargs -n 1 cp src_file
```

#### Reference

> [Linux man page](https://linux.die.net/man/1/xargs)
> [Linux xargs command](http://landoflinux.com/linux_xargs_command.html)
> [10 xargs command example](http://www.thegeekstuff.com/2013/12/xargs-examples)
> [xagrs wikipedia](https://en.wikipedia.org/wiki/Xargs)

---
