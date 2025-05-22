const c = @import("c_libs").import;

pub const PresentModeKHR = enum(c_uint) {
    fifo_khr = c.VK_PRESENT_MODE_FIFO_KHR,
    fifo_relaxed_khr = c.VK_PRESENT_MODE_FIFO_RELAXED_KHR,
    immediate_khr = c.VK_PRESENT_MODE_IMMEDIATE_KHR,
    mailbox_khr = c.VK_PRESENT_MODE_MAILBOX_KHR,
};
pub const Bool32 = enum(c_uint) {
    true = c.VK_TRUE,
    false = c.VK_FALSE,
};
pub const SampleCountFlags = enum(c_uint) {
    _1 = c.VK_SAMPLE_COUNT_1_BIT,
    _2 = c.VK_SAMPLE_COUNT_2_BIT,
    _4 = c.VK_SAMPLE_COUNT_4_BIT,
    _8 = c.VK_SAMPLE_COUNT_8_BIT,
    _16 = c.VK_SAMPLE_COUNT_16_BIT,
    _32 = c.VK_SAMPLE_COUNT_32_BIT,
    _64 = c.VK_SAMPLE_COUNT_64_BIT,
};
pub const StructureType = enum(c_int) {
    application_info = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
    command_pool_create_info = c.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
    debug_utils_messenger_create_info = c.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
    device_create_info = c.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
    device_queue_create_info = c.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
    instance_create_info = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    fence_create_info = c.VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
    swap_chain_create_info_khr = c.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
    semaphore_create_info = c.VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
};
pub const APIVersion = enum(c_uint) {
    V1_0 = c.VK_API_VERSION_1_0,
};
pub const CommandPoolCreateFlags = enum(c_int) {
    transient = c.VK_COMMAND_POOL_CREATE_TRANSIENT_BIT,
    reset_command_buffer = c.VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
    protected = c.VK_COMMAND_POOL_CREATE_PROTECTED_BIT,
};
pub const QueueCreateFlags = enum(c_uint) {
    graphics = c.VK_QUEUE_GRAPHICS_BIT,
    compute = c.VK_QUEUE_COMPUTE_BIT,
};
pub const DeviceCreateFlags = enum(c_int) {};
pub const SwapChainCreateFlagsKHR = enum(c_int) {
    split_instance_bind_regions = c.VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR,
    protected = c.VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR,
    mutable_format = c.VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR,
    deferred_memory_allocation = c.VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_EXT,
};
pub const ImageUsageFlags = enum(c_int) {
    sampled = c.VK_IMAGE_USAGE_SAMPLED_BIT,
    storage = c.VK_IMAGE_USAGE_STORAGE_BIT,
    color_attachment = c.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
    depth_stencil_attachment = c.VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT,
    input_attachment = c.VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT,
    transient_attachment = c.VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT,
    fragment_shading_rate_attachment_khr = c.VK_IMAGE_USAGE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR,
    fragment_density_map = c.VK_IMAGE_USAGE_FRAGMENT_DENSITY_MAP_BIT_EXT,
    video_decode_dst_khr = c.VK_IMAGE_USAGE_VIDEO_DECODE_DST_BIT_KHR,
    video_decode_dpb_khr = c.K_IMAGE_USAGE_VIDEO_DECODE_DPB_BIT_KHR,
    video_encode_src_khr = c.K_IMAGE_USAGE_VIDEO_ENCODE_SRC_BIT_KHR,
    video_encode_dpb_khr = c.K_IMAGE_USAGE_VIDEO_ENCODE_DPB_BIT_KHR,
    sample_weight_qcom = c.VK_IMAGE_USAGE_SAMPLE_WEIGHT_BIT_QCOM,
    sample_block_match_qcom = c.VK_IMAGE_USAGE_SAMPLE_BLOCK_MATCH_BIT_QCOM,
    video_encode_quantization_delta_map_khr = c.VK_IMAGE_USAGE_VIDEO_ENCODE_QUANTIZATION_DELTA_MAP_BIT_KHR,
    video_encode_emphasis_map_khr = c.VK_IMAGE_USAGE_VIDEO_ENCODE_EMPHASIS_MAP_BIT_KHR,
};
pub const SharingMode = enum(c_int) {
    exclulsive = c.VK_SHARING_MODE_EXCLUSIVE,
    concurrent = c.VK_SHARING_MODE_CONCURRENT,
};
pub const SurfaceTransformFlagsKHR = enum(c_int) {
    identity = c.VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR,
    rotate_90 = c.VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR,
    rotate_180 = c.VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR,
    rotate_270 = c.VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR,
    horizontal_mirror = c.VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR,
    horizontal_mirror_rotate_90 = c.K_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR,
    horizontal_mirror_rotate_180 = c.K_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR,
    horizontal_mirror_rotate_270 = c.K_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR,
    inherit = c.VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR,
};
pub const CompositeAlphaFlagsKHR = enum(c_int) {
    opaque_ = c.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
    pre_multiplied = c.VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR,
    post_multiplied = c.VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR,
    inherit = c.VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR,
};
pub const InstanceCreateFlags = enum(c_int) {};
pub const Format = enum(c_int) {}; // todo
pub const ColorSpaceKHR = enum(c_int) {
    srgb_nonlinear = c.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR,
    display_p3_nonlinear_ext = c.VK_COLOR_SPACE_DISPLAY_P3_NONLINEAR_EXT,
    extended_srgb_linear_ext = c.VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT,
    display_p3_linear_ext = c.VK_COLOR_SPACE_DISPLAY_P3_LINEAR_EXT,
    dci_p3_nonlinear_ext = c.VK_COLOR_SPACE_DCI_P3_NONLINEAR_EXT,
    bt709_linear_ext = c.VK_COLOR_SPACE_BT709_LINEAR_EXT,
    bt709_nonlinear_ext = c.VK_COLOR_SPACE_BT709_NONLINEAR_EXT,
    bt2020_linear_ext = c.VK_COLOR_SPACE_BT2020_LINEAR_EXT,
    hdr10_st2084_ext = c.VK_COLOR_SPACE_HDR10_ST2084_EXT,
    dolbyvision_ext = c.VK_COLOR_SPACE_DOLBYVISION_EXT,
    hdr10_hlg_ext = c.VK_COLOR_SPACE_HDR10_HLG_EXT,
    adobergb_linear_ext = c.VK_COLOR_SPACE_ADOBERGB_LINEAR_EXT,
    adobergb_nonlinear_ext = c.VK_COLOR_SPACE_ADOBERGB_NONLINEAR_EXT,
    pass_through_ext = c.VK_COLOR_SPACE_PASS_THROUGH_EXT,
    extended_srgb_nonlinear_ext = c.VK_COLOR_SPACE_EXTENDED_SRGB_NONLINEAR_EXT,
    display_native_amd = c.VK_COLOR_SPACE_DISPLAY_NATIVE_AMD,
    srbg_nonlinear_khr = c.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR,
};
pub const SemaphoreCreateFlags = enum(c_int) {};
pub const FenceCreateFlags = enum(c_int) {
    signaled = c.VK_FENCE_CREATE_SIGNALED_BIT,
};
