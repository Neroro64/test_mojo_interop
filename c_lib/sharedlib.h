// sharedlib.h

#ifndef SHAREDLIB_H
#define SHAREDLIB_H

// Define a simple data structure
typedef struct {
    char* name;
    int value;
} MyData;

// Function declarations
MyData* create_data(const char* initial_name, int initial_value);
void modify_data(MyData* data, const char* new_name, int new_value);
void delete_data(MyData* data);

#endif // SHAREDLIB_H