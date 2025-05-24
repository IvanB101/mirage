const c = @import("c_libs").import;
const std = @import("std");

const res = @import("result.zig");
const Result = res.Result;
const Error = res.Error;
const Status = res.Status;
const map = res.map;

const Window = @import("glfw").Window;

const create_info = @import("create_info.zig");
const ApplicationInfo = create_info.ApplicationInfo;
const InstanceCreateInfo = create_info.InstanceCreateInfo;
const DebugUtilsMessengerCreateInfoExt = create_info.DebugUtilsMessengerCreateInfoExt;
const DeviceQueueCreateInfo = create_info.DeviceQueueCreateInfo;
const DeviceCreateInfo = create_info.DeviceCreateInfo;
const CommandPoolCreateInfo = create_info.CommandPoolCreateInfo;
const SwapchainCreateInfoKHR = create_info.SwapchainCreateInfoKHR;
const SemaphoreCreateInfo = create_info.SemaphoreCreateInfo;
const FenceCreateInfo = create_info.FenceCreateInfo;

const other = @import("other_types.zig");
const Extent2D = other.Extent2D;
const SurfaceFormatKHR = other.SurfaceFormatKHR;
const PhysicalDeviceProperties = other.PhysicalDeviceProperties;
const QueueFamilyProperties = other.QueueFamilyProperties;
const LayerProperties = other.LayerProperties;
const ExtensionProperties = other.ExtensionProperties;
const PhysicalDeviceFeatures = other.PhysicalDeviceFeatures;
const SurfaceCapabilitiesKHR = other.SurfaceCapabilitiesKHR;
const AllocationCallbacks = other.AllocationCallbacks;

const enums = @import("enums.zig");
pub const PresentModeKHR = enums.PresentModeKHR;
pub const Bool32 = enums.Bool32;
pub const SampleFlags = enums.SampleFlags;
pub const StructureType = enums.StructureType;
pub const APIVersion = enums.APIVersion;
pub const CommandPoolCreateFlags = enums.CommandPoolCreateFlags;
pub const QueueCreateFlags = enums.QueueCreateFlags;
pub const DeviceCreateFlags = enums.DeviceCreateFlags;
pub const SwapChainCreateFlagsKHR = enums.SwapChainCreateFlagsKHR;
pub const ImageUsageFlags = enums.ImageUsageFlags;
pub const SharingMode = enums.SharingMode;
pub const SurfaceTransformFlagsKHR = enums.SurfaceTransformFlagsKHR;
pub const CompositeAlphaFlagsKHR = enums.CompositeAlphaFlagsKHR;
pub const InstanceCreateFlags = enums.InstanceCreateFlags;
pub const Format = enums.Format;
pub const ColorSpaceKHR = enums.ColorSpaceKHR;
pub const SemaphoreCreateFlags = enums.SemaphoreCreateFlags;
pub const FenceCreateFlags = enums.FenceCreateFlags;

const Instance = @import("instance.zig").Instance;

const dev = @import("device.zig");
const PhysicalDevice = dev.PhysicalDevice;
const Device = dev.Device;

pub const CommandPool = struct {
    const Self = @This();
    handle: c.VkDevice,
    device: *const Device,

    pub fn init(
        device: Device,
        p_create_info: *const CommandPoolCreateInfo,
    ) !Self {
        var handle = null;
        _ = try map(c.vkCreateCommandPool(device, p_create_info, null, &handle));
        return .{
            .handle = handle,
        };
    }

    pub fn deinit(self: *Self) void {
        c.vkDestroyCommandPool(self.device.handle, self.handle, null);
    }
};

pub const SurfaceKHR = struct {
    const Self = @This();
    handle: c.VkSurfaceKHR,
    instance: *Instance,

    pub fn init(window: *const Window, instance: *const Instance) Self {
        var handle = null;
        _ = try c.glfwCreateWindowSurface(instance, window.handle(), null, &handle);
        return .{
            .handle = handle,
            .instance = instance,
        };
    }

    pub fn deinit(self: *Self) void {
        c.vkDestroySurfaceKHR(self.instance, self.handle, null);
    }
};

pub const Framebuffer = struct {
    const Self = @This();

    pub fn init() Self {}

    // pub fn deinit(self: *Self) void {}
};

pub const Image = struct {
    const Self = @This();

    pub fn init() Self {}

    // pub fn deinit(self: *Self) void {}
};

pub const ImageView = struct {
    const Self = @This();

    pub fn init() Self {}

    // pub fn deinit(self: *Self) void {}
};

pub const SwapChainKHR = struct {
    const Self = @This();

    pub fn init() Self {}

    // pub fn deinit(self: *Self) void {}
};

pub const Semaphore = struct {
    const Self = @This();

    pub fn init() Self {}

    // pub fn deinit(self: *Self) void {}
};

pub const Fence = struct {
    const Self = @This();

    pub fn init() Self {}

    // pub fn deinit(self: *Self) void {}
};
