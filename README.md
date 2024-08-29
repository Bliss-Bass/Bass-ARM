# Android 14 for the Raspberry PI 4 series based on the GloDroid project

[![GloDroid](https://img.shields.io/badge/GLODROID-PROJECT-blue)](https://github.com/GloDroid/glodroid_manifest)
[![ProjectStatus](https://img.shields.io/badge/PROJECT-STATUS-yellowgreen)](https://github.com/GloDroidCommunity/raspberry-pi/issues/1)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Discord](https://img.shields.io/discord/753603904406683670.svg?label=Discord&logo=discord&colorB=7289DA&style=flat-square)](https://discord.gg/5H8cW5xA)

## Warning!

This project is a free and open-source initiative maintained by a group of volunteers. It is provided "as is" without any warranties or guarantees.
The user is fully responsible for any issues arising from using the project.

## Flashing images

Find the sdcard image or archive with fastboot images [here](https://github.com/GloDroidCommunity/raspberry-pi/releases)

Use the SDCard raw image to flash the Android into SDCard.

Or use the fastboot images archive to download Android on SDCard using fastboot mode:  

### Step 1
Extract the content of the archive.  
Using any available iso-to-usb utility, prepare recovery SDCARD.  
To flash Android on a sdcard, use *deploy-sd.img*  
  
### Step 2
Ensure you have installed the adb package: ```$ sudo apt install adb``` (required to set up udev rules)  
Insert recovery sdcard into the phone.  
Connect the phone and your PC using a typec cable.  
Power up the phone. Blue LED indicates that the phone is in bootloader mode, and you can proceed with flashing.  
  
### Step 3
Run .*/flash-sd.sh* utility for flashing Android to sdcard  
  
*After several minutes flashing should complete, and Android should boot*  

## Building from sources

Before building, ensure your system has at least 32GB of RAM, a swap file is at least 8GB, and 300GB of free disk space available.
We recommend using the latest laptops to get good performance. E.g., the HP ENVY x360 model15-ds1083cl takes about 5 hours to build the project.  

### Install system packages
(Ubuntu 22.04 LTS is only supported. Building on other distributions can be done using docker)
<br/>

- [Install AOSP required packages](https://source.android.com/setup/build/initializing).
```bash
sudo apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig
```

<br/>

- Install additional packages
```bash
sudo apt-get install -y swig libssl-dev flex bison device-tree-compiler mtools git gettext libncurses5 libgmp-dev libmpc-dev cpio rsync dosfstools kmod gdisk lz4 cmake libglib2.0-dev git-lfs libgnutls28-dev
```

<br/>

- Install additional packages (for building mesa3d, libcamera, and other meson-based components)
```bash
sudo apt-get install -y python3-pip pkg-config python3-dev ninja-build
sudo pip3 install mako jinja2 ply pyyaml pyelftools meson
```

- Install RustC, cargo and other components
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install cargo-ndk

rustup target add \
   aarch64-linux-android \
   armv7-linux-androideabi \
   x86_64-linux-android \
   i686-linux-android
```

- Install vulkan SDK (ubuntu jammy)

For other versions or distributions, please see the Vulkan SDK install page: https://vulkan.lunarg.com/sdk/home

```bash
wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo tee /etc/apt/trusted.gpg.d/lunarg.asc
sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.3.283-jammy.list https://packages.lunarg.com/vulkan/1.3.283/lunarg-vulkan-1.3.283-jammy.list
sudo apt update
sudo apt install vulkan-sdk
```

- Install the `repo` tool
```bash
sudo apt-get install -y python-is-python3 wget
wget -P ~/bin http://commondatastorage.googleapis.com/git-repo-downloads/repo
chmod a+x ~/bin/repo
```

**NOTE: After this step, you may need to log out and log in to the system to make $HOME/bin added to the PATH environment variable.**

### Fetching the sources and building the project

```bash
git clone https://github.com/Bliss-Bass/Bass-ARM.git bass-arm
cd bass-arm
```

### Building AOSP

```bash
./unfold_aosp.sh && ./build.sh
```

**NOTE: If you're using `git` for the first time, it may ask you to configure the user name and email address and confirm the colored terminal.
Please follow the suggestion you see on the screen in this case.**

### Building LineageOS

To enable GMS (microg), set the environment variable `export WITH_GMS=true`.

```bash
./unfold_lineageos.sh && ./build.sh
```

### Building Bass-Pi

To see all build options, use: `bash build_bass_rpi4.sh -h`.

```bash
./unfold_bass_rpi4.sh && ./build_bass_rpi4.sh -h
```

#### Examples

##### BassPi-Desktop

Bass builds are all configured from the single cmdline interface. So our standard Desktop offering is compiled with the following command:

```bash
bash build_bass_pri4.sh --clean --title "BassPi" --blissbuildvariant foss --specialvariant "-Desktop-v14" --ethernetmanager --tabletnav --nolarge --supervanilla --minimal --smartdock --clearhotseat --cleardwhotseat --minfossapps --usecalyxmicrog --aurorastore
```

After a build, the argument history can be found in the build_arg_history file linked in the main project folder.

### Notes

- Depending on your hardware and internet connection, downloading and building may take 8h or more.  
- After the successful build, find the fastboot images at `./out/images.tar.gz` or sdcard image at `./out/sdcard.img`.
- To disable GloDroid's prebuild apps (like skytube, Firefox, etc.), set the environment variable before building `export GD_NO_DEFAULT_APPS=true`.
