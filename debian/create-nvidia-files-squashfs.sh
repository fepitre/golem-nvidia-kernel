#!/bin/bash

set -exu -o pipefail

squashfs_dir="$1"
packages_list="${2:-nvidia-kernel-common-535 libnvidia-cfg1-535 xserver-xorg-video-nvidia-535 nvidia-compute-utils-535 libnvidia-compute-535 libnvidia-gl-535-server libnvidia-common-535-server nvidia-utils-535}"

# Make a packages array
read -r -a packages <<< "$packages_list"

# Cleanup
rm -rf "${squashfs_dir}"
mkdir -p "${squashfs_dir}"

# Create package files list
for pkg in "${packages[@]}"; do
    while read f; do [ ! -d "$f" ] && echo "$f"; done < <(dpkg -L "$pkg") | \
        sed \
            -e "/usr\/share\/doc/d;/usr\/share\/man/d" \
            -e "s:^/\(lib\|bin\|sbin\):/usr\0:" \
            >> "${squashfs_dir}/files.list"
done

# Copy only files from system to squashfs directory
rsync -av --files-from="${squashfs_dir}/files.list" / "${squashfs_dir}/"

# Create squashfs into parent directory
output_dir="$(dirname "${squashfs_dir}")"
mksquashfs "${squashfs_dir}" "${output_dir}/nvidia-files.squashfs" -e "${squashfs_dir}/files.list"
