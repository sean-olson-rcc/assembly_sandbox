#include <iostream>
using namespace std;

extern "C" int* reverse_array(int* arr, int length) {

	cout << "In the reverse.cpp file\n" << endl;
  // // verify that a valid array was passed  
	// if (!arr || length <= 1) {
	// 		cout << "[reverse_array()] ERROR: array passed to function was wither null or empty" << endl;
	// 		return arr; 
	// 	}	

	// 	// initialize the indexes
  //   int start = 0;
  //   int end = length - 1;

	// 	// loop through the array, swapping first and last values
  //   while (start < end) {
  //       int temp = arr[start];
  //       arr[start] = arr[end];
  //       arr[end] = temp;

  //       start++;
  //       end--;
  //   }

  //   return arr;
	cout << "Returning from the reverse.cpp file\n" << endl;	
	return 0
}