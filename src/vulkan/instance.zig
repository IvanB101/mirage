const c = @import("c_libs").import;
const std = @import("std");
const builtin = @import("builtin");

const c_info = @import("create_info.zig");
const InstanceCreateInfo = c_info.InstanceCreateInfo;
const DebugUtilsMessengerCreateInfoExt = c_info.DebugUtilsMessengerCreateInfoExt;
const ApplicationInfo = c_info.ApplicationInfo;

const device = @import("device.zig");
const PhysicalDevice = @import("device.zig").PhysicalDevice;

const enums = @import("enums.zig");
const Bool32 = enums.Bool32;
const APIVersion = enums.APIVersion;

const res = @import("result.zig");
const map = res.map;
const Result = res.Result;
const Status = res.Status;
const Error = res.Error;

const ext = @import("extensions.zig");
const DebugUtils = ext.DebugUtils;

pub export fn debugCallback(
    _: c_uint,
    _: u32,
    p_callback_data: ?*const DebugUtils.CallbackData,
    _: ?*anyopaque,
) callconv(.c) Bool32 {
    if (p_callback_data) |callback_data| {
        std.debug.print("validation layer: {s}\n", .{callback_data.pMessage});
    }

    return .false;
}

pub const Instance = struct {
    const Self = @This();
    handle: c.VkInstance,
    debug_messenger: c.VkDebugUtilsMessengerEXT,

    pub const Config = struct {
        enable_validation_layers: bool = (builtin.mode == .Debug),
        p_create_info: *const InstanceCreateInfo,
        debug_messenger_create_info: DebugUtilsMessengerCreateInfoExt = .{
            .messageSeverity = DebugUtils.MessageSeverity.WarningBit |
                DebugUtils.MessageSeverity.ErrorBit,
            .messageType = DebugUtils.MessageType.GeneralBit |
                DebugUtils.MessageType.ValidationBit |
                DebugUtils.MessageType.PerformanceBit,
            .pfnUserCallback = debugCallback,
            .pUserData = null, // Optional
        },
        validation_layers: [1][*c]const u8 = .{
            "VK_LAYER_KHRONOS_validation",
        },
    };

    pub fn init(config: Config) !Self {
        var handle = null;
        var debug_messenger = null;

        const app_info: ApplicationInfo = .{
            .pApplicationName = "mirage Engine",
            .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
            .pEngineName = "No Engine",
            .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
            .apiVersion = APIVersion.V1_0,
        };

        const create_info: InstanceCreateInfo = .{
            .pApplicationInfo = &app_info,
            .enabledExtensionCount = @intCast(config.extensions.items.len),
            .ppEnabledExtensionNames = extensions.items.ptr,
        };

        if (config.enable_validation_layers) {
            create_info.enabledLayerCount = @intCast(config.validation_layers.len);
            create_info.ppEnabledLayerNames = &config.validation_layers;

            create_info.pNext = &config.debug_messenger_create_info;
        } else {
            create_info.enabledLayerCount = 0;
            create_info.pNext = null;
        }

        if (vk.createInstance(&create_info, null, &self.instance) != vk.Success) {
            return Error.InstanceCreationFailed;
        }

        _ = try map(c.vkCreateInstance(config.p_create_info, null, &handle));

        if (config.enable_validation_layers) {
            const func: c.PFN_vkCreateDebugUtilsMessengerEXT =
                @ptrCast(c.vkGetInstanceProcAddr(handle, "vkCreateDebugUtilsMessengerEXT"));
            if (func == null or func.?(handle, config.p_create_info, null, &debug_messenger) != Status.success) {
                return Error.InitializationFailed;
            }
        }

        return .{
            .handle = handle,
            .debug_messenger = debug_messenger,
        };
    }

    pub fn deinit(self: *Self) void {
        c.vkDestroyInstance(self.handle, null);
        const func: c.PFN_vkDestroyDebugUtilsMessengerEXT =
            @ptrCast(c.vkGetInstanceProcAddr(self.handle, "vkDestroyDebugUtilsMessengerEXT"));
        if (func != null) {
            func.?(self.handle, self.debug_messenger, null);
        }
    }

    pub fn getLayerProperties(allocator: std.mem.Allocator) !std.ArrayList([*c]const u8) {
        var layerCount: u32 = 0;
        _ = c.enumerateInstanceLayerProperties(&layerCount, null);
        var properties = std.ArrayList(c.LayerProperties).init(allocator);
        try properties.resize(layerCount);
        _ = c.enumerateInstanceLayerProperties(&layerCount, properties.items.ptr);
        return properties;
    }

    pub fn getExtensionProperties(allocator: std.mem.Allocator) !std.ArrayList(c.ExtensionProperties) {
        var available_count: u32 = 0;
        _ = c.enumerateInstanceExtensionProperties(null, &available_count, null);
        var extentions = std.ArrayList(c.ExtensionProperties).init(allocator);
        try extentions.resize(available_count);
        _ = c.enumerateInstanceExtensionProperties(null, &available_count, extentions.items.ptr);
        return extentions;
    }

    pub fn enumeratePhysicalDevices(
        self: *const Self,
        allocator: std.mem.Allocator,
    ) !std.ArrayList(PhysicalDevice) {
        var device_count: u32 = 0;
        _ = c.enumeratePhysicalDevices(self.instance, &device_count, null);
        var handles = std.ArrayList(c.PhysicalDevice).init(allocator);
        defer handles.deinit();
        try handles.resize(device_count);
        _ = c.enumeratePhysicalDevices(self.instance, &device_count, handles.items.ptr);
        var devices = try std.ArrayList(PhysicalDevice).initCapacity(allocator, device_count);
        for (handles) |handle| {
            devices.append(.{ .handle = handle });
        }
        return devices;
    }
};
