const glfw = @import("glfw");
const std = @import("std");

const Device = @import("gpu/device.zig").Device;

pub const App = struct {
    const Self = @This();

    pub const Config = struct {
        name: [*c]const u8,
        allocator: std.mem.Allocator,
    };

    window: glfw.Window,
    device: Device,

    pub fn init(config: Config) !Self {
        var window = try glfw.Window.init(config.name);
        const device = try Device.init(.{
            .window = &window,
            .allocator = config.allocator,
        });

        return .{
            .window = window,
            .device = device,
        };
    }

    pub fn setup(self: *Self) void {
        self.window.setCallbacks();
    }

    pub fn deinit(self: *Self) void {
        self.window.deinit();
        self.device.deinit();
    }

    pub fn run(self: *Self) void {
        while (!self.window.shouldClose()) {
            glfw.pollEvents();
        }
    }
};
