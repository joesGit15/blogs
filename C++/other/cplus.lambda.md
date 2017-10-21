### Lambda expressions (since C++11)

Constructs a closure(闭包): an unnamed function object capable of capturing variables in scope.

#### Syntax

```cpp
[ capture-list ] ( params ) mutable(optional) constexpr(optional) exception attribute -> ret { body }    (1) 
[ capture-list ] ( params ) -> ret { body } (2) 
[ capture-list ] ( params ) { body }    (3) 
[ capture-list ] { body }   (4) 
```

1. Full declaration.
2. Declaration of a const lambda: the objects captured by copy cannot be modified.
3. Omitted(忽略) trailing-return-type: the return type of the closure's operator() is determined according to the following rules:

if the body consists of nothing but a single return statement with an expression, the return type is the type of the returned expression (after lvalue-to-rvalue, array-to-pointer, or function-to-pointer implicit conversion);
otherwise, the return type is void.

The return type is deduced(推断) from return statements as if for a function whose return type is declared auto.

4. Omitted parameter list: function takes no arguments, as if the parameter list was (). This form can only be used if none of constexpr, mutable, exception specification, attributes, or trailing return type is used.

##### Explanation

- (mutable)[http://en.cppreference.com/w/cpp/language/cv](可变的): allows body to modify the parameters captured by copy, and to call their non-const member functions
- constexpr[** Don't clear this C++ key word Now!**]: explicitly specifies that the function call operator is a constexpr function. When this specifier is not present, the function call operator will be constexpr anyway, if it happens to satisfy all constexpr function requirements
- exception(异常): provides the exception specification or the noexcept clause for operator() of the closure type
- attribute:provides the attribute specification for operator() of the closure type
- capture-list:a comma-separated list of zero or more captures, optionally beginning with a capture-default.

    Capture list can be passed as follows (see below for the detailed description):

    - [a,&b] where a is captured by copy and b is captured by reference.
    - [this] captures the current object (\*this) by reference
    - [&] captures all automatic variables used in the body of the lambda by reference and current object by reference if exists
    - [=] captures all automatic variables used in the body of the lambda by copy and current object by reference if exists
    - [] captures nothing

- params:The list of parameters, as in named functions, except that default arguments are not allowed. If auto is used as a type of a parameter, the lambda is a generic lambda.
- ret:Return type. If not present it's implied by the function return statements (or void if it doesn't return any value)
- body:Function body

The lambda expression is a prvalue (prue rvalue)[http://en.cppreference.com/w/cpp/language/value_category] expression whose value is whose result object is an unnamed temporary object of unique unnamed non-union non-aggregate(非集合) class type, known as closure type, which is declared (for the purposes of ADL) in the smallest block scope, class scope, or namespace scope that contains the lambda expression. The closure type has the following members:

```cpp
ClosureType::operator()(params)

ret operator()(params) const { body }

ret operator()(params) { body }

template<template-params>
ret operator()(params) { body }
```

Executes the body of the lambda-expression, when invoked. When accessing a variable, accesses its captured copy (for the entities captured by copy), or the original object (for the entities captured by reference). Unless the keyword mutable was used in the lambda-expression, the function-call operator is const-qualified and the objects that were captured by copy are non-modifiable from inside this operator(). The function-call operator is never volatile-qualified and never virtual.

The function-call operator is always constexpr if it satisfies(满足) the requirements of a constexpr function. It is also constexpr if the keyword constexpr was used in the lambda declaration.

For every parameter in params whose type is specified as auto, an invented(** How to clear it? **) template parameter is added to template-params, in order of appearance. The invented template parameter may be a parameter pack if the corresponding function member of params is a function parameter pack.

```cpp
// generic lambda, operator() is a template with two parameters
auto glambda = [](auto a, auto&& b) { return a < b; };
bool b = glambda(3, 3.14); // ok
 
// generic lambda, operator() is a template with one parameter
auto vglambda = [](auto printer) {
    return [=](auto&&... ts) // generic lambda, ts is a parameter pack
    { 
        printer(std::forward<decltype(ts)>(ts)...);
        return [=] { printer(ts...); }; // nullary lambda (takes no parameters)
    };
};

auto p = vglambda([](auto v1, auto v2, auto v3) { std::cout << v1 << v2 << v3; });
auto q = p(1, 'a', 3.14); // outputs 1a3.14
q();                      // outputs 1a3.14
```

ClosureType's operator() cannot be explicitly instantiated or explicitly specialized.

the exception specification exception on the lambda-expression applies to the function-call operator or operator template.

For the purpose of name lookup, determining the type and value of the this pointer and for accessing non-static class members, the body of the closure type's function call operator is considered in the context of the lambda-expression.

```cpp
struct X {
    int x, y;
    int operator()(int);
    void f()
    {
        // the context of the following lambda is the member function X::f
        [=]()->int
        {
            return operator()(this->x + y); // X::operator()(this->x + (*this).y)
                                            // this has type X*
        };
    }
};
```

ClosureType's operator() cannot be named in a friend declaration.

##### Dangling references(悬空引用)

If a non-reference entity is captured by reference, implicitly(暗含) or explicitly(明确), and the function call operator of the closure object is invoked after the entity's lifetime has ended, undefined behavior occurs. The C++ closures do not extend the lifetimes of the captured references.
Same applies to the lifetime of the object pointed to by the captured this pointer.

```cpp
ClosureType::operator ret(*)(params)()

//(capture-less non-generic lambda)
using F = ret(*)(params);
operator F() const;

using F = ret(*)(params);
constexpr operator F() const;

//(capture-less generic lambda)
template<template-params> using fptr_t = /*see below*/;
template<template-params> operator fptr_t<template-params>() const;

template<template-params> using fptr_t = /*see below*/;
template<template-params> operator fptr_t<template-params>() const;
```

This user-defined conversion function is only defined if the capture list of the lambda-expression is empty. It is a public, constexpr non-virtual, non-explicit, const noexcept member function of the closure object.

A generic captureless lambda has user-defined conversion function template with the same invented template parameter list as the function-call operator template. If the return type is empty or auto, it is obtained by return type deduction on the function template specialization, which, in turn, is obtained by template argument deduction for conversion function templates.

```cpp
void f1(int (*)(int)) {}
void f2(char (*)(int)) {}
void h(int (*)(int)) {} // #1
void h(char (*)(int)) {} // #2

auto glambda = [](auto a) { return a; };
f1(glambda); // ok
f2(glambda); // error: not convertible
h(glambda); // ok: calls #1 since #2 is not convertible

int& (*fpi)(int*) = [](auto* a)->auto& { return *a; }; // ok
```

The value returned by this conversion function is a pointer to a function with C++ language linkage that, when invoked, has the same effect as invoking the closure object's function call operator directly.

This function is constexpr if the function call operator (or specialization, for generic lambdas) is constexpr.

```cpp
auto Fwd= [](int(*fp)(int), auto a){return fp(a);};
auto C=[](auto a){return a;};

static_assert(Fwd(C,3)==3);//OK

auto NC=[](auto a){static int s; return a;};

static_assert(Fwd(NC,3)==3); // error: no specialization can be constexpr because of s
```

If the closure object's operator() has a non-throwing exception specification, then the pointer returned by this function has the type pointer to noexcept function.

```cpp
ClosureType::ClosureType()

ClosureType() = delete;
ClosureType(const ClosureType& ) = default;
ClosureType(ClosureType&& ) = default;
```

Closure types are not DefaultConstructible. Closure types have a deleted (until C++14)no (since C++14) default constructor. The copy constructor and the move constructor are implicitly-declared (until C++14)declared as defaulted (since C++14) and may be implicitly-defined according to the usual rules for copy constructors and move constructors.
ClosureType::operator=(const ClosureType&)

ClosureType& operator=(const ClosureType&) = delete;
Closure types are not CopyAssignable.
ClosureType::~ClosureType()

~ClosureType() = default;
The destructor is implicitly-declared.
ClosureType::Captures

T1 a;
T2 b;
...

If the lambda-expression captures anything by copy (either implicitly with capture clause [=] or explicitly(明确的) with a capture that does not include the character &, e.g. [a, b, c]), the closure type includes unnamed non-static data members, declared in unspecified order, that hold copies of all entities that were so captured.

Those data members that correspond to captures without initializers are direct-initialized when the lambda-expression is evaluated(评估). Those that correspond to captures with initializers are initialized as the initializer requires (could be copy- or direct-initialization). If an array is captured, array elements are direct-initialized in increasing index order. The order in which the data members are initialized is the order in which they are declared (which is unspecified).

The type of each data member is the type of the corresponding captured entity, except if the entity has reference type (in that case, references to functions are captured as lvalue references to the referenced functions, and references to objects are captured as copies of the referenced objects).

For the entities that are captured by reference (with the default capture [&] or when using the character &, e.g. [&a, &b, &c]), it is unspecified if additional data members are declared in the closure type , but any such additional members must satisfy LiteralType (since C++17).

Lambda-expressions are not allowed in unevaluated expressions, template arguments, alias declarations, typedef declarations, and anywhere in a function (or function template) declaration except the function body and the function's default arguments.

#### Lambda capture

The capture-list is a comma-separated list of zero or more captures, optionally beginning with the capture-default. The only capture defaults are

- & (implicitly catch the odr-used automatic variables and \*this by reference) and
- = (implicitly catch the odr-used automatic variables by copy and implicitly catch \*this by reference if this is odr-used).

The syntax of an individual capture in capture-list is

1. identifier
2. identifier ...
3. identifier initializer
4. & identifier
5. & identifier ...
6. & identifier initializer
7. this
8. * this

- 1) simple by-copy capture
- 2) by-copy capture that is a pack expansion
- 3) by-copy capture with an initializer
- 4) simple by-reference capture
- 5) by-reference capture that is a pack expansion
- 6) by-reference capture with an initializer
- 7) by-reference capture of the current object
- 8) by-copy capture of the current object

If the capture-default is &, subsequent captures must not begin with &. If the capture-default is =, subsequent captures must begin with & or be \*this (since C++17). Any capture may appear only once.

```cpp
struct S2 { void f(int i); };

void S2::f(int i)
{
    [&]{}; //ok: by-reference capture default
    [=]{}; //ok: by-copy capture default
    [&, i]{}; // ok: by-reference capture, except i is captured by copy
    [=, &i]{}; // ok: by-copy capture, except i is captured by reference
    [&, &i] {}; // error: by-reference capture when by-reference is the default
    [=, this] {}; // error: this when = is the default
    [=, *this]{}; // ok: captures the enclosing S2 by copy (C++17)
    [i, i] {}; // error: i repeated
    [this, *this] {}; // error: "this" repeated (C++17)
}
```

Only lambda-expressions defined at block scope may have a capture-default or captures without initializers. For such lambda-expression, the reaching scope is defined as the set of enclosing scopes up to and including the innermost enclosing function (and its parameters). This includes nested(嵌套) block scopes and the scopes of enclosing lambdas if this lambda is nested.

The identifier in any capture without an initializer (other than the this-capture) is looked up using usual unqualified name lookup in the reaching scope of the lambda. The result of the lookup must be a variable with automatic storage duration declared in the reaching scope. The variable (or this) is explicitly(明确地) captured.

A capture with an initializer acts as if it declares and explicitly captures a variable declared with type auto, whose declarative region is the body of the lambda expression (that is, it is not in scope within its initializer), except that:

if the capture is by-copy, the non-static data member of the closure object is another way to refer to that auto variable.

if the capture is by-reference, the reference variable's lifetime ends when the lifetime of the closure object ends

This is used to capture move-only types with a capture such as x = std::move(x)

```cpp
int x = 4;
auto y = [&r = x, x = x + 1]()->int
    {
        r += 2;
        return x * x;
    }(); // updates ::x to 6 and initializes y to 25.
```

If a capture list has a capture-default and does not explicitly capture the enclosing object (as this or \*this) or an automatic variable, it captures it implicitly if the body of the lambda odr-uses the variable or the this pointer or the variable or the this pointer is named in a potentially(潜在的)-evaluated expression within an expression that depends on a generic lambda parameter

```cpp
void f(int, const int (&)[2] = {}) {} // #1
void f(const int&, const int (&)[1]) {} // #2

void test()
{
    const int x = 17;
    auto g1 = [](auto a) { f(x); }; // ok: calls #1, does not capture x
    auto g2 = [=](auto a) {
            int selector[sizeof(a) == 1 ? 1 : 2] = {};
            f(x, selector); // ok: is a dependent expression, so captures x
    };
}
```

If the body of a lambda odr-uses an entity captured by copy, the member of the closure type is accessed. If it is not odr-using the entity, the access is to the original object:

```cpp
void f(const int*);

void g()
{
    const int N = 10;
    [=]{ 
        int arr[N]; // not an odr-use: refers to g's const int N
        f(&N); // odr-use: causes N to be captured (by copy)
               // &N is the address of the closure object's member N, not g's N
    }();
}
```

If a lambda odr-uses a reference that is captured by reference, it is using the object referred-to by the original reference, not the captured reference itself:

```cpp
#include <iostream>
 
auto make_function(int& x) {
  return [&]{ std::cout << x << '\n'; };
}
 
int main() {
  int i = 3;
  auto f = make_function(i); // the use of x in f binds directly to i
  i = 5;
  f(); // OK; prints 5
}
```

Within the body of a lambda, any use of decltype on any variable with automatic storage duration is as if it were captured and odr-used, even though decltype itself isn't an odr-use and no actual capture takes place:

```cpp
void f3() {
    float x, &r = x;
    [=]
    { // x and r are not captured (appearance in a decltype operand is not an odr-use)
        decltype(x) y1; // y1 has type float
        decltype((x)) y2 = y1; // y2 has type float const& because this lambda
                               // is not mutable and x is an lvalue
        decltype(r) r1 = y1;   // r1 has type float& (transformation not considered)
        decltype((r)) r2 = y2; // r2 has type float const&
    };
}
```

Any entity captured by a lambda (implicitly or explicitly) is odr-used by the lambda-expression (therefore, implicit capture by a nested lambda triggers implicit capture in the enclosing lambda).

All implicitly-captured variables must be declared within the reaching scope of the lambda.

If a lambda captures the enclosing object (as this or \*this), the nearest enclosing function must be a non-static member function:

```cpp
struct s2 {
  double ohseven = .007;
  auto f() { // nearest enclosing function for the following two lambdas
    return [this] { // capture the enclosing s2 by reference
      return [*this] { // capture the enclosing s2 by copy (C++17)
          return ohseven; // OK
       }
     }();
  }
  auto g() {
     return []{ // capture nothing
         return [*this]{}; // error: *this not captured by outer lambda-expression
      }();
   }
};
```

If a lambda expression (or an instantiation of a generic lambda's function call operator) ODR-uses this or any variable, it must be captured by the lambda expression.

```cpp
void f1(int i)
{
    int const N = 20;
    auto m1 = [=] {
            int const M = 30;
            auto m2 = [i] {
                    int x[N][M]; // N and M are not odr-used 
                                 // (ok that they are not captured)
                    x[0][0] = i; // i is explicitly captured by m2
                                 // and implicitly captured by m1
            };
    };
 
    struct s1 // local class within f1()
    {
        int f;
        void work(int n) // non-static member function
        {
            int m = n * n;
            int j = 40;
            auto m3 = [this, m] {
                auto m4 = [&, j] { // error: j is not captured by m3
                        int x = n; // error: n is implicitly captured by m4
                                   // but not captured by m3
                        x += m;    // ok: m is implicitly captured by m4
                                   // and explicitly captured by m3
                        x += i;    // error: i is outside of the reaching scope
                                   // (which ends at work())
                        x += f;    // ok: this is captured implicitly by m4
                                   // and explicitly captured by m3
                };
            };
        }
    };
}
```

Class members cannot be captured explicitly by a capture without initializer (as mentioned above, only variables are permitted in the capture list):

```cpp
class S {
  int x = 0;
  void f() {
    int i = 0;
//  auto l1 = [i, x]{ use(i, x); };    // error: x is not a variable
    auto l2 = [i, x=x]{ use(i, x); };  // OK, copy capture
    i = 1; x = 1; l2(); // calls use(0,0)
    auto l3 = [i, &x=x]{ use(i, x); }; // OK, reference capture
    i = 2; x = 2; l3(); // calls use(1,2)
  }
};
```

When a lambda captures a member using implicit by-copy capture, it does not make a copy of that member variable: the use of a member variable m is treated as an expression (\*this).m, and the this pointer is what's captured (by value) instead. The member behaves as if caught by reference:

```cpp
class S {
  int x = 0;
  void f() {
    int i = 0;
    auto l1 = [=]{ use(i, x); }; // captures a copy of i and a copy of the this pointer
    i = 1; x = 1; l1(); // calls use(0,1), as if i by copy and x by reference
    auto l2 = [i, this]{ use(i, x); }; // same as above, made explicit
    i = 2; x = 2; l2(); // calls use(1,2), as if i by copy and x by reference
    auto l3 = [&]{ use(i, x); }; // captures i by reference and a copy of the this pointer
    i = 3; x = 2; l3(); // calls use(3,2), as if i and x are both by reference
    auto l4 = [i, *this]{ use(i, x); }; // makes a copy of *this, including a copy of x
    i = 4; x = 4; l4(); // calls use(3,2), as if i and x are both by copy
  }
};
```

If a lambda-expression appears in a default argument, it cannot explicitly or implicitly capture anything.

Members of anonymous unions cannot be captured.

If a nested lambda m2 captures something that is also captured by the immediately enclosing lambda m1, then m2's capture is transformed as follows:

if the enclosing lambda m1 captures by copy, m2 is capturing the non-static member of m1's closure type, not the original variable or this.

if the enclosing lambda m1 by reference, m2 is capturing the original variable or this.

```cpp
#include <iostream>
 
int main()
{
    int a = 1, b = 1, c = 1;
 
    auto m1 = [a, &b, &c]() mutable {
        auto m2 = [a, b, &c]() mutable {
            std::cout << a << b << c << '\n';
            a = 4; b = 4; c = 4;
        };
        a = 3; b = 3; c = 3;
        m2();
    };
 
    a = 2; b = 2; c = 2;
 
    m1();                             // calls m2() and prints 123
    std::cout << a << b << c << '\n'; // prints 234
}
```

This example shows (a) how to pass a lambda to a generic algorithm; (b) how objects resulting from a lambda declaration can be stored in std::function objects.

```cpp
#include <vector>
#include <iostream>
#include <algorithm>
#include <functional>
 
int main()
{
    std::vector<int> c = {1, 2, 3, 4, 5, 6, 7};
    int x = 5;
    c.erase(std::remove_if(c.begin(), c.end(), [x](int n) { return n < x; }), c.end());
 
    std::cout << "c: ";
    std::for_each(c.begin(), c.end(), [](int i){ std::cout << i << ' '; });
    std::cout << '\n';
 
    // the type of a closure cannot be named, but can be inferred with auto
    auto func1 = [](int i) { return i + 4; };
    std::cout << "func1: " << func1(6) << '\n';
 
    // like all callable objects, closures can be captured in std::function
    // (this may incur unnecessary overhead)
    std::function<int(int)> func2 = [](int i) { return i + 4; };
    std::cout << "func2: " << func2(6) << '\n';
}
```

```
Output:
c: 5 6 7
func1: 10
func2: 10
```

#### Reference

- [cppreference](http://en.cppreference.com/w/cpp/language/lambda)

---
