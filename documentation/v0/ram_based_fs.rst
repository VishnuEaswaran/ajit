==========
Ajit Linux
==========

The goal is to build a Linux system based on a ram-based filesystem.
Running out of volatile memory has got advantages and disadvantages. Volatility leads to loss of data once the system is shutdown, but runtime 
performance gets a boost because of the fast memory. Linux provide few options 
for such filesystems, among which ramfs and tmpfs are the prominent ones.

This document discuss about what is ram-based filesystem, its significance in 
Linux systems and how we implement it in Ajit-linux. 

Version details of related components are as follows

    - Linux kernel: 3.16.1
    - Buildroot: buildroot-2014.08
    - GCC: 4.7.x
    - gdb: 7.6.x 
    - uClibc C library: 0.9.33.x
    - binutils: 2.22

The RAM based Filesystems
=========================

When kernel boot, it must find and run the first user program, usually "init". Since it is a user program, it exist in a filesystem. So, the Linux Kernel must find and mount the first filesystem, "root" filesystem or *rootfs*, to boot successfully.
The earliest solution for locating and mounting the root filesystem was the "root=" kernel command line option. Soon it became insufficient to provide enough information, which lead to a solution involving a ram-based initial root filesystem bundled to the kernel, from version 2.6.

Till kernel 2.4, there existed "initrd", with an emulated block device called *ramdisk* that reside in RAM. This solution had multiple drawbacks, mainly complications arising from the synthetic block device, leading to redundant caching of files, resulting in wastage of memory.

ramfs
-----

It is a wrapper around the well established and tested disk caching system of Linux. Provides bare minimum handles to VFS for it to work. It could dynamically resize according to the data contained within. It also posed the problem of using up all the available RAM memory too. Hence only root user is given permission to write.

tmpfs
-----

An improved *ramfs* contributed by the community. It can write data to swap space, and also define the size of a mount point. It enabled non-root users with write permission and the ability to use swap memory for flexibility.

It is an improved version of *ramfs* (which can write the data to swap space, and limit the size of a given mount point so it fills up before consuming all available memory). Initramfs is an instance of *tmpfs*.

Linux boot details
==================

initrd
------

Solution to simplify boot process by allowing system startup to occur in two phases.
initrd provides the capability to load a RAM disk by the boot loader. This RAM disk can then be mounted as the root file system and programs can be run from it. Afterwards, a new root file system can be mounted from a different device. The previous root (from initrd) is then moved to a directory and can be subsequently unmounted.

Initially a "ramdev", which is a synthetic block device, was used as the device. Later, *ramfs* was put to use followed by *tmpfs*.

initramfs
---------

initramfs was introduced in 2.6. All 2.6 Linux kernels contain a gzipped “cpio” format archive, which is extracted into rootfs when the kernel boots up. After extracting, the kernel checks to see if rootfs contains a file “init”, and if so it executes it as PID 1.

- the initramfs archive is linked into the Linux kernel image.
- initramfs archive is a gzipped cpio archive, for which the kernel has extraction code.
- init program from initramfs is not expected to return to the kernel while initrd used to.
- initramfs is rootfs: you can neither pivot_root rootfs, nor unmount it.

Buildroot
=========
 
Ajit_linux at present runs indefinitely out of initramfs. We need to change to a boot process which mounts a separate rootfs and then switches to that, for future proofing the development. Existing build tool, Buildroot, can be used for this, and we need to build twice in the process
	
- once for creating just the final rootfs 
- second for creating the appropriate initramfs and kernel.

Required changes have have been made to GeneratememMapForAjit.sh for the same.

Tests
=====

Read and write test
-------------------

Each iteration of the test creates a unique file and writes a string to it, and reads the string from each of the created file afterwards.
The *write* and *read* scrpts are consecutive.
Each operation is timed using *time* and results are as follows.
The script runs from the newly created */home* directory in the tmpfs rootfs.

========= =======  ========== ==========
Script    System   Iterations Real time
========= =======  ========== ==========
write.sh  FPGA     100        22m 34.02s
read.sh   FPGA     100        45m 2.02s
write.sh  c-model  5          0m 0.05s
read.sh   c-model  5          0m 0.71s
write.sh  c-model  10         0m 0.80s
read.sh   c-model  10         0m 1.40s
========= =======  ========== ==========

Inferences
==========

**tmpfs**: performance similar to initramfs

**booting time:** ~5m in Fpga and ~1.5 hours with c-model

**read & write performance:** *echo* takes about half the time compared to *cat*

**strace:** doesn't show any anomaly

References
==========

- `Linux kernel documentation(latest) <https://www.kernel.org/doc/html/latest/>`_
- `initrd <https://www.kernel.org/doc/html/latest/admin-guide/initrd.html>`_
- `ramfs,rootfs & initramfs kernel doc <https://www.kernel.org/doc/html/latest/filesystems/ramfs-rootfs-initramfs.html>`_
- `for version 3.16.1 <https://elixir.bootlin.com/linux/v3.16.1/source/Documentation/filesystems/ramfs-rootfs-initramfs.txt>`_
- `ramfs source-code <https://elixir.bootlin.com/linux/v5.11/source/fs/ramfs>`_ 
- `Buildroot manual <https://buildroot.org/downloads/manual/manual.html>`_
- `ramfs from debian wiki <https://wiki.debian.org/ramfs>`_
- `initramfs from debian wiki <https://wiki.debian.org/initramfs>`_

.. - `Linux kernel debugging <https://www.youtube.com/watch?v=NDXYpR_m1CU>`_
