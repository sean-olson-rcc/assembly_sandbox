#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

long get_input(double* the_double){

	char buffer[LINE_MAX];

	if (fgets(buffer, LINE_MAX, stdin) == NULL || sscanf(buffer, "%lf", the_double) < 1){
		return 0;
	}
	 return 1;
}

int main() {
	// 
	double value;
	long result = get_input(&value);

	printf("get_input() returned %ld and the value is now: %lf\n", result, value);

	return 0;
}

