const c = @import("c_libs").import;

pub const NullHandle = c.VK_NULL_HANDLE;

const types = @import("types/root.zig");

const res = @import("result.zig");
pub const Result = res.Result;
pub const Error = res.Error;
pub const Status = res.Status;
pub const map = res.map;

const create_info = @import("create_info.zig");
pub const ApplicationInfo = create_info.ApplicationInfo;
pub const InstanceCreateInfo = create_info.InstanceCreateInfo;
pub const DebugUtilsMessengerCreateInfoExt = create_info.DebugUtilsMessengerCreateInfoExt;
pub const DeviceQueueCreateInfo = create_info.DeviceQueueCreateInfo;
pub const DeviceCreateInfo = create_info.DeviceCreateInfo;
pub const CommandPoolCreateInfo = create_info.CommandPoolCreateInfo;
pub const SwapchainCreateInfoKHR = create_info.SwapchainCreateInfoKHR;
pub const SemaphoreCreateInfo = create_info.SemaphoreCreateInfo;
pub const FenceCreateInfo = create_info.FenceCreateInfo;

const other = @import("other_types.zig");
pub const Extent2D = other.Extent2D;
pub const SurfaceFormatKHR = other.SurfaceFormatKHR;
pub const PhysicalDeviceProperties = other.PhysicalDeviceProperties;
pub const QueueFamilyProperties = other.QueueFamilyProperties;
pub const LayerProperties = other.LayerProperties;
pub const ExtensionProperties = other.ExtensionProperties;
pub const PhysicalDeviceFeatures = other.PhysicalDeviceFeatures;
pub const SurfaceCapabilitiesKHR = other.SurfaceCapabilitiesKHR;
pub const AllocationCallbacks = other.AllocationCallbacks;

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

const raii = @import("raii.zig");
pub const Instance = raii.Instance;
pub const PhysicalDevice = raii.PhysicalDevice;
pub const Device = raii.Device;
pub const CommandPool = raii.CommandPool;
pub const SurfaceKHR = raii.SurfaceKHR;
pub const Queue = raii.Queue;
pub const DebugUtilsMessengerExt = raii.DebugUtilsMessengerExt;
pub const Framebuffer = raii.Framebuffer;
pub const Image = raii.Image;
pub const ImageView = raii.ImageView;
pub const SwapChainKHR = raii.SwapChainKHR;
pub const Semaphore = raii.Semaphore;
pub const Fence = raii.Fence;
