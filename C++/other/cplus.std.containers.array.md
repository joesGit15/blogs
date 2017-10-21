### std::array

template < class T, size_t N > class array;

#### Code Example

```cpp
#include <iostream>
#include <array>
#include <cstring>

using namespace std;

int main(int argc, char **argv)
{
    array<int, 5> intArr = {1,2,3,4,5};
    for(auto it = intArr.begin(); it != intArr.end(); it++ )
    {
        cout << *it << "\t";
    }
    ///< output: 1  2   3   4   5

    cout << "\n";
    ///< r means reverse
    for(auto rit = intArr.rbegin(); rit < intArr.rend(); rit++)
    {
        cout << *rit << "\t";
    }
    ///< output: 5  4   3   2   1

    cout << "\n";
    ///< c means const
    for(auto cit = intArr.cbegin(); cit != intArr.cend(); cit++ )
    {
        cout << *cit << "\t";
    }
    ///< output:1   2   3   4   5
    
    cout << "\n";
    for(auto crit = intArr.crbegin(); crit < intArr.crend(); crit++)
    {
        cout << *crit << "\t";
    }
    ///< output:5   4   3   2   1

    cout << "\n";
    cout << "size of array:" << intArr.size() << "\n"; ///< output: 5
    cout << "sizeof array:" << sizeof intArr << "\n";  ///< output: 5

    cout << "\n";
    array<char, 10> arrCh = {'a','b','c','d','e'};
    cout << "size of array:" << arrCh.size() << "\n"; ///< output: 10
    cout << "max_size of array" << arrCh.max_size() << "\n"; ///< output: 10

    cout<< "\n";
    array<int, 0> first;
    array<int, 5> second;
    cout << "first array:" << first.empty() << "\n"; 
    ///< output: 1, means true
    cout << "second array:" << second.empty() << "\n";
    ///< output: 0, means false

    for(int i=0; i < second.size(); i++){
        second[i]=i;
    }

    for(auto it = second.begin(); it != second.end(); it++){
        cout << *it << "\t";
    }
    ///< output: 10 11  12  13  14

    for(int i=0; i < second.size(); i++){
        second.at(i) = i;
    }
    cout << "\n";
    for(int i=0; i< second.size(); i++){
        cout << second.at(i) << "\t";
    }
    ///< output:1   2   3   4   5

    array<int, 3> third = {1,2,3};
    for(int &x:third){
        cout << x << "\t";
    }
    ///< output:1   2   3

    cout << "\n";
    cout << "array::front():" << third.front() << "\n"; ///< output: 1
    cout << "array::back():" << third.back() << "\n";   ///< output: 3
    cout <<"modify front and back\n";
    third.front() == 11;
    third.back() = 22;
    cout << "array::front():" << third.front() << "\n"; ///< output: 11
    cout << "array::back():" << third.back() << "\n";   ///< output: 22

    const char * cstr = "Hello array";
    array<char, 20> arrChar;
    memcpy(arrChar.data(),cstr, strlen(cstr));
    cout << arrChar.data() << "\n";
    ///< output: Hello array

    array<int,10> fourth;
    fourth.fill(2);
    for(int &x:fourth){
        cout << x << "\t";
    }
    ///< output: 2  2   2   2   2   2   2   2   2   2

    array<int, 5> five = {1,2,3,4,5};
    array<int, 5> six = {6,7,8,9,0};
    five.swap(six);
    cout << "\n";
    for(int &x:five){
        cout << x << "\t";
    }
    ///< output: 6  7   8   9   0

    cout << "\n";
    for(int &x:six){
        cout << x << "\t";
    }
    ///< output:1   2   3   4   5

    array<int,5> a = {1,2,3,4,5};
    array<int,5> b = {1,2,3,4,5};
    array<int,5> c = {5,4,3,2,1};

    cout << "\n";
    /** They are both true */
    if( a == b ) cout << " a and b are equal!\n";
    if( b!=c ) cout << "b and c are not equal!\n";
    if( b < c ) cout << "b is less than c\n";
    if( c > b ) cout << "c is greater than b\n";
    if( a <= b ) cout << "a is less than or equal b\n";
    if( a >= b ) cout << "ais greater than or equal b\n";

    return 0;
}
```

#### Array class

Arrays are **fixed-size sequence containers:** they hold a specific number of
elements ordered in a strict linear sequence.

Internally, an array does not keep any data other than the elements it
contains (not even its size, which is a template parameter, fixed on compile
 time). It is as efficient in terms of storage size as an ordinary array
declared with the language's bracket syntax ([]). This class merely adds a
layer of member and global functions to it, so that arrays can be used as
standard containers.

Unlike the other standard containers, arrays have a fixed size and do not
manage the allocation of its elements through an allocator: they are an
aggregate type encapsulating a fixed-size array of elements. Therefore,
they cannot be expanded or contracted dynamically (see vector for a similar
container that can be expanded).Zero-sized arrays are valid, but they should
not be dereferenced (members front, back, and data).

Unlike with the other containers in the Standard Library, swapping two array
containers is a linear operation that involves swapping all the elements in
the ranges individually, which generally is a considerably less efficient
operation. On the other side, this allows the iterators to elements in both
containers to keep their original container association.

Another unique feature of array containers is that they can be treated as 
tuple objects: The <array> header overloads the get function to access the
elements of the array as if it was a tuple, as well as specialized tuple_size
and tuple_element types.

#### Container properties

- **Sequence**:Elements in sequence containers are ordered in a strict linear
sequence.Individual elements are accessed by their position in this sequence.
- **Contiguous storage**:The elements are stored in contiguous memory 
locations, allowing constant time random access to elements. Pointers to an
element can be offset to access other elements.
- **Fixed-size aggregate**:The container uses implicit constructors and
destructors to allocate the required space statically. Its size is
compile-time constant. No memory or time overhead.

#### Template parameters

- **T**:Type of the elements contained. Aliased as member type
array::value_type.
- **N**:Size of the array, in terms of number of elements.

In the reference for the array member functions, these same names are assumed
for the template parameters.

#### Member types

The following aliases are member types of array. They are widely used as
parameter and return types by member functions:

member|typedefinitio|notes
---|---|---
value_type              |The first template parameter (T)               |
reference               |value_type&                                    |
const_reference         |const value_type&                              |
pointer                 |value_type\*                                   |
const_pointer           |const value_type\*                             |
iterator                |a random access iterator to value_type         |
convertible to const_iterator
const_iterator          |a random access iterator to const value_type   |
reverse_iterator        |reverse_iterator<iterator>                     |
const_reverse_iterator  |reverse_iterator<const_iterator>               |
size_type               |size_t                                         |
unsigned integral type
difference_type         |ptrdiff_t                                      |
signed integral type

#### Member functions

##### Iterators

- **begin**:    Return iterator to beginning (public member function )
- **end**:      Return iterator to end (public member function )
- **rbegin**:   Return reverse iterator to reverse beginning (public member
        function )
- **rend**:     Return reverse iterator to reverse end (public member function
        )
- **cbegin**:   Return const_iterator to beginning (public member function )
- **cend**:     Return const_iterator to end (public member function )
- **crbegin**:  Return const_reverse_iterator to reverse beginning (public
        member function )
- **crend**:    Return const_reverse_iterator to reverse end (public member
        function )

##### Capacity

- **size**:         Return size (public member function )
- **max_size**:     Return maximum size (public member function )
- **empty**:        Test whether array is empty (public member function )

##### Element access

- **operator[]**:    Access element (public member function )
- **at**:            Access element (public member function )
- **front**:         Access first element (public member function )
- **back**:          Access last element (public member function )
- **data**:          Get pointer to data (public member function )


##### Modifiers

- **fill**:    Fill array with value (public member function )
- **swap**:    Swap content (public member function )

##### Non-member function overloads

- **get (array)**: Get element (tuple interface) (function template )
- **relational operators (array)**:Relational operators for array
(function template )


##### Non-member class specializations

- **tuple_element<array>**:
    Tuple element type for array (class template specialization )
- **tuple_size<array>**:
    Tuple size traits for array (class template specialization )

#### 参考文献

> [cplusplus](http://www.cplusplus.com/reference/array/array/)
