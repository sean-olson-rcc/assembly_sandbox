#include <iostream>

extern "C" {
	void point(char * print_me, long * change_me); // disables name mangling so C++ can call it
	void hey_driver_print_this(char * the_string, long * the_long, double * the_double) ;
}

using namespace std;

int main(){

	cout << "Hello from the driver" << endl ;

	char my_c_string[] = "Hello, this is the c-string owned by main()!";
	long my_long = 100;

	cout << "Driver sees my_long as :" << my_long << endl;

	point(my_c_string, & my_long);

	cout << "Driver is back in control" << endl;
	cout << "Driver sees my_long as: " << my_long << endl;

	return 0;

}

void hey_driver_print_this(char * the_string, long * the_long, double * the_double){
	
	cout << endl;
	cout << "Driver has received a call to hey_driver_print_this()." << endl;
	cout << "Got the string: " << the_string << endl;
	cout << "Got the long (" << the_long << "): " << *the_long << endl;
	cout << "Got the double (" << the_double << "): " << *the_double << endl;
	cout << "hey_driver_print_this() exiting" << endl;
	cout << endl;

}


