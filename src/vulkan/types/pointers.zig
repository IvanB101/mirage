const c = @import("c_libs").import;

pub const PFN_createDebugUtilsMessengerExt = c.PFN_vkCreateDebugUtilsMessengerEXT;
pub const PFN_destroyDebugUtilsMessengerExt = c.PFN_vkDestroyDebugUtilsMessengerEXT;
pub const PFN_debugUtilsMessengerCallbackExt = c.PFN_vkDebugUtilsMessengerCallbackEXT;

pub const SurfaceKHR = c.VkSurfaceKHR;
pub const Instance = c.VkInstance;
pub const DebugUtilsMessengerExt = c.VkDebugUtilsMessengerEXT;
pub const PhysicalDevice = c.VkPhysicalDevice;
pub const CommandPool = c.VkCommandPool;
pub const Device = c.VkDevice;
pub const Queue = c.VkQueue;
pub const Framebuffer = c.VkFramebuffer;
pub const Image = c.VkImage;
pub const ImageView = c.VkImageView;
pub const SwapChainKHR = c.VkSwapchainKHR;
pub const Semaphore = c.VkSemaphore;
pub const Fence = c.VkFence;
