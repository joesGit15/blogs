### C++ class virtual function

```cpp
#include <iostream>

using namespace std;

class BaseClass
{
public:
    BaseClass(int x) { i = x; }

    virtual void myFunction(){
        cout << "Using BaseClass version of myFunction(): ";
        cout << i << '\n';
    }

    int i;
};

class DerivedClass1 : public BaseClass
{
public:
    DerivedClass1(int x) : BaseClass(x) {}

    void myFunction() {
        cout << "Using DerivedClass1's version of myFunction(): ";
        cout << i*i << '\n';
    }
};

class DerivedClass2 : public BaseClass
{
public:
    DerivedClass2(int x) : BaseClass(x) {}
    void myFunction() {
        cout << "Using DerivedClass2's version of myFunction(): ";
        cout << i+i << '\n';
    }
};

int main()
{
    BaseClass *p;
    BaseClass ob(10);
    DerivedClass1 derivedObject1(10);
    DerivedClass2 derivedObject2(10);

    p = &ob;
    p->myFunction(); /// use BaseClass's myFunction()

    p = &derivedObject1;
    p->myFunction(); /// use DerivedClass1's myFunction()

    p = &derivedObject2;
    p->myFunction(); /// use DerivedClass2's myFunction()

    return 0;
}
```

---
