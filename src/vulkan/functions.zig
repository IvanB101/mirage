const c = @import("c_libs").import;

const p_allocator = null;

pub inline fn getInstanceProcAddr(instance: Instance, p_name: *const u8) Result {
    return map(c.vkGetInstanceProcAddr(instance, p_name));
}

pub inline fn createInstance(
    p_create_info: *const InstanceCreateInfo,
    p_instance: *Instance,
) Result {
    return map(c.vkCreateInstance(p_create_info, p_allocator, p_instance));
}
pub inline fn createDevice(
    physical_device: PhysicalDevice,
    p_create_info: *const DeviceCreateInfo,
    p_device: *Device,
) Result {
    return map(c.vkCreateDevice(physical_device, p_create_info, p_allocator, p_device));
}
pub inline fn createCommandPool(
    device: Device,
    p_create_info: *const CommandPoolCreateInfo,
    p_command_pool: *CommandPool,
) Result {
    return map(c.vkCreateCommandPool(device, p_create_info, p_allocator, p_command_pool));
}

pub inline fn enumerateInstanceLayerProperties(p_property_count: *u32, p_properties: *LayerProperties) Result {
    return map(c.vkEnumerateInstanceLayerProperties(p_property_count, p_properties));
}
pub inline fn enumerateInstanceExtensionProperties(
    p_layer_name: *const u8,
    p_property_count: *u32,
    p_properties: ?*ExtensionProperties,
) Result {
    return map(c.vkEnumerateInstanceExtensionProperties(p_layer_name, p_property_count, p_properties));
}
pub inline fn enumerateDeviceExtensionProperties(
    physical_device: PhysicalDevice,
    p_layer_name: *const u8,
    p_property_count: *u32,
    p_properties: ?*ExtensionProperties,
) Result {
    return map(c.vkEnumerateDeviceExtensionProperties(physical_device, p_layer_name, p_property_count, p_properties));
}
pub inline fn enumeratePhysicalDevices(
    instance: Instance,
    p_physical_device_count: *u32,
    p_physical_devices: ?*PhysicalDevice,
) Result {
    return map(c.vkEnumeratePhysicalDevices(instance, p_physical_device_count, p_physical_devices));
}

pub inline fn getPhysicalDeviceQueueFamilyProperties(
    physical_device: PhysicalDevice,
    p_queue_family_property_count: *u32,
    p_queue_family_properties: *QueueFamilyProperties,
) Result {
    return map(c.vkGetPhysicalDeviceQueueFamilyProperties(physical_device, p_queue_family_property_count, p_queue_family_properties));
}
pub inline fn getPhysicalDeviceSurfaceSupportKHR(
    physical_device: PhysicalDevice,
    queue_family_index: u32,
    surface: SurfaceKHR,
    p_supported: *Bool32,
) Result {
    return map(c.vkGetPhysicalDeviceSurfaceSupportKHR(physical_device, queue_family_index, surface, p_supported));
}
pub inline fn getPhysicalDeviceFeatures(
    physical_device: PhysicalDevice,
    p_features: *PhysicalDeviceFeatures,
) Result {
    return map(c.vkGetPhysicalDeviceFeatures(physical_device, p_features));
}
pub inline fn getPhysicalDeviceSurfaceCapabilitiesKHR(
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_surface_capabilities: *SurfaceCapabilitiesKHR,
) Result {
    return map(c.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physical_device, surface, p_surface_capabilities));
}
pub inline fn getPhysicalDeviceSurfaceFormatsKHR(
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_surface_format_count: *u32,
    p_surface_formats: ?*SurfaceFormatKHR,
) Result {
    return map(c.vkGetPhysicalDeviceSurfaceFormatsKHR(physical_device, surface, p_surface_format_count, p_surface_formats));
}
pub inline fn getPhysicalDeviceSurfacePresentModesKHR(
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_present_mode_count: *u32,
    p_present_modes: ?*PresentModeKHR,
) Result {
    return map(c.vkGetPhysicalDeviceSurfacePresentModesKHR(physical_device, surface, p_present_mode_count, p_present_modes));
}
pub inline fn getPhysicalDeviceProperties(
    physical_device: PhysicalDevice,
    p_properties: *PhysicalDeviceProperties,
) Result {
    return map(c.vkGetPhysicalDeviceProperties(physical_device, p_properties));
}
pub inline fn getDeviceQueue(
    device: Device,
    queue_family_index: u32,
    queue_index: u32,
    p_queue: *Queue,
) Result {
    return map(c.vkGetDeviceQueue(device, queue_family_index, queue_index, p_queue));
}

pub inline fn destroyCommandPool(
    device: Device,
    command_pool: CommandPool,
) Result {
    return map(c.vkDestroyCommandPool(device, command_pool, p_allocator));
}
pub inline fn destroyDevice(device: Device) Result {
    return map(c.vkDestroyDevice(device, p_allocator));
}
pub inline fn destroySurfaceKHR(instance: Instance, surface: SurfaceKHR) Result {
    return map(c.vkDestroySurfaceKHR(instance, surface, p_allocator));
}
pub inline fn destroyInstance(instance: Instance) Result {
    return map(c.vkDestroyInstance(instance, p_allocator));
}

// Imports for better lsp experience
const types = @import("types/root.zig");
const Result = @import("result.zig").Result;
const map = @import("result.zig").map;

const PFN_createDebugUtilsMessengerExt = types.PFN_createDebugUtilsMessengerExt;
const PFN_destroyDebugUtilsMessengerExt = types.PFN_destroyDebugUtilsMessengerExt;
const PFN_debugUtilsMessengerCallbackExt = types.PFN_debugUtilsMessengerCallbackExt;
const SurfaceKHR = types.SurfaceKHR;
const DebugUtilsMessengerExt = types.DebugUtilsMessengerExt;
const PhysicalDevice = types.PhysicalDevice;
const CommandPool = types.CommandPool;
const Device = types.Device;
const Instance = types.Instance;
const Queue = types.Queue;
const Framebuffer = types.Framebuffer;
const Image = types.Image;
const ImageView = types.ImageView;
const SwapChainKHR = types.SwapChainKHR;
const Semaphore = types.Semaphore;
const Fence = types.Fence;

const InstanceCreateInfo = types.InstanceCreateInfo;
const ApplicationInfo = types.ApplicationInfo;
const DebugUtilsMessengerCreateInfoExt = types.DebugUtilsMessengerCreateInfoExt;
const DeviceQueueCreateInfo = types.DeviceQueueCreateInfo;
const DeviceCreateInfo = types.DeviceCreateInfo;
const CommandPoolCreateInfo = types.CommandPoolCreateInfo;
const SwapchainCreateInfoKHR = types.SwapchainCreateInfoKHR;
const SemaphoreCreateInfo = types.SemaphoreCreateInfo;
const FenceCreateInfo = types.FenceCreateInfo;

const Extent2D = types.Extent2D;
const SurfaceFormatKHR = types.SurfaceFormatKHR;

const PhysicalDeviceProperties = types.PhysicalDeviceProperties;
const QueueFamilyProperties = types.QueueFamilyProperties;
const LayerProperties = types.LayerProperties;
const ExtensionProperties = types.ExtensionProperties;

const PhysicalDeviceFeatures = types.PhysicalDeviceFeatures;

const SurfaceCapabilitiesKHR = types.SurfaceCapabilitiesKHR;

const AllocationCallbacks = types.AllocationCallbacks;

const en = @import("enums.zig");
const Bool32 = en.Bool32;
const PresentModeKHR = en.PresentModeKHR;
