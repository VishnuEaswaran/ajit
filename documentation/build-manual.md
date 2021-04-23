Build manual
============

For building a Linux system for Ajit processor, follow this document. This is a continuation of [README](assets/README) in the **Ajit-Linux** *Documentation* directory. The build tool of choice is Buildroot and the version info of major components are as follows

- Buildroot: buildroot-2014.08
- Linux kernel: 3.16.1
- GCC: 4.7.x
- gdb: 7.6.x
- uClibc C library: 0.9.33.x
- binutils: 2.22

Design overview
---------------

Linux boot will consist of two steps

1. initramfs
   
   Linux initially boots into initramfs and then run the userspace program *init*.

2. rootfs
   
   *init* of *initramfs* will extract the rootfs tar and mount it on a tmpfs mount point. Following this, *root* is switched to the new mount point, from where the */sbin/init* is executed.

Build process
-------------

Run the `GeneratememMapForAjit.sh` which creates the *root filesystem* tar, which will be then placed in *initramfs* cpio archive that gets integrated into the kernel image.

See the mentioned [script](assets/GeneratememMapForAjit.sh) for details about each step. Refer Documentation/README of Ajit-Linux for more description.

initramfs *init* script
-----------------------

```bash
#!/bin/busybox sh

echo "init shell script called ..."

# Dump to sh if something fails
error() {
	echo "Jumping into the shell..."
	setsid cttyhack sh
}

mount -t proc proc /proc
mount -t sysfs sysfs /sys

mkdir -p /newroot
mount -t tmpfs tmpfs /newroot || error

echo "Extracting rootfs... "
export EXTRACT_UNSAFE_SYMLINKS=1
tar -x -f rootfs.tar -C /newroot || error

# Clean up.
umount /proc
umount /sys

exec switch_root /newroot /sbin/init || error
```

This script is executed at the initramfs stage. It does the following actions

1. mount */proc* and */sys*, which is the bare minimum Linux looks for
2. create a temporary directory called **newroot** that would act as the mount point for the root filesystem. Create and mount a *tmpfs* filesystem at **newroot**.
3. Extract the *rootfs.rar* to the newly created *tmpfs* mount
4. Do some cleanup before switching to the new root by unmounting the */proc* and */sys*
5. Finally, switch root to the newly created *tmpfs* filesystem.