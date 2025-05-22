//! This module provides an abstraction over a glfw window and other functionality
const c = @import("c_libs").import;

const std = @import("std");
const vk = @import("vulkan");

pub const pollEvents = c.glfwPollEvents;
pub const getRequiredInstanceExtensions = c.glfwGetRequiredInstanceExtensions;

pub const Error = error{
    GLFWInitializationFailed,
    WindowCreationFailed,
    SurfaceCreationFailed,
};

pub const Window = struct {
    const Self = @This();
    const InitialHeight = 600;
    const InitialWidth = 800;

    _handle: *c.GLFWwindow,
    width: c_int,
    height: c_int,
    framebuffer_resized: bool,

    pub fn init(name: [*c]const u8) !Self {
        if (c.glfwInit() == c.GLFW_FALSE) {
            return Error.GLFWInitializationFailed;
        }
        c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);
        c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_TRUE);

        const _handle = c.glfwCreateWindow(InitialWidth, InitialHeight, name, null, null);
        if (_handle == null) {
            return Error.WindowCreationFailed;
        }

        return .{ ._handle = _handle orelse unreachable, .width = InitialWidth, .height = InitialHeight, .framebuffer_resized = false };
    }

    pub fn setCallbacks(self: *Self) void {
        c.glfwSetWindowUserPointer(self._handle, self);
        // discard previous callback
        _ = c.glfwSetFramebufferSizeCallback(self._handle, resizeFrameBuffer);
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

    pub fn createWindowSurface(self: *Self, instance: vk.Instance, surface: *vk.SurfaceKHR) !void {
        const result = c.glfwCreateWindowSurface(instance, self._handle, null, surface);
        if (result != vk.Success) {
            std.debug.print("Erorr: {d}\n", .{result});
            return Error.SurfaceCreationFailed;
        }
    }
};
