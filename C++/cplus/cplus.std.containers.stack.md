### std::stack

```cpp
template <class T, class Container = deque<T> > class stack;
```

#### LIFO stack

**Stacks are a type of container adaptor, specifically designed to operate in a LIFO context (last-in first-out), where elements are inserted and extracted only from one end of the container.**

stacks are implemented as containers adaptors, which are classes that use an encapsulated object of a specific container class as its underlying container, providing a specific set of member functions to access its elements. Elements are pushed/popped from the "back" of the specific container, which is known as the top of the stack.

The underlying container may be any of the standard container class templates or some other specifically designed container class. The container shall support the following operations:

- empty
- size
- back
- push\_back
- pop\_back

The standard container classes vector, deque and list fulfill these requirements. By default, if no container class is specified for a particular stack class instantiation, the standard container deque is used.

#### Template parameters

- **T** Type of the elements.  Aliased as member type stack::value\_type.
- **Container** Type of the internal underlying container object where the elements are stored.  Its value\_type shall be T.  Aliased as member type stack::container\_type.

member type     |definition                                 |notes
---|---|---
value\_type      |The first template parameter (T)           |Type of the elements
container\_type  |The second template parameter (Container)  |Type of the underlying container
size\_type       |an unsigned integral type                  |usually the same as size\_t

#### Member functions

- **(constructor)** Construct stack (public member function )
- **empty**         Test whether container is empty (public member function )
- **size**          Return size (public member function )
- **top**           Access next element (public member function )
- **push**          Insert element (public member function )
- **emplace**       Construct and insert element (public member function )
- **pop**           Remove top element (public member function )
- **swap**          Swap contents (public member function )

#### Non-member function overloads

- **relational operators** Relational operators for stack (function )
- **swap (stack)** Exchange contents of stacks (public member function )

#### Non-member class specializations

- **uses__allocator<stack>** Uses allocator for stack (class template )

#### Code Example

```cpp
#include <iostream>
#include <stack>
#include <vector>
#include <deque>

using namespace std;

int main(int argc, char **argv)
{
    deque<int> mydeque(3,10);
    vector<int> myvector(2,20);

    stack<int> first;
    stack<int> second(mydeque);

    stack<int, vector<int> > third;
    stack<int, vector<int> > fourth(myvector);

    /** other function please to see the deque container */
    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/stack/stack/)

---
