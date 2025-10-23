// ============================================================================
// Program: Largest Number Finder
// File: largest.cpp
// Description: Main driver program that serves as the entry point.
//              This C++ file prints welcome/exit messages and calls the
//              assembly manager function to coordinate the program flow.
// Author: Generated for Assembly/C++ Hybrid Programming Exercise
// Platform: Ubuntu x86-64
// Assembler: YASM
// Compiler: g++
// ============================================================================

#include <iostream>
#include <cstdint>

using namespace std;

// ============================================================================
// External Function Declaration
// ============================================================================
// The manager function is implemented in manager.asm
// It coordinates all program operations and returns the count of integers entered
extern "C" int64_t manager();

// ============================================================================
// Function: main
// Description: Entry point of the program. Prints welcome message, invokes
//              the assembly manager function, and displays the result.
// Parameters: None
// Returns: 0 to the operating system indicating successful execution
// ============================================================================
int main() {
    // Print welcome banner
    // Note: The name "Burgundy Flemming" should be replaced with your actual name
    cout << "Welcome to the Largest Number program, brought to you by Burgundy Flemming." << endl;
    
    // Call the assembly manager function
    // This function will coordinate all other operations:
    // - Allocating stack space for the integer array
    // - Getting user input via input_array()
    // - Displaying the array via output_array()
    // - Finding the largest value via find_largest()
    // - Returning the count of integers entered
    int64_t count = manager();
    
    // Display the value returned from manager
    // This count represents how many integers the user successfully entered
    cout << "The driver received this value: " << count << endl;
    
    // Print farewell message
    cout << "Have a nice day. The program will return control to the operating system." << endl;
    
    // Return 0 to indicate successful program execution
    return 0;
}
