// sharedlib.c

#include <stdlib.h>
#include <string.h>

// Define a simple data structure
typedef struct {
    char* name;
    int value;
} MyData;

// Function to create the data structure
MyData* create_data(const char* initial_name, int initial_value) {
    MyData* data = (MyData*)malloc(sizeof(MyData));
    if (!data)
        return NULL;

    data->name = strdup(initial_name);
    data->value = initial_value;
    
    return data;
}

// Function to modify the data structure
void modify_data(MyData* data, const char* new_name, int new_value) {
    if (!data)
        return;

    data->name = strdup(new_name);
    data->value = new_value;
}

// Function to delete the data structure
void delete_data(MyData* data) {
    if (data) {
        free(data->name);
        free(data);
    }
}