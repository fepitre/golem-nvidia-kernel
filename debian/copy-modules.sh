#!/bin/sh
# copy selected kernel modules together with their dependencies
# and print list of copied files to stdout
#
# usage: copy-modules.sh dir-with-lib-modules kernel-version output-dir module [module...]

sysroot="$1"
shift
kver="$1"
shift
outdir="$1"
shift
set -e -x
[ -n "$sysroot" ]
[ -n "$kver" ]
[ -n "$outdir" ]

for mod in "$@"; do
    modprobe --set-version="$kver" --dirname="$sysroot" --show-depends "$mod" | \
    while read action path rest; do \
        if [ "$action" = "insmod" ]; then
            cp "$path" $outdir/
            basename "$path"
        fi
    done
done
