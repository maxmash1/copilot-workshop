# Project 5 - Build a runtime analysis tool that analyzes performance of various functions

Example ideas of functions to analyze
- Language native - Built-in sort
- User implemented - Quick sort, Merge sort, Selection sort, Bubble sort

Steps: Use GitHub Copilot to
- Build a function that generates lists of random integers according to provided input: 10 - 1 million
- List size will be specified by user at run-time
- Range of integer values will be specified by user at run-time
- Run the functions (sorting algorithms) with generated list of integers
- Calculate and display the time it took to run the function
- Allow for multiple runs

Method:
Use GH Copilot to build each step for you


<details>

<summary>Completed Python implementation, for emergency reference only</summary>

**analyzer.py**

```python
import time
import random
from demos import quicksort, mergesort, bubblesort

def create_random_list(size, max_val):
    ran_list = []
    for num in range(size):
        ran_list.append(random.randint(1,max_val))
    return ran_list

def analyze_func(func_name, arr):
    tic = time.time()
    func_name(arr)
    toc = time.time()
    seconds = toc-tic
    print(f"{func_name.__name__.capitalize()}\t-> Elapsed time: {seconds:.5f}")

size = int(input("What size list do you want to create? "))
max = int(input("What is the max value of the range? "))
run_times = int(input("How many times do you want to run? "))

for num in range(run_times):
    print(f"Run: {num+1}")
    l = create_random_list(size,max)
    analyze_func(bubblesort, l.copy())
    analyze_func(quicksort, l)
    analyze_func(mergesort, l)
    analyze_func(sorted, l)
    print("-" * 40)

```


**demos.py**
```python
print("Algorithms file loaded")

def quicksort(arr):
    if len(arr) < 2:
        return arr
    else:
        pivot = arr[-1]
        smaller, equal, larger = [], [], []
        for num in arr:
            if num < pivot:
                smaller.append(num)
            elif num == pivot:
                equal.append(num)
            else:
                larger.append(num)
        return quicksort(smaller) + equal + quicksort(larger)

def merge_sorted(arr1,arr2):
    sorted_arr = []
    i, j = 0, 0
    while i < len(arr1) and j < len(arr2):
        if arr1[i] < arr2[j]:
            sorted_arr.append(arr1[i])
            i += 1
        else:
            sorted_arr.append(arr2[j])
            j += 1
    while i < len(arr1):
        sorted_arr.append(arr1[i])
        i += 1
    while j < len(arr2):
        sorted_arr.append(arr2[j])
        j += 1
    return sorted_arr

def mergesort(arr):
    if len(arr) < 2:
        return arr[:]
    else:
        middle = len(arr)//2
        l1 = mergesort(arr[:middle])
        l2 = mergesort(arr[middle:])
        return merge_sorted(l1, l2)

def bubblesort(arr):
    swap_happened = True
    while swap_happened:
        swap_happened = False
        for num in range(len(arr)-1):
            if arr[num] > arr[num+1]:
                swap_happened = True
                arr[num], arr[num+1] = arr[num+1], arr[num]


```

</details>