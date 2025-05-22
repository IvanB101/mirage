const c = @import("c_libs").import;

pub const DebugUtils = struct {
    pub const name = c.VK_EXT_DEBUG_UTILS_EXTENSION_NAME;
    pub const MessageSeverityFlags = enum(c_int) {
        warn = c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT,
        err = c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT,
    };
    pub const MessageTypeFlags = enum(c_int) {
        general = c.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT,
        validation = c.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT,
        performance = c.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT,
    };
    pub const CallbackData = c.VkDebugUtilsMessengerCallbackDataEXT;
    pub const CreateFlags = enum(c_int) {};
};

pub const KHRSwapChain = struct {
    pub const name = c.VK_KHR_SWAPCHAIN_EXTENSION_NAME;
};
