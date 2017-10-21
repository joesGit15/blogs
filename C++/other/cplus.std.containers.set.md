### std::set

```cpp
template < class T,                        // set::key_type/value_type
           class Compare = less<T>,        // set::key_compare/value_compare
           class Alloc = allocator<T>      // set::allocator_type
           > class set;
```

#### Set

Sets are containers that store unique elements following a specific order.

**In a set, the value of an element also identifies it (the value is itself the key, of type T), and each value must be unique. The value of the elements in a set cannot be modified once in the container (the elements are always const), but they can be inserted or removed from the container.**

Internally, the elements in a set are always sorted following a specific strict weak ordering criterion indicated by its internal comparison object (of type Compare).

**set containers are generally slower than unordered set containers to access individual elements by their key, but they allow the direct iteration on subsets based on their order.**

Sets are typically implemented as binary search trees.

#### Container properties

- **Associative**       Elements in associative containers are referenced by their key and not by their absolute position in the container.
- **Ordered**           The elements in the container follow a strict order at all times. All inserted elements are given a position in this order.
- **Set**               The value of an element is also the key used to identify it.
- **Unique**            keys No two elements in the container can have equivalent keys.
- **Allocator-aware**   The container uses an allocator object to dynamically handle its storage needs.

#### Template parameters

- **T**
    Type of the elements. Each element in a set container is also uniquely identified by this value (each value is itself also the element's key).
    Aliased as member types set::key_type and set::value_type.

- **Compare**
    A binary predicate(断言) that takes two arguments of the same type as the elements and returns a bool. The expression comp(a,b), where comp is an object of this type and a and b are key values,
shall return true if a is considered to go before b in the strict weak ordering the function defines.

    The set object uses this expression to determine both the order the elements follow in the container and whether two element keys are equivalent (by comparing them reflexively: they are equivalent if !comp(a,b) && !comp(b,a)). No two elements in a set container can be equivalent.

    This can be a function pointer or a function object (see constructor for an example). This defaults to less<T>, which returns the same as applying the less-than operator (a<b).
    Aliased as member types set::key_compare and set::value_compare.

- **Alloc**
    Type of the allocator object used to define the storage allocation model. By default, the allocator class template is used, which defines the simplest memory allocation model and is value-independent.
    Aliased as member type set::allocator_type.

#### Member types

member type         |definition     |notes
--- |---|---
key\_type                    |The first template parameter (T)                                                        |
value\_type                  |The first template parameter (T)                                                        |
key\_compare                 |The second template parameter (Compare)                                                 |defaults to: less<key_type>
value\_compare               |The second template parameter (Compare)                                                 |defaults to: less<value_type>
allocator\_type              |The third template parameter (Alloc)                                                    |defaults to: allocator<value\_type>
reference                    |allocator\_type::reference                                                              |for the default allocator: value\_type&
const\_reference             |allocator\_type::const\_reference                                                       |for the default allocator: const value\_type&
pointer                      |allocator\_type::pointer                                                                |for the default allocator: value\_type\*
const\_pointer               |allocator\_type::const\_pointer                                                         |for the default allocator: const value\_type\*
iterator                     |a bidirectional iterator to value\_type                                                 |convertible to const\_iterator
const\_iterator              |a bidirectional iterator to const value\_type                                           |
reverse\_iterator            |reverse\_iterator<iterator>                                                             |
const\_reverse\_iterator     |reverse\_iterator<const\_iterator>                                                      |
difference\_type             |a signed integral type, identical to: iterator\_traits<iterator>::difference\_type      |usually the same as ptrdiff\_t
size\_type                   |an unsigned integral type that can represent any non-negative value of difference\_type |usually the same as size\_t

#### Member functions

- **(constructor)**   Construct set (public member function )
- **(destructor)**    Set destructor (public member function )
- **operator=**       Copy container content (public member function )

Iterators:

- **begin**      Return iterator to beginning (public member function )
- **end**        Return iterator to end (public member function )
- **rbegin**     Return reverse iterator to reverse beginning (public member function )
- **rend**       Return reverse iterator to reverse end (public member function )
- **cbegin**     Return const\_iterator to beginning (public member function )
- **cend**       Return const\_iterator to end (public member function )
- **crbegin**    Return const\_reverse\_iterator to reverse beginning (public member function )
- **crend**      Return const\_reverse\_iterator to reverse end (public member function )

#### Capacity:

- **empty**     Test whether container is empty (public member function )
- **size**      Return container size (public member function )
- **max__size**  Return maximum size (public member function )

#### Modifiers:

- **insert**       Insert element (public member function )
- **erase**        Erase elements (public member function )
- **swap**         Swap content (public member function )
- **clear**        Clear content (public member function )
- **emplace**      Construct and insert element (public member function )
- **emplace__hint** Construct and insert element with hint (public member function )

#### Observers:

- **key__comp**   Return comparison object (public member function )
- **value__comp** Return comparison object (public member function )

#### Operations:

- **find**           Get iterator to element (public member function )
- **count**          Count elements with a specific value (public member function )
- **lower__bound**   Return iterator to lower bound (public member function )
- **upper__bound**   Return iterator to upper bound (public member function )
- **equal__range**   Get range of equal elements (public member function )

#### Allocator:

- **get__allocator**    Get allocator (public member function )

#### Code Example

```cpp
#include <iostream>
#include <set>

using namespace std;

bool fncomp(int lhs, int rhs)
{ return lhs < rhs; }

struct classcomp
{
    bool operator() (const int& lhs, const int& rhs) const
    { return lhs<rhs; }
};

int main(int argc, char **argv)
{
    set<int> first;

    int myints[] = {10,20,30,40,50};

    set<int> first1(myints, myints+5);
    set<int> first2(first1);

    set<int> first3(first2.begin(),first2.end());

    set<int, classcomp> first4;

    bool (*fn_pt)(int,int) = fncomp;
    set<int, bool(*)(int,int)> first5(fn_pt);
    /** other function please to reference other container */

    set<int> second;
    for(int i=0; i < 10; i++)
    {
        second.insert(i);
    }

    cout << '\n';
    set<int>::key_compare comp = second.key_comp();
    int nNum = *(second.rbegin());
    auto it = second.begin();
    do{
        cout << *it << '\t';
    }while( comp(*(++it), nNum) );
    /** outpur:0 1 2 3 4 5 6 7 8 */

    set<int> third;
    for(int i=0; i < 5; i++)
    {
        third.insert(i);
    }
    set<int>::value_compare valComp = third.value_comp();
    nNum = *(third.rbegin());
    it = third.begin();
    cout << '\n';
    do
    {
        cout << *it << '\t';
    }while( valComp( *(++it), nNum ) );

    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/set/set/)
