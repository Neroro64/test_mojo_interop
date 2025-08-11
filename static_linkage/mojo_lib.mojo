from sys.ffi import c_char, c_int, c_size_t, external_call

fn main() raises:
  alias name = "YOMAMA";
  var name_ptr = name.unsafe_cstr_ptr()
  _ = external_call["greet_from_c", NoneType, UnsafePointer[c_char]](name_ptr)

  var result = external_call["add_from_c", c_int, c_int, c_int](123, 321)
  print("Result: {}".format(result))
