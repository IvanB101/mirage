const c = @import("c_libs").import;
const std = @import("std");

const c_info = @import("create_info.zig");
const DeviceCreateInfo = c_info.DeviceCreateInfo;
const DeviceQueueCreateInfo = c_info.DeviceQueueCreateInfo;

const Instance = @import("instance.zig").Instance;
const SurfaceKHR = @import("raii.zig").SurfaceKHR;
const other = @import("other_types.zig");
const SurfaceCapabilitiesKHR = other.SurfaceCapabilitiesKHR;
const SurfaceFormatKHR = other.SurfaceFormatKHR;
const PhysicalDeviceFeatures = other.PhysicalDeviceFeatures;

const res = @import("result.zig");
const map = res.map;
const Error = res.Error;
const enums = @import("enums.zig");
const Bool32 = enums.Bool32;
const QueueFlags = enums.QueueFlags;
const PresentModeKHR = enums.PresentModeKHR;

const glfw = @import("glfw");

pub const PhysicalDevice = struct {
    const Self = @This();
    handle: c.VkPhysicalDevice,

    pub fn getExtensionProperties(
        self: *const Self,
        allocator: std.mem.Allocator,
    ) !std.ArrayList(c.PhysicalDevice) {
        var extension_count: u32 = 0;
        _ = c.enumerateDeviceExtensionProperties(self.handle, null, &extension_count, null);
        var device_extensions = std.ArrayList(c.ExtensionProperties).init(allocator);
        try device_extensions.resize(extension_count);
        _ = c.enumerateDeviceExtensionProperties(self.handle, null, &extension_count, device_extensions.items.ptr);
        return device_extensions;
    }

    pub fn getQueueFamilyProperties(
        self: *const Self,
        allocator: std.mem.Allocator,
    ) !std.ArrayList(c.VkQueueFamilyProperties) {
        var queue_family_count: u32 = 0;
        c.vkGetPhysicalDeviceQueueFamilyProperties(self.handle, &queue_family_count, null);
        var families_properties = std.ArrayList(c.QueueFamilyProperties).init(allocator);
        try families_properties.resize(queue_family_count);
        c.vkGetPhysicalDeviceQueueFamilyProperties(self.handle, &queue_family_count, families_properties.items.ptr);
        return families_properties;
    }

    pub fn hasSurfaceSupportKHR(
        self: *const Self,
        queue_family_index: u32,
        surface: SurfaceKHR,
    ) bool {
        const supported = Bool32.false;
        _ = c.vkGetPhysicalDeviceSurfaceSupportKHR(self.handle, queue_family_index, surface, &supported);
        return supported == Bool32.true;
    }

    pub fn getFeatures(
        self: *const Self,
    ) c.VkPhysicalDeviceFeatures {
        var features = .{};
        c.vkGetPhysicalDeviceFeatures(self.handle, &features);
        return features;
    }

    pub fn getProperties(
        self: *const Self,
    ) c.VkPhysicalDeviceProperties {
        var properties = .{};
        c.vkGetPhysicalDeviceProperties(self.handle, &properties);
        return properties;
    }

    pub fn getSurfaceCapabilitiesKHR(
        self: *const Self,
        surface: SurfaceKHR,
    ) c.VkSurfaceCapabilitiesKHR {
        var capabilities = .{};
        c.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(self.handle, surface.handle, &capabilities);
        return capabilities;
    }

    pub fn getSurfaceFormatsKHR(
        self: *const Self,
        surface: SurfaceKHR,
        allocator: std.mem.Allocator,
    ) std.ArrayList(c.SurfaceFormatKHR) {
        var format_count: u32 = 0;
        _ = c.vkGetPhysicalDeviceSurfaceFormatsKHR(self.handle, surface, &format_count, null);
        var formats = std.ArrayList(c.SurfaceFormatKHR).init(allocator);
        try formats.resize(format_count);
        _ = c.vkGetPhysicalDeviceSurfaceFormatsKHR(self.handle, surface.handle, &format_count, formats.items.ptr);
        return formats;
    }

    pub fn getSurfacePresentModesKHR(
        self: *const Self,
        surface: SurfaceKHR,
        allocator: std.mem.Allocator,
    ) std.ArrayList(c.VkPresentModeKHR) {
        var present_mode_count: u32 = 0;
        _ = c.vkGetPhysicalDeviceSurfacePresentModesKHR(self.handle, surface, &present_mode_count, null);
        var present_modes = std.ArrayList(c.PresentModeKHR).init(allocator);
        try present_modes.resize(present_mode_count);
        _ = c.vkGetPhysicalDeviceSurfacePresentModesKHR(self.handle, surface, &present_mode_count, present_modes.items.ptr);
        return present_modes;
    }

    pub fn isDeviceSuitable(self: *const Self, config: Device.Config) !bool {
        const families = try QueueFamilyIndices.new(self.handle, config.surface, config.allocator);
        if (!families.isComplete()) {
            return false;
        }

        const extensions = self.getExtensionProperties(config.allocator);
        defer extensions.deinit();

        for (config.device_extensions) |required| {
            for (extensions.items) |available| {
                const str_end = std.mem.indexOfScalar(u8, &available.extensionName, 0).?;
                if (std.mem.eql(u8, std.mem.sliceTo(required, 0), available.extensionName[0..str_end])) {
                    break;
                }
            } else {
                return false;
            }
        }

        const formats = try self.getSurfaceFormatsKHR(config.surface, config.allocator);
        defer formats.deinit();
        const present_modes = try self.getSurfacePresentModesKHR(config.surface, config.allocator);
        defer present_modes.deinit();
        if (formats.items.len == 0 or present_modes.items.len == 0) {
            return false;
        }

        return self.getFeatures().samplerAnisotropy != 0;
    }
};

pub const Device = struct {
    const Self = @This();
    handle: c.VkDevice,
    physical_device: PhysicalDevice,
    present_queue: Queue,
    graphics_and_compute_queue: Queue,

    const Config = struct {
        device_extensions: [1][*c]const u8 = .{c.VK_KHR_SWAPCHAIN_EXTENSION_NAME},
        surface: SurfaceKHR,
        window: *const glfw.Window,
        instance: *const Instance,
        allocator: std.mem.Allocator,
    };

    pub fn init(config: Config) !Self {
        var handle = null;
        const physical_device = pickPhysicalDevice(config);
        const indices = QueueFamilyIndices.new(physical_device, config.surface, config.allocator);

        var list = std.ArrayList(u32).init(config.allocator);
        try list.append(indices.present_family.?);
        if (indices.present_modes != indices.graphics_and_compute_family) {
            try list.append(indices.graphics_and_compute_family.?);
        }
        var queue_create_infos = std.ArrayList(DeviceQueueCreateInfo).init(config.allocator);
        const priority: f32 = 1;
        while (list.items) |index| {
            try queue_create_infos.append(.{
                .queueFamilyIndex = index,
                .queueCount = 1,
                .pQueuePriorities = &priority,
            });
        }
        const device_features: PhysicalDeviceFeatures = .{
            .samplerAnisotropy = Bool32.true,
        };
        const create_info: DeviceCreateInfo = .{
            .queueCreateInfoCount = @intCast(queue_create_infos.items.len),
            .pQueueCreateInfos = queue_create_infos.items.ptr,

            .pEnabledFeatures = &device_features,
            .enabledExtensionCount = config.device_extensions.len,
            .ppEnabledExtensionNames = &config.device_extensions,
        };
        _ = try map(c.vkCreateDevice(physical_device.handle, &create_info, null, &handle));

        var graphics_and_compute_queue = undefined;
        var present_queue = undefined;
        c.vkGetDeviceQueue(handle, indices.graphics_and_compute_family, 0, &graphics_and_compute_queue);
        c.vkGetDeviceQueue(handle, indices.present_family, 0, &present_queue);

        return .{
            .handle = handle,
            .physical_device = physical_device,
            .graphics_and_compute_queue = graphics_and_compute_queue,
            .present_queue = present_queue,
        };
    }

    pub fn deinit(self: *Self) void {
        c.vkDestroyDevice(self.handle, null);
    }

    fn pickPhysicalDevice(config: *const Config) PhysicalDevice {
        const physical_devices = config.instance.enumeratePhysicalDevices(config.allocator);
        defer physical_devices.deinit();

        for (physical_devices.items) |device| {
            if (try device.isDeviceSuitable(config)) {
                return device;
            }
        } else {
            return Error.InitializationFailed;
        }
    }

    pub fn getQueue(self: *Self, queue_family_index: u32, queue_index: u32) Queue {
        var queue_handle = null;

        _ = try map(c.vkGetDeviceQueue(self.handle, queue_family_index, queue_index, &queue_handle));

        return .{
            .handle = queue_handle,
        };
    }
};

const QueueFamilyIndices = struct {
    const Self = @This();
    present_family: u32 = null,
    graphics_and_compute_family: u32 = null,

    fn new(physical_device: *PhysicalDevice, surface: SurfaceKHR, allocator: std.mem.Allocator) !Self {
        var present_family: ?u32 = null;
        var graphics_and_compute_family: ?u32 = null;

        const families_properties = try physical_device.getQueueFamilyProperties(allocator);
        defer families_properties.deinit();

        for (families_properties.items, 0..) |properties, i| {
            if (properties.queueFlags & QueueFlags.compute != 0 and properties.queueFlags & QueueFlags.graphics != 0) {
                graphics_and_compute_family = @intCast(i);
            }
            if (physical_device.hasSurfaceSupportKHR(i, surface)) {
                present_family = @intCast(i);
            }
            if (present_family != null and graphics_and_compute_family != null) {
                break;
            }
        }

        return .{
            .present_family = present_family.?,
            .graphics_and_compute_family = graphics_and_compute_family.?,
        };
    }
};

pub const Queue = struct {
    const Self = @This();
    handle: c.VkQueue,
};
