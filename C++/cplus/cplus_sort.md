### Sort

in c++,has `sort` function. it is evry good to use it.

#### Insertion Sort

```cpp
int temp ;
int i,j,k;

for(i=1; i <= arrCount - 1; i++){
    for(j=0; j<i; j++){
        if (arr[j] > arr[i]){
            temp = arr[j];
            arr[j] = arr[i];
            for(k=i; k>j ;k--){
                arr[k] = arr[k - 1] ;
            }
            arr[k + 1] = temp ;
        }
    }
}
```

### Quick Sort

```cpp
#include <cstdlib>
#include<iostream>

using namespace std;

/*Function for partitioning the array*/
int Partition(int low,int high,int arr[])
{
    int pivot = arr[low];/// 枢轴记录

    while (low < high){
        while (low < high && arr[high] >= pivot){
            --high;
        }

        arr[low]=arr[high];/// 交换比枢轴小的记录到左端

        while (low < high && arr[low] <= pivot){
            ++low;
        }

        arr[high] = arr[low];/// 交换比枢轴小的记录到右端
    }

    arr[low]=pivot;
    return low;
}

void Quick_sort(int low,int high,int arr[])
{
    int Piv_index,i;
    if(low < high){
        Piv_index=Partition(low,high,arr);
        Quick_sort(low,Piv_index-1,arr);
        Quick_sort(Piv_index+1,high,arr);
    }
}

int main()
{
    int *a,n,low,high,i;
    cout<<"Quick Sort Algorithm"<< endl;

    cout<<"Enter number of elements:";
    cin>>n;

    a=new int[n];
    for(i=0;i < n;i++){
        a[i]=rand()%100;
    }

    cout<<"Initial Order of elements: ";
    for(i=0;i< n;i++){
        cout<< a[i] <<" ";
    }

    cout << endl;

    low=0; high=n-1;
    Quick_sort(low,high,a);

    cout <<"Final Array After Sorting: ";
    for(i=0;i < n;i++){
        cout << a[i] <<" ";
    }
    cout << endl;

    delete[] a;

    return 0;
}
```

---
