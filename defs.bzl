# This rule simply prefixes the runfile symlinks with a base folder, which
# mimics the organization of the 'share' directory.

def _ros_share_impl(ctx):
    module_name = ctx.attr.module_name
    symlinks = {}
    for target in ctx.attr.data:
        for file in target.files.to_list():
            symlinks["share" + "/" + module_name + "/" + file.path] = file
    return [DefaultInfo(runfiles = ctx.runfiles(symlinks = symlinks))]

ros_share = rule(
    implementation = _ros_share_impl,
    attrs = {
        "data": attr.label_list(allow_files = True),
        "module_name": attr.string(),
    }
)
