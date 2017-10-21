## QScopedpointer

### detailed description

the QScopedpointer class stores a pointer to a dynamically allocated object, and deletes it upon destruction.

managing heap allocated objects manually is hard and error prone, with the common result that code leaks memory and is hard to maintain. QScopedpointer is a small utility class that heavily simplifies this by assigning stack-based memory ownership to heap allocations, more generally called resource acquisition is initialization(raii).

QScopedpointer guarantees that the object pointed to will get deleted when the current scope disappears.

consider this function which does heap allocations, and has various exit points:

```cpp
void myfunction(bool usesubclass)
{
    myclass *p = usesubclass ? new myclass() : new mysubclass;
    qiodevice *device = handsoverownership();

    if (m_value > 3) {
        delete p;
        delete device;
        return;
    }

    try {
        process(device);
    }
    catch (...) {
        delete p;
        delete device;
        throw;
    }

    delete p;
    delete device;
}
```

it's encumbered by the manual delete calls. with QScopedpointer, the code can be simplified to:

```cpp
void myfunction(bool usesubclass)
{
    // assuming that myclass has a virtual destructor
    QScopedpointer<myclass> p(usesubclass ? new myclass() : new mysubclass);
    QScopedpointer<qiodevice> device(handsoverownership());

    if (m_value > 3)
        return;

    process(device);
}
```

the code the compiler generates for QScopedpointer is the same as when writing it manually. code that makes use of delete are candidates for QScopedpointer usage (and if not, possibly another type of smart pointer such as QSharedPointer). QScopedpointer intentionally has no copy constructor or assignment operator, such that ownership and lifetime is clearly communicated.

The const qualification on a regular C++ pointer can also be expressed with a QScopedpointer:

```cpp
      const QWidget *const p = new QWidget();
      // is equivalent to:
      const QScopedpointer<const QWidget> p(new QWidget());

      QWidget *const p = new QWidget();
      // is equivalent to:
      const QScopedpointer<QWidget> p(new QWidget());

      const QWidget *p = new QWidget();
      // is equivalent to:
      QScopedpointer<const QWidget> p(new QWidget());
```

### Custom Cleanup Handlers

Arrays as well as pointers that have been allocated with malloc must not be deleted using delete. QScopedpointer's second template parameter can be used for custom cleanup handlers.

The following custom cleanup handlers exist:

- QScopedpointerDeleter - the default, deletes the pointer using delete
- QScopedpointerArrayDeleter - deletes the pointer using delete []. Use this handler for pointers that were allocated with new [].
- QScopedpointerPodDeleter - deletes the pointer using free(). Use this handler for pointers that were allocated with malloc().
- QScopedpointerDeleteLater - deletes a pointer by calling deleteLater() on it. Use this handler for pointers to QObject's that are actively participating in a QEventLoop.

You can pass your own classes as handlers, provided that they have a public static function void cleanup(T \*pointer).

```cpp
  // this QScopedpointer deletes its data using the delete[] operator:
  QScopedpointer<int, QScopedpointerArrayDeleter<int> > arrayPointer(new int[42]);

  // this QScopedpointer frees its data using free():
  QScopedpointer<int, QScopedpointerPodDeleter> podPointer(reinterpret_cast<int *>(malloc(42)));

  // this struct calls "myCustomDeallocator" to delete the pointer
  struct ScopedPointerCustomDeleter
  {
      static inline void cleanup(MyCustomClass *pointer)
      {
          myCustomDeallocator(pointer);
      }
  };

  // QScopedpointer using a custom deleter:
  QScopedpointer<MyCustomClass, ScopedPointerCustomDeleter> customPointer(new MyCustomClass);

```

### Forward Declared Pointers

Classes that are forward declared can be used within QScopedpointer, as long as the destructor of the forward declared class is available whenever a QScopedpointer needs to clean up.

Concretely, this means that all classes containing a QScopedpointer that points to a forward declared class must have non-inline constructors, destructors and assignment operators:

```cpp
  class MyPrivateClass; // forward declare MyPrivateClass

  class MyClass
  {
  private:
      QScopedpointer<MyPrivateClass> privatePtr; // QScopedpointer to forward declared class

  public:
      MyClass(); // OK
      inline ~MyClass() {} // VIOLATION - Destructor must not be inline

  private:
      Q_DISABLE_COPY(MyClass) // OK - copy constructor and assignment operators
                               // are now disabled, so the compiler won't implicitely
                               // generate them.
  };
```

Otherwise, the compiler output a warning about not being able to destruct MyPrivateClass.

### Related Classed

- QSharedPointer.
