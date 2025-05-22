const std = @import("std");
const vk = @import("vulkan");

const Device = @import("device.zig").Device;

pub const SwapChain = struct {
    const Self = @This();

    pub const Config = struct {
        device: Device,
        extent: vk.Extent2D,
        pre_render: std.ArrayList(vk.Semaphore),
    };

    pub fn init(config: Config) !Self {}
};
