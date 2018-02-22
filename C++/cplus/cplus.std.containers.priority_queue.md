
### std::priority_queue

```cpp
template <class T, class Container = vector<T>,
  class Compare = less<typename Container::value_type> > class priority_queue;
```

#### Priority queue

Priority(优先) queues are a type of container adaptors, **specifically designed such that its first element is always the greatest of the elements it contains, according to some strict weak ordering criterion(严格的弱排序标准).**

**This context is similar to a heap, where elements can be inserted at any moment, and only the max heap element can be retrieved (the one at the top in the priority queue).**

Priority queues are implemented as container adaptors, which are classes that use an encapsulated(封装) object of a specific container class as its underlying container, providing a specific set of member functions to access its elements. Elements are popped from the "back" of the specific container, which is known as the top of the priority queue.

The underlying container may be any of the standard container class templates or some other specifically designed container class. The container shall be accessible through random access iterators and support the following operations:

- empty()
- size()
- front()
- push_back()
- pop_back()

The standard container classes vector and deque fulfill these requirements. By default, if no container class is specified for a particular priority_queue class instantiation, the standard container vector is used.

Support of random access iterators is required to keep a heap structure internally at all times. This is done automatically by the container adaptor by automatically calling the algorithm functions make_heap, push_heap and pop_heap when needed.

#### Template parameters

- **T**            Type of the elements.    Aliased as member type priority_queue::value_type.
- **Container**    Type of the internal underlying container object where the elements are stored.    Its value_type shall be T.    Aliased as member type priority_queue::container_type.
- **Compare**      A binary predicate that takes two elements (of type T) as arguments and returns a bool.    The expression comp(a,b), where comp is an object of this type and a and b are elements in the container, shall return true if a is considered to go before b in the strict weak ordering the function defines.    The priority_queue uses this function to maintain the elements sorted in a way that preserves heap properties (i.e., that the element popped is the last according to this strict weak ordering).    This can be a function pointer or a function object, and defaults to less<T>, which returns the same as applying the less-than operator (a<b).


#### Member types

member type       |definition                                 |notes
---               |---                                                    |---
value_type        |The first template parameter (T) Type of the elements  |
container_type    |The second template parameter (Container)              |Type of the underlying container
size_type         |an unsigned integral type                              |usually the same as size_t

#### Member functions

- **(constructor)**   Construct priority queue (public member function )
- **empty**           Test whether container is empty (public member function )
- **size**            Return size (public member function )
- **top**             Access top element (public member function )
- **push**            Insert element (public member function )
- **emplace**         Construct and insert element (public member function )
- **pop**             Remove top element (public member function )
- **swap**            Swap contents (public member function )

#### Non-member function overloads

- **swap (queue)**:    Exchange contents of priority queues (public member function )

#### Non-member class specializations

- **uses_allocator<queue>**:    Uses allocator for priority queue (class template )

#### Code Example

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <functional>

using namespace std;

class comparison
{
    bool reverse;

public:
    comparison( const bool& revparam=false )
    { reverse = revparam; }

    bool operator() (const int& lhs, const int& rhs) const
    {
        if (reverse) return (lhs>rhs);
        else return (lhs < rhs);
    }
};

int main(int argc, char **argv)
{
    int intArr[] = {10, 60, 50, 20};

    priority_queue<int> first;
    priority_queue<int> second( intArr, intArr + 4 );
    priority_queue<int, vector<int>, greater<int> > third(intArr, intArr+4);

    typedef priority_queue<int, vector<int>, comparison> pq_type;

    pq_type fourth; ///< less than comparison
    pq_type fifth( comparison(true) ); ///< greater than comparison

    /**
     * The example does not produce any output, but it constructs different
     * priority_queue objects:- First is empty.- Second contains the four
     * ints defined for myints, with 60 (the highest) at its top.- Third has
     * the same four ints, but because it uses greater instead of the
     * default (which is less), it has 10 as its top element.- Fourth and
     * fifth are very similar to first: they are both empty, except that these
     * use mycomparison for comparisons, which is a special stateful
     * comparison function that behaves differently depending on a flag set
     * on construction.
     * */

    priority_queue<int> pq;
    pq.push(10);
    pq.push(20);
    pq.push(30);
    pq.push(5);
    cout << "pq.top() is :" << pq.top() << '\n';
    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/queue/priority_queue/)
