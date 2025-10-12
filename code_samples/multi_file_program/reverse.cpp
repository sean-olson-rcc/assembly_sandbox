#include <iostream>
using namespace std;

extern "C" long* reverse_array(long* arr, int length) {

  // verify that a valid array was passed  
			return arr; 
		}	

		// initialize the indexes
    int start = 0;
    int end = length - 1;

		// loop through the array, swapping first and last values
    while (start < end) {
        int temp = arr[start];
        arr[start] = arr[end];
        arr[end] = temp;

        start++;
        end--;
    }

    return arr;

	return arr;
}