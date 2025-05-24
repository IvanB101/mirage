const glfw = @import("glfw");
const vk = @import("vulkan");
const std = @import("std");
const builtin = @import("builtin");

pub const Error = error{
    DebugSetupFailed,
    CommandPoolCreationFailed,
    InstanceCreationFailed,
    LogicalDeviceCreationFailed,
    MissingRequiredExtentionSupport,
    MissingValidationLayerSupport,
    NoValidGPU,
};

pub const Device = struct {
    const Self = @This();

    pub const Config = struct {
        enable_validation_layers: bool = (builtin.mode == .Debug),
        validation_layers: [1][*c]const u8 = .{
            "VK_LAYER_KHRONOS_validation",
        },
        device_extensions: [1][*c]const u8 = .{
            vk.KHRSwapChainExtensionName,
        },
        allocator: std.mem.Allocator,
        debug_messenger_create_info: vk.DebugUtilsMessengerCreateInfoExt = .{
            .sType = vk.StructureType.DebugUtilsMessengerCreateInfo,
            .messageSeverity = vk.ExtDebugUtils.MessageSeverity.WarningBit |
                vk.ExtDebugUtils.MessageSeverity.ErrorBit,
            .messageType = vk.ExtDebugUtils.MessageType.GeneralBit |
                vk.ExtDebugUtils.MessageType.ValidationBit |
                vk.ExtDebugUtils.MessageType.PerformanceBit,
            .pfnUserCallback = debugCallback,
            .pUserData = null, // Optional
        },
        window: *glfw.Window,
    };

    allocator: std.mem.Allocator,

    instance: vk.Instance = undefined,
    debug_messenger: vk.DebugUtilsMessengerExt = undefined,
    physical_device: vk.PhysicalDevice = undefined,
    command_pool: vk.CommandPool = undefined,
    _handle: vk.Device = undefined,
    _surface: vk.SurfaceKHR = undefined,
    _graphic_queue: vk.Queue = undefined,
    _present_queue: vk.Queue = undefined,
    _properties: vk.PhysicalDeviceProperties = .{},

    pub fn init(config: Config) !Self {
        var device = Self{ .allocator = config.allocator };

        try device.createInstance(&config);

        if (config.enable_validation_layers) {
            const func: vk.PFN_createDebugUtilsMessengerExt = @ptrCast(vk.fun.getInstanceProcAddr(device.instance, "vkCreateDebugUtilsMessengerEXT"));
            if (func == null or func.?(device.instance, &config.debug_messenger_create_info, null, &device.debug_messenger) != vk.Success) {
                return Error.DebugSetupFailed;
            }
        }

        try config.window.createWindowSurface(device.instance, &device._surface);
        try device.pickPhysicalDevice(&config);
        try device.createLogicalDevice(&config);
        try device.createCommandPool();

        return device;
    }

    pub fn deinit(self: *Self) void {
        vk.destroyCommandPool(self._handle, self.command_pool, null);
        vk.destroyDevice(self._handle, null);

        const func: vk.PFN_destroyDebugUtilsMessengerEXT = @ptrCast(vk.getInstanceProcAddr(self.instance, "vkDestroyDebugUtilsMessengerEXT"));
        if (func != null) {
            func.?(self.instance, self.debug_messenger, null);
        }

        vk.destroySurfaceKHR(self.instance, self._surface, null);
        vk.destroyInstance(self.instance, null);
    }

    fn createInstance(self: *Self, config: *const Config) !void {
        const extensions = try getRequiredExtensions(config);

        var app_info: vk.ApplicationInfo = .{};
        app_info.sType = vk.StructureType.ApplicationInfo;
        app_info.pApplicationName = "mirage Engine";
        app_info.applicationVersion = vk.MakeVersion(1, 0, 0);
        app_info.pEngineName = "No Engine";
        app_info.engineVersion = vk.MakeVersion(1, 0, 0);
        app_info.apiVersion = vk.Version.V1_0;

        var create_info: vk.InstanceCreateInfo = .{};
        create_info.sType = vk.StructureType.InstanceCreateInfo;
        create_info.pApplicationInfo = &app_info;

        create_info.enabledExtensionCount = @intCast(extensions.items.len);
        create_info.ppEnabledExtensionNames = extensions.items.ptr;

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
    }

    fn pickPhysicalDevice(self: *Self, config: *const Config) !void {
        var device_count: u32 = 0;
        _ = vk.enumeratePhysicalDevices(self.instance, &device_count, null);
        if (device_count == 0) {
            return Error.NoValidGPU;
        }
        var devices = std.ArrayList(vk.PhysicalDevice).init(self.allocator);
        try devices.resize(device_count);
        _ = vk.enumeratePhysicalDevices(self.instance, &device_count, devices.items.ptr);

        for (devices.items) |device| {
            if (try self.isDeviceSuitable(device, config)) {
                self.physical_device = device;
                break;
            }
        } else {
            return Error.NoValidGPU;
        }

        vk.getPhysicalDeviceProperties(self.physical_device, &self._properties);
    }

    fn createLogicalDevice(self: *Self, config: *const Config) !void {
        const indices = try self.getQueueFamilies();
        var list = std.ArrayList(u32).init(self.allocator);
        try list.append(indices.present_family.?);
        try list.append(indices.graphics_and_compute_family.?);
        var queue_create_infos = std.ArrayList(vk.DeviceQueueCreateInfo).init(self.allocator);
        const priority: f32 = 1;
        outer: while (list.pop()) |index| {
            for (list.items) |other| {
                if (other == index) {
                    continue :outer;
                }
            }
            try queue_create_infos.append(.{
                .sType = vk.StructureType.DeviceQueueCreateInfo,
                .queueFamilyIndex = index,
                .queueCount = 1,
                .pQueuePriorities = &priority,
            });
        }
        const device_features: vk.PhysicalDeviceFeatures = .{
            .samplerAnisotropy = vk.True,
        };
        const create_info: vk.DeviceCreateInfo = .{
            .sType = vk.StructureType.DeviceCreateInfo,
            .queueCreateInfoCount = @intCast(queue_create_infos.items.len),
            .pQueueCreateInfos = queue_create_infos.items.ptr,

            .pEnabledFeatures = &device_features,
            .enabledExtensionCount = config.device_extensions.len,
            .ppEnabledExtensionNames = &config.device_extensions,
        };
        const result = vk.createDevice(self.physical_device, &create_info, null, &self._handle);
        if (result != vk.Success) {
            return Error.LogicalDeviceCreationFailed;
        }
        vk.getDeviceQueue(self._handle, indices.graphics_and_compute_family.?, 0, &self._graphic_queue);
        vk.getDeviceQueue(self._handle, indices.present_family.?, 0, &self._present_queue);
    }

    fn createCommandPool(self: *Self) !void {
        const queue_family_indices = try self.getQueueFamilies();

        const pool_info: vk.CommandPoolCreateInfo = .{
            .sType = vk.StructureType.CommandPoolCreateInfo,
            .queueFamilyIndex = queue_family_indices.graphics_and_compute_family.?,
            .flags = vk.CommandPoolCreate.TransientBit |
                vk.CommandPoolCreate.ResetCommandBuffer,
        };

        if (vk.createCommandPool(self._handle, &pool_info, null, &self.command_pool) != vk.Success) {
            return Error.CommandPoolCreationFailed;
        }
    }

    pub fn swapChainSupport(self: *Self, device: vk.PhysicalDevice) !SwapChainSupportDetails {
        var capabilities: vk.SurfaceCapabilitiesKHR = .{};
        _ = vk.getPhysicalDeviceSurfaceCapabilitiesKHR(device, self._surface, &capabilities);

        var format_count: u32 = 0;
        _ = vk.getPhysicalDeviceSurfaceFormatsKHR(device, self._surface, &format_count, null);
        var formats = std.ArrayList(vk.SurfaceFormatKHR).init(self.allocator);
        try formats.resize(format_count);
        _ = vk.getPhysicalDeviceSurfaceFormatsKHR(device, self._surface, &format_count, formats.items.ptr);

        var present_mode_count: u32 = 0;
        _ = vk.getPhysicalDeviceSurfacePresentModesKHR(device, self._surface, &present_mode_count, null);
        var present_modes = std.ArrayList(vk.PresentModeKHR).init(self.allocator);
        try present_modes.resize(present_mode_count);
        _ = vk.getPhysicalDeviceSurfacePresentModesKHR(device, self._surface, &present_mode_count, present_modes.items.ptr);

        return .{
            .capabilities = capabilities,
            .formats = formats,
            .present_modes = present_modes,
        };
    }

    fn getQueueFamilies(self: *const Self) !QueueFamilyIndices {
        return try findQueueFamilies(self.physical_device, self._surface, self.allocator);
    }

    fn isDeviceSuitable(self: *Self, device: vk.PhysicalDevice, config: *const Config) !bool {
        const families = try findQueueFamilies(device, self._surface, self.allocator);
        if (!families.isComplete()) {
            return false;
        }

        var extension_count: u32 = 0;
        _ = vk.enumerateDeviceExtensionProperties(device, null, &extension_count, null);
        var available_extensions = std.ArrayList(vk.ExtensionProperties).init(self.allocator);
        try available_extensions.resize(extension_count);
        defer available_extensions.deinit();
        _ = vk.enumerateDeviceExtensionProperties(device, null, &extension_count, available_extensions.items.ptr);

        for (config.device_extensions) |required| {
            for (available_extensions.items) |available| {
                const str_end = std.mem.indexOfScalar(u8, &available.extensionName, 0).?;
                if (std.mem.eql(u8, std.mem.sliceTo(required, 0), available.extensionName[0..str_end])) {
                    break;
                }
            } else {
                return false;
            }
        }

        var support: SwapChainSupportDetails = try self.swapChainSupport(device);
        defer support.deinit();
        if (support.formats.items.len == 0 or support.present_modes.items.len == 0) {
            return false;
        }

        var supported_features: vk.PhysicalDeviceFeatures = .{};
        vk.getPhysicalDeviceFeatures(device, &supported_features);

        return supported_features.samplerAnisotropy != 0;
    }
};

const QueueFamilyIndices = struct {
    const Self = @This();
    present_family: ?u32 = null,
    graphics_and_compute_family: ?u32 = null,

    fn isComplete(self: *const Self) bool {
        return self.present_family != null and self.graphics_and_compute_family != null;
    }
};

pub const SwapChainSupportDetails = struct {
    const Self = @This();

    capabilities: vk.SurfaceCapabilitiesKHR,
    formats: std.ArrayList(vk.SurfaceFormatKHR),
    present_modes: std.ArrayList(vk.PresentModeKHR),

    fn deinit(self: *Self) void {
        self.formats.deinit();
        self.present_modes.deinit();
    }
};

fn findQueueFamilies(device: vk.PhysicalDevice, surface: vk.SurfaceKHR, allocator: std.mem.Allocator) !QueueFamilyIndices {
    var indices: QueueFamilyIndices = .{};

    var queue_family_count: u32 = 0;
    vk.getPhysicalDeviceQueueFamilyProperties(device, &queue_family_count, null);
    var families_properties = std.ArrayList(vk.QueueFamilyProperties).init(allocator);
    try families_properties.resize(queue_family_count);
    defer families_properties.deinit();
    vk.getPhysicalDeviceQueueFamilyProperties(device, &queue_family_count, families_properties.items.ptr);

    for (families_properties.items, 0..) |properties, i| {
        if (properties.queueFlags & vk.QueueComputeBit != 0 and properties.queueFlags & vk.QueueGraphicsBit != 0) {
            indices.graphics_and_compute_family = @intCast(i);
        }
        var presentSupport: vk.Bool32 = 0;
        _ = vk.getPhysicalDeviceSurfaceSupportKHR(device, @intCast(i), surface, &presentSupport);
        if (properties.queueCount > 0 and presentSupport != 0) {
            indices.present_family = @intCast(i);
        }
        if (indices.isComplete()) {
            break;
        }
    }

    return indices;
}

fn getRequiredExtensions(config: *const Device.Config) !std.ArrayList([*c]const u8) {
    var glfw_extension_count: u32 = 0;
    var glfw_extensions: [*c][*c]const u8 = undefined;
    glfw_extensions = glfw.getRequiredInstanceExtensions(&glfw_extension_count);
    var extensions = std.ArrayList([*c]const u8).init(config.allocator);
    try extensions.appendSlice(glfw_extensions[0..glfw_extension_count]);

    if (config.enable_validation_layers) {
        try extensions.append(vk.ExtDebugUtils.ExtensionName);

        var layerCount: u32 = 0;
        _ = vk.enumerateInstanceLayerProperties(&layerCount, null);

        var availableLayers = std.ArrayList(vk.LayerProperties).init(config.allocator);
        try availableLayers.resize(layerCount);
        defer availableLayers.deinit();
        _ = vk.enumerateInstanceLayerProperties(&layerCount, availableLayers.items.ptr);

        for (config.validation_layers) |layer| {
            for (availableLayers.items) |available| {
                const str_end = std.mem.indexOfScalar(u8, &available.layerName, 0).?;
                if (std.mem.eql(u8, std.mem.sliceTo(layer, 0), available.layerName[0..str_end])) {
                    break;
                }
            } else {
                return Error.MissingValidationLayerSupport;
            }
        }
    }

    var available_count: u32 = 0;
    _ = vk.enumerateInstanceExtensionProperties(null, &available_count, null);
    var available_exts = std.ArrayList(vk.ExtensionProperties).init(config.allocator);
    try available_exts.resize(available_count);
    defer available_exts.deinit();
    _ = vk.enumerateInstanceExtensionProperties(null, &available_count, available_exts.items.ptr);

    // If requiring many extention consider changing to a hashmap
    for (extensions.items) |required| {
        for (available_exts.items) |available| {
            const str_end = std.mem.indexOfScalar(u8, &available.extensionName, 0).?;
            if (std.mem.eql(u8, std.mem.sliceTo(required, 0), available.extensionName[0..str_end])) {
                break;
            }
        } else {
            return Error.MissingRequiredExtentionSupport;
        }
    }

    return extensions;
}
