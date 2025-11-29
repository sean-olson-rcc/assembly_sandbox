
#include <iostream>


using namespace std;

// reference the manager function in the manager.asm file
extern "C" { 
    long manager();
}

int main() {

    cout << endl << "Hello, my name is Sean Olson." << endl;
    cout << "This is the main.cpp driver in an Assembly-C++ hybrid language program." << endl;
    cout << "Calling the manager function in manager.asm." << endl;
    
    // call the manager function and assign the return value to count
    long the_number = manager();
    
    cout << endl << "The driver received this value: " << the_number << endl;
    cout << "Have a nice day. The program will return control to the operating system." << endl << endl;
    
    return 0;
}