#include <stdint.h>
#include <stdio.h>

// external function in the
extern long manager(void);

int main(void) {
    printf("Welcome to Arrays of Integers\n");
    printf("Brought to you by Sean Olson\n");

    long mean_value = manager(); // assign return value from assembly

    printf("\nMain received this number %ld.\n", mean_value);
    printf("Main will return 0 to the operating system. Bye!\n");

    return 0;
}