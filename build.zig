const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const c_mod = b.createModule(.{
        .root_source_file = b.path("src/c_libs.zig"),
        .target = target,
        .optimize = optimize,
    });
    const vulkan_mod = b.createModule(.{
        .root_source_file = b.path("src/vulkan/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    vulkan_mod.addImport("c_libs", c_mod);
    const glfw_mod = b.createModule(.{
        .root_source_file = b.path("src/glfw.zig"),
        .target = target,
        .optimize = optimize,
    });
    glfw_mod.addImport("c_libs", c_mod);
    glfw_mod.addImport("vulkan", vulkan_mod);
    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib_mod.addImport("vulkan", vulkan_mod);
    lib_mod.addImport("glfw", glfw_mod);
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addImport("mirage_lib", lib_mod);

    const c_libs = b.addLibrary(.{
        .linkage = .static,
        .name = "c_libs",
        .root_module = c_mod,
    });
    c_libs.linkLibC();
    c_libs.linkSystemLibrary("vulkan");
    c_libs.linkSystemLibrary("glfw3");
    const vulkan_lib = b.addLibrary(.{
        .linkage = .static,
        .name = "vulkan",
        .root_module = vulkan_mod,
    });
    b.installArtifact(vulkan_lib);
    const glfw_lib = b.addLibrary(.{
        .linkage = .static,
        .name = "glfw",
        .root_module = glfw_mod,
    });
    b.installArtifact(glfw_lib);
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "mirage",
        .root_module = lib_mod,
    });
    b.installArtifact(lib);
    const exe = b.addExecutable(.{
        .name = "mirage",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
