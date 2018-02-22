# std::thread

Defined in header <thread>

## class thread

The class thread represents a single thread of execution. Threads allow multiple functions to execute concurrently(同时发生).

Threads begin execution immediately upon construction of the associated thread object (pending any OS scheduling delays), starting at the top-level function provided as a constructor argument. The return value of the top-level function is ignored and if it terminates by throwing an exception, std::terminate is called. The top-level function may communicate its return value or an exception to the caller via std::promise or by modifying shared variables (which may require synchronization, see std::mutex and std::atomic)

std::thread objects may also be in the state that does not represent any thread (after default construction, move from, detach, or join), and a thread of execution may be not associated with any thread objects (after detach).

No two std::thread objects may represent the same thread of execution; std::thread is not CopyConstructible or CopyAssignable, although it is MoveConstructible and MoveAssignable. 

### Example

#### Create Thread Object

```cpp
#include <iostream>
#include <thread>

#include <utility>
#include <functional>
#include <atomic>

using namespace std;

void fun(int n)
{
    for(int i = 0; i < 10; i++)
    {
        cout << "Thread 1 running...\n";
        n++;
        //this_thread::sleep_for(chrono::milliseconds(1000));
        this_thread::sleep_for(chrono::seconds(1));
    }
}

void funRef(int &n)
{
    for(int i = 0; i < 10; i++)
    {
        cout << "Thread 2 running...\n";
        n++;
        //this_thread::sleep_for(chrono::milliseconds(1000));
        this_thread::sleep_for(chrono::seconds(1));
    }
}

int main(int argc, char **argv)
{
    int n = 0;
    thread t1; ///< it is not a thread

    thread t2(fun, n);
    t2.join();

    thread t3(funRef, ref(n) ); ///< pass by reference
    thread t4(move(t3));        ///< t4 is now running funRef, t3 is no longer a thread

    t4.join();

    cout << "Ok, the n:" << n;
    return 0;

```

#### joinable

`bool joinable() const;`

Checks if the thread object identifies an active thread of execution. Specifically, returns true if `get_id() != std::thread::id()`. So a default constructed thread is not joinable.

A thread that has finished executing code, **but has not yet been joined is still considered an active thread of execution and is therefore joinable.**

```cpp
#include <iostream>
#include <thread>
#include <utility>
#include <functional>
#include <atomic>

using namespace std;

void fun()
{
    for(int i = 0; i < 10; i++)
    {
        cout << "Thread running...\n";
        this_thread::sleep_for(chrono::seconds(1));
    }
}

int main(int argc, char **argv)
{
    int n = 0;
    thread t1;
    cout << "t1 joinable:" << t1.joinable() << "\n";

    thread t2(fun);
    cout << "t2 joinable:" << t2.joinable() << "\n";

    t2.join();
    cout << "t2 joinable twice:" << t2.joinable() << "\n";

    return 0;

```

#### get_id() & native_handle()

`std::thread::id get_id() const;`

Returns a value of std::thread::id identifying the thread associated with *this.  A value of type std::thread::id identifying the thread associated with *this. If there is no thread associated, default constructed std::thread::id is returned. 

```cpp
#include <iostream>
#include <chrono>
#include <utility>
#include <cstring>

#include <pthread.h>
#include <thread>
#include <mutex>

using namespace std;

std::mutex iomutex;

void fun(int n)
{
    this_thread::sleep_for(chrono::seconds(1));

    sched_param sch;
    int policy;

    pthread_getschedparam(pthread_self(), &policy, &sch);
    lock_guard<mutex> lk(iomutex);
    cout << "Thread " << n << "is executing at policy " << sch.sched_priority << "\n";
}

int main(int argc, char **argv)
{
    thread t1(fun, 1), t2(fun, 2);

    thread::id t1Id = t1.get_id();
    thread::id t2Id = t2.get_id();

    cout << "t1 Id " << t1Id << "\n";
    cout << "t2 Id " << t2Id << "\n";

    sched_param sch;
    int policy;

    pthread_getschedparam(t1.native_handle(), &policy, &sch);
    sch.sched_priority = 20;
    if( pthread_setschedparam(t1.native_handle(), SCHED_FIFO, &sch) ){
        cout << "Failed to setschedparam:" << strerror(errno) << "\n";
    }

    t1.join();
    t2.join();

    return 0;
}
```

#### hardware_concurrency

`static unsigned hardware_concurrency();`

Returns the number of concurrent threads supported by the implementation. The value should be considered only a hint.  number of concurrent threads supported. If the value is not well defined or not computable, returns 0. 

```cpp
#include <iostream>
#include <thread>

using namespace std;

int main(int argc, char **argv)
{
    unsigned int n = thread::hardware_concurrency();
    cout << n << " concurrent threads are supported.\n";

    return 0;
}
```

#### join

`void join();`

Blocks the current thread until the thread identified by *this finishes its execution.  The completion of the thread identified by *this synchronizes with the corresponding successful return from join(). just like the join in C.

#### detach

`void detach();`

Separates the thread of execution from the thread object, allowing execution to continue independently. Any allocated resources will be freed once the thread exits.  After calling detach *this no longer owns any thread. 

```cpp
#include <iostream>
#include <thread>
#include <chrono>

using namespace std;

void fun()
{
    cout << "Thread is running...\n";
    this_thread::sleep_for(chrono::seconds(2));
    cout << "Exiting concurrent thread;\n";
}
int main(int argc, char **argv)
{
    thread t(fun);
    t.detach();
    this_thread::sleep_for(chrono::seconds(1));
    cout << "detached ok!\n";

    this_thread::sleep_for(chrono::seconds(5));
    cout << "main ok!\n";
    return 0;
}
```

#### swap

Exchanges the underlying handles of two thread objects. 

```cpp
#include <iostream>
#include <thread>
#include <chrono>

using namespace std;

void fun()
{
    for(int i=0; i < 5; i++)
        this_thread::sleep_for(chrono::seconds(1));
}

void foo()
{
    for(int i=0; i < 5; i++)
        this_thread::sleep_for(chrono::seconds(1));
}

int main(int argc, char **argv)
{
    thread t1(fun);
    thread t2(foo);

    cout << "t1 Id:" << t1.get_id() << "\n";
    cout << "t2 Id:" << t2.get_id() << "\n";

    cout << "\nswap thread:\n";
    swap(t1, t2);

    cout << "t1 Id:" << t1.get_id() << "\n";
    cout << "t2 Id:" << t2.get_id() << "\n";

    cout << "\nswap thread:\n";
    t1.swap(t2);

    cout << "t1 Id:" << t1.get_id() << "\n";
    cout << "t2 Id:" << t2.get_id() << "\n";

    t1.join();
    t2.join();

    return 0;
}
```

#### ~thread

`~thread();`

Destroys the thread object.

If *this has an associated thread (joinable() == true), std::terminate() is called.

**Notes**

A thread object does not have an associated thread (and is safe to destroy) after

- it was default-constructed
- it was moved from
- join() has been called
- detach() has been called 

## Function manageing the current thread

### yield(有让步的意思)

`void yield();`

Provides a hint to the implementation to reschedule the execution of threads, allowing other threads to run. 

**Note**: The exact behavior of this function depends on the implementation, in particular on the mechanics of the OS scheduler in use and the state of the system. For example, a first-in-first-out realtime scheduler (SCHED_FIFO in Linux) would suspend the current thread and put it on the back of the queue of the same-priority threads that are ready to run (and if there are no other threads at the same priority, yield has no effect). 

```cpp
#include <iostream>
#include <thread>
#include <chrono>

using namespace std;

void little_sleep(chrono::microseconds us)
{
    auto start = chrono::high_resolution_clock::now();
    auto end = start + us;

    do{
        this_thread::yield();// let the another thread to running... 让步
    }while( chrono::high_resolution_clock::now() < end );
}

int main(int argc, char **argv)
{
    auto start = chrono::high_resolution_clock::now();

    little_sleep(chrono::microseconds(100));

    auto elapsed = chrono::high_resolution_clock::now() - start;
    cout << "waited for " << chrono::duration_cast<chrono::microseconds>(elapsed).count() << " microseconds\n";

    return 0;
}
```

### get_id

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>

using namespace std;

mutex g_display_mutex;

void fun()
{
    thread::id this_id = this_thread::get_id();

    g_display_mutex.lock();
    cout << "thread " << this_id << " sleeping...\n";
    g_display_mutex.unlock();

    this_thread::sleep_for(chrono::seconds(1));
}

int main(int argc, char **argv)
{
    thread t1(fun);
    thread t2(fun);

    t1.join();
    t2.join();

    cout << "main Ok!\n";
    return 0;
}
```

### sleep_for

Blocks the execution of the current thread for at least the specified sleep_duration.

A steady clock is used to measure the duration. This function may block for longer than sleep_duration due to scheduling or resource contention delays. 

```cpp
/** it is better to use command g++ main.cpp -std=c++14 */
#include <iostream>
#include <chrono>
#include <thread>

using namespace std;

int main(int argc, char **argv)
{
    auto start = chrono::high_resolution_clock::now();
    this_thread::sleep_for(2s);
    auto end = chrono::high_resolution_clock::now();

    chrono::duration<double, milli> elapsed = end-start;
    cout << "Waited " << elapsed.count() << " ms\n";

    return 0;
}
```

### sleep_until

```cpp
template< class Clock, class Duration >
void sleep_until( const std::chrono::time_point<Clock,Duration>& sleep_time );
```
Blocks the execution of the current thread until specified sleep_time has been reached.

The clock tied to sleep_time is used, which means that adjustments of the clock are taken into account. Thus, the duration of the block might, but might not, be less or more than sleep_time - Clock::now() at the time of the call, depending on the direction of the adjustment. The function also may block for longer than until after sleep_time has been reached due to scheduling or resource contention delays. 

## Cache size access (目前,不懂)

defined in header <new>

### hardware_destructive_interference_size 

min offset to avoid false sharing

### hardware_constructive_interference_size

max offset to promote true sharing

## Mutual exclusion

Mutual exclusion algorithms prevent multiple threads from simultaneously(同时的) accessing shared resources. This prevents data races and provides support for synchronization between threads.

### mutex

Defined in header <mutex>

The mutex class is a synchronization primitive(原语) that can be used to protect shared data from being simultaneously accessed by multiple threads.  

mutex offers exclusive(独享), non-recursive ownership semantics(语义):

- A calling thread owns a mutex from the time that it successfully calls either lock or try_lock until it calls unlock.
- When a thread owns a mutex, all other threads will block (for calls to lock) or receive a false return value (for try_lock) if they attempt to claim(要求) ownership of the mutex.
- A calling thread must not own the mutex prior(在什么之前) to calling lock or try_lock. 

**The behavior of a program is undefined if a mutex is destroyed while still owned by any threads, or a thread terminates while owning a mutex. The mutex class satisfies all requirements of Mutex and StandardLayoutType.**

std::mutex is neither copyable nor movable. 

#### lock & try_clock & unlock

`void lock();`

Locks the mutex. If another thread has already locked the mutex, a call to lock will block execution until the lock is acquired.

**If lock is called by a thread that already owns the mutex, the behavior is undefined:** for example, the program may deadlock. An implementation that can detect the invalid usage is encouraged to throw a `std::system_error` with error condition `resource_deadlock_would_occur` instead of deadlocking.

Prior `unlock()` operations on the same mutex synchronize-with (as defined in `std::memory_order`) this operation. 

`bool try_lock();`

Tries to lock the mutex. Returns immediately. On successful lock acquisition returns true, otherwise returns false.

This function is allowed to fail spuriously(伪造的) and return false even if the mutex is not currently locked by any other thread.

If `try_lock` is called by a thread that already owns the mutex, the behavior is undefined.

Prior `unlock()` operation on the same mutex synchronizes-with (as defined in `std::memory_order`) this operation if it returns true. Note that prior `lock()` does not synchronize with this operation if it returns false. 

`void unlock();`

Unlocks the mutex.

The mutex must be locked by the current thread of execution, otherwise, the behavior is undefined.

This operation synchronizes-with (as defined in `std::memory_order`) any subsequent lock operation that obtains ownership of the same mutex. 

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>

using namespace std;

int g_num = 0;
mutex g_num_mutex;

void fun()
{
    for(int i=0; i<10; i++){
        //cout << "try_lock: " << g_num_mutex.try_lock() << "\n";

        g_num_mutex.lock();
        g_num++;
        cout << "Thread " << this_thread::get_id() << " g_num: " << g_num << "\n";
        g_num_mutex.unlock();
        this_thread::sleep_for(chrono::seconds(1));
    }
}

int main(int argc, char **argv)
{
    thread t1(fun);
    thread t2(fun);

    t1.join();
    t2.join();

    cout << "main ok!\n";
    return 0;
}
```

### time_mutex

The timed_mutex class is a synchronization primitive(原语) that can be used to protect shared data from being simultaneously accessed by multiple threads.

In a manner similar to mutex, `timed_mutex` offers exclusive, non-recursive ownership semantics. In addition, `timed_mutex` provides the ability to attempt to claim ownership of a `timed_mutex` with a timeout via the `try_lock_for()` and `try_lock_until()` methods.

#### try_lock_for

```cpp
template< class Rep, class Period >
bool try_lock_for( const std::chrono::duration<Rep,Period>& timeout_duration );
```

Tries to lock the mutex. Blocks until specified timeout_duration has elapsed or the lock is acquired, whichever comes first. On successful lock acquisition returns true, otherwise returns false.

**If `timeout_duration` is less or equal timeout_duration.zero(), the function behaves like try_lock().**

A steady clock is used to measure the duration. This function may block for longer than `timeout_duration` due to scheduling or resource contention delays.

As with try_lock(), this function is allowed to fail spuriously and return false even if the mutex was not locked by any other thread at some point during timeout_duration.

Prior unlock() operation on the same mutex synchronizes-with (as defined in `std::memory_order`) this operation if it returns true.

If `try_lock_for` is called by a thread that already owns the mutex, the behavior is undefined. 

```cpp
/** 这段实例代码的运行,需要特殊平台的支持. 没有测试成功 */
#include <iostream>
#include <mutex>
#include <thread>
#include <vector>
#include <sstream>
 
std::mutex cout_mutex; // control access to std::cout
std::timed_mutex mutex;
 
void job(int id) 
{
    using Ms = std::chrono::milliseconds;
    std::ostringstream stream;
 
    for (int i = 0; i < 3; ++i) {
        if (mutex.try_lock_for(Ms(100))) {
            stream << "success ";
            std::this_thread::sleep_for(Ms(100));
            mutex.unlock();
        } else {
            stream << "failed ";
        }
        std::this_thread::sleep_for(Ms(100));
    }
 
    std::lock_guard<std::mutex> lock(cout_mutex);
    std::cout << "[" << id << "] " << stream.str() << "\n";
}
 
int main() 
{
    std::vector<std::thread> threads;
    for (int i = 0; i < 4; ++i) {
        threads.emplace_back(job, i);
    }
 
    for (auto& i: threads) {
        i.join();
    }
}
```

#### try_lock_until

```cpp
template< class Clock, class Duration >
bool try_lock_until( const std::chrono::time_point<Clock,Duration>& timeout_time );
```

Tries to lock the mutex. Blocks until specified timeout_time has been reached or the lock is acquired, whichever comes first. On successful lock acquisition returns true, otherwise returns false.

If timeout_time has already passed, this function behaves like try_lock().

The clock tied to timeout_time is used, which means that adjustments of the clock are taken into account. Thus, the maximum duration of the block might, but might not, be less or more than timeout_time - Clock::now() at the time of the call, depending on the direction of the adjustment. The function also may block for longer than until after timeout_time has been reached due to scheduling or resource contention delays.

As with try_lock(), this function is allowed to fail spuriously and return false even if the mutex was not locked by any other thread at some point before timeout_time.

Prior unlock() operation on the same mutex synchronizes-with (as defined in std::memory_order) this operation if it returns true.

```cpp
/** 同样受到编译的限制 */
#include <iostream>
#include <thread>
#include <chrono>
#include <mutex>

using namespace std;

timed_mutex test_mutex;

void fun()
{
    auto now = chrono::steady_clock::now();
    test_mutex.try_lock_until(now + chrono::seconds(10));
    cout << "lock ok!\n";
}

int main(int argc, char **argv)
{
    lock_guard<timed_mutex> l(test_mutex);
    thread t(fun);
    t.join();

    cout << "main ok!";
    return 0;
}
```

### recursive_mutex

The `recursive_mutex` class is a synchronization primitive that can be used to protect shared data from being simultaneously accessed by multiple threads.

`recursive_mutex` offers exclusive, recursive ownership semantics:

A calling thread owns a `recursive_mutex` for a period of time that starts when it successfully calls either `lock` or `try_lock`. During this period(时期), the thread may make additional calls to lock or try_lock. The period of ownership ends when the thread makes a matching number of calls to unlock.

When a thread owns a recursive_mutex, all other threads will block (for calls to lock) or receive a false return value (for try_lock) if they attempt to claim ownership of the recursive_mutex.

The maximum number of times that a recursive_mutex may be locked is unspecified, but after that number is reached, calls to lock will throw std::system_error and calls to try_lock will return false. 

The behavior of a program is undefined if a recursive_mutex is destroyed while still owned by some thread. The recursive_mutex class satisfies all requirements of Mutex and StandardLayoutType. 

### recursive_timed_mutex

The recursive_timed_mutex class is a synchronization primitive that can be used to protect shared data from being simultaneously accessed by multiple threads.

In a manner similar to std::recursive_mutex, recursive_timed_mutex provides exclusive, recursive ownership semantics. In addition, recursive_timed_mutex provides the ability to attempt to claim ownership of a recursive_timed_mutex with a timeout via the try_lock_for and try_lock_until methods.

The recursive_timed_mutex class satisfies all requirements of TimedMutex and StandardLayoutType. 

#### shared_mutex

The shared_mutex class is a synchronization primitive that can be used to protect shared data from being simultaneously accessed by multiple threads. In contrast to other mutex types which facilitate exclusive access, a shared_mutex has two levels of access:

- shared:several threads can share ownership of the same mutex. 
- exclusive:only one thread can own the mutex. 

Shared mutexes are usually used in situations when multiple readers can access the same resource at the same time without causing data races, but only one writer can do so.

##### Shared locking

- lock_shared: locks the mutex for shared ownership, blocks if the mutex is not available
- try_lock_shared: tries to lock the mutex for shared ownership, returns if the mutex is not available
- unlock_shared: unlocks the mutex (shared ownership)

```cpp

/** shared_mutex 编译不通过 */
#include <iostream>
#include <thread>
#include <chrono>
#include <mutex>
#include <shared_mutex>

using namespace std;

class ThreadSafeCounter{
    public:
        ThreadSafeCounter() = default;

        /** mutiple threads/readers can read the counter's value at the same time */
        unsigned int get() const{
            shared_lock<shared_mutex> lock(_mutex);
            return _value;
        }

        /** only one thread.writer can increment/write the counter's value*/
        void increment(){
            unique_lock<shared_mutex> lock(_mutex);
            _value++;
        }

        /** only one thread.writer can reset/write the counter's value*/
        void reset(){
            unique_lock<shared_mutex> lock(_mutex);
            _value = 0;
        }

    private:
        mutable std::shared_mutex _mutex;
        unsigned int _value = 0;
};

int main(int argc, char **argv)
{
    ThreadSafeCounter counter;

    auto increment_and_print = [&counter](){
        for(int i=0; i<3; i++){
            counter.increment();
            cout << this_thread::get_id() << " " << counter.get() << "\n";
        }
    };

    thread thread1(increment_and_print);
    thread thread2(increment_and_print);

    thread1.join();
    thread2.join();

    return 0;
}
```

### shared_timed_mutex

The shared_timed_mutex class is a synchronization primitive that can be used to protect shared data from being simultaneously accessed by multiple threads. In contrast to other mutex types which facilitate exclusive access, a shared_timed_mutex has two levels of access:

- shared:several threads can share ownership of the same mutex. 
- exclusive:only one thread can own the mutex. 

Shared mutexes are usually used in situations when multiple readers can access the same resource at the same time without causing data races, but only one writer can do so.

In a manner similar to `timed_mutex`, `shared_timed_mutex` provides the ability to attempt to claim ownership of a `shared_timed_mutex` with a timeout via the `try_lock_for()`, `try_lock_until()`, `try_lock_shared_for()`, `try_lock_shared_until()` methods. 

### lock_guard

The class lock_guard is a mutex wrapper that provides a convenient RAII-style mechanism for owning a mutex for the duration of a scoped(作用域) block.

When a lock_guard object is created, it attempts to take ownership of the mutex it is given. When control leaves the scope in which the lock_guard object was created, the lock_guard is destructed and the mutex is released.

The lock_guard class is non-copyable. 

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>

using namespace std;

int g_i = 0;
mutex g_i_mutex;

void safe_increment()
{
    for(int i=0; i<10; i++){
        lock_guard<mutex> lock(g_i_mutex);
        ++g_i;

        this_thread::sleep_for(chrono::seconds(1));
        cout << this_thread::get_id() << ":" << g_i << "\n";
    }

    /** g_i_mutex is automatically released when lock goes out of scope */
}

int main()
{
    thread thread1(safe_increment);
    thread thread2(safe_increment);

    thread1.join();
    thread2.join();

    return 0;
}
```

### scoped_lock

The class scoped_lock is a mutex wrapper that provides a convenient RAII-style mechanism for owning one or more mutexes for the duration of a scoped block.

When a scoped_lock object is created, it attempts to take ownership of the mutexes it is given. When control leaves the scope in which the scoped_lock object was created, the scoped_lock is destructed and the mutexes are released, in reverse order. If several mutexes are given, deadlock avoidance algorithm is used as if by std::lock.

The scoped_lock class is non-copyable. The use way is same with `lock_guard`.

### unique_lock

The class unique_lock is a general-purpose mutex ownership wrapper allowing deferred locking, time-constrained attempts at locking, recursive locking, transfer of lock ownership, and use with condition variables.

The class unique_lock is movable, but not copyable -- it meets the requirements of MoveConstructible and MoveAssignable but not of CopyConstructible or CopyAssignable.

The class unique_lock meets the BasicLockable requirements. If Mutex meets the Lockable requirements, unique_lock also meets the Lockable requirements (ex.: can be used in std::lock); if Mutex meets the TimedLockable requirements, unique_lock also meets the TimedLockable requirements. 

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>

using namespace std;

struct Box{

    explicit Box(int num): num_things{num}{}

    int num_things;
    mutex m;
};

void transfer(Box &form, Box &to, int num)
{
    for(int i=0; i < 5; i++){

        this_thread::sleep_for(chrono::seconds(1));
        /** don't actually take the locks yet */
        unique_lock<mutex> lock1(form.m,defer_lock);
        unique_lock<mutex> lock2(to.m,defer_lock);

        /** lock both unique_locks without deadlock */
        lock(lock1,lock2);

        form.num_things -= num;
        to.num_things += num;

        /** from.m and to.m mutexes unlocked in unique_lock dtors */
        cout << this_thread::get_id() << ": " << form.num_things << "  " << to.num_things << "\n";
    }
}

int main(int argc, char **argv)
{
    Box bx1(100);
    Box bx2(50);

    thread t1(transfer,ref(bx1),ref(bx2),10);
    thread t2(transfer,ref(bx2),ref(bx1),5);

    t1.join();
    t2.join();

    return 0;
}
```

### shared_lock

The class shared_lock is a general-purpose shared mutex ownership wrapper allowing deferred locking, timed locking and transfer of lock ownership. Locking a shared_lock locks the associated shared mutex in shared mode (to lock it in exclusive mode, std::unique_lock can be used)

The shared_lock class is movable, but not copyable -- it meets the requirements of MoveConstructible and MoveAssignable but not of CopyConstructible or CopyAssignable.

In order to wait in a shared mutex in shared ownership mode, std::condition_variable_any can be used (std::condition_variable requires std::unique_lock and so can only wait in unique ownership mode) 

### defer_lock_t,try_to_lock_t,adopt_lock_t

- defer_lock_t: do not acquire ownership of the mutex
- try_to_lock_t:try to acquire ownership of the mutex without blocking
- adopt_lock_t: assume the calling thread already has ownership of the mutex

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>

using namespace std;

struct bank_account{
    explicit bank_account(int balance):balance(balance){}

    int balance;
    mutex m;
};

void transfer(bank_account &from,bank_account &to, int amount)
{
    /** lock both mutexes without deadlock */
    lock(from.m,to.m);

    /** make true both already locked mutexes are unlocked at the end of scope */
    lock_guard<mutex> lock1(from.m, adopt_lock);
    lock_guard<mutex> lock2(to.m, adopt_lock);

    /*
     * equivalent approach
     * unique_lock<mutex> lock1(from.m, defer_lock);
     * unique_lock<mutex> lock2(to.m, defer_lock);
     */

    from.balance -= amount;
    to.balance += amount;
}

int main(int argc, char **argv)
{
    bank_account my_account(100);
    bank_account your_account(50);

    thread t1(transfer,ref(my_account), ref(your_account), 10);
    thread t2(transfer,ref(your_account), ref(my_account), 5);

    t1.join();
    t2.join();

    cout << my_account.balance << " : " << your_account.balance << "\n";

    return 0;
}
```

### once_flag

The class std::once_flag is a helper structure for std::call_once.

An object of type std::once_flag that is passed to multiple calls to std::call_once allows those calls to coordinate with each other such that only one of the calls will actually run to completion.

std::once_flag is neither copyable nor movable. 

### call_once

```cpp
template< class Callable, class... Args >
void call_once( std::once_flag& flag, Callable&& f, Args&&... args );
```

Executes the Callable object f exactly once, even if called from several threads.

Each group of call_once invocations that receives the same std::once_flag object will meet the following requirements:

Exactly one execution of exactly one of the functions (passed as f to the invocations in the group) is performed. It is undefined which function will be selected for execution. The selected function runs in the same thread as the call_once invocation it was passed to. 

No invocation in the group returns before the abovementioned(上述的) execution of the selected function is completed successfully, that is, doesn't exit via an exception. 

If the selected function exits via exception, it is propagated(传送) to the caller. Another function is then selected and executed. 

```cpp
#include <iostream>
#include <thread>
#include <mutex>

using namespace std;

once_flag flag1,flag2;

void simple_do_once()
{
    call_once(flag1, [](){
            cout << "Simple example: called once.\n";
        });
}

int main(int argc, char **argv)
{
    thread t1(simple_do_once);
    thread t2(simple_do_once);
    thread t3(simple_do_once);

    t1.join(); t2.join(); t3.join();

    return 0;
}
```

```cpp
#include <iostream>
#include <thread>
#include <mutex>

using namespace std;

once_flag flag1;

void may_throw_function(bool do_throw)
{
    if(do_throw){
        cout << "throw: call_once will retry\n";
        throw exception();
    }
    cout << "Didn't throw, call_once will not attempt again\n'";
}

void do_once(bool do_throw)
{
    try{
        call_once(flag1,may_throw_function,do_throw);
    }

    catch(...){}
}

int main(int argc, char **argv)
{

    thread t1(do_once, true);
    thread t2(do_once, true);
    thread t3(do_once, false);
    thread t4(do_once, true);

    t1.join(); t2.join(); t3.join(); t4.join();

    return 0;
}
```

### condition_variable

The condition_variable class is a synchronization primitive that can be used to block a thread, or multiple threads at the same time, until another thread both modifies a shared variable (the condition), and notifies(通知) the condition_variable.

The thread that intends to modify the variable has to

- acquire a std::mutex (typically via std::lock_guard)
- perform the modification while the lock is held
- execute notify_one or notify_all on the std::condition_variable (the lock does not need to be held for notification) 

Even if the shared variable is atomic(原子), it must be modified under the mutex in order to correctly publish the modification to the waiting thread.

Any thread that intends to wait on std::condition_variable has to

- acquire a std::unique_lock<std::mutex>, on the same mutex as used to protect the shared variable
- execute wait, wait_for, or wait_until. The wait operations atomically release the mutex and suspend the execution of the thread.
- When the condition variable is notified, a timeout expires, or a spurious wakeup occurs, the thread is awakened(唤醒), and the mutex is atomically reacquired. The thread should then check the condition and resume waiting if the wake up was spurious(虚假的). 

- std::condition_variable works only with std::unique_lock<std::mutex>; this restriction allows for maximal efficiency on some platforms.- std::condition_variable_any provides a condition variable that works with any BasicLockable object, such as std::shared_lock.

Condition variables permit concurrent invocation of the wait, wait_for, wait_until, notify_one and notify_all member functions. 

#### notify_one

If any threads are waiting on *this, calling notify_one unblocks one of the waiting threads.

**Notes**: The effects of notify_one()/notify_all() and each of the three atomic parts of wait()/wait_for()/wait_until() (unlock+wait, wakeup, and lock) take place in a single total order that can be viewed as modification order of an atomic variable: the order is specific to this individual(单独的) condition_variable. This makes it impossible for notify_one() to, for example, be delayed(延迟) and unblock a thread that started waiting just after the call to notify_one() was made.

The notifying thread does not need to hold the lock on the same mutex as the one held by the waiting thread(s); in fact doing so is a pessimization(恶化), since the notified thread would immediately block again, waiting for the notifying thread to release the lock. However, some implementations (in particular many implementations of pthreads) recognize this situation and avoid this "hurry up and wait" scenario by transferring the waiting thread from the condition variable's queue directly to the queue of the mutex within the notify call, without waking it up.

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>
#include <condition_variable>

using namespace std;

condition_variable cv;
mutex cv_m;

int i = 0;
bool done = false;

void wait()
{
    unique_lock<mutex> lk(cv_m);
    cout << "Waiting...\n";

    cv.wait(lk,[]{return i==1;});
    cout << "...finished waiting i==1\n";
    done = true;
}

void signals()
{
    this_thread::sleep_for(chrono::seconds(1));
    cout << "Notifying falsely...\n";

    /** waiting thread is notified with 1==0 */
    /** cv.wait wakes up,checks i, and goes back to waiting */
    cv.notify_one();   

    unique_lock<mutex> lk(cv_m);
    i=1;
    while(!done){
        cout << "Notifying true changed...\n";
        lk.unlock();

        /** waiting thread is nodified with i==1, cv.wait returns */
        cv.notify_one();
        this_thread::sleep_for(chrono::seconds(1));
        lk.lock();
    }
}

int main(int argc, char **argv)
{
    thread t1(wait);
    thread t2(signals);

    t1.join();
    t2.join();

    return 0;
}
```

#### notify_all

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>
#include <condition_variable>

using namespace std;

condition_variable cv;
mutex cv_m;

int i = 0;

void wait()
{
    unique_lock<mutex> lk(cv_m);
    cerr << "Waiting...\n";

    cv.wait(lk,[]{return i==1;});
    cerr << "...finished waiting i==1\n";
}

void signals()
{
    this_thread::sleep_for(chrono::seconds(1));
    {
        lock_guard<mutex> lk(cv_m);
        cerr << "Notifying...\n";
    }
    cv.notify_all();

    this_thread::sleep_for(chrono::seconds(1));
    {
        lock_guard<mutex> lk(cv_m);
        i=1;
        cerr <<"Notifying again...\n";
    }
    cv.notify_all();
}

int main(int argc, char **argv)
{
    thread t1(wait);
    thread t2(wait);
    thread t3(wait);
    thread t4(signals);

    t1.join();
    t2.join();
    t3.join();
    t4.join();

    return 0;
}
```

#### wait

```cpp
void wait( std::unique_lock<std::mutex>& lock );

template< class Predicate >
void wait( std::unique_lock<std::mutex>& lock, Predicate pred );
```

wait causes the current thread to block until the condition variable is notified or a spurious(虚假的) wakeup occurs, optionally(选择性的) looping until some predicate is satisfied(一些断言被满足).

- Atomically releases lock, blocks the current executing thread, and adds it to the list of threads waiting on *this. The thread will be unblocked when notify_all() or notify_one() is executed. It may also be unblocked spuriously. When unblocked, regardless of the reason, lock is reacquired and wait exits. If this function exits via exception, lock is also reacquired.
- Equivalent to

```cpp
while (!pred()) {
wait(lock);
}
```

This overload may be used to ignore spurious awakenings while waiting for a specific condition to become true. Note that before enter to this method lock must be acquired, after wait(lock) exits it is also reacquired, i.e. lock can be used as a guard to pred() access.

If these functions fail to meet the postconditions (lock.owns_lock()==true and lock.mutex() is locked by the calling thread), std::terminate is called. For example, this could happen if relocking the mutex throws an exception,

Parameters

lock - an object of type std::unique_lock<std::mutex>, which must be locked by the current thread
pred - predicate which returns false if the waiting should be continued.

The signature of the predicate function should be equivalent to the following:

```cpp
bool pred();
```

#### wait_for

```cpp
template< class Rep, class Period >
std::cv_status wait_for( std::unique_lock<std::mutex>& lock, const std::chrono::duration<Rep, Period>& rel_time);

template< class Rep, class Period, class Predicate >
bool wait_for( std::unique_lock<std::mutex>& lock, const std::chrono::duration<Rep, Period>& rel_time, Predicate pred);
```

A steady clock is used to measure the duration. This function may block for longer than timeout_duration due to scheduling or resource contention delays. 

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>
#include <atomic>
#include <condition_variable>

using namespace std;

condition_variable cv;
mutex cv_m;

int i = 0;

void wait(int idx)
{
    unique_lock<mutex> lk(cv_m);
    if(cv.wait_for(lk,idx*100ms,[]{return i==1;}))
        cerr << "Thread " << idx << "finished waiting i == " << i << "\n";
    else
        cerr << "Thread " << idx << "time out i == " << i << "\n";

}

void signals()
{
    this_thread::sleep_for(120ms);
    cerr << "Notifying...\n";
    cv.notify_all();

    std::this_thread::sleep_for(100ms);
    {
        lock_guard<mutex> lk(cv_m);
        i=1;
    }

    cerr <<"Notifying again...\n";
    cv.notify_all();
}

int main(int argc, char **argv)
{
    thread t1(wait,1);
    thread t2(wait,2);
    thread t3(wait,3);
    thread t4(signals);

    t1.join();
    t2.join();
    t3.join();
    t4.join();

    return 0;
}
```

#### wait_until

```cpp
template< class Clock, class Duration >
std::cv_status wait_until( std::unique_lock<std::mutex>& lock, const std::chrono::time_point<Clock, Duration>& timeout_time );

template< class Clock, class Duration, class Predicate >
bool wait_until( std::unique_lock<std::mutex>& lock, const std::chrono::time_point<Clock, Duration>& timeout_time, Predicate pred );
```

wait_until causes the current thread to block until the condition variable is notified, a specific time is reached, or a spurious wakeup occurs, optionally looping until some predicate is satisfied.

- Atomically releases lock, blocks the current executing thread, and adds it to the list of threads waiting on *this. The thread will be unblocked when notify_all() or notify_one() is executed, or when the absolute time point timeout_time is reached. It may also be unblocked spuriously. When unblocked, regardless of the reason, lock is reacquired and wait_until exits. If this function exits via exception, lock is also reacquired. (until C++14)
- Equivalent to

```cpp
while (!pred()) {
    if (wait_until(lock, abs_time) == std::cv_status::timeout) {
        return pred();
    }
}
return true;
```

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <chrono>
#include <atomic>
#include <condition_variable>

using namespace std;

condition_variable cv;
mutex cv_m;

atomic<int> i{0};

void waits(int idx)
{
    unique_lock<mutex> lk(cv_m);
    auto now = chrono::system_clock::now();
    if(cv.wait_until(lk,now+idx*100ms,[]{return i == 1;}))
        cerr << "Thread " << idx << " finished waiting i == " << i << "\n";
    else
        cerr << "Thread " << idx << " timed out i == " << i << "\n";

}

void signals()
{
    this_thread::sleep_for(120ms);
    cerr << "Notifying...\n";
    cv.notify_all();

    this_thread::sleep_for(100ms);
    i = 1;
    cerr << "Notifying again...\n";
    cv.notify_all();
}

int main(int argc,char **argv)
{
    thread t1(waits,1);
    thread t2(waits,2);
    thread t3(waits,3);
    thread t4(signals);

    t1.join();
    t2.join();
    t3.join();
    t4.join();

    return 0;
}
```

#### notify_all_at_thread_exit

```cpp
void notify_all_at_thread_exit( std::condition_variable& cond, std::unique_lock<std::mutex> lk );
```

notify_all_at_thread_exit provides a mechanism to notify other threads that a given thread has completely finished, including destroying all thread_local objects. It operates as follows:

- Ownership(所有权) of the previously acquired lock lk is transferred to internal storage. 
- The execution environment is modified such that when the current thread exits, the condition variable cond is notified as if by: 

```cpp
lk.unlock();
cond.notify_all();
```

The implied(暗示) lk.unlock is sequenced after (as defined in std::memory_order) the destruction of all objects with thread local storage duration associated with the current thread.

An equivalent effect may be achieved with the facilities provided by std::promise or std::packaged_task. 

```cpp
/** 伪代码 */

#include <mutex>
#include <thread>
#include <condition_variable>

std::mutex m;
std::condition_variable cv;

bool ready = false;
ComplexType result;  // some arbitrary type

void thread_func()
{
    std::unique_lock<std::mutex> lk(m);
    // assign a value to result using thread_local data
    result = function_that_uses_thread_locals();
    ready = true;
    std::notify_all_at_thread_exit(cv, std::move(lk));
}   // 1. destroy thread_locals, 2. unlock mutex, 3. notify cv
 
int main()
{
    std::thread t(thread_func);
    t.detach();
 
    // do other work
    // ...
 
    // wait for the detached thread
    std::unique_lock<std::mutex> lk(m);
    while(!ready) {
        cv.wait(lk);
    }
    process(result); // result is ready and thread_local destructors have finished
}
```

- set_value_at_thread_exit: sets the result to specific value while delivering the notification only at thread exit
- make_ready_at_thread_exit: executes the function ensuring that the result is ready only once the current thread exits

#### cv_status

The scoped enumeration std::cv_status describes whether a timed wait returned because of timeout or not.

std::cv_status is used by the wait_for and wait_until methods of std::condition_variable and std::condition_variable_any.

- no_timeout:    the condition variable was awakened with notify_all, notify_one, or spuriously
- timeout:       the condition variable was awakened by timeout expiration

###  Futures

The standard library provides facilities(工具) to obtain values that are returned and to catch exceptions that are thrown by asynchronous tasks (i.e. functions launched in separate threads). These values are communicated in a shared state, in which the asynchronous task may write its return value or store an exception, and which may be examined, waited for, and otherwise manipulated by other threads that hold instances of std::future or std::shared_future that reference that shared state. 

#### promise

```cpp
template< class R > class promise;
template< class R > class promise<R&>;
template<>          class promise<void>;
```

1) base template
2) non-void specialization, used to communicate objects between threads
3) void specialization, used to communicate stateless events

The class template std::promise provides a facility to store a value or an exception that is later acquired asynchronously via a std::future object created by the std::promise object.

Each promise is associated with a shared state, which contains some state information and a result which may be not yet evaluated, evaluated to a value (possibly void) or evaluated to an exception. A promise may do three things with the shared state:

- make ready: the promise stores the result or the exception in the shared state. Marks the state ready and unblocks any thread waiting on a future associated with the shared state.
- release: the promise gives up its reference to the shared state. If this was the last such reference, the shared state is destroyed. Unless this was a shared state created by std::async which is not yet ready, this operation does not block.
- abandon: the promise stores the exception of type std::future_error with error code std::future_errc::broken_promise, makes the shared state ready, and then releases it. 

The promise is the "push" end of the promise-future communication channel: the operation that stores a value in the shared state synchronizes-with (as defined in std::memory_order) the successful return from any function that is waiting on the shared state (such as std::future::get). Concurrent access to the same shared state may conflict otherwise: for example multiple callers of std::shared_future::get must either all be read-only or provide external synchronization. 

```cpp
#include <iostream>
#include <thread>
#include <future>
#include <numeric>
#include <vector>
#include <chrono>

using namespace std;

void my_accumulate(vector<int>::iterator first,vector<int>::iterator last, promise<int> accumulate_promise)
{
    int sum = accumulate(first,last,0);
    accumulate_promise.set_value(sum);
}

void do_work(promise<void> barrier)
{
    this_thread::sleep_for(chrono::seconds(1));
    barrier.set_value();
}

int main(int argc, char **argv)
{
    /** demonstrate using promise<int> to transmit a result between threads */
    vector<int> numbers = {1,2,3,4,5,6};
    promise<int> accumulate_promise;
    future<int> accumulate_future = accumulate_promise.get_future();

    thread work_thread(my_accumulate,numbers.begin(),numbers.end(),move(accumulate_promise));
    /** wait for result */
    accumulate_future.wait();
    cout << "result = " << accumulate_future.get() << "\n";
    work_thread.join();

    /** demonstrate using promise<void> to signal state between threads */
    promise<void> barrier;
    future<void> barrier_future = barrier.get_future();

    thread new_work_thread(do_work,move(barrier));

    barrier_future.wait();
    new_work_thread.join();

    return 0;
}
```

#### std::promise::set_value

```cpp
void set_value( const R& value );
void set_value( R&& value );
void set_value( R& value );
void set_value();
```

```cpp
#include <iostream>
#include <thread>
#include <sstream>
#include <iterator>
#include <future>
#include <cctype>
#include <vector>
#include <algorithm>

using namespace std;

int main(int argc, char** argv)
{
    istringstream iss_numbers{"3 4 1 42 23 -23 93 2 -289 93"};
    istringstream iss_letters{" a 23 b,e a2 k k?a;si,ksa c"};

    vector<int> numbers;
    vector<char> letters;
    promise<void> numbers_promise, letters_promise;

    auto number_future = numbers_promise.get_future();
    auto letter_future = letters_promise.get_future();

    thread value_reader([&]
    {
        copy(istream_iterator<int>{iss_numbers},istream_iterator<int>{},back_inserter(numbers));
        numbers_promise.set_value();

        copy_if(istream_iterator<char>{iss_letters},istream_iterator<char>{},back_inserter(letters),::isalpha);
        letters_promise.set_value();
    });

    number_future.wait();
    sort(numbers.begin(),numbers.end());

    if(letter_future.wait_for(chrono::seconds(1)) == future_status::timeout )
    {
        for(int num:numbers){
            cout << num << " ";
        }
        cout << "\n";
        numbers.clear();
    }

    letter_future.wait();
    sort(letters.begin(),letters.end());

    for(int num:numbers){
        cout << num << " ";
    }
    cout << "\n";

    for(char let:letters){
        cout << let << " ";
    }
    cout << "\n";

    value_reader.join();

    return 0;
}
```

#### std::promise::set_value_at_thread_exit

```cpp
void set_value_at_thread_exit( const R& value );
void set_value_at_thread_exit( R&& value );
void set_value_at_thread_exit( R& value );
void set_value_at_thread_exit()
```

Stores the value into the shared state without making the state ready immediately. The state is made ready when the current thread exits, after all variables with thread-local storage duration have been destroyed.

```cpp
#include <iostream>
#include <thread>
#include <future>
#include <chrono>

using namespace std;

int main(int argc, char **argv)
{
    promise<int> num_promise;
    future<int> num_future = num_promise.get_future();

    thread([&num_promise]{
                this_thread::sleep_for(chrono::seconds(1));
                num_promise.set_value_at_thread_exit(9);
            }).detach();

    cout << "Waiting..." << flush;
    num_future.wait();

    cout << "Done\nResult: " << num_future.get() << "\n";

    return 0;
}
```

#### std::promise::set_exception

```cpp
void set_exception( std::exception_ptr p );
```

Atomically stores the exception pointer p into the shared state and makes the state ready.

```cpp
#include <iostream>
#include <thread>
#include <future>

using namespace std;

int main(int argc, char **argv)
{
    promise<int> my_promise;
    future<int> my_future = my_promise.get_future();

    thread t([&my_promise]{
            
            try{
                throw runtime_error("Example");
            }catch(...){

                try{
                    my_promise.set_exception(current_exception());
                }catch(...){
                
                }

            }

            });

    try{
        my_future.get();
    }catch(const exception& e){
        cout << "Exception from the thread: " << e.what() << "\n";
    }

    t.join();

    return 0;
}
```

```cpp
void set_exception_at_thread_exit( std::exception_ptr p );
```

Stores the exception pointer p into the shared state without making the state ready immediately. The state is made ready when the current thread exits, after all variables with thread-local storage duration have been destroyed. 

### std::packaged_task

The class template `std::packaged_task` wraps any Callable target (function, lambda expression, bind expression, or another function object) so that it can be invoked asynchronously(异步). Its return value or exception thrown is stored in a shared state which can be accessed through std::future objects.

Just like std::function, std::packaged_task is a polymorphic(多态性), allocator-aware container: the stored callable target may be allocated on heap or with a provided allocator. 

```cpp
packaged_task();

template <class F>
explicit packaged_task( F&& f );

template <class F, class Allocator>
explicit packaged_task( std::allocator_arg_t, const Allocator& a, F&& f );

template <class F, class Allocator>
packaged_task( std::allocator_arg_t, const Allocator& a, F&& f );

packaged_task( packaged_task& ) = delete;
packaged_task( const packaged_task& ) = delete;
packaged_task( packaged_task&& rhs );
```

```cpp
#include <iostream>
#include <cmath>
#include <thread>
#include <future>
#include <functional>

using namespace std;

int f(int x,int y){
    return pow(x,y);
}

void task_lambda()
{
    packaged_task<int(int,int)> task([](int a,int b){
                return pow(a,b);
            });
    future<int> result = task.get_future();

    task(2,9);

    cout << "task_lambda:\t" << result.get() << "\n";
}

void task_bind()
{
    packaged_task<int()> task(bind(f,2,11));
    future<int> result = task.get_future();

    task();

    cout << "task_bind:\t" << result.get() << "\n";
}

void task_thread()
{
    packaged_task<int(int,int)> task(f);
    future<int> result = task.get_future();

    thread task_td(move(task),2,10);

    task_td.join();

    cout << "task_thread:\t" << result.get() << "\n";
}

int main(int argc,char** argv)
{
    task_lambda();
    task_bind();
    task_thread();

    return 0;
}
```

```cpp
#include <iostream>
#include <future>
#include <thread>

using namespace std;

int fib(int n)
{
    if(n < 3)
        return 1;
    else
        return fib(n-1) + fib(n-2);
}

int main(int argc, char** argv)
{
    packaged_task<int(int)> fib_task(&fib);

    cout << "starting task\n";
    auto result = fib_task.get_future();

    thread t(move(fib_task),40);

    cout << "waiting for task to finish...\n";
    cout << result.get() << "\n";

    cout << "task complete\n";

    t.join();

    return 0;
}
```

#### std::packaged_task::valid

```cpp
bool valid() const;
```

Checks whether *this has a shared state. 

#### std::packaged_task::swap

```cpp
void swap( packaged_task& other );
```

Exchanges the shared states and stored tasks of *this and other. 

#### std::packaged_task::get_future

```cpp
std::future<R> get_future();
```

Returns a future which shares the same shared state as *this.  get_future can be called only once for each packaged_task

#### std::packaged_task::operator

```cpp
void operator()( ArgTypes... args );
```

Calls the stored task with args as the arguments. The return value of the task or any exceptions thrown are stored in the shared state. The shared state is made ready and any threads waiting for this are unblocked

#### std::packaged_task::make_ready_at_thread_exit

```cpp
void make_ready_at_thread_exit( ArgTypes... args );
```

Calls the stored task with forwarded args as the arguments. The return value of the task or any exception thrown by it is stored in the shared state of *this.

The shared state is only made ready after the current thread exits and all objects of thread local storage duration are destroyed. 

```cpp
#include <iostream>
#include <thread>
#include <future>
#include <chrono>
#include <functional>
#include <utility>

using namespace std;

void worker(future<void>& output)
{
    packaged_task<void(bool&)> my_task{ [](bool& done){ done=true;} };
    auto result = my_task.get_future();

    bool done = false;
    my_task.make_ready_at_thread_exit(done);

    cout << "worker:done = " << boolalpha << done << "\n";

    auto status = result.wait_for(chrono::seconds(0));
    if(status == future_status::timeout){
        cout << "worker:result is not ready yet\n";
    }

    output = move(result);
}

int main(int argc, char** argv)
{
    future<void> result;

    thread{worker,ref(result)}.join();

    auto status = result.wait_for(chrono::seconds(0));
    if(status == future_status::ready){
        cout << "worker:result is ready\n";
    }
    return 0;
}
```

#### std::packaged_task::reset

```cpp
void reset();
```

Resets the state abandoning the results of previous executions. New shared state is constructed.

Equivalent to *this = packaged_task(std::move(f)), where f is the stored task. 

```cpp
#include <iostream>
#include <thread>
#include <future>
#include <cmath>

using namespace std;


int main(int argc,char** argv)
{
    packaged_task<int(int,int)> task([](int a,int b){
        return pow(a,b);
    });

    future<int> result = task.get_future();

    task(2,9);
    cout << "2^9 = " << result.get() << "\n";

    task.reset();
    result = task.get_future();

    thread task_td(move(task),2,10);
    task_td.join();
    cout << "2^10 = " << result.get() << "\n";

    return 0;
}
```

### std::future

The class template std::future provides a mechanism to access the result of asynchronous operations:

An asynchronous operation (created via std::async, std::packaged_task, or std::promise) can provide a std::future object to the creator of that asynchronous operation. 

The creator of the asynchronous operation can then use a variety of methods to query, wait for, or extract a value from the std::future. These methods may block if the asynchronous operation has not yet provided a value. 

When the asynchronous operation is ready to send a result to the creator, it can do so by modifying shared state (e.g. std::promise::set_value) that is linked to the creator's std::future. 

Note that std::future references shared state that is not shared with any other asynchronous return objects (as opposed to std::shared_future). 

```cpp
#include <iostream>
#include <future>
#include <thread>

using namespace std;

int main(int aegc, char** argv)
{
    /** future from a packaged_task */
    packaged_task<int()> task([](){return 7;});
    future<int> f1 = task.get_future();
    thread(move(task)).detach();

    /** future from an async() */
    future<int> f2 = async(launch::async,[](){return 8;});

    /** future from a promise */
    promise<int> p;
    future<int> f3 = p.get_future();
    thread( [&p]{p.set_value_at_thread_exit(9);}).detach();

    cout << "waiting..." << flush;

    f1.wait();
    f2.wait();
    f3.wait();

    cout << "Done!\n Results are: " << f1.get() << "\t" << f2.get() << "\t" << f3.get();
    return 0;
}
```

- future::share:        transfers the shared state from *this to a shared_future and returns it
- future::get:          returns the result
- future::valid:        checks if the future has a shared state
- future::wait:         waits for the result to become available
- future::wait_for:     waits for the result, returns if it is not available for the specified timeout duration
- future::wait_until:   waits for the result, returns if it is not available until specified time point has been reached


### std::shared_future

The class template std::shared_future provides a mechanism to access the result of asynchronous operations, similar to std::future, except that multiple threads are allowed to wait for the same shared state. Unlike std::future, which is only moveable (so only one instance can refer to any particular asynchronous result), std::shared_future is copyable and multiple shared future objects may refer to the same shared state.

Access to the same shared state from multiple threads is safe if each thread does it through its own copy of a shared_future object. 

```cpp
#include <iostream>
#include <future>
#include <chrono>

using namespace std;

int main(int argc, char** argv)
{
    promise<void> ready_promise,t1_ready_promise,t2_ready_promise;
    shared_future<void> ready_future = ready_promise.get_future();

    chrono::time_point<chrono::high_resolution_clock> start;

    auto fun1 = [&, ready_future]() -> chrono::duration<double,milli>
    {
        t1_ready_promise.set_value();
        ready_future.wait();
        return chrono::high_resolution_clock::now() - start;
    };

    auto fun2 = [&, ready_future]() -> chrono::duration<double,milli>
    {
        t2_ready_promise.set_value();
        ready_future.wait();
        return chrono::high_resolution_clock::now() - start;
    };

    auto result1 = async(launch::async, fun1);
    auto result2 = async(launch::async, fun2);

    t1_ready_promise.get_future().wait();
    t2_ready_promise.get_future().wait();

    start = chrono::high_resolution_clock::now();

    ready_promise.set_value();

    cout << "Thread1 received the signal " << result1.get().count() << "ms after start\n";
    cout << "Thread2 received the signal " << result2.get().count() << "ms after start\n";

    return 0;
}
```

#### std::async

```cpp
template< class Function, class... Args>
std::future<typename std::result_of<Function(Args...)>::type>
    async( Function&& f, Args&&... args );

template< class Function, class... Args>
std::future<std::result_of_t<std::decay_t<Function>(std::decay_t<Args>...)>>
    async( Function&& f, Args&&... args );

template< class Function, class... Args >
std::future<typename std::result_of<Function(Args...)>::type>
    async( std::launch policy, Function&& f, Args&&... args );

template< class Function, class... Args >
std::future<std::result_of_t<std::decay_t<Function>(std::decay_t<Args>...)>>
    async( std::launch policy, Function&& f, Args&&... args );
```

The template function async runs the function f asynchronously (potentially(潜在的) in a separate thread which may be part of a thread pool) and returns a std::future that will eventually(最终) hold the result of that function call.

- Behaves the same as async(std::launch::async | std::launch::deferred(延迟), f, args...). In other words, f may be executed in another thread or it may be run synchronously when the resulting std::future is queried(查询) for a value.
- Calls a function f with arguments args according to a specific launch policy policy:

If the async flag is set (i.e. policy & std::launch::async != 0), then async executes the function f on a new thread of execution (with all thread-locals initialized) as if spawned(孵化) by std::thread(f, args...), except that if the function f returns a value or throws an exception, it is stored in the shared state accessible through the std::future that async returns to the caller.

If the deferred flag is set (i.e. policy & std::launch::deferred != 0), then async converts args... the same way as by std::thread constructor, but does not spawn a new thread of execution. Instead, lazy evaluation(评价) is performed: the first call to a non-timed wait function on the std::future that async returned to the caller will cause f(args...) to be executed in the current thread (which does not have to be the thread that originally called std::async). The result or exception is placed in the shared state associated with the future and only then it is made ready. All further accesses to the same std::future will return the result immediately.

If both the std::launch::async and std::launch::deferred flags are set in policy, it is up to the implementation whether to perform asynchronous execution or lazy evaluation. 

If neither std::launch::async nor std::launch::deferred, nor any implementation-defined policy flag is set in policy, the behavior is undefined. 

In any case, the call to std::async synchronizes-with (as defined in std::memory_order) the call to f, and the completion(完成) of f is sequenced-before making the shared state ready. If the async policy is chosen, the associated thread completion synchronizes-with the successful return from the first function that is waiting on the shared state, or with the return of the last function that releases the shared state, whichever comes first. 

```cpp
#include <iostream>
#include <vector>
#include <future>
#include <numeric>
#include <algorithm>

using namespace std;

template <typename RAIter>
int paralle_sum(RAIter beg,RAIter end)
{
    auto len = end - beg;
    if(len < 1000)
        return accumulate(beg,end,0);

    RAIter mid = beg + len/2;
    auto handle = async(launch::async, paralle_sum<RAIter>,mid,end);

    int sum = paralle_sum(beg,mid);
    return sum + handle.get();
}

int main()
{
    vector<int> v(10000,1);
    cout << "The Sum is " << paralle_sum(v.begin(),v.end()) << "\n";
    return 0;
}
```

#### std::launch

```cpp
enum class launch : /* unspecified(未指定) */ {
    async =    /* unspecified */,
    deferred = /* unspecified */,
    /* implementation-defined */
};
```

Specifies the launch policy for a task executed by the std::async function. std::launch is an enumeration used as BitmaskType.

The following constants denoting individual bits are defined by the standard library:

- std::launch::async  a new thread is launched to execute the task asynchronously
- std::launch::deferred   the task is executed on the calling thread the first time its result is requested (lazy evaluation)

In addition, implementations are allowed to:

- define additional bits and bitmasks to specify restrictions on task interactions applicable to a subset of launch policies, and
enable those additional bitmasks for the first (default) overload of std::async. 

#### std::future_status

```cpp
enum class future_status {
    ready,
    timeout,
    deferred
};
```

Specifies state of a future as returned by wait_for and wait_until functions of std::future and std::shared_future.

- deferred    the shared state contains a deferred function, so the result will be computed only when explicitly requested
- ready   the shared state is ready
- timeout     the shared state did not become ready before specified timeout duration has passed 

#### std::future_error

The class std::future_error defines an exception object that is thrown on failure by the functions in the thread library that deal with asynchronous execution and shared states (std::future, std::promise, etc). Similar to std::system_error, this exception carries an error code compatible(兼容) with std::error_code. 

- code returns the error code
- what returns the explanatory string specific to the error code

```cpp
#include <iostream>
#include <future>

using namespace std;

int main(int argc, char** argv)
{
    future<int> empty;

    try{
        int n = empty.get();
    }catch(const future_error& e){
        cout << "Caught a future_error with code " << e.code() << "\n Message:" << e.what() << "\n";
    }

    return 0;
}
```

#### std::future_category(类别)

```cpp
const std::error_category& future_category();
```

Obtains a reference to the static error category object for the errors related to futures and promises. The object is required to override the virtual function error_category::name() to return a pointer to the string "future". It is used to identify error codes provided in the exceptions of type std::future_error. 

#### std::future_errc

```cpp
enum class future_errc {
    broken_promise             = /* implementation-defined */,
    future_already_retrieved   = /* implementation-defined */,
    promise_already_satisfied  = /* implementation-defined */,
    no_state                   = /* implementation-defined */
};
```

The scoped enumeration std::future_errc defines the error codes reported by std::future and related classes in std::future_error exception objects. Only four error codes are required, although the implementation may define additional error codes. Because the appropriate specialization of std::is_error_code_enum is provided, values of type std::future_errc are implicitly convertible to std::error_code.

- broken_promise  the asynchronous task abandoned its shared state
- future_already_retrieved    the contents of shared state were already accessed through std::future
- promise_already_satisfied   attempt to store a value in the shared state twice
- no_state    attempt to access std::promise or std::future without an associated shared state

# Reference

- [cppreference](http://en.cppreference.com/w/cpp/thread)
- [c thread](http://en.cppreference.com/w/c/thread)

---
