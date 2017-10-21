### Threading Classes (Qt help manual key words)

These **Qt Core** classes provide threading support to applications. The **Thread Support** in Qt page covers how to use these classes.

low-level className                 |...
---                                 |---
QThread                             |Platform-independent way to manage threads
QRunnable                           |The base class for all runnable objects
QThreadStorage                      |Per-thread data storage

---dividing line---

middle-level className|...
---|---
QThreadPool                         |Manages a collection of QThreads
QMutex                              |Access serialization between threads
QMutexLocker                        |Convenience class that simplifies locking and unlocking mutexes
QReadLocker                         |Convenience class that simplifies locking and unlocking read-write locks for read access
QWriteLocker                        |Convenience class that simplifies locking and unlocking read-write locks for write access
QReadWriteLock                      |Read-write locking
QSemaphore                          |General counting semaphore
QWaitCondition                      |Condition variable for synchronizing threads

---dividing line---

high-level className|...
---|---
Concurrent Run                      |
Concurrent Map and Map-Reduce       |
Concurrent Filter and Filter-Reduce |
QtConcurrent                        |High-level APIs that make it possible to write multi-threaded programs without using low-level threading primitives
QFuture Represents                  |the result of an asynchronous computation
QFutureWatcher                      |Allows monitoring a QFuture using signals and slots
QFutureSynchronizer                 |Convenience class that simplifies QFuture synchronization

---dividing line---

unKnown ClassName|...
---|---
QAtomicInteger                      |Platform-independent atomic operations on integers
QAtomicPointer                      |Template class that provides platform-independent atomic operations on pointers

---dividing line---

#### QThread Class (low-level)

The QThread class provides a platform-independent way to manage threads.

A QThread object manages one thread of control within the program. QThreads begin executing in `run()`. By default, `run()` starts the **event loop by calling `exec()`** and runs a Qt event loop inside the thread.

You can use **worker objects by moving them to the thread using `QObject::moveToThread()`.**

```cpp
  class Worker : public QObject
  {
      Q_OBJECT

  public slots:
      void doWork(const QString &parameter) {
          QString result;
          /* ... here is the expensive or blocking operation ... */
          emit resultReady(result);
      }

  signals:
      void resultReady(const QString &result);
  };

  class Controller : public QObject
  {
      Q_OBJECT
      QThread workerThread;
  public:
      Controller() {
          Worker *worker = new Worker;

          worker->moveToThread(&workerThread);
          /** 线程的槽函数,是运行在父线程中的,也叫作old thread */
          connect(&workerThread, &QThread::finished, worker, &QObject::deleteLater);

          connect(this, &Controller::operate, worker, &Worker::doWork);
          connect(worker, &Worker::resultReady, this, &Controller::handleResults);

          workerThread.start();
      }
      ~Controller() {
          workerThread.quit();
          workerThread.wait();
      }

  public slots:
      void handleResults(const QString &);
  signals:
      void operate(const QString &);
  };
```

The code inside the Worker's slot would then execute in a separate thread. However, you are free to connect the Worker's slots to any signal, from any object, in any thread. It is safe to connect signals and slots across different threads, thanks to a mechanism called queued connections.

**Another way to make code run in a separate thread, is to subclass QThread and reimplement run().** For example:

```cpp
  /** 这种方法,有很多不好的地方(最初级的)*/
  class WorkerThread : public QThread
  {
      Q_OBJECT
      void run() Q_DECL_OVERRIDE {
          QString result;
          /* ... here is the expensive or blocking operation ... */
          emit resultReady(result);
      }
  signals:
      void resultReady(const QString &s);
  };

  void MyObject::startWorkInAThread()
  {
      WorkerThread *workerThread = new WorkerThread(this);

      connect(workerThread, &WorkerThread::resultReady, this, &MyObject::handleResults);
      connect(workerThread, &WorkerThread::finished, workerThread, &QObject::deleteLater);

      workerThread->start();
  }
```

In that example, the thread will exit after the run function has returned. There will not be any event loop running in the thread unless you call exec().

***It is important to remember that a QThread instance lives in the old thread that instantiated it, not in the new thread that calls run(). This means that all of QThread's queued slots will execute in the old thread. Thus, a developer who wishes to invoke slots in the new thread must use the worker-object approach; new slots should not be implemented directly into a subclassed QThread.***

***When subclassing QThread, keep in mind that the constructor executes in the old thread while run() executes in the new thread. If a member variable is accessed from both functions, then the variable is accessed from two different threads. Check that it is safe to do so.***

***Note: Care must be taken when interacting with objects across different threads. See Synchronizing Threads for details.***

##### Managing Threads

QThread will notifiy you via a signal when the thread is started() and finished(), or you can use isFinished() and isRunning() to query the state of the thread.

You can stop the thread by calling exit() or quit(). **In extreme cases, you may want to forcibly terminate() an executing thread. However, doing so is dangerous and discouraged. Please read the documentation for terminate() and setTerminationEnabled() for detailed information.**

**From Qt 4.8 onwards, it is possible to deallocate objects that live in a thread that has just ended, by connecting the finished() signal to QObject::deleteLater().**

Use wait() to block the calling thread, until the other thread has finished execution (or until a specified time has passed).

QThread also provides static, platform independent sleep functions: sleep(), msleep(), and usleep() allow full second, millisecond, and microsecond resolution respectively. These functions were made public in Qt 5.0.

**Note: wait() and the sleep() functions should be unnecessary in general, since Qt is an event-driven framework. Instead of wait(), consider listening for the finished() signal. Instead of the sleep() functions, consider using QTimer.**

The static functions currentThreadId() and currentThread() return identifiers for the currently executing thread. The former returns a platform specific ID for the thread; the latter returns a QThread pointer.

To choose the name that your thread will be given (as identified by the command ps -L on Linux, for example), you can call setObjectName() before starting the thread. If you don't call setObjectName(), the name given to your thread will be the class name of the runtime type of your thread object (for example, "RenderThread" in the case of the Mandelbrot Example, as that is the name of the QThread subclass). Note that this is currently not available with release builds on Windows.

---

#### QRunnable(low-level)

The QRunnable class is the base class for all runnable objects.

The QRunnable class is an interface for representing a task or piece of code that needs to be executed, represented by your reimplementation of the run() function.

```cpp
virtual void run()=0
```

You can use QThreadPool to execute your code in a separate thread. QThreadPool deletes the QRunnable automatically if autoDelete() returns true (the default). Use setAutoDelete() to change the auto-deletion flag.

QThreadPool supports executing the same QRunnable more than once by calling QThreadPool::tryStart(this) from within the run() function. If autoDelete is enabled the QRunnable will be deleted when the last thread exits the run function. Calling QThreadPool::start() multiple times with the same QRunnable when autoDelete is enabled creates a race condition and is not recommended.

---

#### QThreadStorage(low-level)

The QThreadStorage class provides per-thread data storage.

**QThreadStorage is a template class that provides per-thread data storage.**

The setLocalData() function stores a single thread-specific value for the calling thread. The data can be accessed later using localData().

The hasLocalData() function allows the programmer to determine if data has previously been set using the setLocalData() function. This is also useful for lazy initializiation.

If T is a pointer type, QThreadStorage takes ownership of the data (which must be created on the heap with new) and deletes it when the thread exits, either normally or via termination.

For example, the following code uses QThreadStorage to store a single cache for each thread that calls the cacheObject() and removeFromCache() functions. The cache is automatically deleted when the calling thread exits.

```cpp
  QThreadStorage<QCache<QString, SomeClass> > caches;

  void cacheObject(const QString &key, SomeClass *object)
  {
      caches.localData().insert(key, object);
  }

  void removeFromCache(const QString &key)
  {
      if (!caches.hasLocalData())
          return;

      caches.localData().remove(key);
  }
```

##### Caveats

- The QThreadStorage destructor does not delete per-thread data. QThreadStorage only deletes per-thread data when the thread exits or when setLocalData() is called multiple times.

- QThreadStorage can be used to store data for the main() thread. QThreadStorage deletes all data set for the main() thread when QApplication is destroyed, regardless of whether or not the main() thread has actually finished.

---

#### QThreadPool(middle-level)

The QThreadPool class manages a collection of QThreads.

QThreadPool manages and recyles individual QThread objects to help reduce thread creation costs in programs that use threads. **Each Qt application has one global QThreadPool object, which can be accessed by calling globalInstance().**

To use one of the QThreadPool threads, subclass QRunnable and implement the run() virtual function. Then create an object of that class and pass it to QThreadPool::start().

```cpp
  class HelloWorldTask : public QRunnable
  {
      void run()
      {
          qDebug() << "Hello world from thread" << QThread::currentThread();
      }
  }

  HelloWorldTask *hello = new HelloWorldTask();
  // QThreadPool takes ownership and deletes 'hello' automatically
  QThreadPool::globalInstance()->start(hello);
```

**QThreadPool deletes the QRunnable automatically by default**. Use QRunnable::setAutoDelete() to change the auto-deletion flag.

**QThreadPool supports executing the same QRunnable more than once by calling tryStart(this) from within QRunnable::run(). If autoDelete is enabled the QRunnable will be deleted when the last thread exits the run function. Calling start() multiple times with the same QRunnable when autoDelete is enabled creates a race condition(竞争条件) and is not recommended.(不建议这样调用多次)**

**Threads that are unused for a certain amount of time will expire. The default expiry timeout is 30000 milliseconds (30 seconds). This can be changed using setExpiryTimeout(). Setting a negative(负的) expiry timeout disables the expiry mechanism.**

Call maxThreadCount() to query the maximum number of threads to be used. If needed, you can change the limit with setMaxThreadCount(). The default maxThreadCount() is QThread::idealThreadCount(). The activeThreadCount() function returns the number of threads currently doing work.

The reserveThread() function reserves(存储) a thread for external(外部) use. Use releaseThread() when your are done with the thread, so that it may be reused. Essentially(本质上), these functions temporarily increase or reduce the active thread count and are useful when implementing time-consuming(耗时的) operations that are not visible to the QThreadPool.

Note that QThreadPool is a low-level class for managing threads, see the Qt Concurrent module for higher level alternatives.

---

#### QMutex(middle-level)

The QMutex class provides access serialization between threads.

The purpose of a QMutex is to protect an object, data structure or section of code so that only one thread can access it at a time (this is similar to the Java synchronized keyword). It is usually best to use a mutex with a QMutexLocker since this makes it easy to ensure that locking and unlocking are performed(执行) consistently(一致地).

For example, say there is a method that prints a message to the user on two lines:

If we add a mutex, we should get the result we want:

```cpp
  QMutex mutex;
  int number = 6;

  void method1()
  {
      mutex.lock();
      number *= 5;
      number /= 4;
      mutex.unlock();
  }

  void method2()
  {
      mutex.lock();
      number *= 3;
      number /= 2;
      mutex.unlock();
  }
```

Then only one thread can modify number at any given time and the result is correct. This is a trivial example(这是一个简单的事例), of course, but applies to any other case where things need to happen in a particular sequence.

When you call lock() in a thread, other threads that try to call lock() in the same place will block until the thread that got the lock calls unlock(). A non-blocking alternative to lock() is tryLock().

QMutex is optimized(优化的) to be fast in the non-contended(非竞争) case. A non-recursive(非递归) QMutex will not allocate memory if there is no contention(竞争) on that mutex. It is constructed and destroyed with almost no overhead(几乎没有开销), which means it is fine to have many mutexes as part of other classes.

---

#### QMutexLocker(middle-level)

The QMutexLocker class is a convenience class that simplifies locking and unlocking mutexes.

Locking and unlocking a QMutex in complex functions and statements or in exception handling code is error-prone and difficult to debug. QMutexLocker can be used in such situations to ensure that the state of the mutex is always well-defined.

QMutexLocker should be created within a function where a QMutex needs to be locked. The mutex is locked when QMutexLocker is created. You can unlock and relock the mutex with unlock() and relock(). **If locked, the mutex will be unlocked when the QMutexLocker is destroyed.**

For example, this complex function locks a QMutex upon entering the function and unlocks the mutex at all the exit points:

```cpp
  int complexFunction(int flag)
  {
      mutex.lock();

      int retVal = 0;

      switch (flag) {
      case 0:
      case 1:
          retVal = moreComplexFunction(flag);
          break;
      case 2:
          {
              int status = anotherFunction();
              if (status < 0) {
                  mutex.unlock(); /// must be unlock at return;
                  return -2;
              }
              retVal = status + flag;
          }
          break;
      default:
          if (flag > 10) {
              mutex.unlock(); /// also use the goto
              return -1;
          }
          break;
      }

      mutex.unlock();
      return retVal;
  }
```

This example function will get more complicated as it is developed, which increases the likelihood that errors will occur.

Using QMutexLocker greatly simplifies the code, and makes it more readable:

```cpp
  int complexFunction(int flag)
  {
      QMutexLocker locker(&mutex);

      int retVal = 0;

      switch (flag) {
      case 0:
      case 1:
          return moreComplexFunction(flag);
      case 2:
          {
              int status = anotherFunction();
              if (status < 0)
                  return -2;
              retVal = status + flag;
          }
          break;
      default:
          if (flag > 10)
              return -1;
          break;
      }

      return retVal;
  }
```

**Now, the mutex will always be unlocked when the QMutexLocker object is destroyed (when the function returns since locker is an auto variable).**

The same principle(原理) applies to code that throws and catches exceptions. An exception that is not caught in the function that has locked the mutex has no way of unlocking the mutex before the exception is passed up the stack to the calling function.

QMutexLocker also provides a mutex() member function that returns the mutex on which the QMutexLocker is operating. This is useful for code that needs access to the mutex, such as QWaitCondition::wait(). For example:

```cpp
  class SignalWaiter
  {
  private:
      QMutexLocker locker;

  public:
      SignalWaiter(QMutex *mutex)
          : locker(mutex)
      {
      }

      void waitForSignal()
      {
          ...
          while (!signalled)
              waitCondition.wait(locker.mutex());
          ...
      }
  };
```

---

#### QReadLocker(middle-level)

The QReadLocker class is a convenience class that simplifies locking and unlocking read-write locks for read access.

The purpose of QReadLocker (and QWriteLocker) is to simplify QReadWriteLock locking and unlocking. Locking and unlocking statements or in exception handling code is error-prone and difficult to debug. QReadLocker can be used in such situations to ensure that the state of the lock is always well-defined.

Here's an example that uses QReadLocker to lock and unlock a read-write lock for reading:

```cpp
  QReadWriteLock lock;

  QByteArray readData()
  {
      QReadLocker locker(&lock);
      ...
      return data;
  }

It is equivalent to the following code:

  QReadWriteLock lock;

  QByteArray readData()
  {
      lock.lockForRead();
      ...
      lock.unlock();
      return data;
  }
```

---

#### QWriteLocker(middle-level)

The QWriteLocker class is a convenience class that simplifies locking and unlocking read-write locks for write access.

The purpose of QWriteLocker (and QReadLocker) is to simplify QReadWriteLock locking and unlocking. Locking and unlocking statements or in exception handling code is error-prone and difficult to debug. QWriteLocker can be used in such situations to ensure that the state of the lock is always well-defined.

Here's an example that uses QWriteLocker to lock and unlock a read-write lock for writing:

```cpp
  QReadWriteLock lock;

  void writeData(const QByteArray &data)
  {
      QWriteLocker locker(&lock);
      ...
  }

It is equivalent to the following code:

  QReadWriteLock lock;

  void writeData(const QByteArray &data)
  {
      lock.lockForWrite();
      ...
      lock.unlock();
  }
```

---

#### QReadWriteLock(middle-level)

The QReadWriteLock class provides read-write locking.

A read-write lock is a synchronization tool for protecting resources that can be accessed for reading and writing. This type of lock is useful if you want to allow multiple threads to have simultaneous(同时的) read-only access, but as soon as one thread wants to write to the resource, all other threads must be blocked until the writing is complete.

In many cases, QReadWriteLock is a direct competitor(竞争) to QMutex. QReadWriteLock is a good choice if there are many concurrent reads and writing occurs infrequently.
Example:

```cpp
  QReadWriteLock lock;

  void ReaderThread::run()
  {
      ...
      lock.lockForRead();
      read_file();
      lock.unlock();
      ...
  }

  void WriterThread::run()
  {
      ...
      lock.lockForWrite();
      write_file();
      lock.unlock();
      ...
  }
```

To ensure that writers aren't blocked forever by readers, readers attempting to obtain a lock will not succeed if there is a blocked writer waiting for access, even if the lock is currently only accessed by other readers. Also, if the lock is accessed by a writer and another writer comes in, that writer will have priority over any readers that might also be waiting.

Like QMutex, a QReadWriteLock can be recursively locked by the same thread when constructed with QReadWriteLock::Recursive as QReadWriteLock::RecursionMode. In such cases, unlock() must be called the same number of times lockForWrite() or lockForRead() was called. Note that the lock type cannot be changed when trying to lock recursively, i.e. it is not possible to lock for reading in a thread that already has locked for writing (and vice versa).

---

#### QSemaphone(middle-level)

The QSemaphore class provides a general counting semaphore.

A semaphore is a generalization of a mutex. While a mutex can only be locked once, it's possible to acquire a semaphore multiple times. Semaphores are typically used to protect a certain number of identical resources.

Semaphores support two fundamental operations, acquire() and release():

- acquire(n) tries to acquire n resources. If there aren't that many resources available, the call will block until this is the case.
- release(n) releases n resources.

There's also a tryAcquire() function that returns immediately if it cannot acquire the resources, and an available() function that returns the number of available resources at any time.

Example:

```cpp
  QSemaphore sem(5);      // sem.available() == 5

  sem.acquire(3);         // sem.available() == 2
  sem.acquire(2);         // sem.available() == 0
  sem.release(5);         // sem.available() == 5
  sem.release(5);         // sem.available() == 10  is it right?

  sem.tryAcquire(1);      // sem.available() == 9, returns true
  sem.tryAcquire(250);    // sem.available() == 9, returns false
```

A typical application of semaphores is for controlling access to a circular buffer shared by a producer thread and a consumer thread.

A non-computing example of a semaphore would be dining at a restaurant. A semaphore is initialized with the number of chairs in the restaurant. As people arrive, they want a seat. As seats are filled, available() is decremented. As people leave, the available() is incremented, allowing more people to enter. If a party of 10 people want to be seated, but there are only 9 seats, those 10 people will wait, but a party of 4 people would be seated (taking the available seats to 5, making the party of 10 people wait longer).

---

#### QWaitCondition(middle-level)

The QWaitCondition class provides a condition variable for synchronizing threads.

QWaitCondition allows a thread to tell other threads that some sort of condition has been met. One or many threads can block waiting for a QWaitCondition to set a condition with wakeOne() or wakeAll(). Use wakeOne() to wake one randomly selected thread or wakeAll() to wake them all.

For example, let's suppose that we have three tasks that should be performed whenever the user presses a key. Each task could be split into a thread, each of which would have a run() body like this:

```cpp
  forever {
      mutex.lock();
      keyPressed.wait(&mutex);
      do_something();
      mutex.unlock();
  }
```

Here, the keyPressed variable is a global variable of type QWaitCondition.

A fourth thread would read key presses and wake the other three threads up every time it receives one, like this:

```cpp
  forever {
      getchar();
      keyPressed.wakeAll();
  }
```

The order in which the three threads are woken up is undefined. Also, if some of the threads are still in do_something() when the key is pressed, they won't be woken up (since they're not waiting on the condition variable) and so the task will not be performed for that key press. This issue can be solved using a counter and a QMutex to guard it. For example, here's the new code for the worker threads:

```cpp
  forever {
      mutex.lock();
      keyPressed.wait(&mutex);
      ++count;
      mutex.unlock();

      do_something();

      mutex.lock();
      --count;
      mutex.unlock();
  }
```

Here's the code for the fourth thread:

```cpp
  forever {
      getchar();

      mutex.lock();
      // Sleep until there are no busy worker threads
      while (count > 0) {
          mutex.unlock();
          sleep(1);
          mutex.lock();
      }
      keyPressed.wakeAll();
      mutex.unlock();
  }
```

The mutex is necessary because the results of two threads attempting to change the value of the same variable simultaneously(同时的) are unpredictable.(不可预知的)

---

### Qt Concurrent(high-level)

***The QtConcurrent namespace provides high-level APIs that make it possible to write multi-threaded programs without using low-level threading primitives(原语) such as mutexes, read-write locks, wait conditions, or semaphores. Programs written with QtConcurrent automatically adjust the number of threads used according to the number of processor cores available. This means that applications written today will continue to scale when deployed on multi-core systems in the future.***

QtConcurrent includes functional programming style APIs for parallel(平行的) list processing, including a MapReduce and FilterReduce implementation for shared-memory (non-distributed)(非分布式) systems, and classes for managing asynchronous computations in GUI applications:

- Concurrent Map and Map-Reduce
    1. QtConcurrent::map() applies a function to every item in a container, modifying the items in-place.
    2. QtConcurrent::mapped() is like map(), except that it returns a new container with the modifications.
    3. QtConcurrent::mappedReduced() is like mapped(), except that the modified results are reduced or folded into a single result.
- Concurrent Filter and Filter-Reduce
    1. QtConcurrent::filter() removes all items from a container based on the result of a filter function.
    2. QtConcurrent::filtered() is like filter(), except that it returns a new container with the filtered results.
    3. QtConcurrent::filteredReduced() is like filtered(), except that the filtered results are reduced or folded into a single result.
- Concurrent Run
    1. QtConcurrent::run() runs a function in another thread.
- QFuture represents the result of an asynchronous computation.
- QFutureIterator allows iterating through results available via QFuture.
- QFutureWatcher allows monitoring a QFuture using signals-and-slots.
- QFutureSynchronizer is a convenience class that automatically synchronizes several QFutures.

Qt Concurrent supports several STL-compatible container and iterator types, but works best with Qt containers that have random-access iterators, such as QList or QVector. The map and filter functions accept both containers and begin/end iterators.

STL Iterator support overview:

Iterator Type           |Example classes                |Support status
---                     |---                            |
Input Iterator          |                               |Not Supported
Output Iterator         |                               |Not Supported
Forward Iterator        |std::slist                     |Supported
Bidirectional Iterator  |QLinkedList, std::list         |Supported
Random Access Iterator  |QList, QVector, std::vector    |Supported and Recommended

Random access iterators can be faster in cases where Qt Concurrent is iterating over a large number of lightweight items, since they allow skipping to any point in the container. In addition, using random access iterators allows Qt Concurrent to provide progress information trough QFuture::progressValue() and QFutureWatcher::progressValueChanged().

The non in-place(原地) modifying functions such as mapped() and filtered() makes a copy of the container when called. If you are using STL containers this copy operation might take some time, in this case we recommend specifying the begin and end iterators for the container instead. 

#### Concurrent Map and Map-Reduce

***The QtConcurrent::map(), QtConcurrent::mapped() and QtConcurrent::mappedReduced() functions run computations in parallel on the items in a sequence such as a QList or a QVector. QtConcurrent::map() modifies a sequence in-place, QtConcurrent::mapped() returns a new sequence containing the modified content, and QtConcurrent::mappedReduced() returns a single result.***

These functions are a part of the Qt Concurrent framework.

Each of the above functions has a blocking variant that returns the final result instead of a QFuture. You use them in the same way as the asynchronous variants.

```cpp
  QList<QImage> images = ...;

  // each call blocks until the entire operation is finished
  QList<QImage> future = QtConcurrent::blockingMapped(images, scaled);

  QtConcurrent::blockingMap(images, scale);

  QImage collage = QtConcurrent::blockingMappedReduced(images, scaled, addToCollage);
```

**Note that the result types above are not QFuture objects, but real result types (in this case, QList<QImage> and QImage).**

##### Concurrent Map

**If you want to modify a sequence in-place, use QtConcurrent::map(). The map function must then be of the form:**

```
  U function(T &t);
```

**Note that the return value and return type of the map function are not used.**

```
  void scale(QImage &image)
  {
      image = image.scaled(100, 100);
  }

  QList<QImage> images = ...;
  QFuture<void> future = QtConcurrent::map(images, scale);

```

Since the sequence is modified in place, QtConcurrent::map() does not return any results via QFuture. However, you can still use QFuture and QFutureWatcher to monitor the status of the map. 

##### Concurrent Mapped

**QtConcurrent::mapped() takes an input sequence and a map function. This map function is then called for each item in the sequence, and a new sequence containing the return values from the map function is returned.**

The map function must be of the form:

```
  U function(const T &t);
```

T and U can be any type (and they can even be the same type), but T must match the type stored in the sequence. The function returns the modified or mapped content.

This example shows how to apply a scale function to all the items in a sequence:

```
  QImage scaled(const QImage &image)
  {
      return image.scaled(100, 100);
  }

  QList<QImage> images = ...;
  QFuture<QImage> thumbnails = QtConcurrent::mapped(images, scaled);
```

The results of the map are made available through QFuture. See the QFuture and QFutureWatcher documentation for more information on how to use QFuture in your applications.

##### Concurrent Map-Reduce

**QtConcurrent::mappedReduced() is similar to QtConcurrent::mapped(), but instead of returning a sequence with the new results, the results are combined into a single value using a reduce function.**

The reduce function must be of the form:

```
  V function(T &result, const U &intermediate)
```

T is the type of the final result, U is the return type of the map function. Note that the return value and return type of the reduce function are not used.

Call QtConcurrent::mappedReduced() like this:

```
  void addToCollage(QImage &collage, const QImage &thumbnail)
  {
      QPainter p(&collage);
      static QPoint offset = QPoint(0, 0);
      p.drawImage(offset, thumbnail);
      offset += ...;
  }

  QList<QImage> images = ...;
  QFuture<QImage> collage = QtConcurrent::mappedReduced(images, scaled, addToCollage);
```

**The reduce function will be called once for each result returned by the map function, and should merge the intermediate into the result variable. QtConcurrent::mappedReduced() guarantees that only one thread will call reduce at a time, so using a mutex to lock the result variable is not necessary.** The QtConcurrent::ReduceOptions enum provides a way to control the order in which the reduction is done. If QtConcurrent::UnorderedReduce is used (the default), the order is undefined, while QtConcurrent::OrderedReduce ensures that the reduction is done in the order of the original sequence. 

##### Additional API Features

###### Using Iterators instead of Sequence

Each of the above functions has a variant that takes an iterator range instead of a sequence. You use them in the same way as the sequence variants:

```
  QList<QImage> images = ...;

  // map in-place only works on non-const iterators
  QFuture<void> future = QtConcurrent::map(images.begin(), images.end(), scale);

  QFuture<QImage> thumbnails = QtConcurrent::mapped(images.constBegin(), images.constEnd(), scaled);

  QFuture<QImage> collage = QtConcurrent::mappedReduced(images.constBegin(), images.constEnd(), scaled, addToCollage);
``` 

###### Blocking Variants

Each of the above functions has a blocking variant that returns the final result instead of a QFuture. You use them in the same way as the asynchronous variants.

```
  QList<QImage> images = ...;

  // each call blocks until the entire operation is finished
  QList<QImage> future = QtConcurrent::blockingMapped(images, scaled);

  QtConcurrent::blockingMap(images, scale);

  QImage collage = QtConcurrent::blockingMappedReduced(images, scaled, addToCollage);
```

Note that the result types above are not QFuture objects, but real result types (in this case, QList<QImage> and QImage). 

###### Using Member Functions

QtConcurrent::map(), QtConcurrent::mapped(), and QtConcurrent::mappedReduced() accept pointers to member functions. The member function class type must match the type stored in the sequence:

```
  // squeeze all strings in a QStringList
  QStringList strings = ...;
  QFuture<void> squeezedStrings = QtConcurrent::map(strings, &QString::squeeze);

  // swap the rgb values of all pixels on a list of images
  QList<QImage> images = ...;
  QFuture<QImage> bgrImages = QtConcurrent::mapped(images, &QImage::rgbSwapped);

  // create a set of the lengths of all strings in a list
  QStringList strings = ...;
  QFuture<QSet<int> > wordLengths = QtConcurrent::mappedReduced(string, &QString::length, &QSet<int>::insert);
```

Note that when using QtConcurrent::mappedReduced(), you can mix the use of normal and member functions freely:

```
  // can mix normal functions and member functions with QtConcurrent::mappedReduced()

  // compute the average length of a list of strings
  extern void computeAverage(int &average, int length);
  QStringList strings = ...;
  QFuture<int> averageWordLength = QtConcurrent::mappedReduced(strings, &QString::length, computeAverage);

  // create a set of the color distribution of all images in a list
  extern int colorDistribution(const QImage &string);
  QList<QImage> images = ...;
  QFuture<QSet<int> > totalColorDistribution = QtConcurrent::mappedReduced(images, colorDistribution, QSet<int>::insert);
```

###### Using Function Objects

QtConcurrent::map(), QtConcurrent::mapped(), and QtConcurrent::mappedReduced() accept function objects, which can be used to add state to a function call. The result_type typedef must define the result type of the function call operator:

```
  struct Scaled
  {
      Scaled(int size)
      : m_size(size) { }

      typedef QImage result_type;

      QImage operator()(const QImage &image)
      {
          return image.scaled(m_size, m_size);
      }

      int m_size;
  };

  QList<QImage> images = ...;
  QFuture<QImage> thumbnails = QtConcurrent::mapped(images, Scaled(100));
```

###### Using Bound Function Arguments

If you want to use a map function that takes more than one argument you can use std::bind() to transform it onto a function that takes one argument. If C++11 support is not available, boost::bind() or std::tr1::bind() are suitable replacements.

As an example, we'll use QImage::scaledToWidth():

```
  QImage QImage::scaledToWidth(int width, Qt::TransformationMode) const;
```

scaledToWidth takes three arguments (including the "this" pointer) and can't be used with QtConcurrent::mapped() directly, because QtConcurrent::mapped() expects a function that takes one argument. To use QImage::scaledToWidth() with QtConcurrent::mapped() we have to provide a value for the width and the transformation mode:

```
  std::bind(&QImage::scaledToWidth, 100, Qt::SmoothTransformation)
```

The return value from std::bind() is a function object (functor) with the following signature:

```
  QImage scaledToWith(const QImage &image)
```

This matches what QtConcurrent::mapped() expects, and the complete example becomes:

```
  QList<QImage> images = ...;
  QFuture<QImage> thumbnails = QtConcurrent::mapped(images, std::bind(&QImage::scaledToWidth, 100, Qt::SmoothTransformation));
```

#### Concurrent Filter and Filter-Reduce

The QtConcurrent::filter(), QtConcurrent::filtered() and QtConcurrent::filteredReduced() functions filter items in a sequence such as a QList or a QVector in parallel. QtConcurrent::filter() modifies a sequence in-place, QtConcurrent::filtered() returns a new sequence containing the filtered content, and QtConcurrent::filteredReduced() returns a single result.

Each of the above functions have a blocking variant that returns the final result instead of a QFuture. You use them in the same way as the asynchronous variants.

```cpp
  QStringList strings = ...;

  // each call blocks until the entire operation is finished
  QStringList lowerCaseStrings = QtConcurrent::blockingFiltered(strings, allLowerCase);

  QtConcurrent::blockingFilter(strings, allLowerCase);

  QSet<QString> dictionary = QtConcurrent::blockingFilteredReduced(strings, allLowerCase, addToDictionary);
```

Note that the result types above are not QFuture objects, but real result types (in this case, QStringList and QSet<QString>). 

##### Concurrent Filter

If you want to modify a sequence in-place, use QtConcurrent::filter():

```cpp
  QStringList strings = ...;
  QFuture<void> future = QtConcurrent::filter(strings, allLowerCase);
```

Since the sequence is modified in place, QtConcurrent::filter() does not return any results via QFuture. However, you can still use QFuture and QFutureWatcher to monitor the status of the filter. 

##### Concurrent Filtered

QtConcurrent::filtered() takes an input sequence and a filter function. This filter function is then called for each item in the sequence, and a new sequence containing the filtered values is returned.

The filter function must be of the form:

```cpp
  bool function(const T &t);
```

T must match the type stored in the sequence. The function returns true if the item should be kept(保留), false if it should be discarded(丢弃).

This example shows how to keep strings that are all lower-case from a QStringList:
```cpp
  bool allLowerCase(const QString &string)
  {
      return string.lowered() == string;
  }

  QStringList strings = ...;
  QFuture<QString> lowerCaseStrings = QtConcurrent::filtered(strings, allLowerCase);
```
The results of the filter are made available through QFuture. See the QFuture and QFutureWatcher documentation for more information on how to use QFuture in your applications.

##### Concurrent Filter-Reduce

QtConcurrent::filteredReduced() is similar to QtConcurrent::filtered(), but instead of returing a sequence with the filtered results, the results are combined into a single value using a reduce function.

The reduce function must be of the form:
```cpp
  V function(T &result, const U &intermediate)
```

T is the type of the final result, U is the type of items being filtered. Note that the return value and return type of the reduce function are not used.
Call QtConcurrent::filteredReduced() like this:

```
  void addToDictionary(QSet<QString> &dictionary, const QString &string)
  {
      dictionary.insert(string);
  }

  QStringList strings = ...;
  QFuture<QSet<QString> > dictionary = QtConcurrent::filteredReduced(strings, allLowerCase, addToDictionary);
```

The reduce function will be called once for each result kept by the filter function, and should merge the intermediate into the result variable. QtConcurrent::filteredReduced() guarantees that only one thread will call reduce at a time, so using a mutex to lock the result variable is not necessary. The QtConcurrent::ReduceOptions enum provides a way to control the order in which the reduction is done. 

##### Additional API Features

###### Using Iterators instead of Sequence(like the Concurrent Map)
###### Using Member Functions(like the Concurrent Map)
###### Using Function Objects(like the Concurrent Map)
###### Using Bound Function Arguments(like the Concurrent Map)

#### Concurrent Run

The QtConcurrent::run() function runs a function in a separate thread. The return value of the function is made available through the QFuture API.

##### Running a Function in a Separate Thread

To run a function in another thread, use QtConcurrent::run():

```cpp
  extern void aFunction();
  QFuture<void> future = QtConcurrent::run(aFunction);
```

This will run aFunction in a separate thread obtained from the default QThreadPool. You can use the QFuture and QFutureWatcher classes to monitor the status of the function.

To use a dedicated(专用的) thread pool, you can pass the QThreadPool as the first argument:

```cpp
  extern void aFunction();
  QThreadPool pool;
  QFuture<void> future = QtConcurrent::run(&pool, aFunction);
```

##### Passing Arguments to the Function

Passing arguments to the function is done by adding them to the QtConcurrent::run() call immediately after the function name. For example:

```cpp
  extern void aFunctionWithArguments(int arg1, double arg2, const QString &string);

  int integer = ...;
  double floatingPoint = ...;
  QString string = ...;

  QFuture<void> future = QtConcurrent::run(aFunctionWithArguments, integer, floatingPoint, string);
```

**A copy of each argument is made at the point where QtConcurrent::run() is called, and these values are passed to the thread when it begins executing the function. Changes made to the arguments after calling QtConcurrent::run() are not visible to the thread.**

##### Returning Values from the Function

Any return value from the function is available via QFuture:

```cpp
  extern QString functionReturningAString();
  QFuture<QString> future = QtConcurrent::run(functionReturningAString);
  ...
  QString result = future.result();
```

As documented above, passing arguments is done like this:

```cpp
  extern QString someFunction(const QByteArray &input);

  QByteArray bytearray = ...;

  QFuture<QString> future = QtConcurrent::run(someFunction, bytearray);
  ...
  QString result = future.result();
```

**Note that the QFuture::result() function blocks and waits for the result to become available. Use QFutureWatcher to get notification when the function has finished execution and the result is available.**

##### Additional API Features 

###### Using Member Functions

**QtConcurrent::run() also accepts pointers to member functions. The first argument must be either a const reference or a pointer to an instance of the class. Passing by const reference is useful when calling const member functions; passing by pointer is useful for calling non-const member functions that modify the instance.**

For example, calling QByteArray::split() (a const member function) in a separate thread is done like this:

```cpp
  // call 'QList<QByteArray>  QByteArray::split(char sep) const' in a separate thread
  QByteArray bytearray = "hello world";
  QFuture<QList<QByteArray> > future = QtConcurrent::run(bytearray, &QByteArray::split, ',');
  ...
  QList<QByteArray> result = future.result();
```

Calling a non-const member function is done like this:

```cpp
  // call 'void QImage::invertPixels(InvertMode mode)' in a separate thread
  QImage image = ...;
  QFuture<void> future = QtConcurrent::run(&image, &QImage::invertPixels, QImage::InvertRgba);
  ...
  future.waitForFinished();
  // At this point, the pixels in 'image' have been inverted
```

###### Using Bound Function Arguments

There are number of reasons for binding:

1. To call a function that takes more than 5 arguments.
2. To simplify calling a function with constant arguments.
3. Changing the order of arguments.

See the documentation for the relevant functions for details on how to use the bind API.

Calling a bound function is done like this:

```cpp
  void someFunction(int arg1, double arg2);
  QFuture<void> future = QtConcurrent::run(std::bind(someFunction, 1, 2.0));
  ...
```

---

#### QFuture(high-level)

The QFuture class represents the result of an asynchronous computation.

To start a computation, use one of the APIs in the Qt Concurrent framework.

QFuture allows threads to be synchronized against one or more results which will be ready at a later point in time. The result can be of any type that has a default constructor and a copy constructor. If a result is not available at the time of calling the result(), resultAt(), or results() functions, QFuture will wait until the result becomes available. You can use the isResultReadyAt() function to determine if a result is ready or not. For QFuture objects that report more than one result, the resultCount() function returns the number of continuous results. This means that it is always safe to iterate through the results from 0 to resultCount().

QFuture provides a Java-style iterator (QFutureIterator) and an STL-style iterator (QFuture::const_iterator). Using these iterators is another way to access results in the future.

QFuture also offers ways to interact with a runnning computation. For instance, the computation can be canceled with the cancel() function. To pause the computation, use the setPaused() function or one of the pause(), resume(), or togglePaused() convenience functions. Be aware that not all asynchronous computations can be canceled or paused. For example, the future returned by QtConcurrent::run() cannot be canceled; but the future returned by QtConcurrent::mappedReduced() can.

Progress information is provided by the progressValue(), progressMinimum(), progressMaximum(), and progressText() functions. The waitForFinished() function causes the calling thread to block and wait for the computation to finish, ensuring that all results are available.

The state of the computation represented by a QFuture can be queried using the isCanceled(), isStarted(), isFinished(), isRunning(), or isPaused() functions.

QFuture is a lightweight reference counted class that can be passed by value.

QFuture<void> is specialized to not contain any of the result fetching functions. Any QFuture<T> can be assigned or copied into a QFuture<void> as well. This is useful if only status or progress information is needed - not the actual result data.

To interact with running tasks using signals and slots, use QFutureWatcher.

---

#### QFutureIterator(high-level)

The QFutureIterator class provides a Java-style const iterator for QFuture.

QFuture has both Java-style iterators and STL-style iterators.**The Java-style iterators are more high-level and easier to use than the STL-style iterators; on the other hand, they are slightly less efficient.**

An alternative to using iterators is to use index positions. Some QFuture member functions take an index as their first parameter, making it possible to access results without using iterators.

QFutureIterator<T> allows you to iterate over a QFuture<T>. **Note that there is no mutable iterator for QFuture (unlike the other Java-style iterators).**

The QFutureIterator constructor takes a QFuture as its argument. After construction, the iterator is located at the very beginning of the result list (i.e. before the first result). Here's how to iterate over all the results sequentially:

```cpp
  QFuture<QString> future;
  ...
  QFutureIterator<QString> i(future);
  while (i.hasNext())
      qDebug() << i.next();
```

The next() function returns the next result (waiting for it to become available, if necessary) from the future and advances the iterator. Unlike STL-style iterators, Java-style iterators point between results rather than directly at results. The first call to next() advances the iterator to the position between the first and second result, and returns the first result; the second call to next() advances the iterator to the position between the second and third result, and returns the second result; and so on.

Here's how to iterate over the elements in reverse order:

```cpp
  QFutureIterator<QString> i(future);
  i.toBack();
  while (i.hasPrevious())
      qDebug() << i.previous();
```

If you want to find all occurrences of a particular value, use findNext() or findPrevious() in a loop.

**Multiple iterators can be used on the same future. If the future is modified while a QFutureIterator is active, the QFutureIterator will continue iterating over the original future, ignoring the modified copy.**


---

#### QFutureWatcher(high-level)

**The QFutureWatcher class allows monitoring a QFuture using signals and slots.**

QFutureWatcher provides information and notifications about a QFuture. Use the setFuture() function to start watching a particular QFuture. The future() function returns the future set with setFuture().

For convenience, several of QFuture's functions are also available in QFutureWatcher: progressValue(), progressMinimum(), progressMaximum(), progressText(), isStarted(), isFinished(), isRunning(), isCanceled(), isPaused(), waitForFinished(), result(), and resultAt(). The cancel(), setPaused(), pause(), resume(), and togglePaused() functions are slots in QFutureWatcher.

Status changes are reported via the started(), finished(), canceled(), paused(), resumed(), resultReadyAt(), and resultsReadyAt() signals. Progress information is provided from the progressRangeChanged(), void progressValueChanged(), and progressTextChanged() signals.

Throttling(节流) control is provided by the setPendingResultsLimit() function. When the number of pending resultReadyAt() or resultsReadyAt() signals exceeds(超过r the limit, the computation represented by the future will be throttled automatically. The computation will resume(重新开始) once the number of pending signals drops below the limit.

Example: Starting a computation and getting a slot callback when it's finished:

```cpp
  // Instantiate the objects and connect to the finished signal.
  MyClass myObject;
  QFutureWatcher<int> watcher;
  connect(&watcher, SIGNAL(finished()), &myObject, SLOT(handleFinished()));

  // Start the computation.
  QFuture<int> future = QtConcurrent::run(...);
  watcher.setFuture(future);
```

**Be aware that not all asynchronous computations can be canceled or paused. For example, the future returned by QtConcurrent::run() cannot be canceled; but the future returned by QtConcurrent::mappedReduced() can.**

QFutureWatcher<void> is specialized to not contain any of the result fetching functions. Any QFuture<T> can be watched by a QFutureWatcher<void> as well. This is useful if only status or progress information is needed; not the actual result data.

---

#### QFutureSynchronizer(high-level)

The QFutureSynchronizer class is a convenience class that simplifies QFuture synchronization.

QFutureSynchronizer is a template class that simplifies synchronization of one or more QFuture objects. Futures are added using the addFuture() or setFuture() functions. The futures() function returns a list of futures. Use clearFutures() to remove all futures from the QFutureSynchronizer.

**The waitForFinished() function waits for all futures to finish. The destructor of QFutureSynchronizer calls waitForFinished(), providing an easy way to ensure that all futures have finished before returning from a function:**

```cpp
  void someFunction()
  {
      QFutureSynchronizer<void> synchronizer;

      ...

      synchronizer.addFuture(QtConcurrent::run(anotherFunction));
      synchronizer.addFuture(QtConcurrent::map(list, mapFunction));

      return; // QFutureSynchronizer waits for all futures to finish
  }
```

The behavior of waitForFinished() can be changed using the setCancelOnWait() function. Calling setCancelOnWait(true) will cause waitForFinished() to cancel all futures before waiting for them to finish. You can query the status of the cancel-on-wait feature using the cancelOnWait() function.

### Reference

> [cnblogs](http://www.cnblogs.com/findumars/p/5641570.html)

---
