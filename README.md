# Bass Pi - Android 14 for the Raspberry PI 4 series based on the GloDroid project and Bass OS

[![GloDroid](https://img.shields.io/badge/GLODROID-PROJECT-blue)](https://github.com/GloDroid/glodroid_manifest)
[![ProjectStatus](https://img.shields.io/badge/PROJECT-STATUS-yellowgreen)](https://github.com/GloDroidCommunity/raspberry-pi/issues/1)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Discord](https://img.shields.io/discord/753603904406683670.svg?label=Discord&logo=discord&colorB=7289DA&style=flat-square)](https://discord.gg/5H8cW5xA)

## Bass OS Resources: 

[![Bass OS/ARM Website](https://img.shields.io/badge/BASS-OS-green)](https://bliss-bass.github.io)
[![Bass OS/ARM Documentation](https://img.shields.io/badge/DOCUMENTATION-orange)](https://docs.blisscolabs.dev)

## Warning!

This project is a free and open-source initiative maintained by a group of volunteers. It is provided "as is" without any warranties or guarantees.
The user is fully responsible for any issues arising from using the project.

## Flashing images

Step 1) Find the sdcard image or archive with fastboot images [here](https://github.com/Bliss-Bass/bass-rpi/releases)

Step 2) Follow the instructions from [Bass OS Documentation - Raspberry Pi Installation](https://docs.blisscolabs.dev/installation/raspberry-pi/raspberry-pi-installation/)

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

For signing apps, we need to have the Android SDK's build-tools to be installed on the server at: ~/Android/Sdk
https://dl.google.com/android/repository/build-tools_r34-linux.zip

The easiest wy to do that is from Android-Studio: https://developer.android.com/studio#downloads

This can be downloaded from: https://developer.android.com/studio/index.html#command-line-tools-only

**NOTE: After this step, you may need to log out and log in to the system to make $HOME/bin added to the PATH environment variable.**

### Fetching the sources and building the project

```bash
git clone https://github.com/Bliss-Bass/Bass-ARM.git bass-arm
cd bass-arm
```

### Unfolding the source

This part takes a while and is the part that uses up all your internet bandwidth. Please do this on unmetered connections

```bash
bash unfold_bass_rpi4.sh
```

### Building Bass-Pi

This is where things get a little interesting. Bass Toolkit is integrated as part of Bass ARM, and through that we have access to a variety of build options. So the difference between a Desktop UI based build and a Gaming UI based build is defined by changing a few of the options in the build command. 

Desktop Builds default configs:

- --smartdock : the default Desktop mode taskbar and start menu
- --tabletnav : forces navigation mode to use 3-button navigation
- --nolarge : forces Settings and other apps to not use split screen layouts
- --clearhotseat : removes the favorite apps from the Android launcher
- --cleardwhotseat : removes the favorite apps from the Android taskbar

To see all build options along with their descriptions, use: `bash build_bass_rpi4.sh -h`.

```bash
bash build_bass_rpi4.sh -h
```

#### Examples

##### BassPi-Desktop

Bass builds are all configured from the single cmdline interface. So our standard Desktop offering is compiled with the following command:

```bash
bash build_bass_pri4.sh --clean --title "BassPi" --blissbuildvariant foss --specialvariant "-Desktop-v14" --ethernetmanager --tabletnav --nolarge --supervanilla --minimal --smartdock --clearhotseat --cleardwhotseat --minfossapps --usecalyxmicrog --aurorastore
```

#### Initial Setups

When running your first build, there are a number of options that trigger user input prompts. Some of those are:

- Foss builds - Any foss app or foss variant build will initially ask you to download the latest versions of the FOSS app selections. This can be manually triggered for updates from aosptree/vendor/foss/update.sh
- Production builds - This will prompt for signature certificate generation, so a lot of questions that you have to answer. This only needs to be done once and is saved in the source. Signatures are ignored from the manifest for security. We suggest you keep those separately (in a private repo if they need to be shared with team members).

#### After the build

Images from the build will be found in a folder with the build name and date, found in images/ , linked to the aosptree/images/ folder
After a build, the argument history can be found in the build_arg_history file linked in the main project folder.

### Notes

- Depending on your hardware and internet connection, downloading and building may take 8h or more.  
- After the successful build, find the fastboot images at `./out/images.tar.gz` or sdcard image at `./out/sdcard.img`.
- To disable GloDroid's prebuild apps (like skytube, Firefox, etc.), set the environment variable before building `export GD_NO_DEFAULT_APPS=true`.
