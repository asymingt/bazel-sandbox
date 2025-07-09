
# How resources work in ROS

ROS nodes need to access various data files at runtime. This is handled more generally as 'resources'
through ament_index, which is controlled by the AMENT_PREFIX_PATH:

When you run colcon build without the --merge-install flag each package is put in its own install
directory. The AMENT_PREFIX_PATH=<install_prefix>/<pkg1>:<install_prefix>/<pkg2>... This is a bit
complicated for Bazel to handle, as you'd need to chain all environment variables to make this
work correctly. When you colcon build with --merge-install enabled then the environment variable
is simply AMENT_PREFIX_PATH=<install_prefix>. This is the design we'll adopt.

If you look at the output of a --merge-install it looks something like this:

    <install_prefix>
        + bin                  # merged folder of all ros binaries
        + etc                  # rarely used location for system-wide configuration
        + include
            + pkg1             # package-specific headers
            ...
        + lib
        + opt                  # rarely-used vendor source directory
        + share                
            + pkg1             # package-specific data

            ...
        + src                  # rarely-used vendor source directory
        + tools                # rarely-used vendor tooling directory 
