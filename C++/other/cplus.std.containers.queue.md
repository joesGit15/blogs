
### std::queue

`template <class T, class Container = deque<T> > class queue;`

#### FIFO queue

queues are a type of container adaptor, **specifically designed to operate in a FIFO context (first-in first-out), where elements are inserted into one end of the container and extracted from the other.**

queues are implemented as containers adaptors, which are classes that use an encapsulated(封装) object of a specific container class as its underlying container, providing a specific set of member functions to access its elements. Elements are pushed into the "back" of the specific container and popped from its "front".

The underlying container may be one of the standard container class template or some other specifically designed container class. This underlying container shall support at least the following operations:

- empty
- size
- front
- back
- push_back
- pop_front

The standard container classes deque and list fulfill these requirements. By default, if no container class is specified for a particular queue class instantiation, the standard container deque is used.

#### Template parameters

- **T**:            Type of the elements.    Aliased as member type queue::value_type.
- **Container**:    Type of the internal underlying container object where the elements are stored.    Its value_type shall be T.    Aliased as member type queue::container_type.

#### Member types

member type     |definition                                   |notes
---             |---                                          |
value_type      |The first template parameter (T)             |Type of the elements
container_type  |The second template parameter (Container)    |Type of the underlying container
size_type       |an unsigned integral type                    |usually the same as size_t

#### Member functions

- **(constructor)**:    Construct queue (public member function )
- **empty**:            Test whether container is empty (public member function )
- **size**:             Return size (public member function )
- **front**:            Access next element (public member function )
- **back**:             Access last element (public member function )
- **push**:             Insert element (public member function )
- **emplace**:          Construct and insert element (public member function )
- **pop**:              Remove next element (public member function )
- **swap**:             Swap contents (public member function )

#### Non-member function overloads

- **relational operators**:    Relational operators for queue (function )
- **swap (queue)**:            Exchange contents of queues (public member function )

#### Non-member class specializations

- **uses_allocator<queue>**:    Uses allocator for queue (class template )

#### Code Example

```cpp
#include <iostream>
#include <deque>
#include <list>
#include <queue>

using namespace std;

int main(int argc, char **argv)
{
    deque<int> deck (3, 100);
    list<int> list (2, 200);

    queue<int> first;
    queue<int> first1( deck ); ///< queue initialized to copy of deque

    /** empty queue with list as underlying container */
    queue<int, list<int> > first2;

    /**  */
    queue<int, list<int> > first3 ( list );
    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/queue/queue/)
