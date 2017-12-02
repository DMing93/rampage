# RAMpage

NOTE: This repository is originally developed by H. Schirmeier in Linux
kernel 3.5. Now we update RAMpage to kernel 4.4 and will continue to update. Thanks for everyone interested in RAMpage.
-- by Wang Xiaoqiang <wang_xiaoq@126.com>

This repository contains the RAMpage online memory tester for Linux, which we
developed on the basis of
[Jens Neuhalfen's memtester](https://github.com/neuhalje/kernel-memtest).

## Basic Setup

These steps are required to setup and run RAMpage:

* Download the linux kernel 4.4 source code:

  `wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.4.tar.xz`

* Uncompress the kernel code:

  `tar xvf linux-4.4.tar.xz`
  
* Patch the kernel with rampage patch:

  `cd linux-4.4`
  `patch -p1 < rampage/patches/kernelpatch-rampage-4.4.diff`

* Copy a config file from current running system to kernel source code:

  `cp /boot/config-<kernel-version> .config`

  Note: *kernel-version* may not equal 4.4, but it's ok, just do it:).

* Compile the kernel:

  `make menuconfig`
  `make`
  `make modules_install`
  `make install`

* After having booted the patched kernel, you need to build and insert
  the kernel module by entering module/ and running ```./rebuild.sh```.

* Then you need to prepare the userspace memory tester C extensions:

  `cd rampage/userspace/tester`
  `make && cp build/*/*.so .`
  `cd ..`

* RAMpage should now be ready to run, for example:

  `./main.py -a blockwise --run-time 86400 --retest-time 86400 -4 -t mt86* -f 5120 --enable-p4-claimers=buddy,hotplug-claim,shaking`

  `./main.py --help` 

gives an explanation for the parameters and switches.

Be aware that RAMpage is a prototype, not production-ready software.
One detail you certainly will have to change before using it in a multiuser
environment is the access permissions to /proc/kpagecount and /proc/kpageflags
(rampage/module/rebuild.sh currently chmod's these to 0444) and especially the
module's own /proc/phys_mem (currently 0777).

Patches and ports to new kernel versions and other kernels welcome!


## Publications

A detailed description, and measurements on both effectiveness and efficiency,
can be found in the following two publications:

* H. Schirmeier, J. Neuhalfen, I. Korb, O. Spinczyk, and M. Engel.
  [RAMpage: Graceful degradation management for memory errors in commodity
  Linux servers](http://danceos.org/publications/PRDC-2011-Schirmeier.pdf).
  In *Proceedings of the 17th IEEE Pacific Rim International Symposium on
  Dependable Computing (PRDC '11)*, pages 89-98, Pasadena, CA, USA, Dec. 2011.
  IEEE Computer Society Press.

* H. Schirmeier, I. Korb, O. Spinczyk, and M. Engel. [Efficient online memory
  error assessment and circumvention for Linux with
  RAMpage](http://danceos.org/publications/IJCCBS-2013-Schirmeier.pdf).
  *International Journal of Critical Computer-Based Systems*,
  4(3):227-247, 2013.  Special Issue on PRDC 2011 Dependable Architecture and
  Analysis.

The code in this repository is licensed under the GNU General Public License
(GPL), Version 2.
