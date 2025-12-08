# include <iostream>
#include <iomanip>

using namespace std;

extern "C" {
	void my_assembly_function(long a, double b, long c, double d, char * e);
	double my_cpp_function(long a, double b, long c, double d, char * e);
}



int main() {

	cout << "Hello from the driver" << endl;

	char my_c_string[] = "Hello, this is a cstring owned by main() !";

	my_assembly_function(88, 99.999, 2876216288, 32.23987373, my_c_string);

	cout << "Driver has regained control" << endl;

	return 0;
}


double my_cpp_function(long a, double b, long c, double d, char * e){

	cout << endl;
	cout << "Enter my_cpp_function()" << endl;

	cout << "Got a: " << a << endl;
	cout << "Got b: " << fixed << setprecision(10) << b << endl;
	cout << "Got c: " << c << endl;
	cout << "Got d: " << fixed << setprecision(10) << d << endl;
	cout << "Got e: " << e << endl;

	cout << "my_cpp_function() exiting" << endl;
	cout << endl;

	return 1112222.333334444;
}