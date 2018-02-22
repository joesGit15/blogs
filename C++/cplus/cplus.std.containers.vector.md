### std::vector

```cpp
template < class T, class Alloc = allocator<T> > class vector; // generic template
```

#### Vector

Vectors are sequence containers representing(代表) arrays that can change in size.

Just like arrays, vectors use contiguous(连续) storage locations for their elements, which means that their elements can also be accessed using offsets on regular pointers to its elements, and just as efficiently as in arrays. But unlike arrays, their size can change dynamically, with their storage being handled automatically by the container.

Internally(内部), vectors use a dynamically allocated array to store their elements. This array may need to be reallocated in order to grow in size when new elements are inserted, which implies(暗示) allocating a new array and moving all elements to it. This is a relatively expensive task in terms of processing time, and thus, vectors do not reallocate each time an element is added to the container.

Instead, vector containers may allocate some extra storage to accommodate(容纳) for possible growth, and thus the container may have an actual capacity greater than the storage strictly needed to contain its elements (i.e., its size). Libraries can implement different strategies for growth to balance between memory usage and reallocations, but in any case, reallocations should only happen at logarithmically(对数) growing intervals of size so that the insertion of individual elements at the end of the vector can be provided with amortized(缓冲) constant time complexity (see push_back).

Therefore, **compared to arrays, vectors consume(消耗) more memory in exchange for the ability to manage storage and grow dynamically in an efficient way.**

**Compared to the other dynamic sequence containers (deques, lists and forward_lists), vectors are very efficient accessing its elements (just like arrays) and relatively efficient adding or removing elements from its end. For operations that involve inserting or removing elements at positions other than the end, they perform worse than the others, and have less consistent iterators and references than lists and forward_lists.**

#### Container properties

- **Sequence**
- **Dynamic array**:  Allows direct access to any element in the sequence, even through pointer arithmetics, and provides relatively fast addition/removal of elements at the end of the sequence.
- **Allocator-aware** The container uses an allocator object to dynamically handle its storage needs.

#### Iterators:

begin,end,rbegin,rend,cbegin,cend,crbegin,crend

#### Capacity:

- **size**:
- **max_size**:
- **resize**:
- **capacity**:      Return size of allocated storage capacity (public member function ) 
- **empty**:
- **reserve**:       Request a change in capacity (public member function ) 
- **shrink_to_fit**: Shrink to fit (public member function ) 

#### Element access:

- **operator[]**:
- **at**:
- **front**:    Access first element (public member function )
- **back**:     Access last element (public member function )
- **data**:     Access data (public member function )

#### Modifiers:

- **assign**:       Assign vector content (public member function ) 
- **push_back**:    Add element at the end (public member function )
- **pop_back**:     Delete last element (public member function )
- **insert**
- **erase**
- **swap**
- **clear**:
- **emplace**:      Construct and insert element (public member function )
- **emplace_back**: Construct and insert element at the end (public member function )

#### Allocator:

- **get_allocator**: Get allocator (public member function )

#### Non-member function overloads

- relational operators Relational operators for vector (function template ) 
- swap Exchange contents of vectors (function template ) 

#### Example

```cpp
#include <iostream>
#include <vector>

using namespace std;

int main(int argc, char **argv)
{
    vector<int> first1;
    vector<int> first2(4,25); ///< Note:four ints with value 100 
    vector<int> first3(first2.begin(), first2.end());
    vector<int> first4(first3);

    int intArr[] = {5,4,3,2,1};
    vector<int> second(intArr, intArr + sizeof(intArr)/sizeof(int) );

    cout << "vector first4: ";
    for(auto it = first4.begin(); it != first4.end(); it++){
        cout << *it << "  ";
    }

    cout << "\n";
    return 0;
}
```

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/vector/vector/)

---
