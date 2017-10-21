### std::unordered_map

```cpp
template < class Key,                                    // unordered_map::key_type
           class T,                                      // unordered_map::mapped_type
           class Hash = hash<Key>,                       // unordered_map::hasher
           class Pred = equal_to<Key>,                   // unordered_map::key_equal
           class Alloc = allocator< pair<const Key,T> >  // unordered_map::allocator_type
           > class unordered_map;
```

#### Unordered Map

Unordered maps are associative containers that store elements formed by the combination of a key value and a mapped value, and which allows for fast retrieval of individual elements based on their keys.

In an unordered_map, the key value is generally used to uniquely identify the element, while the mapped value is an object with the content associated to this key. Types of key and mapped value may differ.

Internally, the elements in the unordered_map are not sorted in any particular order with respect to either their key or mapped values, but organized into buckets(桶) depending on their hash values to allow for fast access to individual elements directly by their key values (with a constant average time complexity on average).

unordered_map containers **are faster than map containers to access individual elements by their key, although they are generally less efficient for range iteration through a subset of their elements.**

Unordered maps implement the direct access operator (operator[]) which allows for direct access of the mapped value using its key value as argument.

Iterators in the container are at least forward iterators.

#### Container properties

- **Associative**       Elements in associative containers are referenced by their key and not by their absolute position in the container.
- **Unordered**         Unordered containers organize their elements using hash tables that allow for fast access to elements by their key.
- **Map**               Each element associates a key to a mapped value: Keys are meant to identify the elements whose main content is the mapped value.
- **Unique**            keys No two elements in the container can have equivalent keys.
- **Allocator-aware**   The container uses an allocator object to dynamically handle its storage needs.

#### Template parameters

- **Key**
    Type of the key values. Each element in an unordered_map is uniquely identified by its key value.
    Aliased as member type unordered_map::key_type.

- **T**
    Type of the mapped value. Each element in an unordered_map is used to store some data as its mapped value.
    Aliased as member type unordered_map::mapped_type. Note that this is not the same as unordered_map::value_type (see below).

- **Hash**
    A unary(一元) function object type that takes an object of type key type as argument and returns a unique value of type size_t based on it. This can either be a class implementing a function call operator or a pointer to a function (see constructor for an example). This defaults to hash<Key>, which returns a hash value with a probability of collision approaching 1.0/std::numeric_limits<size_t>::max().
    The unordered_map object uses the hash values returned by this function to organize its elements internally, speeding up the process of locating individual elements.
    Aliased as member type unordered_map::hasher.

- **Pred**
    A binary predicate(断言) that takes two arguments of the key type and returns a bool. The expression pred(a,b), where pred is an object of this type and a and b are key values, shall return true if a is to be considered equivalent to b. This can either be a class implementing a function call operator or a pointer to a function (see constructor for an example). This defaults to equal_to<Key>, which returns the same as applying the equal-to operator (a==b).
    The unordered_map object uses this expression to determine whether two element keys are equivalent. No two elements in an unordered_map container can have keys that yield true using this predicate.
    Aliased as member type unordered_map::key_equal.

- **Alloc**
    Type of the allocator object used to define the storage allocation model. By default, the allocator class template is used, which defines the simplest memory allocation model and is value-independent.
    Aliased as member type unordered_map::allocator_type.

In the reference for the unordered_map member functions, these same names (Key, T, Hash, Pred and Alloc) are assumed for the template parameters.

Iterators to elements of unordered_map containers access to both the key and the mapped value. For this, the class defines what is called its value_type, which is a pair class with its first value corresponding to the const version of the key type (template parameter Key) and its second value corresponding to the mapped value (template parameter T):

```cpp
typedef pair<const Key, T> value_type;
```

Iterators of a unordered_map container point to elements of this value_type. Thus, for an iterator called it that points to an element of a map, its key and mapped value can be accessed respectively(分别) with:

```cpp
unordered_map<Key,T>::iterator it;
(*it).first;             // the key value (of type Key)
(*it).second;            // the mapped value (of type T)
(*it);                   // the "element value" (of type pair<const Key,T>) 
```

Naturally, any other direct access operator, such as -> or [] can be used, for example:

```cpp
it->first;               // same as (*it).first   (the key value)
it->second;              // same as (*it).second  (the mapped value) 
```

#### Member types

The following aliases are member types of unordered_map. They are widely used as parameter and return types by member functions:

member type             |definition                                 |notes
---                     |---                                        |---
key_type                |the first template parameter (Key)         |
mapped_type             |the second template parameter (T)          |
value_type              |pair<const key_type,mapped_type>           |
hasher                  |the third template parameter (Hash)        |defaults to: hash<key_type>
key_equal               |the fourth template parameter (Pred)       |defaults to: equal_to<key_type>
allocator_type          |the fifth template parameter (Alloc)       |defaults to: allocator<value_type>
reference               |Alloc::reference                           |
const_reference         |Alloc::const_reference                     |
pointer                 |Alloc::pointer                             |for the default allocator: value_type\*
const_pointer           |Alloc::const_pointer                       |for the default allocator: const value_type\*
iterator                |a forward iterator to value_type           |
const_iterator          |a forward iterator to const value_type     |
local_iterator          |a forward iterator to value_type           |
const_local_iterator    |a forward iterator to const value_type     |
size_type               |an unsigned integral type                  |usually the same as size_t
difference_type         |a signed integral type                     |usually the same as ptrdiff_t

#### Member functions

- **(constructor)** Construct unordered_map (public member function )
- **(destructor)**  Destroy unordered map (public member function)
- **operator=**     Assign content (public member function )

#### Capacity

- **empty**     Test whether container is empty (public member function)
- **size**      Return container size (public member function)
- **max_size** Return maximum size (public member function)

#### Iterators

- **begin**     Return iterator to beginning (public member function)
- **end**       Return iterator to end (public member function)
- **cbegin**    Return const_iterator to beginning (public member function)
- **cend**      Return const_iterator to end (public member function)

#### Element access

- **operator[]** Access element (public member function )
- **at**         Access element (public member function)

#### Element lookup

- **find**          Get iterator to element (public member function)
- **count**         Count elements with a specific key (public member function )
- **equal_range**  Get range of elements with specific key (public member function)

#### Modifiers

- **emplace**       Construct and insert element (public member function )
- **emplace_hint** Construct and insert element with hint (public member function )
- **insert**        Insert elements (public member function )
- **erase**         Erase elements (public member function )
- **clear**         Clear content (public member function )
- **swap**          Swap content (public member function)

#### Buckets

- **bucket_count**         Return number of buckets (public member function)
- **max_bucket_count**    Return maximum number of buckets (public member function)
- **bucket_size**          Return bucket size (public member type)
- **bucket**                Locate element's bucket (public member function)

#### Hash policy

- **load_factor**      Return load factor (public member function)
- **max_load_factor** Get or set maximum load factor (public member function ) 
- **rehash**            Set number of buckets (public member function ) 
- **reserve**           Request a capacity change (public member function)

#### Observers

- **hash_function**    Get hash function (public member type) 
- **key_eq**           Get key equivalence predicate (public member type) 
- **get_allocator**    Get allocator (public member function)

#### Non-member function overloads

- **operators** (unordered_map) Relational operators for unordered_map (function template ) 
- **swap** (unordered_map) Exchanges contents of two unordered_map containers (function template ) 

#### Code Example

```cpp
#include <iostream>
#include <string>
#include <unordered_map>

using namespace std;

typedef unordered_map<string,string> stringmap;
typedef unordered_map<int,int> intmap;

stringmap merge(stringmap a,stringmap b){
    stringmap tmp(a);
    tmp.insert(b.begin(),b.end());
    return tmp;
}

int main(int argc, char **argv)
{
    stringmap first1;
    stringmap first2( { {"apple","red"}, {"lemon","yellow"} } );
    stringmap first3( { {"orange","orange"}, {"strawberry","red"} } );
    stringmap first4( first2 );
    stringmap first5( merge(first2, first3) );
    stringmap first6( first5.begin(), first5.end() );

    cout << "string map first6 :\n";
    for( auto& x:first6 )
        cout << x.first << ":" << x.second << "\n";

    stringmap second = { {"house","maison"}, {"apple","pomme"}, {"tree","arbre"}, 
        {"book","liver"}, {"door","porte"}, {"grapefruit","pamplemouse"} };

    unsigned n = second.bucket_count();
    cout << "\nsecond map has " << n << " buckets\n";
    for( unsigned i=0; i < n; i++ ){
        cout << "bucket#" << i << "contains: "<< second.bucket_size(i) << "elements: ";
        for( auto it = second.begin(i); it != second.end(i); it++ ){
            cout << it->first << ":" << it->second << ",";
        }
        cout << "\n";
    }

    cout << "\n";
    for( auto& x:second){
        cout << "Element [" << x.first << ":" << x.second << "]";
        cout << " is in bucket #" << second.bucket( x.first ) << "\n";
    }

    intmap third;

    cout << "size: " << third.size() << "\n";
    cout << "bucket_count: " << third.bucket_count() << "\n";
    cout << "load_factor: " << third.load_factor() << "\n";
    cout << "max_load_factor: "<< third.max_load_factor() << "\n";

    /**
     * Sets the number of buckets in the container to n or more.
    If n is greater than the current number of buckets in the container (bucket_count), a rehash is forced. The new bucket count can either be equal or greater than n.
    If n is lower than the current number of buckets in the container (bucket_count), the function may have no effect on the bucket count and may not force a rehash.
    */

    third.rehash(40);
    cout << "rehash bucket count: "<< third.bucket_count() << "\n";

    intmap::hasher fn = third.hash_function();
    cout << "int hash function: 10:" << fn(10) << "\n";
    cout << "int hash function: 11:" << fn(11) << "\n";

    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/unordered_map/unordered_map/)

---
