#include <iostream>
using namespace std;

extern "C" long* reverse_array(long* arr, int length) {

    // verify that a valid array was passed  
    if (arr == nullptr || length <= 0) {
        return arr; 
    }	

    // initialize the indexes
    int start = 0;
    int end = length - 1;

    // loop through the array, swapping first and last values
    while (start < end) {
        long temp = arr[start];    // Also changed int to long here
        arr[start] = arr[end];
        arr[end] = temp;

        start++;
        end--;
    }

    return arr;
}