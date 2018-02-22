### std::unordered_set

```cpp
template < class Key,                        // unordered_set::key_type/value_type
           class Hash = hash<Key>,           // unordered_set::hasher
           class Pred = equal_to<Key>,       // unordered_set::key_equal
           class Alloc = allocator<Key>      // unordered_set::allocator_type
           > class unordered_set;
```

#### Unordered Set

Unordered sets are containers that **store unique elements in no particular order, and which allow for fast retrieval of individual elements based on their value.**

In an unordered_set, the value of an element is at the same time its key, that identifies it uniquely. Keys are immutable(不可变), therefore, the elements in an unordered_set **cannot be modified once in the container - they can be inserted and removed, though.**

Internally, the elements in the unordered_set are not sorted in any particular order, but organized into buckets depending on their hash values to allow for fast access to individual elements directly by their values (with a constant average time complexity on average).

unordered_set containers are faster than set containers to access individual elements by their key, although they are generally less efficient for range iteration through a subset of their elements.

Iterators in the container are at least forward iterators.

#### Container properties

- **Associative**:      Elements in associative containers are referenced by their key and not by their absolute position in the container.
- **Unordered**:        Unordered containers organize their elements using hash tables that allow for fast access to elements by their key.
- **Set**:              The value of an element is also the key used to identify it.
- **Unique**:           keys No two elements in the container can have equivalent keys.
- **Allocator-aware**:  The container uses an allocator object to dynamically handle its storage needs.

#### Template parameters

- **Key**: Type of the elements. Each element in an unordered_set is also uniquely identified by this value. Aliased as member types unordered_set::key_type and unordered_set::value_type.
- **Hash**: A unary function object type that takes an object of the same type as the elements as argument and returns a unique value of type size_t based on it. This can either be a class implementing a function call operator or a pointer to a function (see constructor for an example). This defaults to hash<Key>, which returns a hash value with a probability of collision approaching 1.0/std::numeric_limits<size_t>::max().  The unordered_set object uses the hash values returned by this function to organize its elements internally, speeding up the process of locating individual elements.  Aliased as member type unordered_set::hasher.
- **Pred**: A binary predicate that takes two arguments of the same type as the elements and returns a bool. The expression pred(a,b), where pred is an object of this type and a and b are key values, shall return true if a is to be considered equivalent to b. This can either be a class implementing a function call operator or a pointer to a function (see constructor for an example). This defaults to equal_to<Key>, which returns the same as applying the equal-to operator (a==b).  The unordered_set object uses this expression to determine whether two element keys are equivalent. No two elements in an unordered_set container can have keys that yield true using this predicate.  Aliased as member type unordered_set::key_equal.
- **Alloc**: Type of the allocator object used to define the storage allocation model. By default, the allocator class template is used, which defines the simplest memory allocation model and is value-independent.  Aliased as member type unordered_set::allocator_type.

In the reference for the unordered_set member functions, these same names (Key, Hash, Pred and Alloc) are assumed for the template parameters.

#### Member types

The following aliases are member types of unordered_set. They are widely used as parameter and return types by member functions:

member type             |definition  |notes
---|---|---
key_type                |the first template parameter (Key)         |
value_type              |the first template parameter (Key)         |The same as key_type
hasher                  |the second template parameter (Hash)       |defaults to: hash<key_type>
key_equal               |the third template parameter (Pred)        |defaults to: equal_to<key_type>
allocator_type          |the fourth template parameter (Alloc)      |defaults to: allocator<value_type>
reference               |Alloc::reference                           |
const_reference         |Alloc::const_reference                     |
pointer                 |Alloc::pointer                             |for the default allocator: value_type*
const_pointer           |Alloc::const_pointer                       |for the default allocator: const value_type*
iterator                |a forward iterator to const value_type     |* convertible to const_iterator
const_iterator          |a forward iterator to const value_type     |*
local_iterator          |a forward iterator to const value_type     |* convertible to const_local_iterator
const_local_iterator    |a forward iterator to const value_type     |*
size_type               |an unsigned integral type                  |usually the same as size_t
difference_type         |a signed integral type                     |usually the same as ptrdiff_t

*Note: All iterators in an unordered_set point to const elements. Whether the const_ member type is the same type as its non-const_ counterpart depends on the particular library implementation, but programs should not rely on them being different to overload functions: const_iterator is more generic, since iterator is always convertible to it.
The same applies to local_ and non-local_ iterator types: they may either be the same type or not, but a program should not rely on them being different.

#### Member functions

- **(constructor)**:Construct unordered_set (public member function )
- **(destructor)**: Destroy unordered set (public member function)
- **operator=**     Assign content (public member function )

#### Capacity 

**empty, size, max_size**

#### Iterators

**begin, end, cbegin, cend**

#### Element lookup

- **find**:         Get iterator to element (public member function)
- **count**:        Count elements with a specific key (public member function)
- **equal_range**:  Get range of elements with a specific key (public member function)

#### Modifiers

- **emplace**:      Construct and insert element (public member function )
- **emplace_hint**: Construct and insert element with hint (public member function)
- **insert**:       Insert elements (public member function )
- **erase**:        Erase elements (public member function )
- **clear**:        Clear content (public member function)
- **swap**:         Swap content (public member function)

#### Buckets

- **bucket_count**:     Return number of buckets (public member function)
- **max_bucket_count**: Return maximum number of buckets (public member function)
- **bucket_size**:      Return bucket size (public member type)
- **bucket**:           Locate element's bucket (public member function)

#### Hash policy

- **load_factor**:      Return load factor (public member function)
- **max_load_factor**:  Get or set maximum load factor (public member function)
- **rehash**:           Set number of buckets (public member function )
- **reserve**:          Request a capacity change (public member function)

#### Observers

- **hash_function**:    Get hash function (public member type )
- **key_eq**:           Get key equivalence predicate (public member type)
- **get_allocator**:    Get allocator (public member function)

#### Non-member function overloads

- **operators** (unordered_set) Relational operators for unordered_set (function template )
- **swap** (unordered_set) Exchanges contents of two unordered_set containers (function template )

#### Code Example

```cpp
#include <iostream>
#include <string>
#include <unordered_set>

using namespace std;

template<class T>
T cmerge(T a, T b){
    T t(a);
    t.insert(b.begin(), b.end());
    return t;
}

int main(int argc, char **argv)
{
    unordered_set<string> first1;
    unordered_set<string> first2( {"one", "two", "three"} );
    unordered_set<string> first3( {"red", "green", "blue"} );
    unordered_set<string> first4( first2 );
    unordered_set<string> first5( cmerge(first4,first3) );
    unordered_set<string> first6( first5.begin(), first5.end() );

    cout << "\nFirst6 set: ";
    for(const string& x: first6 ){
        cout << "  " << x;
    }

    return 0;

    /** other function please to see the unordered_map */

```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/unordered_set/unordered_set/)
