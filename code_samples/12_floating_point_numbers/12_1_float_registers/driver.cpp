#include <iostream>

extern "C" {
	double floater();
}

using namespace std;

int main(){

	cout << "Hello from the driver" << endl ;

	double return_value = floater();

	cout << "Driver has regained control." << endl;
	cout << "Driver has received this value: " << return_value << endl;

	return 0;

}


