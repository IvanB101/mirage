const c = @import("c_libs").import;

pub const res = @import("result.zig");
pub const fun = @import("functions.zig");
pub const t = @import("types/root.zig");
pub const en = @import("enums.zig");
pub const ext = @import("extensions.zig");

pub const NullHandle = c.VK_NULL_HANDLE;
// macros
pub const MakeVersion = c.VK_MAKE_VERSION;
