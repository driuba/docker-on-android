# TODO document

```
adb -a start-server
```

```
repo sync
source ./build/envsetup.sh
breakfast davinci
cd ./device/xiaomi/davinci
./extract-files.py
croot
make bootimage
```

```
find . -name 'BoardConfigCommon.mk'
cat ./device/xiaomi/sm6150-common/BoardConfigCommon.mk | grep -i target_kernel_config
find . -path '*/vendor/*' -name 'sdmsteppe-perf_defconfig'
make ARCH=arm64 vendor/sdmsteppe-perf_defconfig
make ARCH=arm64 menuconfig
make ARCH=arm64 savedefconfig
```

---

# Android (LineageOS) compilation environment

This project is mainly intended for my personal usage, but feel free to use anything that's applicable to your use case.

The goal is to enable my spare phone - [Xiaomi Mi 9T](https://wiki.lineageos.org/devices/davinci/variant1/) to run [Docker](https://www.docker.com/products/cli/).
To that end I need to figure out:  
 * how to compile relevant Android kernel;
 * how to enable necessary kernel options;
 * how install Docker.

As a side quest, how to enable [KernelSU](https://kernelsu.org/) rooting, since this device doesn't seem to support it out of the box.

## Compiling the kernel

As an additional goal I decided to set up container based build environment.
This allows me to isolate all of the build dependecies from my main system.

My Android ROM choice was mostly motivated solely by the fact that this device happened to be officially supported by LineageOS.
For base image I chose [Debian](https://www.debian.org/) only because I'm familiar and comfortable with Debian based distros.

I wanted to build basically just the kernel, maybe some minimally related code.
I really wanted to avoid building the whole OS as is documented in the [official guide](https://wiki.lineageos.org/devices/davinci/build/variant1/).
My initial attempt was trying to follow [this gist](https://gist.github.com/davidgarland/ae6da821016fde4c877973ddd3f8f116), however it quickly proved to be quite complicated to set up.
After a bunch of searching I did stumble upon a Reddit [comment](https://www.reddit.com/r/LineageOS/comments/19emtus/comment/kjdpl7l/) hinting that the documented guide can also build just the boot image.
So, I pivoted and set up a container with dependencies and source code for LineageOS.
I tested the build without any modification and after a quick boot image flash I was in business.

<!-- TODO: insert code snippeds an comments on this process -->
