#!/bin/bash

# Clean up any passed options and reset them. 
CLEAN_COMMAND=""
build_date=$(date +%Y%m%d%H%M)
build_filename="bliss_gd_rpi4_${build_date}"

# clean exported variables
export RELEASE_OS_TITLE=BlissBass
export USE_SMARTDOCK=false
export USE_SMARTDOCK_B=false
export USE_KERNEL_SU_PLUS=false
export USE_FOSSAPPS=false
export BLISS_BUILD_VARIANT=vanilla
export IS_GO_VERSION=false
export BOARD_IS_GO_BUILD=false
export USE_GO_RES_ICONS=false
export BLISS_SUPER_VANILLA=false
export BLISS_MINIMAL_PACKAGES=false
export BLISS_SPECIAL_VARIANT=""
export USE_BLISS_SETUPWIZARD=false
export BLISS_REMOVE_USER_TOOLS=false
export BLISS_VIA_BROWSER=false
export IS_INTEL_ATOM=false
export USE_BLISS_ETHERNET_MANAGER=false
export BLISS_REMOVE_KSU=false
export BLISS_PRODUCTION_BUILD=false
export BLISS_SECURE_LOCKDOWN_BUILD=false
export BLISS_TABLET_NAVIGATION=false
export BLISS_LAUNCHER3_TASKBAR_NAVIGATION=false
export USE_BLISS_RESTRICTED_LAUNCHER=false
export USE_BLISS_RESTRICTED_LAUNCHER_PRO=false
export USE_BLISS_GARLIC_LAUNCHER=false
export USE_BLISS_GAME_MODE_LAUNCHER=false
export USE_BLISS_CROSS_LAUNCHER=false
export USE_BLISS_POWER_MANAGER=false
export BLISS_GESTURE_NAVIGATION=false
export BLISS_CLEAR_HOTSEAT_FAVORITES=false
export BUILD_EXTRA_PACKAGES=""
export USE_SHOW_KEYBOARD=false
export USE_ALWAYS_ON_SETTINGS=false
export USE_PER_DISPLAY_FOCUS=false
export USE_PER_DISPLAY_FOCUS_IME=false
export USE_PER_DISPLAY_FOCUS_ZQY_IME=false
export UPDATE_FOSSAPPS=false
export USE_MOUSE_PRESENTATION=false
export FORCE_NAVBAR_ON_SECONDARY_DISPLAYS=false
export FORCE_STATUSBAR_ON_SECONDARY_DISPLAYS=false
export BLISS_DISABLE_LARGE_SCREEN_SETTINGS=false
export BLISS_USE_SYSTEMUI_RECENTS=false
export USE_POS_TERMINAL_APP=false
export FORCE_RIGHT_MOUSE_AS_BACK=false
export TARGET_HAS_SOF_FIRMWARE=false
export TARGET_HAS_SILEAD_FIRMWARE=false
export USE_BLISS_TV_LAUNCHER=false
export USE_TITANIUS_LAUNCHER=false
export USE_GBOARD_PREBUILT=false
export USE_GBOARD_LITE_PREBUILT=false
export USE_MINIMAL_FOSS_APPS=false
export BLISS_DISABLE_DEVICE_SEARCH=false
export BLISS_BUILD_SECURE_ADB=false
export USE_DESKTOP_MODE_ON_SECONDARY_DISPLAYS=false
export GRUB_CMDLINE_OPTIONS=""
export INCLUDE_AGPRIVAPPS=false
export BASS_DO_NOT_CLEAN=false
export BASS_CHECK_PROJECT_STATUS=false
export USE_MINIMAL_FOSS_APPS_WITH_MICROG=false
export USE_CALYX_MICROG=false
export USE_AURORA_STORE=false
export INCLUDE_AURORA_SERVICES=false
export USE_AX86_STARTMENU=false
# autogenerated clear exports go here
export BLISS_CLEAR_DW_HOTSEAT=false
export BLISS_USE_SYSTEMUI_BLUR=false

# Help dialog
function displayHelp() {
    echo "Usage: build-rpi4.sh [options]"
    echo "Options:"
    echo "-h, --help             Display this help dialog"
    echo "-c, --clean            Clean the project"
    echo "--nocleanconf          Do not clean the project configs that are changed in source"
    echo "-d, --dirty            Run in dirty mode"
    echo "-t, --title (title)    Set the release title"
    # echo "-b, --blissbuildvariant (variant)   Set the Bliss build variant"
    echo "-i, --isgo             Enable isgo version"
    echo "-v, --specialvariant (variant)      Set the special variant"
    # echo '--grubcmdline "option1=1 option2=1" Set the grub cmdline options'
    # echo "--production           Disable Test Build watermark and sign builds (requires release/product signature keys)"
    echo "--checkproject         Check the project status"
    echo ""
    echo "Launcher Options:"
    echo "--clearhotseat         Enable clear hotseat favorites for Launcher3 Quickstep"
    echo "--disablesearch        Disable device search"
    echo "-s, --smartdock        Enable smartdock"
    echo "--smartdockb           Enable smartdock with Bliss customizations"
    echo "-k, --kiosk            Enable kiosk launcher **requires private git access**"
    echo "--restrictedlauncher   Enable restricted launcher"
    echo "--restrictedlauncherpro   Enable restricted launcher pro **requires private git access**"
    echo "--garliclauncher       Enable garlic launcher"
    echo "--gamemodelauncher     Enable game mode launcher"
    echo "--crosslauncher        Enable cross launcher"
    echo "--tvlauncher           Enable tv launcher"
    echo "--titaniuslauncher     Enable titanius launcher"
    echo "--desktoponsecondary   Enable desktop on secondary displays"
    echo ""
    echo "Navigation Options:"
    echo "-t, --tabletnav        Enable tablet navigation"
    echo "--taskbarnav           Enable taskbar navigation"
    echo "--gesturenav    Enable gesture navigation"
    # echo "--externalnav          Enable navigation on external displays"
    # echo "--externalstatusbar    Enable status bar on external displays"
    # echo "--rightmouseasback     Enable right mouse button as back"
    echo ""
    echo "Package Options:"
    echo "--noksu                Disable KernelSU"
    echo "-f, --fossapps         Enable fossapps"
    echo "--minfossapps          Enable minimal fossapps"
    echo "--minfossmicrog        Enable minimal fossapps with microg"
    echo "--usecalyxmicrog       Enable Calyx microg"
    echo "--aurorastore          Enable Aurora store"
    # echo "-e, --supervanilla     Enable supervanilla"
    # echo "-m, --minimal          Enable minimal packages"
    # echo "-r, --removeusertools  Enable removeusertools"
    # echo "--viabrowser           Enable viabrowser"
    # echo "-w, --wiz              Enable Bliss setupwizard"
    # echo "--ethernetmanager      Enable EthernetManager"
    # echo "--powermanager         Enable power manager"
    # echo "--buildextra           Build extra packages"
    echo "--updatefossapps       Update fossapps"
    echo "--usepos               Enable TabShop pos terminal app"
    echo "-p, --privateapp       Enable privateapps **requires private git access**"
    echo "--ax86startmenu        Enable ax86 startmenu"
    echo ""
    echo "Input Options:"
    echo "--showkeyboard         Enable show keyboard"
    echo "--perdisplayfocus      Enable per display focus (will display any IME on all displays)"
    echo "--gboard               Enable Google GBoard IME"
    echo "--gboardlite           Enable Google GBoard Lite IME"
    echo "--perdisplayfocusime      Enable per display focus with experiment IME"
    echo "--perdisplayfocuszqyime   Enable per display focus with ZQY IME"
    # echo "--mousepresentation    Enable mouse presentation mode"
    echo ""
    # echo "Firmware & Driver Options:"
    # echo "--sof                  Include SOF firmware"
    # echo "--silead               Include Silead firmware"
    # echo ""
    echo "Other Options:"
    # echo "-a, --atom             Include Intel Atom specific configurations"
    # echo "-l, --lockdown         Enable secure lockdown build"
    echo "--adblockdown          Enable lockdown ADB defaults"
    echo "-m, --manifest         Generate manifest"
    echo "--alwaysonsettings     Enable always on settings"
    echo "--nolarge              Disable large screen settings"
    # echo "--usesystemuirecents   Set SystemUI as the default recents provider"
    # autogenerated help items go here
    echo "--cleardwhotseat          Enable clear dw hotseat favorites"
    echo "--useblur          use SystemUI Blur effects"

    exit 0
}

# Clean configs function
function clean_configs()
{    
    cd vendor/bass
    git checkout -- overlay/common/frameworks/base/core/res/res/values/config.xml
    git checkout -- overlay/common/frameworks/base/packages/SettingsProvider/res/values/defaults.xml
    cd ../..
    cd packages/apps/Launcher3
    if [[ "$BLISS_CLEAR_HOTSEAT_FAVORITES" = "true" ]] || [[ "$USE_AX86_STARTMENU" = "true" ]]; then
        WORKSPACE_LIST=$(find res/xml/ -type f -name "default_workspace*.xml")
        for file in $WORKSPACE_LIST
        do
            git checkout -- $file
        done
    fi
    git checkout -- src/com/android/launcher3/config/FeatureFlags.java
    cd ../../..
    cd frameworks/base 
    git checkout -- core/java/android/util/FeatureFlagUtils.java
    git checkout -- core/res/res/values/config.xml
    git checkout -- packages/SettingsProvider/res/values/defaults.xml
    cd ../..
    
}

doImageCopy() {
    # Copy images to their own folder
    # Look in out/ for the images and copy them to a new /images directory. 
    #using the filename of the .iso for the directory name and the .iso file name.
    mkdir -p images
    img_exists=$(find out/target/product/gd_rpi4/ -name "sdcard.img")
    zip_exists=$(find out/target/product/gd_rpi4/ -name "sdcard.img.zip")
    tar_exists=$(find out/target/product/gd_rpi4/ -name "images.tar.gz")
    flash_exists=$(find out/target/product/gd_rpi4/ -name "flash-sd.sh")
    fastboot_exists=$(find out/target/product/gd_rpi4/ -name "fastboot")
    build_date=$(date +%Y%m%d%H%M%S)
    build_pre="${RELEASE_OS_TITLE:-bass}"
    build_post="${BLISS_SPECIAL_VARIANT}"
    build_filename="${build_pre}${build_post}_gd_rpi4_${build_date}"
    if [[  "$img_exists" != "" ]]; then 
        mkdir -p images/$build_filename
        img_name=$(basename "$img_exists")
        xz -d "$img_exists"
        cp "$img_exists.xz" images/$build_filename/"$img_name".xz
    fi
    if [[  "$zip_exists" != "" ]]; then 
        mkdir -p images/$build_filename
        zip_name=$(basename "$zip_exists")
        cp "$zip_exists" images/$build_filename/"$zip_name"
    fi
    if [[  "$tar_exists" != "" ]]; then 
        mkdir -p images/$build_filename
        tar_name=$(basename "$tar_exists")
        cp "$tar_exists" images/$build_filename/"$tar_name"
    fi
    if [[  "$flash_exists" != "" ]]; then 
        mkdir -p images/$build_filename
        flash_name=$(basename "$flash_exists")
        cp "$flash_exists" images/$build_filename/"$flash_name"
    fi
    if [[  "$fastboot_exists" != "" ]]; then 
        mkdir -p images/$build_filename
        fastboot_name=$(basename "$fastboot_exists")
        cp "$fastboot_exists" images/$build_filename/"$fastboot_name"
    fi
}

# if $# -eq 0, exit
if [ $# -eq 0 ]; then
    displayHelp
else
    echo "Starting build..."
    echo " "

    if [ ! -f .bbconfig/build_arg_history ]; then
        mkdir -p .bbconfig
        touch .bbconfig/build_arg_history
    fi
    shelldate=$( date +%Y-%m-%d_%H:%M:%S )
    printf "Date: %s: bash build_bass_pri4.sh %s\n" "$shelldate" "$*" >> .bbconfig/build_arg_history
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            displayHelp
            ;;
        -c|--clean)
            echo "Cleaning..."
            CLEAN_COMMAND="make clean "
            shift
            ;;
        -d|--dirty)
            echo "Running dirty..."
            CLEAN_COMMAND=""
            shift
            ;;
        -t|--title)
            RELEASE_OS_TITLE="$2"
            shift
            shift
            ;;
        -s|--smartdock)
            USE_SMARTDOCK=true
            shift
            ;;
        --smartdockb)
            USE_SMARTDOCK_B=true
            shift
            ;;
        -k|--kiosk)
            USE_BLISS_KIOSK_LAUNCHER=true
            shift
            ;;
        -f|--fossapps)
            USE_FOSSAPPS=true
            shift
            ;;
        -b|--blissbuildvariant)
            BLISS_BUILD_VARIANT="$2"
            shift
            shift
            ;;
        -i|--isgo)
            IS_GO_VERSION=true
            BOARD_IS_GO_BUILD=true
            USE_GO_RES_ICONS=true
            shift
            ;;
        -e|--supervanilla)
            BLISS_SUPER_VANILLA=true
            shift
            ;;
        -m|--minimal)
            BLISS_MINIMAL_PACKAGES=true
            shift
            ;;
        -r|--removeusertools)
            BLISS_REMOVE_USER_TOOLS=true
            shift
            ;;
        --viabrowser)
            BLISS_VIA_BROWSER=true
            shift
            ;;
        -v|--specialvariant)
            BLISS_SPECIAL_VARIANT="$2"
            shift
            shift
            ;;
        -w|--wiz)
            USE_BLISS_SETUPWIZARD=true
            shift
            ;;
        -a|--atom)
            IS_INTEL_ATOM=true 
            shift
            ;;
        -m|--manifest)
            GENERATE_MANIFEST=true
            shift
            ;;
        --ethernetmanager)
            USE_BLISS_ETHERNET_MANAGER=true
            shift
            ;;
        --noksu)
            BLISS_REMOVE_KSU=true
            shift
            ;;
        --production)
            BLISS_PRODUCTION_BUILD=true
            shift
            ;;
        -l|--lockdown)
            BLISS_SECURE_LOCKDOWN_BUILD=true
            shift
            ;;
        -t|--tabletnav)
            BLISS_TABLET_NAVIGATION=true
            shift
            ;;
        --taskbarnav)
            BLISS_LAUNCHER3_TASKBAR_NAVIGATION=true
            shift
            ;;
        --restrictedlauncher)
            USE_BLISS_RESTRICTED_LAUNCHER=true
            shift
            ;;
        --restrictedlauncherpro)
            USE_BLISS_RESTRICTED_LAUNCHER_PRO=true
            shift
            ;;
        --garliclauncher)
            USE_BLISS_GARLIC_LAUNCHER=true
            shift
            ;;
        --gamemodelauncher)
            USE_BLISS_GAME_MODE_LAUNCHER=true
            shift
            ;;
        --crosslauncher)
            USE_BLISS_CROSS_LAUNCHER=true
            shift
            ;;
        --powermanager)
            USE_BLISS_POWER_MANAGER=true
            shift
            ;;
        --gesturenav)
            BLISS_GESTURE_NAVIGATION=true
            shift
            ;;
        --clearhotseat)
            BLISS_CLEAR_HOTSEAT_FAVORITES=true
            shift
            ;;
        --buildextra)
            BUILD_EXTRA_PACKAGES="$2"
            shift
            shift
            ;;
        --showkeyboard)
            USE_SHOW_KEYBOARD=true
            shift
            ;;
        --alwaysonsettings)
            USE_ALWAYS_ON_SETTINGS=true
            shift
            ;;
        --perdisplayfocus)
            USE_PER_DISPLAY_FOCUS=true
            shift
            ;;
        --perdisplayfocusime)
            USE_PER_DISPLAY_FOCUS=true
            USE_PER_DISPLAY_FOCUS_IME=true
            shift
            ;;
        --perdisplayfocuszqy)
            USE_PER_DISPLAY_FOCUS=true
            USE_PER_DISPLAY_FOCUS_ZQY_IME=true
            shift
            ;;
        --updatefossapps)
            UPDATE_FOSSAPPS=true
            shift
            ;;
        --mousepresentation)
            USE_MOUSE_PRESENTATION=true
            shift
            ;;
        --externalnav)
            FORCE_NAVBAR_ON_SECONDARY_DISPLAYS=true
            shift
            ;;
        --externalstatusbar)
            FORCE_STATUS_BAR_ON_SECONDARY_DISPLAYS=true
            shift
            ;;
        --nolarge)
            BLISS_DISABLE_LARGE_SCREEN_SETTINGS=true
            shift
            ;;
        --usesystemuirecents)
            BLISS_USE_SYSTEMUI_RECENTS=true
            shift
            ;;
        --usepos)
            USE_POS_TERMINAL_APP=true
            shift
            ;;
        --rightmouseasback)
            FORCE_RIGHT_MOUSE_AS_BACK=true
            shift
            ;;
        --sof)
            TARGET_HAS_SOF_FIRMWARE=true
            shift
            ;;
        --silead)
            TARGET_HAS_SILEAD_FIRMWARE=true
            shift
            ;;
        --tvlauncher)
            USE_BLISS_TV_LAUNCHER=true
            shift
            ;;
        --titaniuslauncher)
            USE_TITANIUS_LAUNCHER=true
            shift
            ;;
        --gboard)
            USE_GBOARD_PREBUILT=true
            shift
            ;;
        --gboardlite)
            USE_GBOARD_LITE_PREBUILT=true
            shift
            ;;
        --minfossapps)
            USE_FOSSAPPS=true
            USE_MINIMAL_FOSS_APPS=true
            shift
            ;;
        --disablesearch)
            BLISS_DISABLE_DEVICE_SEARCH=true
            shift
            ;;
        --adblockdown)
            BLISS_BUILD_SECURE_ADB=true
            shift
            ;;
        --desktoponsecondary)
            USE_DESKTOP_MODE_ON_SECONDARY_DISPLAY=true
            shift
            ;;
        --grubcmdline)
            # GRUB_CMDLINE_OPTIONS="$2"
            shift
            while [[ $1 != "" && $1 != -* ]]; do
                GRUB_CMDLINE_OPTIONS="$GRUB_CMDLINE_OPTIONS $1"
                shift
            done
            echo "GRUB_CMDLINE_OPTIONS=$GRUB_CMDLINE_OPTIONS"
            ;;
        -p |--privateapp)
            INCLUDE_AGPRIVAPPS=true
            shift
            ;;
        --nocleanconf)
            BASS_DO_NOT_CLEAN=true
            shift
            ;;
        --checkproject)
            BASS_CHECK_PROJECT_STATUS=true
            shift
            ;;
        --minfossmicrog)
            USE_FOSSAPPS=true
            USE_MINIMAL_FOSS_APPS=true
            USE_MINIMAL_FOSS_APPS_WITH_MICROG=true
            shift
            ;;
        --usecalyxmicrog)
            USE_CALYX_MICROG=true
            shift
            ;;
        --aurorastore)
            USE_AURORA_STORE=true
            INCLUDE_AURORA_SERVICES=true
            shift
            ;;
        --ax86startmenu)
            USE_AX86_STARTMENU=true
            shift
            ;;
        # autogenerated menu items go here
        --cleardwhotseat)
               BLISS_CLEAR_DW_HOTSEAT=true
               shift
               ;;
        --useblur)
               BLISS_USE_SYSTEMUI_BLUR=true
               shift
               ;;
        *)
            echo "Unknown option: $1"
            displayHelp
            ;;

    esac
done

# if RELEASE_OS_TITLE is over 12 characters, exit
if [ ${#RELEASE_OS_TITLE} -gt 12 ]; then
    echo -e "\e[31m!!WARNING!!\e[0m"
    echo -e "\e[31mRelease title cannot be over 12 characters.\e[0m"
    exit 1
fi

if [[ $(echo ${USE_TITANIUS_LAUNCHER} ${USE_BLISS_TV_LAUNCHER} ${USE_SMARTDOCK} ${USE_BLISS_KIOSK_LAUNCHER} ${USE_BLISS_GAME_MODE_LAUNCHER} ${USE_BLISS_RESTRICTED_LAUNCHER} ${USE_BLISS_RESTRICTED_LAUNCHER_PRO} ${USE_BLISS_GARLIC_LAUNCHER} | grep -c "true") -gt 1 ]]; then
    echo -e "\e[31m!!WARNING!!\e[0m"
    echo -e "\e[31mOnly one admin launcher can be enabled at the same time.\e[0m"
    exit 1
fi

if [ "${BLISS_SECURE_LOCKDOWN_BUILD}" = true ]; then
    export USE_BLISS_KIOSK_LAUNCHER=true;
fi

if [[ ${BLISS_LAUNCHER3_TASKBAR_NAVIGATION} = true ]] && [[ ${BLISS_TABLET_NAVIGATION} = true ]]; then
    echo -e "\e[33m!NOTICE!\e[0m"
    echo -e "\e[33mLauncher3 taskbar and 3-button navigation will be enabled at the same time.\e[0m"
fi

if [ "$USE_FOSSAPPS" = true ]; then
    if [ ! -d vendor/foss/bin ]; then
        echo -e "\e[31m!!WARNING!!\e[0m"
        echo -e "\e[31mFOSSAPPS is enabled, but no vendor/foss/bin directory is found.\e[0m"
        echo -e ""
        read -p "Would you like to sync the vendor/foss directory now? (Y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "\e[33m!NOTICE!\e[0m"
            echo -e "\e[33mSyncing vendor/foss...\e[0m"
            $(cd vendor/foss && bash update.sh 1)
        fi
    fi
fi

. build/envsetup.sh
$CLEAN_COMMAND 
# check output of clean command to make sure it completes successfully
if [ $? -ne 0 ]; then  
    echo -e "\e[31m!!WARNING!!\e[0m"
    echo -e "\e[31mClean command failed. Please manually remove the out folder before continuing\e[0m"
    echo -e "\e[31mExiting...\e[0m"
    exit 1  
fi

# set up build variables
export RELEASE_OS_TITLE=${RELEASE_OS_TITLE:-BlissBass};
export USE_SMARTDOCK=${USE_SMARTDOCK:-false};
export USE_SMARTDOCK_B=${USE_SMARTDOCK_B:-false};
export USE_BLISS_KIOSK_LAUNCHER=${USE_BLISS_KIOSK_LAUNCHER:-false};
export USE_FOSSAPPS=${USE_FOSSAPPS:-false};
export BLISS_BUILD_VARIANT=${BLISS_BUILD_VARIANT:-vanilla};
export IS_GO_VERSION=${IS_GO_VERSION:-false};
export BOARD_IS_GO_BUILD=${BOARD_IS_GO_BUILD:-false};
export USE_GO_RES_ICONS=${USE_GO_RES_ICONS:-false};
export BLISS_SUPER_VANILLA=${BLISS_SUPER_VANILLA:-false};
export BLISS_MINIMAL_PACKAGES=${BLISS_MINIMAL_PACKAGES:-false};
export BLISS_SPECIAL_VARIANT=${BLISS_SPECIAL_VARIANT:-""};
export USE_BLISS_SETUPWIZARD=${USE_BLISS_SETUPWIZARD:-false};
export BLISS_REMOVE_USER_TOOLS=${BLISS_REMOVE_USER_TOOLS:-false};
export BLISS_VIA_BROWSER=${BLISS_VIA_BROWSER:-false};
export IS_INTEL_ATOM=${IS_INTEL_ATOM:-false};
export USE_BLISS_ETHERNET_MANAGER=${USE_BLISS_ETHERNET_MANAGER:-false};
export BLISS_REMOVE_KSU=${BLISS_REMOVE_KSU:-false};
export BLISS_PRODUCTION_BUILD=${BLISS_PRODUCTION_BUILD:-false};
export BLISS_SECURE_LOCKDOWN_BUILD=${BLISS_SECURE_LOCKDOWN_BUILD:-false};
export BLISS_TABLET_NAVIGATION=${BLISS_TABLET_NAVIGATION:-false};
export BLISS_LAUNCHER3_TASKBAR_NAVIGATION=${BLISS_LAUNCHER3_TASKBAR_NAVIGATION:-false};
export USE_BLISS_RESTRICTED_LAUNCHER=${USE_BLISS_RESTRICTED_LAUNCHER:-false};
export USE_BLISS_RESTRICTED_LAUNCHER_PRO=${USE_BLISS_RESTRICTED_LAUNCHER_PRO:-false};
export USE_BLISS_GARLIC_LAUNCHER=${USE_BLISS_GARLIC_LAUNCHER:-false};
export GENERATE_MANIFEST=${GENERATE_MANIFEST:-false};
export USE_BLISS_GAME_MODE_LAUNCHER=${USE_BLISS_GAME_MODE_LAUNCHER:-false};
export USE_BLISS_CROSS_LAUNCHER=${USE_BLISS_CROSS_LAUNCHER:-false};
export USE_BLISS_POWER_MANAGER=${USE_BLISS_POWER_MANAGER:-false};
export BLISS_GESTURE_NAVIGATION=${BLISS_GESTURE_NAVIGATION:-false};
export BLISS_CLEAR_HOTSEAT_FAVORITES=${BLISS_CLEAR_HOTSEAT_FAVORITES:-false};
export BUILD_EXTRA_PACKAGES=${BUILD_EXTRA_PACKAGES:-""};
export USE_SHOW_KEYBOARD=${USE_SHOW_KEYBOARD:-false};
export USE_ALWAYS_ON_SETTINGS=${USE_ALWAYS_ON_SETTINGS:-false};
export USE_PER_DISPLAY_FOCUS=${USE_PER_DISPLAY_FOCUS:-false};
export USE_PER_DISPLAY_FOCUS_IME=${USE_PER_DISPLAY_FOCUS_IME:-false};
export USE_PER_DISPLAY_FOCUS_ZQY_IME=${USE_PER_DISPLAY_FOCUS_ZQY_IME:-false};
export USE_MOUSE_PRESENTATION=${USE_MOUSE_PRESENTATION:-false};
export FORCE_NAVBAR_ON_SECONDARY_DISPLAYS=${FORCE_NAVBAR_ON_SECONDARY_DISPLAYS:-false};
export FORCE_STATUS_BAR_ON_SECONDARY_DISPLAYS=${FORCE_STATUS_BAR_ON_SECONDARY_DISPLAYS:-false};
export BLISS_DISABLE_LARGE_SCREEN_SETTINGS=${BLISS_DISABLE_LARGE_SCREEN_SETTINGS:-false};
export BLISS_USE_SYSTEMUI_RECENTS=${BLISS_USE_SYSTEMUI_RECENTS:-false};
export USE_POS_TERMINAL_APPS=${USE_POS_TERMINAL_APPS:-false};
export FORCE_RIGHT_MOUSE_AS_BACK=${FORCE_RIGHT_MOUSE_AS_BACK:-false};
export TARGET_HAS_SOF_FIRMWARE=${TARGET_HAS_SOF_FIRMWARE:-false};
export TARGET_HAS_SILEAD_FIRMWARE=${TARGET_HAS_SILEAD_FIRMWARE:-false};
export USE_BLISS_TV_LAUNCHER=${USE_BLISS_TV_LAUNCHER:-false};
export USE_TITANIUS_LAUNCHER=${USE_TITANIUS_LAUNCHER:-false};
export USE_GBOARD_PREBUILT=${USE_GBOARD_PREBUILT:-false};
export USE_GBOARD_LITE_PREBUILT=${USE_GBOARD_LITE_PREBUILT:-false};
export USE_MINIMAL_FOSS_APPS=${USE_MINIMAL_FOSS_APPS:-false};
export BLISS_DISABLE_DEVICE_SEARCH=${BLISS_DISABLE_DEVICE_SEARCH:-false};
export BLISS_BUILD_SECURE_ADB=${BLISS_BUILD_SECURE_ADB:-false};
export USE_DESKTOP_MODE_ON_SECONDARY_DISPLAYS=${USE_DESKTOP_MODE_ON_SECONDARY_DISPLAYS:-false};
export GRUB_CMDLINE_OPTIONS=${GRUB_CMDLINE_OPTIONS:-""};
export INCLUDE_AGPRIVAPPS=${INCLUDE_AGPRIVAPPS:-false};
export BASS_DO_NOT_CLEAN=${BASS_DO_NOT_CLEAN:-false};
export BASS_CHECK_PROJECT_STATUS=${BASS_CHECK_PROJECT_STATUS:-false};
export USE_MINIMAL_FOSS_APPS_WITH_MICROG=${USE_MINIMAL_FOSS_APPS_WITH_MICROG:-false};
export USE_CALYX_MICROG=${USE_CALYX_MICROG:-false};
export USE_AURORA_STORE=${USE_AURORA_STORE:-false};
export INCLUDE_AURORA_SERVICES=${INCLUDE_AURORA_SERVICES:-false};
export USE_AX86_STARTMENU=${USE_AX86_STARTMENU:-false};
# autogenerated export items go here
export BLISS_CLEAR_DW_HOTSEAT=${BLISS_CLEAR_DW_HOTSEAT:-false};
export BLISS_USE_SYSTEMUI_BLUR=${BLISS_USE_SYSTEMUI_BLUR:-false};

if [ "$BLISS_PRODUCTION_BUILD" = "true" ]; then
    if [ ! -d "vendor/bliss/config/signing" ]; then
        echo " Missing signing keys. Would you like to generate them? (y/n)" && read ANSWER
        if [ "$ANSWER" = "y" ]; then
            echo "Generating signing keys..."
            bash vendor/bass/tools/tool-generate-keys.sh
        else
            echo "Please verify your keys are located in vendor/bliss/config/signing or do not build with --production flag. Exiting..."
            exit 1
        fi
    fi
fi

# Display build configuration
echo "Title: ${RELEASE_OS_TITLE}";
echo "SmartDock: ${USE_SMARTDOCK}";
echo "SmartDockB: ${USE_SMARTDOCK_B}";
echo "Kiosk Launcher: ${USE_BLISS_KIOSK_LAUNCHER}";
echo "FossApps: ${USE_FOSSAPPS}";
echo "BlissBuildVariant: ${BLISS_BUILD_VARIANT}";
echo "IsGoVersion: ${IS_GO_VERSION}";
echo "SuperVanilla: ${BLISS_SUPER_VANILLA}";
echo "RemoveUserTools: ${BLISS_REMOVE_USER_TOOLS}";
echo "ViaBrowser: ${BLISS_VIA_BROWSER}";
echo "SpecialVariant: ${BLISS_SPECIAL_VARIANT}";
echo "BuildWizard: ${USE_BLISS_SETUPWIZARD}";
echo "IsIntelATOM: ${IS_INTEL_ATOM}";
echo "BlissEthernetManager: ${USE_BLISS_ETHERNET_MANAGER}";
echo "RemoveKsu: ${BLISS_REMOVE_KSU}";
echo "ProductionBuild: ${BLISS_PRODUCTION_BUILD}";
echo "SecureLockdownBuild: ${BLISS_SECURE_LOCKDOWN_BUILD}";
echo "TabletNavigation: ${BLISS_TABLET_NAVIGATION}";
echo "Launcher3TaskbarNavigation: ${BLISS_LAUNCHER3_TASKBAR_NAVIGATION}";
echo "GestureNavigation: ${BLISS_GESTURE_NAVIGATION}";
echo "RestrictedLauncher: ${USE_BLISS_RESTRICTED_LAUNCHER}";
echo "RestrictedLauncherPro: ${USE_BLISS_RESTRICTED_LAUNCHER_PRO}";
echo "GarlicLauncher: ${USE_BLISS_GARLIC_LAUNCHER}";
echo "GenerateManifest: ${GENERATE_MANIFEST}";
echo "GameModeLauncher: ${USE_BLISS_GAME_MODE_LAUNCHER}";
echo "CrossLauncher: ${USE_BLISS_CROSS_LAUNCHER}";
echo "PowerManager: ${USE_BLISS_POWER_MANAGER}";
echo "ClearHotseatFavorites: ${BLISS_CLEAR_HOTSEAT_FAVORITES}";
echo "BuildExtraPackages: ${BUILD_EXTRA_PACKAGES}";
echo "ShowKeyboard: ${USE_SHOW_KEYBOARD}";
echo "AlwaysOnSettings: ${USE_ALWAYS_ON_SETTINGS}";
echo "PerDisplayFocus: ${USE_PER_DISPLAY_FOCUS}";
echo "PerDisplayFocusIME: ${USE_PER_DISPLAY_FOCUS_IME}";
echo "PerDisplayFocusZQYIME: ${USE_PER_DISPLAY_FOCUS_ZQY_IME}";
echo "MousePresentation: ${USE_MOUSE_PRESENTATION}";
echo "ForceNavbarOnSecondaryDisplays: ${FORCE_NAVBAR_ON_SECONDARY_DISPLAYS}";
echo "ForceStatusBarOnSecondaryDisplays: ${FORCE_STATUS_BAR_ON_SECONDARY_DISPLAYS}";
echo "DisableLargeScreenSettings: ${BLISS_DISABLE_LARGE_SCREEN_SETTINGS}";
echo "UseSystemUIRecents: ${BLISS_USE_SYSTEMUI_RECENTS}";
echo "UsePOSTerminalApp: ${USE_POS_TERMINAL_APP}";
echo "ForceRightMouseAsBack: ${FORCE_RIGHT_MOUSE_AS_BACK}";
echo "TargetHasSofFirmware: ${TARGET_HAS_SOF_FIRMWARE}";
echo "TargetHasSileadFirmware: ${TARGET_HAS_SILEAD_FIRMWARE}";
echo "UseTVLauncher: ${USE_BLISS_TV_LAUNCHER}";
echo "UseTitaniusLauncher: ${USE_TITANIUS_LAUNCHER}";
echo "UseGboardPrebuilt: ${USE_GBOARD_PREBUILT}";
echo "UseGboardLitePrebuilt: ${USE_GBOARD_LITE_PREBUILT}";
echo "UseMinimalFossApps: ${USE_MINIMAL_FOSS_APPS}";
echo "DisableDeviceSearch: ${BLISS_DISABLE_DEVICE_SEARCH}";
echo "BuildSecureADB: ${BLISS_BUILD_SECURE_ADB}";
echo "DesktopModeOnSecondaryDisplays: ${USE_DESKTOP_MODE_ON_SECONDARY_DISPLAY}";
echo "GrubCmdlineOptions: ${GRUB_CMDLINE_OPTIONS}";
echo "IncludeAgPrivApps: ${INCLUDE_AGPRIVAPPS}";
echo "BassDoNotClean: ${BASS_DO_NOT_CLEAN}";
echo "BassCheckProjectStatus: ${BASS_CHECK_PROJECT_STATUS}";
echo "UseMinFossAppsWithMicroG: ${USE_MINIMAL_FOSS_APPS_WITH_MICROG}";
echo "UseCalyxMicroG: ${USE_CALYX_MICROG}";
echo "UseAuroraStore: ${USE_AURORA_STORE}";
echo "Ax86StartMenu: ${USE_AX86_STARTMENU}";
# autogenerated echo items go here
echo "Enablecleardwhotseatfavorites: ${BLISS_CLEAR_DW_HOTSEAT}";
echo "UseSystemUIBlureffects: ${BLISS_USE_SYSTEMUI_BLUR}";

jcores=$(nproc --all --ignore=4);
# lunch bliss_x86_64-userdebug && make ${BUILD_EXTRA_PACKAGES} blissify iso_img -j$jcores;
lunch gd_rpi4-userdebug
make images sdcardzip -k || make images sdcardzip -j1

doImageCopy

if [[ "$GENERATE_MANIFEST" = "true" ]]; then
    mkdir -p images/$build_filename/manifest/
    repo manifest -o images/$build_filename/manifest/$build_filename-manifest.xml -r
fi

# Clean up dynamic configs
if [ "$BASS_DO_NOT_CLEAN" != "true" ]; then
    echo "Cleaning up dynamic configs..."
    clean_configs
else
    echo "Skipping cleaning up dynamic configs..."
    echo ""
    echo "Uncommitted changes may be found in the following locations:"
    echo " - bootable/newinstaller"
    echo " - device/generic/common"
    echo " - vendor/$vendor_name"
    echo " - packages/apps/Launcher3"
    echo " - packages/apps/Blissify"
    echo " - kernel"
    echo " - frameworks/base"
fi

if [ "$BASS_CHECK_PROJECT_STATUS" = "true" ]; then
    bass_check_project
else
    echo "Skipping checking project status..."
    echo "You can run (. build/envsetup.sh && bass_check_project) to check project status manually."
fi

echo -e "build files can be found: images/${build_filename}/"
echo -e "revisional manifest can be found: images/${build_filename}/manifest/${build_filename}-manifest.xml"

# count the number of folders in images/
images_count=$(find images/ -mindepth 1 -maxdepth 1 -type d | wc -l)
echo "Number of builds in images/: $images_count"
if [ "$images_count" -gt 5 ]; then
    echo "There are many builds in images/: $images_count"
    # ask if the user wants to remove builds older than the last 5 builds
    read -t 30 -p "Do you want to remove builds older than the last 5 builds? (y/n) " -n 1 -r
    if [[ -z "$REPLY" ]]; then
        REPLY="n"
    fi
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing builds older than the last 5 builds..."
        rm -rf $(find images/ -mindepth 1 -maxdepth 1 -type d -printf '%T+ %p\n' | sort | head -n -5 | awk '{print $2}')
    fi
fi
