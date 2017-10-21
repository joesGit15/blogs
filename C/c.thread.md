### Multithreading in C, POSIX(可移植操作系统接口Portable Operating System Interface X ) style

#### Multithreading — An Overview

In most modern operating systems it is possible for an application to split into many "threads" that all execute concurrently(同时发生). It might not be immediately obvious why this is useful, but there are numerous(许多的) reasons why this is beneficial(有利的).

When a program is split into many threads, each thread acts like its own individual program, except that all the threads work in the same memory space, so all their memory is shared. This makes communication between threads fairly(相当的) simple, but there are a few caveats(警告说明) that will be noted later.

So, what does multithreading do for us?

Well, for starters, multiple threads can run on multiple CPUs, providing a performance improvement. A multithreaded application works just as well on a single-CPU system, but without the added speed. As multi-core processors become commonplace(普遍的), such as Dual-Core processors and Intel Pentium 4's with HyperThreading, multithreading will be one of the simplest ways to boost performance.

Secondly, and often more importantly, it allows the programmer to divide each particular job of a program up into its own piece that operates independently of all the others. This becomes particularly important when many threads are doing blocking I/O operations.

A media player, for example, can have a thread for pre-buffering the incoming media, possibly from a harddrive, CD, DVD, or network socket, a thread to process user input, and a thread to play the actual media. A stall in any single thread won't keep the others from doing their jobs.

For the operating system, switching between threads is normally cheaper than switching between processes. This is because the memory management information doesn't change between threads, only the stack and register set do, which means less data to copy on context switches.

#### Multithreading — Basic Concepts

Multithreaded applications often require synchronization(同步) objects. These objects are used to protect memory from being modified by multiple threads at the same time, which might make the data incorrect.

The first, and simplest, is an object called a mutex. A mutex is like a lock. A thread can lock it, and then any subsequent attempt to lock it, by the same thread or any other, will cause the attempting thread to block until the mutex is unlocked. These are very handy for keeping data structures correct from all the threads' points of view. For example, imagine a very large linked list. If one thread deletes a node at the same time that another thread is trying to walk the list, it is possible for the walking thread to fall off the list, so to speak, if the node is deleted or changed. Using a mutex to "lock" the list keeps this from happening.

Computer Scientist people will tell you that Mutex stands for Mutual Exclusion. 

In Java, Mutex-like behaviour is accomplished using the synchronized keyword.

Technically speaking, only the thread that locks a mutex can unlock it, but sometimes operating systems will allow any thread to unlock it. Doing this is, of course, a Bad Idea. If you need this kind of functionality, read on about the semaphore in the next paragraph.

Similar to the mutex is the semaphore. A semaphore is like a mutex that counts instead of locks. If it reaches zero, the next attempt to access the semaphore will block until someone else increases it. This is useful for resource management when there is more than one resource, or if two separate(分离) threads are using the same resource in coordination. Common terminology(术语) for using semaphores is "uping" and "downing", where uping increases the count and downing decreases and blocks on zero. 

Java provides a Class called Semaphore which does the same thing, but uses acquire() and release() methods instead of uping and downing.

With a name as cool-sounding as semaphore, even Computer Scientists couldn't think up what this is short for. (Yes, I know that a semaphore is a signal or flag ;)

Unlike mutexes, semaphores are designed to allow multiple threads to up and down them all at once. If you create a semaphore with a count of 1, it will act just like a mutex, with the ability to allow other threads to unlock it.

The third and final structure is the thread itself. More specifically, thread identifiers. These are useful for getting certain threads to wait for other threads, or for getting threads to tell other threads interesting things.

Computer Scientists like to refer to the pieces of code protected by mutexes and semaphores as Critical Sections(临界区). In general, it's a good idea to keep Critical Sections as short as possible to allow the application to be as parallel(平行) as possible. The larger the critical section, the more likely it is that multiple threads will hit it at the same time, causing stalls.

In POSIX, the types we'll be dealing with are pthread_t for thread identifiers, pthread_mutex_t for mutexes, and sem_t for semaphores. We use the word "pthread" a lot because it stands for POSIX Threads.

#### Compiling Multithreaded Programs

Compiling multithreaded applications will require a few minor(轻微的) tweaks(调整) to our build setup. First, we'll need to include the appropriate header file. For POSIX systems, this header is called pthread.h. This header defines all the functions we'll be using to make threads. If we're using semaphores we'll also need to include semaphore.h.

```cpp
#include <pthread.h>
#include <semaphore.h>
```

The next change is that we'll need to link our program with the pthread library to use its functions. For a compiler like gcc we simply use the -l option, like this:

gcc myProgram.o -o myProgram -lpthread

Now that we've got the header in place, and we know how to link our program, let's get started.

#### Creating a thread

Creating a pthread is fairly easy. The function `pthread_create` is used, and it takes 4 arguments.

```cpp
int pthread_create(pthread_t * pth, pthread_attr_t *att, void * (*function), void * arg);
```

The first argument is a pointer to a `pthread_t`, where the function stores the identifier of the newly-created thread. The next argument is the attribute argument. This is typically NULL, but can also point to a structure that changes the thread's attributes. the third argument is the function the new thread will start at. If the thread returns from the function, the thread is terminated as well. You can think of the function as main, since it behaves similarly. The final argument is passed to the function when the thread is started. this is similar to the argc/argv command line arguments to main, but it can be any data type. Zero is returned on success, otherwise a failure of some variety happened.

Inside the thread function, a thread can terminate itself by returning from the thread function or by calling `pthread_exit.` They behave identically.

A thread can also be "detached", which frees all the resources the thread acquired while it was running as soon as it terminates. This is accomplished with `pthread_detach.` A detached thread can't be waited on.

#### Stopping a thread

Sometimes an application may wish to stop a thread that is currently executing. The function `pthread_cancel` can help us accomplish this.

```cpp
int pthread_cancel(pthread_t thread);
```

The only argument to `pthread_cancel` is the thread identifier for the thread to be cancelled. It returns zero if successful, or an error code otherwise.

A thread can set whether or not it can be cancelled by using int `pthread_setcancelstate.`

#### Mutexes and Semaphores

Mutexes are fairly easy to create. The function we use is `pthread_mutex_init`, which takes 2 parameters. The first is a pointer to a `mutex_t` that we're creating. The second parameter is usually NULL, but can also be a `pthread_mutexattr_t` structure that specifies different attributes for it.

To lock and unlock a mutex, use `pthread_mutex_lock` and `pthread_mutex_unlock`. These both take 1 parameter: a pointer to the mutex being operated on. `pthread_mutex_trylock` is similar to `pthread_mutex_lock`, except that if it can't lock the mutex, it returns a error instead of blocking.

When the mutex is no longer needed, it can be freed with `pthread_mutex_destroy`.

Semaphores follow a similar paradigm(模型). They are initialized with `sem_init`, which takes 3 parameters. The first is a pointer to the semaphore being initialized. The second is always zero. This argument is used to denote semaphores shared between processes, but it isn't always supported. The third argument specifies the initial value of the newly created semaphore.

To "Up" a semaphore, use sem_post. To "Down" a semaphore, use `sem_wait`. These kind of parallel `pthread_mutex_lock` and `pthread_mutex_unlock`.

sem_destroy is used to destroy a semaphore once it is no longer needed.

#### Multithreading — Waiting for other threads

It is also possible to make one thread stop and wait for another thread to finish. This is accomplished with `pthread_join`. This function takes a `pthread_t` identifier to pick(选择) which thread to wait for, and takes a void ** parameter to capture the return value. Joining a thread that has already exited is possible, and performing this will free any resources the thread had not already deallocated. In GNU/Linux, as well as other UNIX-like operating systems, these unjoined threads are called zombies(僵尸线程).

Note that only 1 thread can wait for any other thread. A detached thread (with `pthread_detach`) can't be waited on either.

Here's some example code to illustrate(说明) pthread_join:

```cpp
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

/* This is our thread function.  It is like main(), but for a thread */
void *threadFunc(void *arg)
{
    char *str;
    int i = 0;

    str=(char*)arg;

    while(i < 10 )
    {
        usleep(1);/// you can use the sleep
        printf("threadFunc says: %s\n",str);
        ++i;
    }

    return NULL;
}

int main(void)
{
    pthread_t pth;  // this is our thread identifier
    int i = 0;
    char str[] = "processing...";

    /* Create worker thread */
    pthread_create(&pth,NULL,threadFunc,str);

    /* wait for our thread to finish before continuing */
    pthread_join(pth, NULL /* void ** return value could go here */);

    while(i < 10 )
    {
        usleep(1);
        printf("main() is running...\n");
        ++i;
    }

    return 0;
}

// Note: just use the gcc main.cpp, it is ok.
```

Running this code will produce a bunch of text from threadFunc(), and then a bunch from main().

#### Multithreading — Example Source

Here's some example code to illustrate thread creation:

```cpp
#include <pthread.h>
#include <unistd.h>
#include <stdio.h>

/* This is our thread function.  It is like main(), but for a thread*/
void *threadFunc(void *arg)
{
    char *str;
    int i = 0;

    str=(char*)arg;

    while(i < 110 )
    {
        usleep(1); /// try use the sleep
        printf("threadFunc says: %s\n",str);
        ++i;
    }

    return NULL;
}

int main(void)
{
    pthread_t pth;  // this is our thread identifier
    int i = 0;
    char str[] = "foo";

    pthread_create(&pth,NULL,threadFunc,str);
    
    while(i < 100)
    {
        usleep(1);
        printf("main is running...\n");
        ++i;
    }

    printf("main waiting for thread to terminate...\n");
    pthread_join(pth,NULL);
    printf("ok, thread is finished\n");
    return 0;
}

// Note: just use the gcc main.cpp, it is ok.
```

The output will be (mostly) alternating lines as the main() and threadFunc() threads execute and pause. Without the usleep()'s they'll not switch because we aren't doing anything that takes long enough to consume our whole time slice.

We could capture the return value in the pthread_join() call if we used a variable instead of NULL for the second argument.

#### Performance Considerations

When designing an application for threads, or converting an existing program, there are some considerations to keep in mind when it comes to threads.

First, thread creation tends to be expensive -- spawning(引起) thousands of threads with short lifetimes usually isn't time-effective. If you need to create threads frequently, a common pattern used to reduce this cost is a "Thread Pool". At startup, the application will spawn a number of threads and supply them on demand(需求). When the thread task completes, the thread returns to the pool for reuse later. Fancier implementations will dynamically close threads when there's too much of a surplus(多余的), or spawn additional threads when there's a shortage.

Each additional thread also gets its own stack. This stack space can be large, which can consume a lot of memory space (especially in 32bit applications). There are methods to reduce a thread's stack size using the pthreads API. For small numbers of threads this usually isn't a concern(担心), but it's something to keep in mind.

Lock contention (when two or more threads are trying to acquire the same lock) requires skillful design to keep as many threads operating in parallel as possible. There are several volumes(大量的) of literature(文章) on ways to design locks, lock hierarchies(层次), and other variations(变化) to mitigate(使缓和) this cost.

#### Multithreading Terms

There are many terms used when writing multithreaded applications. I'll try to describe a few of there here.

Deadlock — A state where two or more threads each hold a lock that the others need to finish. For example, if one thread has locked mutex A and needs to lock mutex B to finish, while another thread is holding mutex B and is waiting for mutex A to be released, they are in a state of deadlock. The threads are stuck(困住), and cannot finish. One way to avoid deadlock is to acquire necessary mutexes in the same order (always get mutex A then B). Another is to see if a mutex is available via `pthread_mutex_trylock`, and release any held locks if one isn't available.

Race Condition(竞争状态) — A program that depends on threads working in a certain sequence to complete normally. Race Conditions happen when mutexes are used improperly(不合适的), or not at all.

Thread-Safe — A library that is designed to be used in multithreaded applications is said to be thread-safe. If a library is not thread-safe, then one and only one thread should make calls to that library's functions.

#### Example

##### Print pthread_t

```cpp
#include <stdio.h>
#include <pthread.h>

void *threadFunc(void *arg){
    char *str;

    pthread_t pth = pthread_self();
    printf("threadId: %08x\n", pth);

    str = (char *)arg;
    printf("threadFunc says: %s\n", str);

    return NULL;
}

int main(void){
    pthread_t pth[3];
    int i = 0;
    char str[] = "processing...";

    pthread_t pmainth = pthread_self();
    printf("main threadId: %08x\n", pmainth);

    /** join means waitting, if uncomment the join, the three print threid are same value */
    pthread_create(&pth[1],NULL,threadFunc,str);
    //pthread_join(pth[1],NULL);

    pthread_create(&pth[2],NULL,threadFunc,str);
    //pthread_join(pth[2],NULL);

    pthread_create(&pth[3],NULL,threadFunc,str);
    //pthread_join(pth[3],NULL);

    return 0;
}
```

##### Stop thread

###### pthread_exit

```cpp
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

typedef struct {
    int nMaxIndex;
    int nExitIndex;
}threadArgs;

void *threadFunc(void *arg){
    threadArgs *parg;
    int i;

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++){
        printf("thread i:%d--%d\n", i, parg->nExitIndex);
        sleep(1);
        if( parg->nExitIndex > parg->nMaxIndex ){
            printf("thread will exit;\n");
            pthread_exit(NULL); /// exit
        }
    }

    return NULL;
}

int main(void){
    pthread_t pth;
    threadArgs thArgs = {20,10};

    pthread_create(&pth,NULL,threadFunc,&thArgs);

    do{
        sleep(1);
        thArgs.nExitIndex++;
        printf("main: %d\n", thArgs.nExitIndex);
    }while( thArgs.nExitIndex < thArgs.nMaxIndex + 10);

    return 0;
}
```

###### pthread_detach

```cpp
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

typedef struct {
    int nMaxIndex;
    int nIndex;
}threadArgs;

void *threadFunc(void *arg){
    threadArgs *parg;
    int i;

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++){
        printf("thread i:%d\n", i);
        sleep(1);
    }

    return NULL;
}

int main(void){
    pthread_t pth;
    threadArgs thArgs = {20,10};

    pthread_create(&pth,NULL,threadFunc,&thArgs);

    do{
        sleep(1);
        thArgs.nIndex++;
        printf("main: %d\n", thArgs.nIndex);
    }while( thArgs.nIndex < thArgs.nMaxIndex - 5);

    printf("thread will detach, and will frees all the resources;\n");
    pthread_detach( pth );

    return 0;
}
```

###### pthread_cancel

```cpp
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

typedef struct {
    int nMaxIndex;
    int nIndex;
}threadArgs;

void *threadFunc0(void *arg){
    threadArgs *parg;
    int i;

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++){
        printf("thread_0: i:%d\n", i);
        sleep(1);
    }

    return NULL;
}

void *threadFunc1(void *arg){
    threadArgs *parg;
    int i;
    /** the thread is not cancelable. if a cancelation request is received,
     * it is blocked until cancelability is enable;*/
    pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
    //pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++){
        printf("thread_1 i:%d\n", i);
        sleep(1);
    }

    return NULL;
}

int main(void){
    pthread_t pth[3];
    threadArgs thArgs = {20,10};

    pthread_create(&pth[0],NULL,threadFunc0,&thArgs);
    sleep(1);
    printf("thread_0 will cancel\n");
    pthread_cancel(pth[0]);

    pthread_create(&pth[1],NULL,threadFunc1,&thArgs);
    sleep(1);
    printf("thread_1 will cancel\n");
    pthread_cancel(pth[1]);

    do{
        sleep(1);
        thArgs.nIndex++;
        printf("main: %d\n", thArgs.nIndex);
    }while( thArgs.nIndex < thArgs.nMaxIndex - 5);

    return 0;
}
```

###### thread mutex

```cpp

/** with static initialization */

#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

typedef struct {
    int nMaxIndex;
    int nIndex;
}threadArgs;

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *threadFunc(void *arg){
    pthread_t pth = pthread_self();
    threadArgs *parg;
    int i;

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++){
        pthread_mutex_lock(&mutex); // pthread_mutex_trylock

        printf("threadId:%08x, %d\n", pth, parg->nIndex );
        parg->nIndex++;

        pthread_mutex_unlock(&mutex);

        sleep(1);
    }

    return NULL;
}

int main(void){
    pthread_t pth[3];
    threadArgs thArgs = {20,10};

    pthread_create(&pth[0],NULL,threadFunc,&thArgs);
    pthread_create(&pth[1],NULL,threadFunc,&thArgs);

    pthread_join(pth[0], NULL);
    pthread_join(pth[1], NULL);
    return 0;
}
```

```cpp

/** without static initialization */

#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

typedef struct {
    int nMaxIndex;
    int nIndex;
}threadArgs;

static pthread_once_t once = PTHREAD_ONCE_INIT;
static pthread_mutex_t mutex;

void mutex_init(){
    pthread_mutex_init(&mutex, NULL);
}

void *threadFunc(void *arg){

    int i;
    threadArgs *parg;
    pthread_t pth = pthread_self();

    /** just init once */
    pthread_once(&once,mutex_init);

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++){
        pthread_mutex_lock(&mutex);

        printf("threadId:%08x, %d\n", pth, parg->nIndex );
        parg->nIndex++;

        pthread_mutex_unlock(&mutex);

        sleep(1);
    }

    return NULL;
}

int main(void){
    pthread_t pth[3];
    threadArgs thArgs = {20,10};

    pthread_create(&pth[0],NULL,threadFunc,&thArgs);
    pthread_create(&pth[1],NULL,threadFunc,&thArgs);

    pthread_join(pth[0], NULL);
    pthread_join(pth[1], NULL);
    return 0;
}

```

###### pthread_mutexattr_t

```cpp
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

typedef struct {
    int nMaxIndex;
    int nIndex;
}threadArgs;

static pthread_once_t once = PTHREAD_ONCE_INIT;
static pthread_mutex_t mutex;

void mutex_init(){
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    //** If mutexattr is NULL, default attributes are used instead */
    pthread_mutex_init(&mutex, &attr);
}

void *threadFunc(void *arg){

    int i;
    threadArgs *parg;
    pthread_t pth = pthread_self();

    /** just init once */
    pthread_once(&once,mutex_init);

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++){
        pthread_mutex_lock(&mutex);

        printf("threadId:%08x, %d\n", pth, parg->nIndex );
        parg->nIndex++;

        pthread_mutex_unlock(&mutex);

        sleep(1);
    }

    return NULL;
}

int main(void){
    pthread_t pth[3];
    threadArgs thArgs = {20,10};

    pthread_create(&pth[0],NULL,threadFunc,&thArgs);
    pthread_create(&pth[1],NULL,threadFunc,&thArgs);

    pthread_join(pth[0], NULL);
    pthread_join(pth[1], NULL);

    pthread_mutex_destroy(&mutex);
    return 0;
}
```

###### sem_init

```cpp
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

typedef struct {
    int nMaxIndex;
    int nIndex;
}threadArgs;

sem_t sem_name;

void *threadFunc(void *arg){

    int i, nSem;
    threadArgs *parg;
    pthread_t pth = pthread_self();

    parg = (threadArgs *)arg;
    for(i=0; i < parg->nMaxIndex; i++)
    {
        sem_wait(&sem_name);

        sem_getvalue(&sem_name,&nSem);
        printf("threadId:%08x, %d, nSem=%d\n", pth, parg->nIndex, nSem);
        parg->nIndex++;

        sem_post(&sem_name);

        sleep(1);
    }

    return NULL;
}

int main(void){
    pthread_t pth[3];
    threadArgs thArgs = {20,10};

    sem_init(&sem_name,0,1);

    pthread_create(&pth[0],NULL,threadFunc,&thArgs);
    pthread_create(&pth[1],NULL,threadFunc,&thArgs);

    pthread_join(pth[0], NULL);
    pthread_join(pth[1], NULL);

    sem_destroy(&sem_name);
    return 0;
}
```

#### Reference

> [Multithreading in C](http://softpixel.com/~cwright/programming/threads/threads.c.php)
> [pthread.h](http://pubs.opengroup.org/onlinepubs/7908799/xsh/pthread.h.html)
> [print thread id](http://stackoverflow.com/questions/1759794/how-to-print-pthread-t)
> [pthread_exit](http://man7.org/linux/man-pages/man3/pthread_exit.3.html)
> [pthread_detach](http://man7.org/linux/man-pages/man3/pthread_detach.3.html)
> [cnblogs pthread_cancel](http://www.cnblogs.com/lijunamneg/archive/2013/01/25/2877211.html)
> [man7.org pthread_cancel](http://man7.org/linux/man-pages/man3/pthread_cancel.3.html)
> [linux.die.net pthread_mutex_init](https://linux.die.net/man/3/pthread_mutex_init)
> [pthread_mutexattr_t](https://sourceware.org/pthreads-win32/manual/pthread_mutexattr_init.html)
> [pthread_mutex_init](https://www.sourceware.org/pthreads-win32/manual/pthread_mutex_init.html)
> [sem_init](http://www.csc.villanova.edu/~mdamian/threads/posixsem.html)
> [semaphore.h](https://linux.die.net/include/semaphore.h)
> [POSIX Threads Programming](https://computing.llnl.gov/tutorials/pthreads/)
> [yolinux thread libraries ](http://www.yolinux.com/TUTORIALS/LinuxTutorialPosixThreads.html)

---
