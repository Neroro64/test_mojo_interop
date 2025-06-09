// main.zig
const std = @import("std");

// Define a Zig equivalent of the C struct.
// This tells Zig about the memory layout of the data
// being passed from the shared library.
const MyData = extern struct {
    name: [*c]const u8,
    value: c_int,
};

pub fn main() !void {
    const lib_path = "/home/nuoc/dev/Experiments/example-project/mojo_lib/libmy_shared_lib.so";

    // 1. Use the modern, safer API to open the shared library.
    var lib = try std.DynLib.open(lib_path);
    defer lib.close();

    // 2. Look up symbols with type safety. The function signature is provided directly.
    const create_data = lib.lookup(fn ([*c]const u8, c_int) callconv(.C) ?*MyData, "create_data") orelse {
        std.log.err("error: could not find symbol 'create_data'\n", .{});
        return;
    };

    const modify_data = lib.lookup(fn (?*MyData, [*c]const u8, c_int) callconv(.C) void, "modify_data") orelse {
        std.log.err("error: could not find symbol 'modify_data'\n", .{});
        return;
    };

    const delete_data = lib.lookup(fn (?*MyData) callconv(.C) void, "delete_data") orelse {
        std.log.err("error: could not find symbol 'delete_data'\n", .{});
        return;
    };

    // 3. Create data, using c"..." for a null-terminated C string.
    // Use `orelse` to gracefully handle the null pointer case.
    const my_data = create_data("InitialName", 42) orelse {
        std.log.err("failed to create data\n", .{});
        return;
    };

    // Zig automatically dereferences pointers for field access.
    std.debug.print("Created: name={s}, value={d}\n", .{ my_data.name, my_data.value });

    // 4. Modify data
    modify_data(my_data, "NewName", 99);

    std.debug.print("Modified: name={s}, value={d}\n", .{ my_data.name, my_data.value });

    // 5. Delete data
    delete_data(my_data);
    std.debug.print("Data deleted.\n", .{});
}