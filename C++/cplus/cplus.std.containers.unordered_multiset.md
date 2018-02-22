### std::unordered_multiset

```cpp
template < class Key,                         // unordered_multiset::key_type/value_type
           class Hash = hash<Key>,            // unordered_multiset::hasher
           class Pred = equal_to<Key>,        // unordered_multiset::key_equal
           class Alloc = allocator<Key>       // unordered_multiset::allocator_type
           > class unordered_multiset;
```

#### Unordered Multiset

Unordered multisets are containers that store elements in no particular order, allowing fast retrieval of individual elements based on their value, much like unordered_set containers, **but allowing different elements to have equivalent values.**

In an unordered_multiset, the value of an element is at the same time its key, used to identify it. Keys are immutable(不可变的), therefore, the elements in an unordered_multiset cannot be modified once in the container - they can be inserted and removed, though.

Internally, the elements in the unordered_multiset are not sorted in any particular, but organized into buckets depending on their hash values to allow for fast access to individual elements directly by their values (with a constant average time complexity on average).

Elements with equivalent values are grouped together in the same bucket and in such a way that an iterator (see equal_range) can iterate through all of them.

Iterators in the container are at least forward iterators.

**Notice** that this container is not defined in its own header, but shares header <unordered_set> with unordered_set.

#### Example

```cpp
#include <iostream>
#include <string>
#include <unordered_set>    ///> Note: use the unordered_set header

using namespace std;

template<class T>
T cmerge(T a, T b){
    T t(a);
    t.insert(b.begin(), b.end());
    return t;
}

int main(int argc, char **argv)
{
    unordered_multiset<string> first1;
    unordered_multiset<string> first2( {"one", "two", "three"} );
    unordered_multiset<string> first3( {"red", "green", "blue"} );
    unordered_multiset<string> first4( first2 );
    unordered_multiset<string> first5( cmerge(first4,first3) );
    unordered_multiset<string> first6( first5.begin(), first5.end() );

    cout << "\nFirst6 set: ";
    for(const string& x: first6 ){
        cout << "  " << x;
    }

    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/unordered_set/unordered_multiset/)
