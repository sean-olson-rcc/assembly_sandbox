#include <stdint.h> // for int64_t if you want explicit size
#include <stdio.h>

// external function in the
extern long manager(void);

int main(void) {
    printf("Hello from main.c\n");
    printf("Calling int_from_asm_a() in the_asm_file.asm\n");

    long asm_a_value = manager(); // assign return value from assembly

    printf("\nback in main.c and we received this from the_asm_file.asm: %ld\n", asm_a_value);
    printf("Main will return 0 to the operating system. Bye!\n");

    return 0;
}