### std::unordered_multimap

```cpp
template < class Key,                                    // unordered_multimap::key_type
           class T,                                      // unordered_multimap::mapped_type
           class Hash = hash<Key>,                       // unordered_multimap::hasher
           class Pred = equal_to<Key>,                   // unordered_multimap::key_equal
           class Alloc = allocator< pair<const Key,T> >  // unordered_multimap::allocator_type
           > class unordered_multimap;
```

#### Unordered Multimap

Unordered multimaps are associative containers that store elements formed by the combination of a key value and a mapped value, **much like unordered_map containers, but allowing different elements to have equivalent keys.**

In an unordered_multimap, the key value is generally used to uniquely identify the element, while the mapped value is an object with the content associated to this key. Types of key and mapped value may differ.

**Internally, the elements in the unordered_multimap are not sorted in any particular order with respect to either their key or mapped values, but organized into buckets depending on their hash values to allow for fast access to individual elements directly by their key values (with a constant average time complexity on average).**

**Elements with equivalent keys are grouped together in the same bucket** and in such a way that an iterator (see equal_range) can iterate through all of them.

Iterators in the container are at least forward iterators.

Notice that this container is not defined in its own header, but shares header <unordered_map> with unordered_map.

#### Reference

> [cplusplus](http://www.cplusplus.com/reference/unordered_map/unordered_multimap/)
