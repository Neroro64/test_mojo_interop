// main.c

#include <stdio.h>
#include "sharedlib.h"

int main() {
    // Create data structure instance
    MyData* data = create_data("InitialName", 42);
    
    printf("Created: %s, %d\n", data->name, data->value);

    // Modify the instance
    modify_data(data, "NewName", 100);
    printf("Modified: %s, %d\n", data->name, data->value);

    // Clean up
    delete_data(data);

    return 0;
}