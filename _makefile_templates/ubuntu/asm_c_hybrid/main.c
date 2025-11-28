
#include <stdio.h>

// external function in the
extern long manager(void);

int main(void) {

		printf("\nHello, my name is Sean Olson.\n");
    printf("This is the main.c driver in an Assembly-C hybrid language program.\n");
		printf("Calling the manager function in manager.asm.\n");

    long the_number = manager(); 

    printf("\nmain() received this number %ld.\n", the_number);
    printf("main() will return 0 to the operating system. Bye!\n");

    return 0;
}