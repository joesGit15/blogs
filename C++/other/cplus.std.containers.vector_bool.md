#### std::vector<bool>

```cpp
template < class T, class Alloc = allocator<T> > class vector; // generic template
template <class Alloc> class vector<bool,Alloc>;               // bool specialization(特殊化)
```

#### Vector of bool

This is a specialized version of vector, which is used for elements of type bool and optimizes(最优化) for space.

It behaves like the unspecialized version of vector, with the following changes:

The storage is not necessarily an array of bool values, but the library implementation may optimize storage so that each value is stored in a single bit.

Elements are not constructed using the allocator object, but their value is directly set on the proper bit in the internal storage.

Member function flip and a new signature(签名) for member swap.

A special member type, reference, a class that accesses individual bits in the container's internal storage with an interface that emulates(模仿) a bool reference. Conversely(相反的), member type const_reference is a plain bool.

The pointer and iterator types used by the container are not necessarily neither pointers nor conforming iterators, although they shall simulate(模拟) most of their expected behavior.

These changes provide a quirky interface to this specialization and favor memory optimization over processing (which may or may not suit your needs). In any case, it is not possible to instantiate the unspecialized template of vector for bool directly. Workarounds to avoid this range from using a different type (char, unsigned char) or container (like deque) to use wrapper types or further specialize for specific allocator types.

bitset is a class that provides a similar functionality for fixed-size arrays of bits.

#### Member functions

- **flip**: Flip bits (public member function )
- **swap**: Swap containers or elements (public member function )

#### Non-member class specializations

- **hash<vector<bool>>**: Hash for vector (class template specialization )

#### Data races

Simultaneous access to different elements is not guaranteed to be thread-safe (as storage bytes may be shared by multiple bits).

#### Example

```cpp
#include <iostream>
#include <vector>

using namespace std;

int main(int argc, char **argv)
{
    vector<bool> flags;

    flags.push_back(true);
    flags.push_back(false);
    flags.push_back(false);
    flags.push_back(true);

    flags.flip(); // false true true false

    cout << "flags value:";
    for(int i=0; i < flags.size(); i++)
        cout << " " << flags.at(i);

    cout << "\n";
    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/vector/vector-bool/)

---
