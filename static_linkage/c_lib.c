#include <stdio.h>
#include "c_lib.h" // Assuming you have a header

void greet_from_c(const char* name) {
    printf("Hello, %s from C (statically linked)!\n", name);
}

int add_from_c(int a, int b) {
    return a + b;
}
