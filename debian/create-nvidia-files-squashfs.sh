#!/bin/bash

set -exu -o pipefail

squashfs_dir="$1"
packages_list="${2:-nvidia-kernel-common-525 libnvidia-cfg1-525 xserver-xorg-video-nvidia-525 nvidia-compute-utils-525 libnvidia-compute-525 libnvidia-gl-525-server libnvidia-common-525-server nvidia-utils-525}"

# Make a packages array
read -r -a packages <<< "$packages_list"

# Cleanup
rm -rf "${squashfs_dir}"
mkdir -p "${squashfs_dir}"

# Create package files list
for pkg in "${packages[@]}"; do
    while read f; do [ ! -d "$f" ] && echo "$f"; done < <(dpkg -L "$pkg") | sed "/usr\/share\/doc/d;/usr\/share\/man/d" >> "${squashfs_dir}/files.list"
done

# Copy only files from system to squashfs directory
rsync -av --files-from="${squashfs_dir}/files.list" / "${squashfs_dir}/"

# Create squashfs into parent directory
output_dir="$(dirname "${squashfs_dir}")"
mksquashfs "${squashfs_dir}" "${output_dir}/nvidia-files.squashfs" -e "${squashfs_dir}/files.list"
