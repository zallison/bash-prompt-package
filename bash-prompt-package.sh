#!/bin/bash

#######################
# Bash Prompt Package #
#######################

# UTF Glyphs
BPP_GLYPHS=()
BPP_NEWLINE=$'\n'
BPP_NBS=" "
BPP_ZAP="⚡"
BPP_DOWNARROW="↓"
BPP_TOP="╔"
BPP_MIDDLE="║"
BPP_BOTTOM="╚"
BPP_OPEN="❰"
BPP_CLOSE="❱"

export BPP_GLYPHS BPP_OPEN BPP_CLOSE
BPP_OLD_PWD=""
BPP_VENV_PATHS="venv env virtual-env .venv .environment environment"
export BPP_VENV_PATHS

# Colors
function bpp_ps1_escape { echo "\[$*\]"; }
function bpp_mk_prompt_color { bpp_ps1_escape "$(bpp_mk_color $1)"; }
function bpp_mk_color { echo "\033[38;5;${1}m"; }
function bpp_mk_prompt_bgcolor { bpp_ps1_escape "$(bpp_mk_bgcolor $1)"; }
function bpp_mk_bgcolor { echo "\033[48;5;${1}m"; }
RESET="\033[m"
BPP_FONT_RESET=$(bpp_ps1_escape $RESET)


# Forground
BPP_COLOR[BLACK]=$(bpp_mk_prompt_color 0)
BPP_COLOR[RED]=$(bpp_mk_prompt_color 1)
BPP_COLOR[GREEN]=$(bpp_mk_prompt_color 2)
BPP_COLOR[ORANGE]=$(bpp_mk_prompt_color 3)
BPP_COLOR[BLUE]=$(bpp_mk_prompt_color 4)
BPP_COLOR[PURPLE]=$(bpp_mk_prompt_color 5)
BPP_COLOR[CYAN]=$(bpp_mk_prompt_color 6)
BPP_COLOR[GREY]=$(bpp_mk_prompt_color 7)
BPP_COLOR[DARKGREY]=$(bpp_mk_prompt_color 8)
BPP_COLOR[BRIGHTRED]=$(bpp_mk_prompt_color 9)
BPP_COLOR[BRIGHTGREEN]=$(bpp_mk_prompt_color 10)
BPP_COLOR[YELLOW]=$(bpp_mk_prompt_color 11)
BPP_COLOR[BRIGHTBLUE]=$(bpp_mk_prompt_color 12)
BPP_COLOR[BRIGHTPURPLE]=$(bpp_mk_prompt_color 13)
BPP_COLOR[BRIGHTCYAN]=$(bpp_mk_prompt_color 14)
BPP_COLOR[WHITE]=$(bpp_mk_prompt_color 15)

# Background
BPP_BGCOLOR[BLACK]=$(bpp_mk_prompt_bgcolor 0)
BPP_BGCOLOR[RED]=$(bpp_mk_prompt_bgcolor 1)
BPP_BGCOLOR[GREEN]=$(bpp_mk_prompt_bgcolor 2)
BPP_BGCOLOR[ORANGE]=$(bpp_mk_prompt_bgcolor 3)
BPP_BGCOLOR[BLUE]=$(bpp_mk_prompt_bgcolor 4)
BPP_BGCOLOR[PURPLE]=$(bpp_mk_prompt_bgcolor 5)
BPP_BGCOLOR[CYAN]=$(bpp_mk_prompt_bgcolor 6)
BPP_BGCOLOR[GREY]=$(bpp_mk_prompt_bgcolor 7)
BPP_BGCOLOR[DARKGREY]=$(bpp_mk_prompt_bgcolor 8)
BPP_BGCOLOR[BRIGHTRED]=$(bpp_mk_prompt_bgcolor 9)
BPP_BGCOLOR[BRIGHTGREEN]=$(bpp_mk_prompt_bgcolor 10)
BPP_BGCOLOR[YELLOW]=$(bpp_mk_prompt_bgcolor 11)
BPP_BGCOLOR[BRIGHTBLUE]=$(bpp_mk_prompt_bgcolor 12)
BPP_BGCOLOR[BRIGHTPURPLE]=$(bpp_mk_prompt_bgcolor 13)
BPP_BGCOLOR[BRIGHTCYAN]=$(bpp_mk_prompt_bgcolor 14)
BPP_BGCOLOR[WHITE]=$(bpp_mk_prompt_bgcolor 15)

# Options (depends on terminal support)
BPP_COLOR[BOLD]="\[\033[1m\]"
BPP_COLOR[DIM]="\[\033[2m\]"
BPP_COLOR[UNDERLINED]="\[\033[4m\]"
BPP_COLOR[BLINK]="\[\033[7m\]"
BPP_COLOR[INVERT]="\[\033[8m\]"

export BPP_COLOR

# Options
if [[ $TERM = *256* ]]; then
    BPP_DECORATION_COLOR=${BPP_FONT_RESET}$(bpp_mk_prompt_color 25) # blue-ish
    BPP_GOOD_COLOR="$(bpp_mk_prompt_color 47)" # Bright green
    BPP_WARNING_COLOR=${BPP_BGCOLOR[DARKGREY]}${BPP_COLOR[BOLD]}${BPP_COLOR[YELLOW]}
    BPP_CRITICAL_COLOR=${BPP_COLOR[BRIGHTRED]}
else
    BPP_DECORATION_COLOR=${BPP_FONT_RESET}${BPP_COLOR[CYAN]}
    BPP_GOOD_COLOR=${BPP_COLOR[BOLD]}${BPP_COLOR[GREEN]}
    BPP_WARNING_COLOR=${BPP_COLOR[DARKGREY]}${BPP_COLOR[BOLD]}${BPP_COLOR[YELLOW]}
    BPP_CRITICAL_COLOR=${BPP_COLOR[BRIGHTRED]}
fi

# Commands:
#   CMD - run command and append result to PS1, with decoration
#   EXE - Execute command, but do not add to PS1
#   STR - Insert a string as is, without decoration
#   STRDEC - Insert a string with decoration
#   CMDRAW - Ran a command and insert result without decoration
export BPP=()

# BPP Environment Options
export BPP_DEFAULT_USER="user"
export BPP_DATE_FORMAT="%I:%M"

# These can be turned off at runtime to disable a running module
export BPP_USER=1
export BPP_UPTIME=1
export BPP_DATE=1
export BPP_TEMP=1
export BPP_DIRINFO=1
export BPP_VCS=1
export BPP_VCS_REMOTE=0
export BPP_VENV=1
export BPP_ERROR=1
export BPP_ACPI=1
export BPP_SET_TITLE=1
export BPP_SEND_EMACS_PATH_INFO=1
export BPP_FAHRENHEIT=0
export BPP_UPTIME_BLOCK=0
export BPP_UPTIME_SEPERATOR="${BPP_FONT_RESET} "
export BPP_VCS_TYPE=0
export BPP_DECORATOR=bpp_decorate
export BPP_IFS=" "
# Bash Options
export PROMPT_DIRTRIM=3

####### END SETTINGS #######

# Global because ugh.
declare EXIT_STATUS

### Core System

function prompt_command {
    EXIT_STATUS=$?
#    local IFS=$BPP_IFS
    PS1="${BPP_FONT_RESET}"
    for ((i=0; i<${#BPP[*]}; i++)); do
        module=${BPP[$i]}
        local IFS=" "
        bpp_exec_module $i $module
    done
    PS1="${PS1}${BPP_FONT_RESET} "
    BPP_OLD_PWD=$(pwd)
}
export PROMPT_COMMAND=prompt_command

function bpp_exec_module {
    INDEX=$1
    CMD=$2
    shift;shift
    ARGS=$*
    declare RET=""
    case $CMD in
        CMD) RET=$($BPP_DECORATOR $($ARGS $INDEX));;
        CMDRAW) RET=$($ARGS $INDEX);;
        STRDEC) RET=$($BPP_DECORATOR "$ARGS");;
        STR) RET=$(echo -e $ARGS);;
        EXE) $ARGS;;
        FILE) RET=$($BPP_DECORATOR "$(head -1 $2)");;
        NOOP) return;;
        *) echo "Unknown: $CMD"
    esac
    PS1+=${RET}${BPP_FONT_RESET}
}

### End Core System

### Decorators
function bpp_decorate {
    if [ -z "$*" ]; then return;fi
    echo "${BPP_DECORATION_COLOR}${BPP_OPEN}${BPP_FONT_RESET}$*${BPP_DECORATION_COLOR}${BPP_CLOSE}${BPP_FONT_RESET}"
}

### End Decorators

### Modules
function bpp_date {
    if [[ ${BPP_DATE} == 1 ]]; then
        DATE="${BPP_COLOR[BLUE]}$(date +${BPP_DATE_FORMAT})"
    else
        DATE=""
    fi
    echo $DATE
}

function bpp_uptime {
    UPTIME=""
    if [[ ${BPP_UPTIME} == 1 ]]; then
        BPP_UPTIME_SEPERATOR=${BPP_UPTIME_SEPERATOR:=}
        BPP_UPTIME_BLOCK=${BPP_UPTIME_BLOCK:=1}
        function colorize {
            uptime=$1
            cores=$(nproc --all)
            color=""
            relative_load=$(echo "5k 125 ${uptime} ${cores} / *p" | dc)
            case $relative_load in
                [456]?.*) color=$BPP_WARNING_COLOR;;
                0* | .* | [0-9].* | [0123]?.*) color=$BPP_GOOD_COLOR;;
                *) color=$BPP_CRITICAL_COLOR;;
            esac
            if [ $BPP_UPTIME_BLOCK == 1 ]; then
                echo ${color}$uptime$(bpp_get_block_height $relative_load)
            else
                echo ${color}$uptime
            fi
        }

        LOAD=$(uptime| sed 's/.*: //' | sed 's/, / /g')

        for val in $LOAD; do
            UPTIME+="$(colorize ${val})${BPP_UPTIME_SEPERATOR}"
        done
    fi

    echo $UPTIME
}

function bpp_user_and_host {
    if [ -z "$SSH_CONNECTION" ]; then
        # Local
        HOSTCOLOR=$BPP_GOOD_COLOR
    else
        HOSTCOLOR=$BPP_WARNING_COLOR
    fi
    if [[ $BPP_USER == 1 ]]; then
        if [ -z "$USER" ]; then
            USER=$BPP_DEFAULT_USER
        fi
        if [ "$(whoami)" != "root" ]; then
            USERCOLOR=$BPP_GOOD_COLOR
        else
            USERCOLOR=$BPP_CRITICAL_COLOR
            HOSTCOLOR=$BPP_CRITICAL_COLOR
        fi

        USERatHOST="${USERCOLOR}${USER}${BPP_DECORATION_COLOR}@${HOSTCOLOR}\h"
    else
        USERatHOST=""
    fi
    echo $USERatHOST
}

function bpp_error {
    if [[ "$BPP_ERROR" == 1 ]]; then
        if [[ "$EXIT_STATUS" -eq "0" || "$EXIT_STATUS" == "130" ]]; then
            EXIT=""
        else
            EXIT="${BPP_CRITICAL_COLOR}❌ [err: $EXIT_STATUS] ❌${WHITE}"
        fi
    else
        EXIT=""
    fi
    echo $EXIT
}

function bpp_venv {
    local VENV here
    local envpath
    env_path=''
    env_prefix=''
    for P in $BPP_VENV_PATHS; do
        if [[ -f "./${P}/bin/activate" ]]; then
            env_path="./${P}/bin/activate"
            env_prefix=$P
            break;
        fi
    done

    if [[ $BPP_VENV == 1 ]]; then
        current=$(readlink -f .)
        if [[ $VIRTUAL_ENV ]]; then
            here=$(basename $current)
            there=$(basename $VIRTUAL_ENV)
            if [[ ${current} == ${VIRTUAL_ENV} ]]; then
                VENV="${BLUE}venv: ${here}"
            elif [[ ! -z "$env_path" ]]; then
                VENV="${BPP_CRITICAL_COLOR}venv: ${BPP_WARNING_COLOR}${there} ${BPP_CRITICAL_COLOR}vs${BPP_WARNING_COLOR} $here"
            else
                VENV="${BPP_WARNING_COLOR}venv: $(basename ${VIRTUAL_ENV})"
            fi
        elif [[ $env_path ]]; then
            VENV="${BPP_WARNING_COLOR}venv available"
        fi
    fi
    echo $VENV
}

function bpp-venv {
    local ENVPATH
    for P in $BPP_VENV_PATHS; do
        if [[ -f "./${P}/bin/activate" ]]; then
            ENVPATH="./${P}/bin/activate"
            break
        fi
    done

    function load_env {
        if [[ $ENVPATH ]]; then
            source $ENVPATH;
            export VIRTUAL_ENV=$(readlink -f .)
        else
            echo "No virtual environment found"
        fi
    }

    function unload_env {
        if [[ $VIRTUAL_ENV ]]; then
            unset VIRTUAL_ENV
            deactivate
        else
            echo "No virtual environment loaded"
        fi

    }

    function goto_env {
        if [[ $VIRTUAL_ENV ]]; then
            cd $VIRTUAL_ENV || exit
        else
            echo "No virtual environment loaded"
        fi
    }

    case $1 in
        '') if [[ $VIRTUAL_ENV ]]; then unload_env; else load_env;fi;;
        'activate') load_env;;
        'disable') unload_env;;
        'deactivate') unload_env;;
        'return') goto_env;;
        'go') goto_env;;
        *) _bpp-venv; echo "Unknown action $1, try: ${COMPREPLY[*]}";;
    esac
}
function _bpp-venv {
    COMPREPLY=( $(compgen -W 'activate deactivate return go disable' -- $2))
    return 0
}
complete -F _bpp-venv bpp-venv

function bpp_vcs {
    INDEX=$1
    local VCS_TYPE

    if [[ -z "$BPP_VCS" || $BPP_VCS == 0 ]]; then
        VCS=""
    elif [ -e .svn ] ; then
        VCS=$(bpp_svn)
        VCS_TYPE="svn"
    elif [[ $(git status 2> /dev/null) ]]; then
        VCS=$(bpp_git)
        VCS_TYPE="git"
    fi
    if [[ $VCS ]]; then
        if [[ $BPP_VCS_TYPE == 0 ]]; then
            VCS="${VCS}"
        else
            VCS="${VCS_TYPE} ${VCS}"
        fi
    fi

    echo ${VCS}
}

function bpp_svn {
    local SVN_STATUS
    SVN_STATUS=$(svn info 2>/dev/null)
    if [[ $SVN_STATUS != "" ]] ; then
        local REFS
        REFS=" $(svn info | grep "Repository Root" | sed 's/.*\///')"
        MODS=$(svn status | sed 's/ .*//' | grep -cE ^"(M|A|D)")
        if [[ ${MODS} != "0" ]] ; then
            SVN="${BLUE}svn:$REFS ${BPP_CRITICAL_COLOR}m:${MODS}" # Modified
        else
            SVN="${BLUE}svn:$REFS"
        fi
    fi
    echo $SVN
}

function bpp_git() {
    REMOTE=$(git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')
    if [[ ! $REMOTE ]]; then
        REMOTE=local
    fi
    STATUS=$(_show_git_status)
    DETAILS=$(git status --porcelain -u -b 2>/dev/null \
                  | awk 'BEGIN {ORS=" "}NR>1{arr[$1]++}END{for (a in arr) print a":", arr[a]}' | sed 's/ $//')
    if [[ $DETAILS ]]; then
        STATUS="${STATUS} ${DETAILS}";
    fi
    if [[ $BPP_VCS_REMOTE == 1 ]]; then
        GIT="${BPP_FONT_RESET}$REMOTE: $STATUS";
    else
        GIT="${BPP_FONT_RESET}$STATUS";
    fi
    echo $GIT
}

function bpp_dirinfo {
    if [[ ${BPP_DIRINFO} == 1 ]]; then
        FILES="$(/bin/ls -F | grep -cv /$) files"
        DIRSIZE="$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')"
        DIRS="$(/bin/ls -F | grep -c /$) dirs"
        DIRINFO="${FILES} - $DIRSIZE - $DIRS"
    else
        DIRINFO=""
    fi

    echo $DIRINFO
}

function bpp_set_title() {
    function set_title {
        if [[ -z $BPP_SET_TITLE || $BPP_SET_TITLE != 0 ]]; then
            if [[ ! -z $TMUX && -z $SSH ]]; then
                tmux rename-window -t${TMUX_PANE} "$*"
            elif [[ $TERM =~ screen ]]; then
                printf "\033k %s \033\\" "$*"
            fi
        fi
    }

    local LENGTH=15
    local tmp="${PWD/#$HOME/\~}"
    tmp=${tmp:${#tmp}<${LENGTH}?0:-${LENGTH}}

    # Set title for xterm / screen / tabs
    if [ -z "$SSH_CONNECTION" ]; then
        # Local
        set_title "${tmp}"
    else
        # ssh
        set_title "${USER}@${HOSTNAME%%.*}:${tmp}"
    fi

}

function bpp_send_emacs_path_info() {
    local ssh_hostname
    local VALIDTERM=0

    if [[ $LC_EMACS ]]; then
        INSIDE_EMACS=1
    fi
    if [[ $LC_BPP_HOSTNAME ]]; then
        ssh_hostname=$LC_BPP_HOSTNAME
    else
        ssh_hostname=$(hostname -s)
    fi
    if [[ $TERM =~ "screen" || $TERM =~ "tmux" ]]; then
        VALIDTERM=1
    fi
    if [[ $VALIDTERM && $INSIDE_EMACS ]]; then
        echo -en "\033P\033AnSiTu" $(whoami)"\n\033\\"
        echo -en "\033P\033AnSiTc" $(pwd)"\n\033\\"
        echo -en "\033P\033AnSiTh" ${ssh_hostname}"\n\033\\"
    elif [[ $TERM =~ "eterm" ]]; then
        echo -e "\033AnSiTu" $(whoami)
        echo -e "\033AnSiTc" $(pwd)
        echo -e "\033AnSiTh" ${ssh_hostname}
    fi
}

function _show_git_status() {
    # Get the current git branch and colorize to indicate branch state
    # branch_name+ indicates there are stash(es)
    # branch_name? indicates there are untracked files
    # branch_name! indicates your branches have diverged
    local unknown untracked stash clean ahead behind staged dirty diverged
    unknown=${BPP_GOOD_COLOR}
    untracked=${BPP_GOOD_COLOR}
    stash=${BPP_GOOD_COLOR}
    clean=${BPP_GOOD_COLOR}
    ahead=${BPP_WARNING_COLOR}
    behind=${BPP_WARNING_COLOR}
    staged=${UNDERLINED}${BPP_WARNING_COLOR}
    dirty=${BPP_WARNING_COLOR}
    diverged=${RED}

    if [ "$(command -v git)" ]; then
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n "$branch" ]]; then
            git_status=$(git status 2> /dev/null)
            # If nothing changes the color, we can spot unhandled cases.
            color=$unknown
            if [[ $git_status =~ 'Untracked files' ]]; then
                color=$untracked
                branch="${branch}?"
            fi
            if git stash show &>/dev/null; then
                color=$stash
                branch="${branch}*"
            fi
            if [[ $git_status =~ 'working directory clean' ]]; then
                color=$clean
            fi
            if [[ $git_status =~ 'Your branch is ahead' ]]; then
                color=$ahead
                branch="${branch}>"
            fi
            if [[ $git_status =~ 'Your branch is behind' ]]; then
                color=$behind
                branch="${branch}<"
            fi
            if [[ $git_status =~ 'Changes to be committed' ]]; then
                color=$staged
            fi
            if [[ $git_status =~ 'Changed but not updated' ||
                      $git_status =~ 'Changes not staged'      ||
                      $git_status =~ 'Unmerged paths' ]]; then
                color=$dirty
            fi
            if [[ $git_status =~ 'Your branch'.+diverged ]]; then
                color=$diverged
                branch="${branch}!"
            fi
            echo -n "${color}${branch}${BPP_FONT_RESET}"
        fi
    fi
    return 0
}

function bpp_acpi {
    if [[ ! -z "$BPP_ACPI" && $BPP_ACPI != 0 ]]; then
        ACPI=$(acpi 2>/dev/null | head -1 | awk '{print $3 $4}' | tr ,% \ \ )
        BATTERY_LEVEL=${ACPI#* }
        CHARGE_STATUS=${ACPI/ *}
        if [ -z $BATTERY_LEVEL ]; then
            BPP_ACPI=0
            return
        fi
        CHARGE_ICON=""
        BATTERY_DISP=""
        BLOCK=""
        case $CHARGE_STATUS in
            "Discharging") CHARGE_ICON="${BPP_WARNING_COLOR}${BPP_DOWNARROW}${BPP_FONT_RESET}";;
            "Charging")    CHARGE_ICON="${BPP_GOOD_COLOR}${BPP_ZAP}${BPP_FONT_RESET}";;
            *)           CHARGE_ICON="${BPP_GOOD_COLOR}$CHARGE_STATUS${BPP_FONT_RESET}";;
        esac
        CHARGE_ICON="${CHARGE_ICON}"
        BLOCK=$(bpp_get_block_height $BATTERY_LEVEL)
        case $BATTERY_LEVEL in
            100* | [98765]*) BATTERY_DISP="${BPP_GOOD_COLOR}";;
            [432]*) BATTERY_DISP="${BPP_WARNING_COLOR}";;
            *) BATTERY_DISP="${BPP_CRITICAL_COLOR}";;
        esac
        BATTERY_DISP+="${BLOCK} ${BATTERY_LEVEL}"
        echo "${BATTERY_DISP}${CHARGE_ICON}${BPP_FONT_RESET}"
    fi
}

function bpp_get_block_height {
    # Make a bar with 0
    height=$1
    BLOCK1="_"
    BLOCK2="▁"
    BLOCK3="▂"
    BLOCK4="▃"
    BLOCK5="▄"
    BLOCK6="▅"
    BLOCK7="▆"
    BLOCK8="▇"
    BLOCK9="█"
    BLOCK=""
    if [ ! -z "$2" ]; then
        # Horizontal
        BLOCK9="█"
        BLOCK8="▉"
        BLOCK7="▊"
        BLOCK6="▋"
        BLOCK5="▋"
        BLOCK4="▌"
        BLOCK3="▍"
        BLOCK2="▎"
        BLOCK1="▏"
    fi
    case $height in
        100*) BLOCK="$BLOCK9";;
        9*) BLOCK="$BLOCK8";;
        8*) BLOCK="$BLOCK7";;
        7*) BLOCK="$BLOCK6";;
        6*) BLOCK="$BLOCK5";;
        5*) BLOCK="$BLOCK4";;
        4*) BLOCK="$BLOCK3";;
        3*) BLOCK="$BLOCK3";;
        2*) BLOCK="$BLOCK2";;
        *) BLOCK="$BLOCK1";;
    esac
    echo "$BLOCK"
}

function bpp_cpu_temp {
    local TEMP
    if [[ ! -z "$BPP_TEMP" && $BPP_TEMP != 0 ]]; then

        BPP_TEMP_CRIT=${BPP_TEMP_CRIT:-55}
        BPP_TEMP_WARNING=${BPP_TEMP_WARNING:-45}

        if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
            TEMP=$(echo $(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -rn | head -1) 1000 / p | dc)
        else
            BPP_TEMP=0 # Disable the module
            return
        fi

        if [[ -z $TEMP ]]; then
            # No attempts to get temperature were successful
            return
        fi

        COLOR=${BPP_GOOD_COLOR}
        if [ $(echo "$TEMP > ${BPP_TEMP_CRIT}" | bc) == 1 ]; then
            COLOR="$BPP_CRITICAL_COLOR"
        elif [ $(echo "$TEMP > ${BPP_TEMP_WARNING}" | bc) == 1 ]; then
            COLOR="$BPP_WARNING_COLOR"
        fi
        temp_status="${COLOR}$TEMP°${BPP_FONT_RESET}"
        echo $temp_status
    fi
}

function bpp_history {
    # Share history with other shells by storing and reloading the
    # history.
    history -a # Store my latest command
    history -n # Get commmands from other shells
}

### Prompt Examples

function bpp-simple-prompt {
    BPP=('STR \u@\h:\w\$${BPP_NBS}')
}

function bpp-compact-prompt {
    export BPP_DECORATOR=bpp_decorate
    export BPP_VCS_REMOTE=0
    export BPP=("EXE bpp_set_title"
                "EXE bpp_send_emacs_path_info"
                "EXE bpp_history"
                "CMD bpp_vcs"
                "STRDEC \\w"
                "STR \$${BPP_NBS}")
}

function bpp-fancy-prompt {
    export BPP_DECORATOR=bpp_decorate
    BPP=("EXE bpp_set_title"
         "EXE bpp_send_emacs_path_info"
         "EXE bpp_history"
         "CMD bpp_error"
         "STR ${BPP_NEWLINE}${BPP_DECORATION_COLOR}${BPP_TOP} "
         "CMD bpp_user_and_host"
         "CMD bpp_uptime"
         "CMD bpp_acpi"
         "CMD bpp_venv"
         "CMD bpp_cpu_temp"
         "STR ${BPP_NEWLINE}${BPP_DECORATION_COLOR}${BPP_BOTTOM}${BPP_FONT_RESET}"
         "CMD bpp_vcs"
         "STR ${BPP_DECORATION_COLOR}${BPP_OPEN}${BPP_FONT_RESET}\w${BPP_DECORATION_COLOR}${BPP_CLOSE}\$${BPP_NBS}")
}

function bpp-super-git-prompt {
    bpp-fancy-prompt
    BPP[13]=${BPP[11]} # Keep the STR as the last element
    BPP[10]="STR ${BPP_NEWLINE}"
    BPP[11]="CMDRAW bpp_super_git"
    BPP[12]="STR ${BPP_NEWLINE}${BPP_DECORATION_COLOR}${BPP_BOTTOM}${BPP_FONT_RESET}"
    BPP[13]="STR ${BPP_DECORATION_COLOR}${BPP_OPEN}${BPP_FONT_RESET}\w${BPP_DECORATION_COLOR}${BPP_CLOSE}\$${BPP_NBS}"
}

function bpp_super_git {
    if [[ ! $REMOTE ]]; then
        REMOTE=local
    fi
    # Header
    REMOTE=$(git remote)
    COLORED_BRANCH=$(_show_git_status)
    ORIGIN=$(git remote -v | grep ${REMOTE} | head -n1 | awk '{print $2}')

    echo -n ${BPP_DECORATION_COLOR}${BPP_MIDDLE} branch: ${COLORED_BRANCH}${BPP_NBS}
    echo ${BPP_DECORATION_COLOR}remote: ${BPP_WARNING_COLOR}${REMOTE}${BPP_FONT_RESET}
    echo ${BPP_DECORATION_COLOR}${BPP_MIDDLE} ${REMOTE}: ${BPP_WARNING_COLOR}${ORIGIN}${BPP_FONT_RESET}

    while read STATUS; do
        echo "${BPP_DECORATION_COLOR}${BPP_MIDDLE}${BPP_FONT_RESET} ${BPP_GOOD_COLOR}${STATUS}"
    done <<< $(git diff --stat --color)

    while read FILE; do
        if [[ ! -z $FILE ]]; then
            echo "${BPP_DECORATION_COLOR}${BPP_MIDDLE} ${BPP_WARNING_COLOR}${FILE}"
        fi
    done <<< $(git status --porcelain | grep ^??)
}

### Tools

function bpp-show-color {
    local ROWS=${1:-4}
    ## Show the 256 (we hope) colors available.
    for x in $(seq 0 255); do
        echo -ne "$(bpp_mk_color $x)Color ${x} $(bpp_mk_bgcolor $x)12"\
             "$(bpp_mk_color 0)${x}$(bpp_mk_color $x)34${RESET}\t"
        if [[ $[ $x % ${ROWS} ] == 0 ]]; then
            echo
        fi
    done
}

function bpp-show-prompt {
    j=0
    for line in "${BPP[@]}"; do
        echo $j: $line
        j=$[ $j + 1 ];
    done
}

### Set prompt based on term size
if [[ $COLUMNS -lt 80 ]]; then
    export BPP_ERROR=0
    if [[ $COLUMNS -lt 40 ]]; then
        bpp-simple-prompt
    else
        bpp-compact-prompt
    fi
else
    bpp-fancy-prompt
fi

### APPENDING BPP_NOTES HERE FOR NOW

declare -A BPP_NOTES
if [[ "$BPP_NOTE" == 1 || -z "$BPP_NOTE" ]]; then
    BPP_NOTE_FILE="${HOME}/.bppnotes"
    if [ -f "${BPP_NOTE_FILE}" ]; then
        source "${BPP_NOTE_FILE}"
        export BPP_NOTES
    fi
fi
BPP_NOTE_ON_ENTRY=1
function bpp_note {
    local PWD
    PWD=$(pwd)
    if [[ ! -z "$BPP_NOTE" && "$BPP_NOTE" == 0 ]]; then
        return
    fi

    if [[ "$BPP_OLD_PWD" == "$PWD" ]]; then
        if [[ "$BPP_NOTE_ON_ENTRY" == 1 ]]; then
            return
        fi
    fi

    BPP_NOTES[PWD]=$PWD
    NOTE="${BPP_NOTES[${PWD}]}"

    if [ -z "$NOTE" ]; then
        return
    fi

    local IFS=$'\n'
    while read LINE; do
        echo -n "${BPP_NEWLINE}${BPP_DECORATION_COLOR}${BPP_MIDDLE} * ${BPP_WARNING_COLOR}${LINE}"
    done <<< $(echo "$NOTE")
}

function bpp-note {
    local MESSAGE=$1
    local DIR=${2:-$(pwd)}
    BPP_NOTES[$DIR]=$MESSAGE
    unset BPP_OLD_PWD
    _bpp_note_save
}
alias _bpp_note=bpp-note

function _bpp_note_add {
    local MESSAGE=$1
    local DIR=${2:-$(pwd)}
    if [ ! -z "${BPP_NOTES[$DIR]}" ]; then
        MESSAGE="${BPP_NOTES[$DIR]}"$'\n'"$MESSAGE"
    fi
    BPP_NOTES[$DIR]=$MESSAGE
    unset BPP_OLD_PWD
    _bpp_note_save
}

alias note=_bpp_note
alias noteadd=_bpp_note_add

function _bpp_note_save {
    declare -p BPP_NOTES > ${BPP_NOTE_FILE}
}
