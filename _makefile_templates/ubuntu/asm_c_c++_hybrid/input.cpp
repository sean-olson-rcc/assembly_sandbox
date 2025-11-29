#include <iostream>
#include <string>

using namespace std;


extern "C" long get_user_input() {
    long value;
    cout << "Enter a number: ";
    cin >> value;
    cout << "You entered: " << value << ", which is now being returned to manager.asm" << endl;
    
    return value;
}