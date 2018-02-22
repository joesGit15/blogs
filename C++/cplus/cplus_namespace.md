
```cpp
#include <iostream>

using namespace std;

namespace MyNameSpace1{
    int i;
    namespace MyNameSpace2{
        int j;
    }
}

int main()
{
    MyNameSpace1::i = 19;
    MyNameSpace1::MyNameSpace2::j = 10;
    cout << MyNameSpace1::i << " "<< MyNameSpace1::MyNameSpace2::j << "\n";
    using namespace MyNameSpace1;
    cout << i * MyNameSpace2::j;
    return 0;
}
```
