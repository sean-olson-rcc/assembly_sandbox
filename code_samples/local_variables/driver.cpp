#include <iostream>

using namespace std;

extern "C"
{
  void local_vars();
}

int main() {
  cout << "Hello! This is the driver, and my name is Sean Olson.  Welcome to the local variables demo." << endl;
  
  local_vars();

  cout << "The driver is back in control." << endl;

  cout << "program exiting" << endl;

  return 0;


}