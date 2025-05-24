const c = @import("c_libs").import;

pub const Extent2D = c.VkExtent2D;
pub const SurfaceFormatKHR = c.VkSurfaceFormatKHR;

pub const PhysicalDeviceProperties = c.VkPhysicalDeviceProperties;
pub const QueueFamilyProperties = c.VkQueueFamilyProperties;
pub const LayerProperties = c.VkLayerProperties;
pub const ExtensionProperties = c.VkExtensionProperties;

pub const PhysicalDeviceFeatures = c.VkPhysicalDeviceFeatures;

pub const SurfaceCapabilitiesKHR = c.VkSurfaceCapabilitiesKHR;

pub const AllocationCallbacks = c.VkAllocationCallbacks;
