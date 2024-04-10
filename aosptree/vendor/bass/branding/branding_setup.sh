# Bass OS branding profile
#
# This is part of the Bliss-Bass vendor template and
# is used to for rebranding and customization project
#
# SPDX-License-Identifier: BSD-3-Clause

# set -e

# save the official lunch command to aosp_lunch() and source it
tmp_lunch=`mktemp`

# grab path for this script
SCRIPT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# define vendor_branding_name as the top directory name
vendor_branding_name=$(basename "$SCRIPT_PATH")

#setup colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
purple=`tput setaf 5`
teal=`tput setaf 6`
light=`tput setaf 7`
dark=`tput setaf 8`
ltred=`tput setaf 9`
ltgreen=`tput setaf 10`
ltyellow=`tput setaf 11`
ltblue=`tput setaf 12`
ltpurple=`tput setaf 13`
CL_CYN=`tput setaf 12`
CL_RST=`tput sgr0`
reset=`tput sgr0`

echo "SCRIPT_PATH: $SCRIPT_PATH"
export PATH="$SCRIPT_PATH/../includes/core-menu/includes/:$PATH"
source $SCRIPT_PATH/../includes/core-menu/includes/easybashgui
source $SCRIPT_PATH/../includes/core-menu/includes/common.sh
export supertitle="Bliss-Bass Vendor Customization"

# Redirect menu function
function menu_redirect()
{
    
    echo -e ""
    echo -e "${ltblue}
██████  ██      ██ ███████ ███████ 
██   ██ ██      ██ ██      ██      
██████  ██      ██ ███████ ███████ 
██   ██ ██      ██      ██      ██ 
██████  ███████ ██ ███████ ███████ 
                                   
                                   
██████   █████  ███████ ███████    
██   ██ ██   ██ ██      ██         
██████  ███████ ███████ ███████    
██   ██ ██   ██      ██      ██    
██████  ██   ██ ███████ ███████   

(BROAD APPARATUS SUPPORT SYSTEM)
    ${CL_RST}"

    # wait 5 seconds for user to press 'm'. If input is 'm', then launch menu function, else continue
    echo -e "${ltgreen}\nPress 'm' followed by return within 5 seconds to launch Bliss-Bass Vendor Customization Menu...${CL_RST}"
    # use read command with timeout of 5 seconds
    read -t 5 -p "Prompt " LAUNCH_MENU
    if [[ $? -gt 128 ]]; then
        echo -e "\nTimeout"
    else 
        if [[ "$LAUNCH_MENU" == "m" ]]; then
            echo "Response = \"$LAUNCH_MENU\"" 
            launch_menu

            # flag to control if we should show the question to run launch_menu again
            reload_flag=true

            while $reload_flag; do
                echo -e "${ltgreen}\nDo you want to run launch_menu again? Press 'y' followed by return within 5 seconds...${CL_RST}"
                read -t 5 -p "Prompt " RELOAD
                if [[ $? -gt 128 ]]; then
                    echo -e "\nTimeout"
                    reload_flag=false
                else
                    if [[ "$RELOAD" == "y" ]]; then
                        echo "Response = \"$RELOAD\""
                        launch_menu
                    else
                        reload_flag=false
                    fi
                fi
            done
        fi
    fi

}

# Copy wallpaper
# copy and replace any image found in vendor/$vendor_branding_name/branding/wallpaper to 
# vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-*
function copy_wallpaper()
{
    if [ -f vendor/$vendor_branding_name/branding/wallpaper/* ]; then
        echo -e "Wallpaper branding found. Updating that now..."
        echo ""
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-hdpi/
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-mdpi/
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-nodpi/
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-xhdpi/
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-xxhdpi/
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-xxxhdpi/
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-sw600dp-nodpi/
        cp -r vendor/$vendor_branding_name/branding/wallpaper/* vendor/$vendor_branding_name/overlay/common/frameworks/base/core/res/res/drawable-sw720dp-nodpi/
        echo -e "Wallpaper branding updated"
    fi
}

function copy_grub_background()
{
    if [ -f vendor/$vendor_branding_name/branding/grub/* ]; then
        echo -e "Grub branding found. Updating that now..."
        echo ""
        cp -r vendor/$vendor_branding_name/branding/grub/*.png bootable/newinstaller/boot/isolinux/android-x86.png
        echo -e "Grub branding updated"
    fi
}

function check_patchsets() 
{
    patchset_type=$1
    local T=$(gettop)
    if [ ! "$T" ]; then
        echo "[lunch] Couldn't locate the top of the tree.  Try setting TOP." >&2
        return
    fi
    # Find the first folder in vendor/$vendor_branding_name/patches/patchsets
    are_patchsets=`ls vendor/$vendor_branding_name/patches/patchsets`
    if [ ! "$are_patchsets" ]; then
        echo "[lunch] No patchsets found"
        return
    else
        echo "[lunch] Patchsets found"
        if [ "$patchset_type" != "" ]; then
            if [ -d vendor/$vendor_branding_name/patches/patchsets-$patchset_type ]; then
                bash vendor/$vendor_branding_name/patches/autopatch.sh vendor/$vendor_branding_name/patches/patchsets-$patchset_type
            else
                echo "No patchsets found for $patchset_type"
            fi
        else
            bash vendor/$vendor_branding_name/patches/autopatch.sh vendor/$vendor_branding_name/patches/patchsets
        fi
    fi
}
