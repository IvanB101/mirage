const std = @import("std");
const lib = @import("mirage_lib");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var app = try lib.App.init(.{
        .name = "mirage engine",
        .allocator = gpa.allocator(),
    });
    defer app.deinit();
    app.setup();
    app.run();
}
