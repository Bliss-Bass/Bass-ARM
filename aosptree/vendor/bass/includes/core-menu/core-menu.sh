#!/bin/bash
set -e

# Start heading
EASYLEGACY="false"
OCONFIG=""

arg0=$(basename "$0" .sh)
blnk=$(echo "$arg0" | sed 's/./ /g')

usage_info()
{
    echo "Usage: $arg0 [-l|--legacy] type"
    echo "       $blnk [{-c|--config} config_location] "
    echo "       $blnk [-d|--debug]"
    echo "       $blnk [-h|--help]"
}

usage()
{
    exec 1>2   # Send standard output to standard error
    usage_info
    continue 2
}

error()
{
    echo "$arg0: $*" >&2
    exit 1
}

help()
{
    usage_info
    echo
    echo "  {-l|--legacy} type              -- launch for legacy menu control (possible values: yad, gtkdialog, kdialog, zenity, Xdialog, dialog, none. default: auto select)"
    echo "  {-h|--help}                     -- print this help message and exit"
    echo "  {-d|--debug}                     -- prints verbose info for debugging"
    echo "  {-c|--config} config_location   -- set custom config location (default: ./options/options.json)"
    [[ $_ != $0 ]] && exit 0 2>/dev/null || return 0 2>/dev/null;

}

flags()
{
    while test $# -gt 0
    do
        case "$1" in
        (-l|--legacy)
            shift
            [ $# = 0 ] && OCTYPE="" || OCTYPE="$1"
            EASYLEGACY="true"
            shift;;
        (-c|--config)
            shift
            [ $# = 0 ] && error "No config specified"
            OCONFIG="$1"
            shift;;
        (-d|--debug)
            echo "Debug Mode Enabled"
            EZ_DEBUG_MODE="true"
            shift;;
        (-h|--help)
            help ;;
        (*) usage;;
        esac
    done
}

flags "$@"

# End heading

SCRIPT_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
MAIN_SCRIPT_PATH=$SCRIPT_PATH
INCLDIR=$MAIN_SCRIPT_PATH/includes
optionspath=$MAIN_SCRIPT_PATH/options
temp_path="$MAIN_SCRIPT_PATH/tmp/"

export SCRIPT_PATH="$SCRIPT_PATH"
export supertitle="Start Menu"
export supericon=""
source $INCLDIR/common.sh

function goto
{
    label=$1
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | 
          grep -v ':$')
    eval "$cmd"
    exit
}

menuParse() {
  # Root Menu:
  # (jq -r '.options.menuEntry[]? | .name' $options_path)
  # First Child Menu:
  # (jq -r '.options.menuEntry[]? | select(.name == "this") | .subMenuEntry[]? | .name' $options_path)
  # First Child Dependency:
  # (jq -r '.options.menuEntry[]? | select(.name == "this") | .dependencies[]? | .dep' $options_path)

  # We will keep the base address static
  BASE_ENTRY=".options"

  # Define MENUENTRY if not passed ($1)
  if [ ! "$1" ]; then
    MENUENTRY=".menuEntry[]?"
  else
    MENUENTRY="$1"
  fi
  # Define THIS_MENU if not passed ($2)
  if [ ! "$2" ]; then
    THIS_MENU=".name"
  else
    THIS_MENU="$2"
  fi
  LAST_MENUENTRY="$MENUENTRY"
  LAST_MENUNAME="$THIS_MENU"

  current_menuentry="$MENUENTRY"
  current_menu="$THIS_MENU"
  
  if [[ $current_menuentry != $previous_menuentry ]] || [[ $current_menu != $previous_menu ]]; then
    if [[ -n "$previous_menu" ]]; then
      echo "New menu: $previous_menu"
    fi
    echo -e ""
    echo -e "Menu ${BLUE}$current_project${NC}"
    echo -e ""
  else
    current_menuentry="$previous_menuentry"
    current_menu="$previous_menu"
    MENUENTRY="$previous_menuentry"
    THIS_MENU="$previous_menu"
  fi

  # If a third and fourth variables are passed, we use those for a search definition
  # $3 = variable_name
  # $4 = Variable_Value
  if [[ "$3" ]] && [[ "$4" ]]; then
    THIS_SEARCH="select($3 == '"$4"')"
  else
    THIS_SEARCH=""
  fi
  if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
    echo "MENUENTRY: $MENUENTRY"
    echo "THIS_MENU: $THIS_MENU"
    echo "THIS_SEARCH: $THIS_SEARCH"
  fi
  parseMenu(){
    # Parse menu
    MENUOPTIONS=()
    while IFS= read -r entry; do
      if [[ "$EZ_DEBUG_MODE" == "true" ]]; then 
        echo "Parsing Menuoptions Entry: $entry"
      fi
      # Check Dependency Here First
      MENUITEMDEPS=()
      while IFS= read -r menuitem; do
        if [[ "$menuitem" != "" ]]; then
          MENUITEMDEPS+=("$menuitem")
          $menuitem # 2>/dev/null;
          if [ $? -eq 0 ]; then
            if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
              echo "Dependency Passed: $menuitem"
            fi
          else
            if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
              echo "Dependency Falied: $menuitem"
            fi
            smconfigerror="true";
          fi
        else
          MENUITEMDEPS+=("$menuitem")

          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then 
            echo "No dependency found: $entry"
          fi
        fi
        # If dependency passes, add entry
        if [[ ! "$smconfigerror" ]] || [[ "$menuitem" == "" ]]; then

          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then 
            echo "Adding Entry: $entry"
          fi
          MENUOPTIONS+=("$entry")
        fi
        smconfigerror="";
      done < <(jq -r "$BASE_ENTRY$MENUENTRY | select(.name == \"${entry}\") | .dependencies[]?.dep" $options_path)
      if [[ "$MENUITEMDEPS" == "" ]]; then 
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then 
          echo "No deps stated, adding Entry: $entry"
        fi
        MENUOPTIONS+=("$entry")
      fi
    done < <(jq -r "$BASE_ENTRY$MENUENTRY$THIS_MENU" $options_path)
  }
  parseMenu
  while :
    do
    if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
      echo "SUBMENUENTRY: $SUBMENUENTRY"
      echo "MENUENTRY: $MENUENTRY"
      echo "THIS_MENU: $THIS_MENU"
      echo "previous_menuentry: $previous_menuentry"
      echo "previous_menu: $previous_menu"
      echo "current_menuentry: $current_menuentry"
      echo "current_menu: $current_menu"
      echo "initial MENUOPTIONS:"
      echo "${MENUOPTIONS[@]}"
    fi
    if [[ "$SUBMENUENTRY" == "" ]] && [[ "$previous_menuentry" != "" ]]; then
      echo "NEW SUBMENU"
      if [[ "$previous_menuentry" == "$current_menuentry" ]]; then
        MENUENTRY=".menuEntry[]?"
        THIS_MENU=".name"
      else
        MENUENTRY="$previous_menuentry"
        THIS_MENU="$previous_menu"
      fi
      if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
        echo "reparsed MENUENTRY: $MENUENTRY"
        echo "reparsed THIS_MENU: $THIS_MENU"
      fi
      parseMenu
    fi

    menu ".." "${MENUOPTIONS[@]}"
    answer=$(0< "${dir_tmp}/${file_tmp}")
    
    for i in "${MENUOPTIONS[@]}" ; do
      i="$(echo ${i} |  tr -d '\n' | tr -d '\r' | tr -d \")"
      if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "${i}" ]]; then
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "Starting \"${i}\" ..."
        fi
        # Check for Flags here, to see if we need to form any options

        # If Flags, and Command are both present, we find n flags.
        # Command
        # COMMAND=()
        # while IFS= read -r com; do
        #   COMMAND+=("$com")        
        # done < <(jq -r "$BASE_ENTRY$MENUENTRY | select(.name == \"${i}\") | .command" $options_path)
        COMMAND="$(jq -r "$BASE_ENTRY$MENUENTRY | select(.name == \"${i}\") | .command" $options_path)"
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "Command: $COMMAND"
        fi
        # Flags
        FLAGS=()
        while IFS= read -r flag; do
          FLAGS+=("$flag")
        done < <(jq -r "$BASE_ENTRY$MENUENTRY | select(.name == \"${i}\") | .flags[]?.flag" $options_path)
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "FLAGS: ${FLAGS[@]}"
        fi
        if [[ "${FLAGS[@]}" != "" ]]; then
          FLAG_ANSWERS=""
          menu ".." "${FLAGS[@]}"
          answer=$(0< "${dir_tmp}/${file_tmp}")
          for f in "${FLAGS[@]}" ; do
            if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "${f}" ]]; then
              flag_name="$f"
              flag_description="$(jq -r "$BASE_ENTRY$MENUENTRY | select(.name == \"${i}\") | .flags[]? | select(.flag == \"${f}\") | .descr" $options_path)"
              flag_type="$(jq -r "$BASE_ENTRY$MENUENTRY | select(.name == \"${i}\") | .flags[]? | select(.flag == \"${f}\") | .type" $options_path)"

              if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                echo "flag_name: ${flag_name}"
                echo "flag_description: ${flag_description}"
                echo "flag_type: ${flag_type}"
              fi
              
              if [[ "$flag_type" == "boolean" ]]; then
                # Show popup question for bool
                question "$flag_description"
                flag_answer="${?}"
                if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                  echo "flag_answer: ${flag_answer}"
                fi
                if [[ "${flag_answer}" = 0 ]]; then
                  flag_command="$flag_name"
                elif [[ "${flag_answer}" == "1" ]]; then
                  flag_command=""
                fi
              elif [[ "$flag_type" == "string" ]]; then
                # Show popup question for bool
                input "$flag_description"
                flag_answer=$(0< "${dir_tmp}/${file_tmp}" )
                if {[ ${flag_answer} != "" ]}; then
                  flag_command="$flag_name $flag_answer"
                fi
              fi
              FLAG_ANSWERS="${FLAG_ANSWERS} $flag_command"
              if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                echo "flag_command: ${flag_command}"
                echo "FLAG_ANSWERS: ${FLAG_ANSWERS}"
              fi
            fi

            if [[ "${answer}" == ".." ]]; then
              SUBMENUENTRY=""
              THIS_SUBMENU=""
              MENUENTRY=""
              THIS_MENU=""
              if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                echo "Going Back"
              fi
              previous_menuentry="$current_menuentry"
              previous_menu="$current_menu"
              continue 2
            fi

            if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "" ]]; then
              if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
                echo "exiting..."
              fi
              [[ $_ != $0 ]] && exit 0 2>/dev/null || return 0 2>/dev/null;
            fi

          done
          # we parse the command
          PARSED_MENU_OPTION_COMMAND="$COMMAND $FLAG_ANSWERS"
          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
            echo "Parsed flag command: $PARSED_MENU_OPTION_COMMAND"
          fi
        else 
          # we parse the command
          PARSED_MENU_OPTION_COMMAND=$COMMAND
          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
            echo "Parsed command: $PARSED_MENU_OPTION_COMMAND"
          fi
        fi
        if [[ "$PARSED_MENU_OPTION_COMMAND" != "" ]]; then
          $PARSED_MENU_OPTION_COMMAND
        fi
        # Do submenu operation

        SUBMENUOPTIONS=()
        while IFS= read -r option; do
          SUBMENUOPTIONS+=("$option")
        done < <(jq -r "$BASE_ENTRY$MENUENTRY | select(.name == \"${i}\") | .menuEntry[]? | .name" $options_path)
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "SUBMENUOPTIONS: ${SUBMENUOPTIONS[@]}"
        fi
        if [[ "${SUBMENUOPTIONS[@]}" != "" ]]; then
          SUBMENUENTRY="$MENUENTRY | select(.name == \"${i}\") | .menuEntry[]?"
          THIS_SUBMENU=".name"
          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
            echo "SUBMENUENTRY: $SUBMENUENTRY"
            echo "THIS_SUBMENU: $THIS_SUBMENU"
          fi
          previous_menuentry="$current_menuentry"
          previous_menu="$current_menu"
          current_menuentry="$SUBMENUENTRY"
          current_menu="$THIS_SUBMENU"
          return 0
        else
          SUBMENUENTRY=""
          THIS_SUBMENU=""
          MENUENTRY=""
          THIS_MENU=""
          if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
            echo "SUBMENUENTRY: $SUBMENUENTRY"
            echo "THIS_SUBMENU: $THIS_SUBMENU"
          fi
          # goto "$menu"
          return 0
        fi
      fi

      if [[ "${answer}" == ".." ]]; then

        # refactor: let's parce the places to get the parent.

        previous_menuentry="$current_menuentry"
        previous_menu="$current_menu"
        SUBMENUENTRY=""
        THIS_SUBMENU=""
        MENUENTRY="$previous_menuentry"
        THIS_MENU="$previous_menu"
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "Clearing vars and moving back to parent menu"
        fi
        break && break
      fi

      if [[ "$(echo ${answer} |  tr -d '\n' | tr -d '\r')" == "" ]]; then
        if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
          echo "exiting..."
        fi
        [[ $_ != $0 ]] && exit 0 2>/dev/null || return 0 2>/dev/null;
      fi
      
    done
    if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
      echo "Exiting MENUOPTIONS for loop"
    fi
  done
  if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
    echo "Exiting menuParse()"
  fi

}

# if debug or tty, set "supermode" var to "none"
# export supermode="none" && source easybashgui
if [[ "$EASYLEGACY" == "true" ]]; then
  export supermode="$OCTYPE" && source $MAIN_SCRIPT_PATH/includes/easybashgui
else
  export supermode="" && source $MAIN_SCRIPT_PATH/includes/easybashgui
  source $MAIN_SCRIPT_PATH/includes/easybashgui.lib
fi

if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
  export EZ_DEBUG_MODE="true"
else
  export EZ_DEBUG_MODE="false"
fi

# If OCONFIG is not "" then set the options file to the passed location
if [[ "$OCONFIG" != "" ]]; then
  options_path=$OCONFIG
else
# Otherwise, set the options file to the default location
  options_path=$optionspath/options.json
fi

# Detect 32/64 bit host

HOST_ARCH=$(uname -m)
chmod +x $INCLDIR/jq-linux*
if [[ "$HOST_ARCH" == "x86_64" ]]; then
	alias jq=$INCLDIR/jq-linux64
else
	alias jq=$INCLDIR/jq-linux32
fi

# use jq to grab the following variables for the menu options:
#   - option name (string)
#   - if it is a suboption (bool)
#   - command (string)
#   - dependencies (array)

# Do root level menu
if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
  echo
  echo "Running First Menu"
  echo
fi

menuParse

if [[ "$SUBMENUENTRY" != "" ]]; then
  if [[ "$EZ_DEBUG_MODE" == "true" ]]; then
    echo
    echo "Running second Menu"
    echo
  fi
  menuParse "$SUBMENUENTRY" "$THIS_SUBMENU"
fi

clean_temp #(since v.6.X.X this function is no more required if easybashlib is present and then successfully loaded by easybashgui)
