const c = @import("c_libs").import;

const ext = @import("../extensions.zig");
const ptr = @import("pointers.zig");
const en = @import("../enums.zig");
const o = @import("other.zig");

pub const InstanceCreateInfo = extern struct {
    sType: en.StructureType = .instance_create_info,
    pNext: ?*const anyopaque,
    flags: en.InstanceCreateFlags = 0,
    pApplicationInfo: [*c]const ApplicationInfo,
    enabledLayerCount: u32 = 0,
    ppEnabledLayerNames: [*c]const [*c]const u8 = null,
    enabledExtensionCount: u32 = 0,
    ppEnabledExtensionNames: [*c]const [*c]const u8 = null,
};
pub const ApplicationInfo = extern struct {
    sType: en.StructureType = .application_info,
    pNext: ?*const anyopaque = null,
    pApplicationName: [*c]const u8,
    applicationVersion: u32,
    pEngineName: [*c]const u8 = null,
    engineVersion: u32 = 0,
    apiVersion: u32 = 0,
};
pub const DebugUtilsMessengerCreateInfoExt = extern struct {
    sType: en.StructureType = .debug_utils_messenger_create_info,
    pNext: ?*const anyopaque = null,
    flags: ext.DebugUtils.CreateFlags = 0,
    messageSeverity: ext.DebugUtils.MessageSeverityFlags = 0,
    messageType: ext.DebugUtils.MessageTypeFlags = 0,
    pfnUserCallback: ptr.PFN_debugUtilsMessengerCallbackEXT = null,
    pUserData: ?*anyopaque = null,
};
pub const DeviceQueueCreateInfo = extern struct {
    sType: en.StructureType = .device_create_info,
    pNext: ?*const anyopaque = null,
    flags: en.QueueCreateFlags = 0,
    queueFamilyIndex: u32,
    queueCount: u32,
    pQueuePriorities: [*c]const f32,
};
pub const DeviceCreateInfo = extern struct {
    sType: en.StructureType = .device_create_info,
    pNext: ?*const anyopaque = null,
    flags: en.DeviceCreateFlags = 0,
    queueCreateInfoCount: u32,
    pQueueCreateInfos: [*c]const DeviceQueueCreateInfo,
    enabledLayerCount: u32 = 0,
    ppEnabledLayerNames: [*c]const [*c]const u8 = null,
    enabledExtensionCount: u32 = 0,
    ppEnabledExtensionNames: [*c]const [*c]const u8 = null,
    pEnabledFeatures: [*c]const o.PhysicalDeviceFeatures = null,
};
pub const CommandPoolCreateInfo = extern struct {
    sType: en.StructureType = .command_pool_create_info,
    pNext: ?*const anyopaque = null,
    flags: en.CommandPoolCreateFlags = 0,
    queueFamilyIndex: u32,
};
pub const SwapchainCreateInfoKHR = extern struct {
    sType: en.StructureType = .swap_chain_create_info_khr,
    pNext: ?*const anyopaque = null,
    flags: en.SwapChainCreateFlagsKHR = 0,
    surface: ptr.SurfaceKHR,
    minImageCount: u32,
    imageFormat: en.Format,
    imageColorSpace: en.ColorSpaceKHR,
    imageExtent: o.Extent2D,
    imageArrayLayers: u32 = 0,
    imageUsage: en.ImageUsageFlags,
    imageSharingMode: en.SharingMode = .exclulsive,
    queueFamilyIndexCount: u32,
    pQueueFamilyIndices: [*c]const u32,
    preTransform: en.SurfaceTransformFlagsKHR = 0,
    compositeAlpha: en.CommandPoolCreateFlags = 0,
    presentMode: en.PresentModeKHR = .fifo_khr,
    clipped: en.Bool32 = .false,
    oldSwapchain: ptr.SwapChainKHR = null,
};
pub const SemaphoreCreateInfo = extern struct {
    sType: en.StructureType = .semaphore_create_info,
    pNext: ?*const anyopaque = null,
    flags: en.SemaphoreCreateFlags = 0,
};
pub const FenceCreateInfo = extern struct {
    sType: en.StructureType = .fence_create_info,
    pNext: ?*const anyopaque = null,
    flags: en.FenceCreateFlags = 0,
};
