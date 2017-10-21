### std::map

```cpp
template < class Key,                                     // map::key_type
           class T,                                       // map::mapped_type
           class Compare = less<Key>,                     // map::key_compare
           class Alloc = allocator<pair<const Key,T> >    // map::allocator_type
           > class map;
```

#### Map

Maps are associative containers that store elements formed by a combination of a key value and a mapped value, following a specific order.

**In a map, the key values are generally used to sort and uniquely identify the elements, while the mapped values store the content associated to this key.** The types of key and mapped value may differ, and are grouped together in member type value_type, which is a pair type combining both:

`typedef pair<const Key, T> value_type;`

Internally, **the elements in a map are always sorted by its key following a specific strict weak ordering criterion indicated by its internal comparison object (of type Compare).**

**map containers are generally slower than unordered_map containers to access individual elements by their key, but they allow the direct iteration on subsets based on their order.**

The mapped values in a map can be accessed directly by their corresponding key using the bracket(方括号) operator ((operator[]).

**Maps are typically implemented as binary search trees(二叉搜索树).**

#### Container properties

- **Associative**:      Elements in associative containers are referenced by their key and not by their absolute position in the container.
- **Ordered**:          The elements in the container follow a strict order at all times. All inserted elements are given a position in this order.
- **Map**:              Each element associates a key to a mapped value: Keys are meant to identify the elements whose main content is the mapped value.
- **Unique keys**:      No two elements in the container can have equivalent keys.
- **Allocator-aware**:  The container uses an allocator object to dynamically handle its storage needs.

#### Template parameters

- **Key**:      Type of the keys. Each element in a map is uniquely identified by its key value.    Aliased as member type map::key_type.
- **T**:        Type of the mapped value. Each element in a map stores some data as its mapped value.    Aliased as member type map::mapped_type.
- **Compare**:  A binary predicate(二元谓词) that takes two element keys as arguments and returns a bool. The expression comp(a,b), where comp is an object of this type and a and b are key values, shall return true if a is considered to go before b in the strict weak ordering the function defines.    The map object uses this expression to determine both the order the elements follow in the container and whether two element keys are equivalent (by comparing them reflexively: they are equivalent if !comp(a,b) && !comp(b,a)). No two elements in a map container can have equivalent keys.    This can be a function pointer or a function object (see constructor for an example). This defaults to less<T>, which returns the same as applying the less-than operator (a<b).    Aliased as member type map::key_compare.
- **Alloc**:    Type of the allocator object used to define the storage allocation model. By default, the allocator class template is used, which defines the simplest memory allocation model and is value-independent.    Aliased as member type map::allocator_type.

#### Member types

member type                                 |definition                                                                           |notes
---                                         |---                                                                                    |---
key_type                                    |The first template parameter (Key)                                                     |
mapped_type                                 |The second template parameter (T)                                                      |
value_type                                  |pair<const key_type,mapped_type>                                                       |
key_compare                                 |The third template parameter (Compare)                                                 |defaults to: less<key_type>
value_compare                               |Nested function class to compare elements                                              |see value_comp
allocator_type                              |The fourth template parameter (Alloc)                                                  |defaults to: allocator<value_type>
reference                                   |value_type&                                                                            |
const_reference                             |const value_type&                                                                      |
pointer                                     |allocator_traits<allocator_type>::pointer                                              |for the default allocator: value_type*
const_pointer                               |allocator_traits<allocator_type>::const_pointer                                        |for the default allocator: const value_type*
iterator                                    |a bidirectional iterator to value_type                                                 |convertible to const_iterator
const_iterator                              |a bidirectional iterator to const value_type                                           |
reverse_iterator                            |reverse_iterator<iterator>                                                             |
const_reverse_iterator                      |reverse_iterator<const_iterator>                                                       |
difference_type                             |a signed integral type, identical to:                                                  |
iterator_traits<iterator>::difference_type  |usually the same as ptrdiff_t                                                          |
size_type                                   |an unsigned integral type that can represent any non-negative value of difference_type |usually the same as size_t

#### Member functions

- **(constructor)**    Construct map (public member function )
- **(destructor)**     Map destructor (public member function )
- **operator=**        Copy container content (public member function )

#### Iterators:

- **begin**:    Return iterator to beginning (public member function )
- **end**:      Return iterator to end (public member function )
- **rbegin**:   Return reverse iterator to reverse beginning (public member function )
- **rend**:     Return reverse iterator to reverse end (public member function )
- **cbegin**:   Return const_iterator to beginning (public member function )
- **cend**:     Return const_iterator to end (public member function )
- **crbegin**:  Return const_reverse_iterator to reverse beginning (public member function )
- **crend**:    Return const_reverse_iterator to reverse end (public member function )

#### Capacity:

- **empty**:    Test whether container is empty (public member function )
- **size**:     Return container size (public member function )
- **max_size**: Return maximum size (public member function )

#### Element access:

- **operator[]**: Access element (public member function )
- **at**:         Access element (public member function )

#### Modifiers:

- **insert**:       Insert elements (public member function )
- **erase**:        Erase elements (public member function )
- **swap**:         Swap content (public member function )
- **clear**:        Clear content (public member function )
- **emplace**:      Construct and insert element (public member function )
- **emplace_hint**: Construct and insert element with hint (public member function )

#### Observers(观察者):

- **key_comp**:    Return key comparison object (public member function )
- **value_comp**:  Return value comparison object (public member function )

#### Operations:

- **find**:           Get iterator to element (public member function )
- **count**:          Count elements with a specific key (public member function )
- **upper_bound**:    Return iterator to upper bound (public member function )
- **lower_bound**:    Return iterator to lower bound (public member function )
- **equal_range**:    Get range of equal elements (public member function )

#### Allocator:

- **get_allocator**:  Get allocator (public member function )

#### Code Example

```cpp
#include <iostream>
#include <map>

using namespace std;

bool fncomp( char lhs, char rhs )
{ return lhs < rhs; }

struct classcomp{
    bool operator() (const char& lhs, const char& rhs)
    { return lhs < rhs; }
};

int main(int argc, char **argv)
{
    map<char,int> first1;

    first1['a'] = 10;   first1['b'] = 20;
    first1['c'] = 30;   first1['d'] = 40;

    map<char,int> first2( first1.begin(),first1.end() );
    map<char,int> first3( first2 );

    map<char,int, classcomp> first4; ///< class as Compare

    /** function pointer as Compare */
    bool(*fn_pt)(char,char) = fncomp;
    map<char,int,bool(*)(char,char)> first5(fn_pt);

    map<char,int> second;
    second.emplace('x', 100);
    second.emplace('y', 200);
    second.emplace('z', 300);
    cout << '\n';
    for(auto &x:second) cout << x.first << ":" << x.second << '\t';

    auto it = second.end();
    it = second.emplace_hint(it, 'b', 20);
    second.emplace_hint(it, 'a', 10);
    second.emplace_hint(it, 'c', 30);
    cout << '\n';
    for(auto &x:second) cout << x.first << ":" << x.second << '\t';

    map<char,int> third;
    /** 获取key 比较器 */
    map<char,int>::key_compare third_comp = third.key_comp();

    third['a'] = 100; third['b'] = 200;
    third['c'] = 300; third['d'] = 400;
    third['e'] = 500; third['f'] = 600;

    char dCh = 'd';
    it = third.begin();

    cout << '\n';
    do{
        cout << it->first << ":" << it->second << '\t';
    }while( third_comp( (*it++).first, dCh ) );

    pair<char,int> dValue = *third.rbegin();

    it = third.begin();
    cout << '\n';
    do{
        cout << it->first << ":" << it->second << '\t';
    }while( third.value_comp()( *it++, dValue ) );

    it = third.find('b');
    if( it != third.end() )
        third.erase(it);

    cout << '\n';
    for( char cIndex = 'a'; cIndex < 'z'; cIndex++ )
    {
        cout << cIndex;
        /** key == cIndex count */
        if( third.count(cIndex) > 0 )
            cout << " has \n";
        else
            cout << " not has.\n";
    }

    auto itlow = third.lower_bound('c'); ///< itlow points to c
    auto itup = third.upper_bound('e');  ///< itup points to f (not e)
    third.erase(itlow,itup);
    cout << '\n';
    for(auto &x:third) cout << x.first << ":" << x.second << '\t';

    map<char,int> four;

    four['a'] = 10; four['b'] = 20;
    four['c'] = 30; four['d'] = 40;
    four['e'] = 50; four['f'] = 60;

    pair< map<char,int>::iterator, map<char,int>::iterator > ret;
    ret = four.equal_range('b');

    cout << "\n lower bound points to:"
         << ret.first->first << ":" << ret.first->second;

    cout << "\n upper bound points to: "
         << ret.second->first << ":" << ret.second->second;

    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/map/map/)

---
