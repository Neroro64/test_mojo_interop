from memory import UnsafePointer
from sys.ffi import c_char, c_int, DLHandle

@value
struct MyData:
  var Name: UnsafePointer[c_char]
  var Value: c_int

struct CLibHandler(Copyable):
  var dlHandle: Optional[DLHandle]
  alias create_data_func_t = fn(UnsafePointer[c_char], c_int) -> UnsafePointer[MyData]
  alias modify_data_func_t = fn(UnsafePointer[MyData], UnsafePointer[c_char], c_int)
  alias delete_data_func_t = fn(UnsafePointer[MyData])

  fn __init__(out self) raises:
    self.dlHandle = DLHandle("/home/nuoc/dev/Experiments/example-project/c_lib/libshared.so")


  fn create(self, name: StringLiteral, value: Int) raises -> Optional[UnsafePointer[MyData]]:
    if self.dlHandle:
      var create_data_func = self.dlHandle[].get_function[CLibHandler.create_data_func_t]("create_data")
      return create_data_func(name.unsafe_cstr_ptr(), value)
    return None

  fn modify(self, myData: UnsafePointer[MyData], owned name: String, value: Int) raises:
    if self.dlHandle:
      var modify_data_func = self.dlHandle[].get_function[CLibHandler.modify_data_func_t]("modify_data")
      modify_data_func(myData, name.unsafe_cstr_ptr(), value)

  fn delete(self, myData: UnsafePointer[MyData]) raises:
    if self.dlHandle:
      var delete_data_func = self.dlHandle[].get_function[CLibHandler.delete_data_func_t]("delete_data")
      delete_data_func(myData)

  fn __enter__(self) -> Self: return self

  fn __exit__(mut self) raises:
    try:
      if self.dlHandle:
        self.dlHandle[].close()
    except e:
      print("Failued to release the handle: ", e)


@export(ABI="C")
fn mojolib_create_modify(newName: UnsafePointer[c_char], newValue: c_int) -> UnsafePointer[MyData]:
  var myData_ptr = UnsafePointer[MyData].alloc(1)
  myData_ptr[].Name = newName
  myData_ptr[].Value = newValue
  return myData_ptr

