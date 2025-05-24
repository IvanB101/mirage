//! This module provides an abstraction over a glfw window and other functionality
const c = @import("c_libs").import;

const std = @import("std");
const vk = @import("vulkan");

pub const pollEvents = c.glfwPollEvents;
pub const getRequiredInstanceExtensions = c.glfwGetRequiredInstanceExtensions;

pub const Error = error{
    GLFWInitializationFailed,
    WindowCreationFailed,
};

pub const Window = struct {
    const Self = @This();

    _handle: *c.GLFWwindow,
    width: c_int,
    height: c_int,
    framebuffer_resized: bool,

    pub const Config = struct {
        name: [*c]const u8,
        width: u32 = 800,
        height: u32 = 600,
        allocator: std.mem.Allocator,
    };

    pub fn init(config: Config) !Self {
        if (c.glfwInit() == c.GLFW_FALSE) {
            return Error.GLFWInitializationFailed;
        }
        c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);
        c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_TRUE);

        const _handle = c.glfwCreateWindow(config.width, config.height, config.name, null, null);
        const window = try config.allocator.create(Window);
        window.* = .{
            ._handle = _handle orelse return Error.WindowCreationFailed,
            .width = config.width,
            .height = config.height,
            .framebuffer_resized = false,
        };

        c.glfwSetWindowUserPointer(window._handle, window);
        // discard previous callback
        _ = c.glfwSetFramebufferSizeCallback(window._handle, resizeFrameBuffer);

        return window;
    }

    pub fn deinit(self: *Self) void {
        c.glfwDestroyWindow(self._handle);
        c.glfwTerminate();
    }

    pub fn resizeFrameBuffer(_handle: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.c) void {
        const window: *Self = @alignCast(@ptrCast(c.glfwGetWindowUserPointer(_handle)));

        window.framebuffer_resized = true;
        window.width = width;
        window.height = height;
    }

    pub fn shouldClose(self: *const Self) bool {
        return c.glfwWindowShouldClose(self._handle) != 0;
    }

    pub fn wasResized(self: *const Self) bool {
        return self.framebuffer_resized;
    }

    pub fn resetResizedFlag(self: *Self) void {
        self.framebuffer_resized = false;
    }

    pub fn handle(self: *const Self) *c.GLFWwindow {
        return self._handle;
    }

    pub fn extent(self: *const Self) vk.Extent2D {
        return .{ @intCast(self.width), @intCast(self.height) };
    }
};
