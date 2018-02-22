### std::multimap

```cpp
template < class Key,                                     // multimap::key_type
           class T,                                       // multimap::mapped_type
           class Compare = less<Key>,                     // multimap::key_compare
           class Alloc = allocator<pair<const Key,T> >    // multimap::allocator_type
           > class multimap;
```

#### Multiple-key map

Multimaps are associative containers that store elements formed by a combination of a key value and a mapped value, following a specific order, and **where multiple elements can have equivalent keys.**

In a multimap, the key values are generally used to sort and uniquely identify the elements, while the mapped values store the content associated to this key. The types of key and mapped value may differ, and are grouped together in member type value_type, which is a pair type combining both:

`typedef pair<const Key, T> value_type;`

Internally, the elements in a multimap are always sorted by its key following a specific strict weak ordering criterion indicated by its internal comparison object (of type Compare).

multimap containers are generally slower than unordered_multimap containers to access individual elements by their key, but they allow the direct iteration on subsets based on their order.

Multimaps are typically implemented as binary search trees.

#### Container properties

- **Associative**:                Elements in associative containers are referenced by their key and not by their absolute position in the container.
- **Ordered**:                    The elements in the container follow a strict order at all times. All inserted elements are given a position in this order.
- **Map**:                        Each element associates a key to a mapped value: Keys are meant to identify the elements whose main content is the mapped value.
- **Multiple equivalent keys**:   Multiple elements in the container can have equivalent keys.
- **Allocator-aware**:            The container uses an allocator object to dynamically handle its storage needs.

#### Template parameters

- **Key**:        Type of the keys. Each element in a map is identified by its key value.    Aliased as member type multimap::key_type.
- **T**:          Type of the mapped value. Each element in a multimap stores some data as its mapped value.    Aliased as member type multimap::mapped_type.
- **Compare**:    A binary predicate that takes two element keys as arguments and returns a bool. The expression comp(a,b), where comp is an object of this type and a and b are element keys, shall return true if a is considered to go before b in the strict weak ordering the function defines.    The multimap object uses this expression to determine both the order the elements follow in the container and whether two element keys are equivalent (by comparing them reflexively: they are equivalent if !comp(a,b) && !comp(b,a)).    This can be a function pointer or a function object (see constructor for an example). This defaults to less<T>, which returns the same as applying the less-than operator (a<b).   Aliased as member type multimap::key_compare.
- **Alloc**:      Type of the allocator object used to define the storage allocation model. By default, the allocator class template is used, which defines the simplest memory allocation model and is value-independent.
    Aliased as member type multimap::allocator_type.

Multimap 的函数和map的相同, 所以就不记录了. 直接写一些代码例子, Map的详细说明, [参见这里](http://www.cnblogs.com/zi-xing/p/6242369.html);

#### Code

```cpp
#include <iostream>
#include <map>

bool fncomp(char lhs,char rhs)
{ return lhs < rhs; }

struct classcomp
{
    bool operator() (const char &lhs, const char &rhs)
    { return lhs < rhs; }
};

int main(int argc, char **argv)
{
    multimap<char,int> first;

    first.insert( pair<char,int>('a',10) );
    first.insert( pair<char,int>('b',20) );
    first.insert( pair<char,int>('b',20) );
    first.insert( pair<char,int>('c',30) );

    multimap<char,int> first1( first.begin(), begin.end());
    multimap<char,int> first2(first1);
    multimap<char,int, classcomp> first3;

    bool (* fn_pt)(char ,char) =fncomp;
    multimap<char,int, bool(*)(char,char)> first4(fn_pt);
    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/map/multimap/)

---
