### std::deque

template < class T, class Alloc = allocator<T> > class deque;

#### Double ended queue

**deque** means double enden queue;

deque (usually pronounced like "deck") is an irregular acronym of double-ended queue. Double-ended queues are sequence containers with **dynamic sizes** that can be expanded or contracted on both ends (either its front or its back).

Specific libraries may implement deques in different ways, generally as some form of dynamic array. But in any case, they allow for the individual elements to be accessed directly through random access iterators, with storage handled automatically by expanding and contracting the container as needed.

Therefore, they provide a functionality similar to vectors, but with efficient insertion and deletion of elements also at the beginning of the sequence, and not only at its end. But, unlike vectors, **deques are not guaranteed(保证) to store all its elements in contiguous(相邻) storage locations:** accessing elements in a deque by offsetting a pointer to another element causes undefined behavior.

Both vectors and deques provide a very similar interface and can be used for similar purposes, but internally both work in quite different ways: **While vectors use a single array that needs to be occasionally reallocated for growth(有时候，会重新分配), the elements of a deque can be scattered(分散) in different chunks of storage, with the container keeping the necessary information internally to provide direct access to any of its elements in constant time and with a uniform sequential interface (through iterators). Therefore, deques are a little more complex internally than vectors, but this allows them to grow more efficiently under certain circumstances, especially with very long sequences, where reallocations become more expensive.**

**For operations that involve(包含) frequent insertion or removals of elements at positions other than the beginning or the end, deques perform worse and have less consistent iterators and references than lists and forward lists.**

#### Container properties

- **Sequence**:         Elements in sequence containers are ordered in a strict linear sequence. Individual elements are accessed by their position in this sequence.
- **Dynamic array**:    Generally implemented as a dynamic array, it allows direct access to any element in the sequence and provides relatively fast addition/removal of elements at the beginning or the end of the sequence.
- **Allocator-aware**:  The container uses an allocator object to dynamically handle its storage needs.

#### Template parameters

- **T**:    Type of the elements.    Aliased as member type deque::value_type.
- **Alloc** Type of the allocator object used to define the storage allocation model. By default, the allocator class template is used, which defines the simplest memory allocation model and is value-independent.    Aliased as member type deque::allocator_type.

#### Member types

member type|definition|notes
---|---|---
value_type                                |The first template parameter (T)
allocator_type                            |The second template parameter (Alloc)                                                  |  defaults to: allocator<value_type>
reference                                 |value_type&                                                                            |
const_reference                           |const value_type&                                                                      |
pointer                                   |allocator_traits<allocator_type>::pointer                                              |  for the default allocator: value_type*
const_pointer                             |allocator_traits<allocator_type>::const_pointer                                        |  for the default allocator: const value_type*
iterator                                  |a random access iterator to value_type                                                 | convertible to const_iterator
const_iterator                            |a random access iterator to const value_type                                           |
reverse_iterator                          |reverse_iterator<iterator>                                                             |
const_reverse_iterator                    |reverse_iterator<const_iterator>                                                       |
difference_type                           |a signed integral type, identical to:                                                  |
iterator_traits<iterator>::difference_type|usually the same as ptrdiff_t                                                          |
size_type                                 |an unsigned integral type that can represent any non-negative value of difference_type | usually the same as size_t

#### Member functions

- **(constructor)**:    Construct deque container (public member function )
- **(destructor)**:     Deque destructor (public member function )
- **operator=**:        Assign content (public member function )

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

- **size**:         Return size (public member function )
- **max_size**:     Return maximum size (public member function )
- **resize**:       Change size (public member function )
- **empty**:        Test whether container is empty (public member function )
- **shrink_to_fit** Shrink(收缩) to fit (public member function )

#### Element access:

- **operator[]**:    Access element (public member function )
- **at**:            Access element (public member function )
- **front**:         Access first element (public member function )
- **back**:          Access last element (public member function )

#### Modifiers:

- **assign**:        Assign(分配) container content (public member function )
- **push_back**:     Add element at the end (public member function )
- **push_front**:    Insert element at beginning (public member function )
- **pop_back**:      Delete last element (public member function )
- **pop_front**:     Delete first element (public member function )
- **insert**:        Insert elements (public member function )
- **erase**:         Erase elements (public member function )
- **swap**:          Swap content (public member function )
- **clear**:         Clear content (public member function )
- **emplace**:       Construct and insert element (public member function )
- **emplace_front**: Construct and insert element at beginning (public member function )
- **emplace_back**:  Construct and insert element at the end (public member function )

#### Allocator:

- **get_allocator**:    Get allocator (public member function )

#### Non-member functions overloads

- **relational operators**:    Relational operators for deque (function )
- **swap**                     Exchanges the contents of two deque containers (function template )

#### Code Example

```cpp
#include <iostream>
#include <deque>
#include <vector>

using namespace std;

int main(int argc, char **argv)
{
    deque<int> first;            ///< emprt deque of ints
    deque<int> second(4, 100);   ///< four ints with value 100
    /** iterating through second */
    deque<int> third(second.begin(),second.end());
    deque<int> four(third);     ///< a copy of third

    int myints[] = {11,12,14,13};
    deque<int> fifth(myints, myints + sizeof (myints) / sizeof (int) );
    for(auto it = fifth.begin(); it != fifth.end(); it++){
        cout << *it << "\t";
    }
    cout << "\n";


    /** = */
    deque<int> six(3);
    deque<int> seven(5);
    seven = six;
    six = deque<int>();
    cout << "size of six:" << int (six.size()) << '\n';
    cout << "size of seven:" << int (seven.size()) << '\n';
    /** output : 0 , 3 */

    /**
     * The code sets a sequence of 10 numbers as the initial content for
     * mydeque. It then uses resize first to set the container size to 5,
     * then to extend its size to 8 with values of 100 for its new elements,
     * and finally it extends its size to 12 with their default values
     * (for int elements this is zero). Output:
     * */
    deque<int> eight;
    for(int i=0; i < 10; i++){
        eight.push_back(i);
    }
    cout << '\n' << "Init deque : ";
    for(auto it=eight.begin(); it != eight.end(); it++){
        cout << *it << '\t';
    }
    /** output:0    1   2   3   4   5   6   7   8   9 */
    eight.resize(5);
    cout << '\n' << "deque::resize(5): ";
    for(auto it=eight.begin(); it != eight.end(); it++){
        cout << *it << '\t';
    }
    /** output:0    1   2   3   4 */
    eight.resize(8,100);
    cout << '\n' << "deque::resize(8,100): ";
    for(auto it=eight.begin(); it != eight.end(); it++){
        cout << *it << '\t';
    }
    /** output:0    1   2   3   4   100 100 100 */
    eight.resize(12);
    cout << '\n' << "deque::resize(12): ";
    for(auto it=eight.begin(); it != eight.end(); it++){
        cout << *it << '\t';
    }
    /** output:0    1   2   3   4   100 100 100 0   0   0   0*/

    /**
     * Requests the container to reduce its memory usage to fit its size.
     * A deque container may have more memory allocated than needed to hold
     * its current elements: this is because most libraries implement deque
     * as a dynamic array that can keep the allocated space of removed
     * elements or allocate additional capacity in advance to allow for faster
     * insertion operations.
     * This function requests that the memory usage is adapted to the current
     * size of the container, but the request is non-binding, and the
     * container implementation is free to optimize its memory usage otherwise.
     * Note that this function does not change the size of the container
     * (for that, see resize instead).
     */
    deque<int> nine(100);
    cout << '\n' << "deque::size(): "<< int ( nine.size() );
    nine.resize(10);
    cout << '\n' << "deque::resize(10): "<< int ( nine.size() );
    for(int i=0; i < 5; i++){
        nine[i] = i;
    }
    nine.shrink_to_fit();

    /** assign */
    deque<int> ten1;
    deque<int> ten2;
    deque<int> ten3;

    ten1.assign(7,100);
    ten2.assign( ten1.begin()+1, ten1.end()-1 );
    int myint2[] = {1776,7,4};
    ten3.assign(myint2,myint2+3);
    cout << '\n' << "size of ten1:" << int (ten1.size());
    cout << '\n' << "size of ten2:" << int (ten2.size());
    cout << '\n' << "size of ten3:" << int (ten3.size());

    deque<int> firstQue;
    for(int i=0; i < 6; i++)
        firstQue.push_back(i);
    /** 0   1   2   3   4   5 */
    auto it = firstQue.begin() + 1;
    it = firstQue.insert(it, 10);
    /** 0 10 1  2   3   4   5 */
    firstQue.insert(it,2,20);
    /** 0 20 20 10 1 2 3 4 5 */
    it = firstQue.begin() + 2;

    vector<int> vector(2,30);
    firstQue.insert(it, vector.begin(),vector.end());
    /** 0 20 30 30 20 10 1 2 3 4 5 */
    cout << '\n';
    for(auto it = firstQue.begin(); it != firstQue.end(); it++){
        cout << *it << '\t';
    }

    /** erase the 6th element */
    firstQue.erase(firstQue.begin() + 5);
    /** 0 20 30 30 20 1 2 3 4 5 */
    firstQue.erase(firstQue.begin(),firstQue.begin() + 3);
    /** 30 20 1 2 3 4 5 */

    deque<int> foo(3,100);
    deque<int> bar(5,200);
    foo.swap(bar);
    /** foo: 200 200 200 200 200 */
    /** bar: 100 100 100  */
    /** 队列的交换类型必须相同,长度可以不同,但是数组的交换,类型和长度必须相同 */

    /** The container is extended by inserting a new element at position. This
     * new element is constructed in place using args as the arguments for its
     * construction. */
    it = foo.emplace(foo.begin()+1, 100);
    /** 200 100 200 200 200 200 */
    foo.emplace(it, 300);
    /** 200 300 100 200 200 200 200 */
    foo.emplace(foo.end(),300);
    /** 200 300 100 200 200 200 200 300 */

    /**
     * 有什么作用呢?
     * Returns a copy of the allocator object associated with the deque object
     * */
    deque<int> secondQue;
    int *p;
    unsigned int i;
    /**
     * allocate an array with space for 5 elements using deque's allocator:
     * */
    p = secondQue.get_allocator().allocate(5);
    /**construct values in-place on the array: */
    for(i=0; i < 5;i++){
        secondQue.get_allocator().construct(&p[i],i);
    }

    cout << '\n';
    for(i=0; i < 5;i++){
        cout << p[i] << '\t';
    }

    /**destroy and deallocate */
    for(i=0; i < 5;i++){
        secondQue.get_allocator().destroy(&p[i]);
    }
    secondQue.get_allocator().deallocate(p,5);


    return 0;
}
```

---
