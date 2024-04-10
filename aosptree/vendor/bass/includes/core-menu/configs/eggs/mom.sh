#!/usr/bin/env bash
#
#####################################

# Disable unicode.
LC_ALL=C
LANG=C

MSP=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $MSP
source ${MSP}/includes/easybashgui
source ${MSP}/includes/easybashgui.lib
source ${MSP}/includes/common.sh


main() {
    title=$(jq .project ${MSP}/eggs.json)

    name=$(jq '.options.menuEntry[].name' ${MSP}/eggs.json )
    
    while true; do
        clear
        menu ${name}
        answer=$(0< "${dir_tmp}/${file_tmp}" )

        case "$answer" in 
            adapt)
                flagsDialog 0 ;;
            calamares)
                flagsDialog 1;;
            dad)
                flagsDialog $answer;;
            help)
                flagsDialog 3;;
            kill)
                flagsDialog 4;;
            install)
                flagsDialog 5;;
            produce)
                flagsDialog 6;;
            syncfrom)
                flagsDialog 7;;
            syncto)
                flagsDialog 8;;
            status)
                flagsDialog 9;;
            update)
                flagsDialog 10;;
            export)
                submenu 11;;
            tools)
                submenu 12 ;;
            *) #quit and others
                theEnd ;;
        esac
    done

}

################################
function flagsDialog() {
    #filter=".options.menuEntry[$1].flags[].flag"
    #       '.options.menuEntry[]? | select(.name == "'"$i"'") | .flags[].flag' 
    _filter=".options.menuEntry[]? | select(.name == $answer) | .flags[].flag"
    flags=$(jq -r ${_filter} ${MSP}/eggs.json )
    echo "${flags}"
    echo $_filter
    press_a_key_to_continue
}

################################
function submenu() {
    _filter=".options.menuEntry[$1].submenu[$2].name"
    _name=$(jq ${_filter} ${MSP}/eggs.json )
    menu ${_name}
    _answer=$(0< "${dir_tmp}/${file_tmp}" )
    press_a_key_to_continue
}

################################
function press_a_key_to_continue {
   read -rp "Press enter to continue"
}

################################
function theEnd {
   echo "regular exit"
   exit 0
}


main