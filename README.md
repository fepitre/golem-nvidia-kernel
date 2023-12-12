# Linux kernel packaging with nvidia modules for Golem GPU Live USB

This repository packages Linux kernel and nvidia drivers (in separate files) as a deb package.
It is important to keep this up to date.

## Updating

To update to a newer kernel version, add a new entry at the top of `debian/changelog` like this:

    golem-nvidia-kernel (6.1.66-1) jammy; urgency=medium

      * Update to 6.1.66

     -- Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>  Sat, 09 Dec 2023 18:22:45 +0100

Commit the change, tag it with a tag named as `v` + a version (for the example above: `v6.1.66-1`). and push. Github action will take care of the build. When the build completes, next update of APT repository in golem-gpu-live will pick up new version automatically.

Currently the repository uses Linux LTS branch 6.1.x (supposed to be maintained [until December 2026](https://kernel.org/category/releases.html)). Migrating to a different branch may require adjusting kernel config and maybe also a list of modules to load in ya-runtime-vm.
New nvidia drivers are picked up automatically, based on nvidia packages (525 branch) in Ubuntu 22.04.
