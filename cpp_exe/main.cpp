#include "../c_lib/sharedlib.h"
#include <cassert>
#include <cstdlib>
#include <cstring>
#include <dlfcn.h>
#include <stdio.h>

typedef MyData *(*mojolib_create_modify)(const char *, int);

void cleanup(void *handle) {
  if (handle) {
    dlclose(handle);
    printf("\nLibrary closed.\n");
  }
}

int main() {
  void *handle;
  const char *error_msg;

  const char *mojo_library_path =
      "/home/nuoc/dev/Experiments/example-project/mojo_lib/libmy_shared_lib.so";

  handle = dlopen(mojo_library_path, RTLD_LAZY);
  if (!handle) {
    fprintf(stderr, "Failed to load library %s: %s\n", mojo_library_path,
            dlerror());
    return 1;
  }
  printf("Successfully loaded Mojo shared library: %s\n", mojo_library_path);

  // Clear any existing error conditions
  dlerror();

  auto mojo_fn = (mojolib_create_modify)dlsym(handle, "mojolib_create_modify");
  if ((error_msg = dlerror()) != NULL) {
    fprintf(stderr, "Failed to find 'mojolib_create_modify': %s\n", error_msg);
    cleanup(handle);
  }

  auto myData_ptr = mojo_fn("NEOMAMA", 99);

  assert(std::strcmp(myData_ptr->name, "NEOMAMA") == 0);
  assert(myData_ptr->value == 99);

  cleanup(handle);

  return error_msg ? 1 : 0;
}
