from memory import UnsafePointer
from sys.ffi import c_char, c_int, DLHandle

@value
struct MyData:
  var Name: UnsafePointer[c_char]
  var Value: c_int

struct CLibHandler:
  var dlHandle: DLHandle
  alias create_data_func_t = fn(UnsafePointer[c_char], c_int) -> UnsafePointer[MyData]
  alias modify_data_func_t = fn(UnsafePointer[MyData], UnsafePointer[c_char], c_int)
  alias delete_data_func_t = fn(UnsafePointer[MyData])

  fn __init__(out self) raises:
    self.dlHandle = DLHandle("/home/nuoc/dev/Experiments/example-project/c_lib/libshared.so")


  fn create(self, name: StringLiteral, value: Int) -> UnsafePointer[MyData]:
    var create_data_func = self.dlHandle.get_function[CLibHandler.create_data_func_t]("create_data")
    return create_data_func(name.unsafe_cstr_ptr(), value)

  fn modify(self, myData: UnsafePointer[MyData], owned name: String, value: Int):
    var modify_data_func = self.dlHandle.get_function[CLibHandler.modify_data_func_t]("modify_data")
    return modify_data_func(myData, name.unsafe_cstr_ptr(), value)

  fn delete(self, myData: UnsafePointer[MyData]):
    var delete_data_func = self.dlHandle.get_function[CLibHandler.delete_data_func_t]("delete_data")
    return delete_data_func(myData)


@export(ABI="C")
fn mojolib_create_modify(newName: UnsafePointer[c_char], newValue: c_int) raises -> UnsafePointer[MyData]:
  var handle = CLibHandler()
  
  var data = handle.create("YOMAMA", 42)

  handle.modify(data, String(unsafe_from_utf8_ptr=newName), Int(newValue))

  return data

