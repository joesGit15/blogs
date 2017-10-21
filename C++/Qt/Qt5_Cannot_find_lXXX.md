#### Description

I had the error message **Can not find -lGL** when i run qt qmake long ago. The error message shows me that there was a lib not to be found. At that time, I know the GL lib is one of OpenGl libs. because I didn't use any libs of OPenGL, so I just to modify the Makefile. So it well work. But, The error always shown only the qt pro file modified. because the Makefile will be created when pro file modified. Today, I got some libs are not found. I must to find good way to work it out. like below.

#### Ways

When you get the error message like **Can not find -lXXX** at you run make the program. You can flow below steps to work it out;

1. use the linux command `locate` to find whether install the lib in your linux system;`locate libXXX`
2. if not install, you should install them . about how to install them, you can search it from google.
3. if you install these libs. you just create link file at `/usr/lib`.like:`ln -s /usr/lib/x86_64-linux-gnu/mesa/libXXX.so.1 /usr/lib/libXXX.so`
4. remake to generate Makefile. That all. Good luck!
5. if you want more information, you can click Reference licks.

#### Reference

> [cnblogs](www.cnblogs.com/coding-my-life/p/5677256.html)
> [qtcn](http://www.qtcn.org/bbs/simple/?t51311.html)
