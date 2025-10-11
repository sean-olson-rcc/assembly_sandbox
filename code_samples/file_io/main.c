#include <stdio.h>

extern int file_io();

int main(){
    printf("Hello from the main.c driver\n");

    long result = file_io();

    printf("Driver got the following value from file_io(): %ld\n", result);
    return 0;
}