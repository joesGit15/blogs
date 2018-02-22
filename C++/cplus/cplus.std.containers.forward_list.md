### std::forward_list

template < class T, class Alloc = allocator<T> > class forward_list;

#### Forward list

Forward lists are sequence containers that **allow constant time insert and erase operations anywhere within the sequence.**

Forward lists are implemented as **singly-linked lists;** Singly linked lists can store each of the elements they contain in different and unrelated storage locations. The ordering is kept by the association to each element of a link to the next element in the sequence.

**The main design difference between a forward_list container and a list container is that the first keeps internally only a link to the next element, while the latter keeps two links per element: one pointing to the next element and one to the preceding one, allowing efficient iteration in both directions, but consuming additional(额外的消耗) storage per element and with a slight higher time overhead inserting and removing elements. forward_list objects are thus more efficient than list objects, although they can only be iterated forwards.**

Compared to other base standard sequence containers (array, vector and deque), **forward_list perform generally better in inserting, extracting(提取) and moving elements in any position within the container, and therefore also in algorithms that make intensive use of these, like sorting algorithms.**

The main **drawback** of forward_lists and lists compared to these other sequence containers is that they lack direct access to the elements by their position; **For example, to access the sixth element in a forward_list one has to iterate from the beginning to that position, which takes linear time in the distance between these. They also consume(消耗) some extra memory to keep the linking information associated to each element (which may be an important factor for large lists of small-sized elements).**

The forward_list class template has been designed with efficiency in mind: By design, it is as efficient as a simple handwritten C-style singly-linked list, and in fact is the only standard container to deliberately(从容的) lack(缺乏) a size member function for efficiency considerations: due to its nature as a linked list, having a size member that takes constant time would require it to keep an internal counter for its size (as list does). This would consume some extra storage and make insertion and removal operations slightly(轻微的) less efficient. To obtain the size of a forward_list object, you can use the distance algorithm with its begin and end, which is an operation that takes linear time.

#### Container properties

- **Sequence**:       Elements in sequence containers are ordered in a strict linear sequence. Individual elements are accessed by their position in this sequence.
- **Linked list**:    Each element keeps information on how to locate the next element, allowing constant time insert and erase operations after a specific element (even of entire ranges), but no direct random access.
- **Allocator-aware**:    The container uses an allocator object to dynamically handle its storage needs.

#### Template parameters

- **T**:        Type of the elements.    Aliased as member type forward_list::value_type.
- **Alloc**:    Type of the allocator object used to define the storage allocation model. By default, the allocator class template is used, which defines the simplest memory allocation model and is value-independent.    Aliased as member type forward_list::allocator_type.

#### Member types
member|type	definition|notes
---|---|---
value_type      |The first template parameter (T)                                                       |
allocator_type  |The second template parameter (Alloc)                                                  |defaults to: allocator<value_type>
reference       |value_type&                                                                            |
const_reference |const value_type&                                                                      |
pointer         |allocator_traits<allocator_type>::pointer                                              |for the default allocator: value_type*
const_pointer   |allocator_traits<allocator_type>::const_pointer                                        |for the default allocator: const value_type*
iterator        |a forward iterator to value_type                                                       |convertible to const_iterator
const_iterator  |a forward iterator to const value_type                                                 |
difference_type |a signed integral type, identical to: iterator_traits<iterator>::difference_type       |usually the same as ptrdiff_t
size_type       |an unsigned integral type that can represent any non-negative value of difference_type |usually the same as size_t

#### Member functions

- **(constructor)**:    Construct forward_list object (public member function )
- **(destructor)**:     Destroy forward_list object (public member function )
- **operator=**:        Assign content (public member function )

#### Iterators

- **before_begin**:    Return iterator to before beginning (public member function )
- **begin**:           Return iterator to beginning (public member type )
- **end**:             Return iterator to end (public member function )
- **cbefore_begin**:   Return const_iterator to before beginning (public member function )
- **cbegin**:          Return const_iterator to beginning (public member function )
- **cend**:            Return const_iterator to end (public member function )

#### Capacity(容量)

- **empty**:       Test whether array is empty (public member function )
- **max_size**:    Return maximum size (public member function )

####Element access

- **front**:    Access first element (public member function )

#### Modifiers

- **assign**:         Assign content (public member function )
- **emplace_front**:  Construct and insert element at beginning (public member function )
- **push_front**:     Insert element at beginning (public member function )
- **pop_front**:      Delete first element (public member function )
- **emplace_after**:  Construct and insert element (public member function )
- **insert_after**:   Insert elements (public member function )
- **erase_after**:    Erase elements (public member function )
- **swap**:           Swap content (public member function )
- **resize**:         Change size (public member function )
- **clear**:          Clear content (public member function )

#### Operations

- **splice_after**   Transfer elements from another forward_list (public member function )
- **remove**:        Remove elements with specific value (public member function )
- **remove_if**:     Remove elements fulfilling condition (public member function template )
- **unique**:        Remove duplicate values (public member function )
- **merge**:         Merge sorted lists (public member function )
- **sort**:          Sort elements in container (public member function )
- **reverse**:       Reverse the order of elements (public member function )

#### Observers

- **get_allocator**:    Get allocator (public member function )

#### Non-member function overloads

- **relational operators (forward_list)**:    Relational operators for forward_list (function template )
- **swap (forward_list)**:    Exchanges the contents of two forward_list containers (function template )

#### Code Example

```cplus
#include <iostream>
#include <forward_list>
#include <cmath>

using namespace std;

template<class Container>
Container by_two(const Container& x)
{
    Container temp(x);
    for(auto &x:temp)
        x *= 2;
    return temp;
}

bool single_digit(const int& value){ return (value < 10); }

class is_odd_class
{
public:
    bool operator() (const int& value) {return (value%2)==1; }
} is_Odd_Object;

bool same_integral_part(double first, double second)
{ return ( int(first) == int(second) ); }

class is_near_class
{
public:
    bool operator() (double first, double second)
    { return ( fabs( first - second )< 0.5 ); }
} is_near_Object;

int main(int argc, char **argv)
{
    forward_list<int> flist1;
    forward_list<int> flist2(3, 77);
    forward_list<int> flist3(flist2.begin(),flist2.end());
    forward_list<int> flist4(flist3);
    /** move ctor. (fourth wasted) 把flist4给flist5, 然后清空flist4 */
    forward_list<int> flist5(move(flist4));
    forward_list<int> flist6 = {3,52,25,90};

    cout << "\n flist1: "; for(int &x: flist1) cout << x << '\t';
    cout << "\n flist2: "; for(int &x: flist2) cout << x << '\t';
    cout << "\n flist3: "; for(int &x: flist3) cout << x << '\t';
    cout << "\n flist4: "; for(int &x: flist4) cout << x << '\t';
    cout << "\n flist5: "; for(int &x: flist5) cout << x << '\t';
    cout << "\n flist6: "; for(int &x: flist6) cout << x << '\t';

    forward_list<int> second1(4);
    forward_list<int> second2(3,5);

    second1 = second2;
    second2 = by_two(second1);
    cout << "\n second1:"; for(int &x:second1) cout << x;
    cout << "\n second2:"; for(int &x:second2) cout << x;

    forward_list<int> third = {20,30,40,50};
    third.insert_after( third.before_begin(), 11 );
    cout << "\n third:"; for(int &x:third) cout << x;

    forward_list<int> four1 = {1,2,3};
    forward_list<int> four2 = {10,20,30};

    auto it = four1.begin();
    four1.splice_after(four1.begin(), four2 );
    /**
     *  first: 10 20 30 1 2 3
     *  four2: (empty)
     *  "it" still points to the 1 (now four1's 4th element)
     * */

    four2.splice_after( four2.begin(), four1, four1.begin(), it );
    /** four1:10 1 2 3 four2: 20 30 */

    four1.splice_after( four1.before_begin(), four2, four2.begin() );
    /**
     * four1:30 10 1 2 3 four2: 20
     * notice that what is moved after the iterator
     * */

    four1.remove(10);
    /** four1: 30 1 2 3 */

    forward_list<int> five = {7,80,7,15,85,52,6};
    five.remove_if(single_digit); ///< 80 15 85 52
    five.remove_if(is_Odd_Object);///< 80 52

    forward_list<double> six = {15.2, 73.0, 3.14, 15.85, 69.5, 73.0, 3.99,
    15.2, 69.2, 18.5 };

    six.sort();   ///< 3.14 3.99 15.2 15.2 15.85 18.5 69.2 69.5 73.0 73.0
    six.unique(); ///< 3.14 3.99 15.2 15.85 18.5 69.2 69.5 73.0
    six.unique( same_integral_part );///< 3.14 15.2 18.5 69.2 73.0
    six.unique( is_near_Object ); ///< 3.14 15.2 69.2

    forward_list<double> seven1 = {4.2, 2.9, 3.1};
    forward_list<double> seven2 = {1.4, 7.7, 3.1};
    forward_list<double> seven3 = {6.2, 3.7, 7.1};

    seven1.sort(); ///< 2.9 3.1 4.2
    seven2.sort(); ///< 1.4 3.1 7.7
    seven1.merge(seven2); ///< 1.4 2.9 3.1 4.2 7.7

    seven1.sort( greater<double>() ); ///< 7.7 4.2 3.1 2.9 1.4
    seven3.sort( greater<double>() ); ///< 7.1 6.2 3.7
    seven1.merge( seven3, greater<double>() );
    ///< 7.7 7.1 6.2 4.2 3.7 3.1 2.9 1.4

    seven1.reverse();
    /** 1.4 2.9 3.1 3.7 4.2 6.2 7.1 .7.7 */
    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/forward_list/forward_list/)
