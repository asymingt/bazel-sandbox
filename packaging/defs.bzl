# This rule simply prefixes the runfile symlinks with a base folder, which
# mimics the organization of the 'share' directory.

load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("@rules_pkg//pkg:mappings.bzl", "pkg_files")

def _ros_share_impl(ctx):
    module_name = ctx.attr.module_name
    symlinks = {}
    for target in ctx.attr.data:
        for file in target.files.to_list():
            symlinks["share" + "/" + module_name + "/" + file.path] = file
    return [
        DefaultInfo(runfiles = ctx.runfiles(symlinks = symlinks))
    ]

ros_share = rule(
    implementation = _ros_share_impl,
    attrs = {
        "data": attr.label_list(allow_files = True),
        "module_name": attr.string(),
    }
)

def ros_package(libraries = [], executables = [], headers = [], share = []):
    """
    Should this be a rule? probably...
    """

    # Create an empty file representing the ament resource index.
    native.genrule(
        name = "pkg_ament_resource_index",
        outs = [native.module_name()],
        cmd_bat = "echo. >> $@",
        cmd = "touch $@",
    )

    # Install libraries to lib.
    pkg_files(
        name = "pkg_lib",
        srcs = libraries,
        prefix = "lib",
        visibility = ["//visibility:public"],
    )

    # Install binaries to bin.
    pkg_files(
        name = "pkg_bin",
        srcs = executables,
        prefix = "bin",
        visibility = ["//visibility:public"],
    )

    # Install header files to <prefix>/include/<module>
    pkg_files(
        name = "pkg_headers",
        srcs = headers,
        prefix = "include/" + native.module_name(),
        visibility = ["//visibility:public"],
    )

    # Install data files to <prefix>/share/<module>
    pkg_files(
        name = "pkg_share_module",
        srcs = share,
        prefix = "share/" + native.module_name(),
        visibility = ["//visibility:public"],
    )

    # Install ament resource index to <prefix>/share/ament_index/resource_index/<package>
    pkg_files(
        name = "pkg_share_ament",
        srcs = [":pkg_ament_resource_index"],
        prefix = "share/ament_index/resource_index",
        visibility = ["//visibility:public"],
    )

    # Bundle up all these files into a neat little tarball.
    pkg_tar(
        name = "pkg",
        srcs = [
            ":pkg_lib",
            ":pkg_bin",
            ":pkg_headers",
            ":pkg_share_ament",
            ":pkg_share_module",
        ],
        package_file_name = native.module_name() + ".tar.gz",
        visibility = ["//visibility:public"],
    )
