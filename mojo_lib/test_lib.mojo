from memory import UnsafePointer
from testing import assert_equal, assert_true
from my_shared_lib import CLibHandler, MyData

fn test_create_my_data() raises:
  var handler = CLibHandler()
  var data = handler.create("YOMAMA", 42)
  
  assert_true(data)
  assert_equal("YOMAMA", String(unsafe_from_utf8_ptr=data[][].Name))
  assert_equal(42, data[][].Value)

fn test_modify_my_data() raises:
  var handler = CLibHandler()
  var myData = MyData(Name="YOMAMA".unsafe_cstr_ptr(), Value=42)

  var newName: String = "AINT YOMAMA"
  handler.modify(UnsafePointer[MyData](to=myData),newName^, 74)

  assert_equal("AINT YOMAMA", String(unsafe_from_utf8_ptr=myData.Name))
  assert_equal(74, myData.Value)

fn test_delete_my_data() raises:
  var handler = CLibHandler()
  var data = handler.create("YOMAMA", 42)

  handler.delete(data[])
