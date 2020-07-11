#!/bin/bash

#######################
# Bash Prompt Package #
#######################
# Variables
declare -A BPP_OPTIONS
declare -A BPP_ENABLED
declare -A BPP_DATA
declare -A BPP_GLYPHS
declare -A BPP_COLOR
declare -A BPP_BGCOLOR
declare -A BPP_TEXT

# UTF Glyphs

function _bpp_change_glyphs {
    if [ "${BPP_OPTIONS[GLYPH]}" = "utf" ]; then
        BPP_GLYPHS[BOTTOM]="╚"
        BPP_GLYPHS[CLOSE]="❱"
        BPP_GLYPHS[DOWNARROW]="↓"
        BPP_GLYPHS[FILE]="🖺"
        BPP_GLYPHS[FOLDER]="📁"
        BPP_GLYPHS[MAIL]="📧"
        BPP_GLYPHS[MIDDLE]="║"
        BPP_GLYPHS[NBS]=" "
        BPP_GLYPHS[NEWLINE]=$'\n'
        BPP_GLYPHS[OPEN]="❰"
        BPP_GLYPHS[TOP]="╔"
        BPP_GLYPHS[ZAP]="⚡"
    else
        BPP_GLYPHS[BOTTOM]=""
        BPP_GLYPHS[CLOSE]=")"
        BPP_GLYPHS[DOWNARROW]="D"
        BPP_GLYPHS[FILE]="F"
        BPP_GLYPHS[FOLDER]=""
        BPP_GLYPHS[MAIL]="M"
        BPP_GLYPHS[MIDDLE]=""
        BPP_GLYPHS[NBS]=" "
        BPP_GLYPHS[NEWLINE]=$'\n'
        BPP_GLYPHS[OPEN]="("
        BPP_GLYPHS[TOP]=""
        BPP_GLYPHS[ZAP]="Z"
    fi
}

# Colors
function bpp_ps1_escape { echo "\[$*\]"; }
function bpp_mk_prompt_color { bpp_ps1_escape "$(bpp_mk_color $1)"; }
function bpp_mk_color { echo "\033[38;5;${1}m"; }
function bpp_mk_prompt_bgcolor { bpp_ps1_escape "$(bpp_mk_bgcolor $1)"; }
function bpp_mk_bgcolor { echo "\033[48;5;${1}m"; }

# Reset
BPP_COLOR[RESET]=$(bpp_ps1_escape "\033[m")
BPP_COLOR[RESETTERM]="\033[m"

# Options (depends on terminal support)
BPP_COLOR[BOLD]="\[\033[1m\]"
BPP_COLOR[DIM]="\[\033[2m\]"
BPP_COLOR[UNDERLINED]="\[\033[4m\]"
BPP_COLOR[BLINK]="\[\033[7m\]"
BPP_COLOR[INVERT]="\[\033[8m\]"

export BPP_COLOR BPP_BGCOLOR
## Named Colors for 0-15
# Foreground
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
# Term Options
if [[ $TERM = *256* ]]; then
    BPP_COLOR[DECORATION]=${BPP_COLOR[RESET]}$(bpp_mk_prompt_color 25) # blue-ish
    BPP_COLOR[GOOD]="$(bpp_mk_prompt_color 47)" # Bright green
    BPP_COLOR[WARNING]=${BPP_BGCOLOR[DARKGREY]}${BPP_COLOR[BOLD]}${BPP_COLOR[YELLOW]}
    BPP_COLOR[CRITICAL]=${BPP_COLOR[BRIGHTRED]}
    BPP_COLOR[INFO]=${BPP_COLOR[GREY]}
else
    BPP_COLOR[DECORATION]=${BPP_COLOR[RESET]}${BPP_COLOR[CYAN]}
    BPP_COLOR[GOOD]=${BPP_COLOR[BOLD]}${BPP_COLOR[GREEN]}
    BPP_COLOR[WARNING]=${BPP_COLOR[DARKGREY]}${BPP_COLOR[BOLD]}${BPP_COLOR[YELLOW]}
    BPP_COLOR[CRITICAL]=${BPP_COLOR[BRIGHTRED]}
    BPP_COLOR[INFO]=${BPP_COLOR[GREY]}
fi
# BPP Environment Options

# These can be turned off at runtime to disable a running module
BPP_ENABLED[ACPI]=1
BPP_ENABLED[DATE]=1
BPP_ENABLED[DIRINFO]=1
BPP_ENABLED[EMACS]=1
BPP_ENABLED[ERROR]=1
BPP_ENABLED[NOTES]=1
BPP_ENABLED[SET_TITLE]=1
BPP_ENABLED[TEMP]=1
BPP_ENABLED[UPTIME]=1
BPP_ENABLED[USER]=1
BPP_ENABLED[VCS]=1
BPP_ENABLED[VCS_REMOTE]=0
BPP_ENABLED[VCS_TYPE]=0
BPP_ENABLED[VENV]=1

BPP_OPTIONS[ACPI_HIDE_ABOVE]=65
BPP_OPTIONS[DATE_FORMAT]="%I:%M"
BPP_OPTIONS[HOST_LOCAL]=1
BPP_OPTIONS[GLYPH]=${BPP_OPTIONS[GLYPH]-utf}
BPP_OPTIONS[NOTE_FILE]="${HOME}/.bppnotes"
BPP_OPTIONS[NOTE_ON_ENTRY]=1
BPP_OPTIONS[TEMP_CRIT]=65
BPP_OPTIONS[TEMP_WARN]=55
BPP_OPTIONS[TEMP_HIDE_BELOW]=50
BPP_OPTIONS[UPTIME_BLOCK]=0 # A "graph" type display.
BPP_OPTIONS[UPTIME_SEPERATOR]="${BPP_COLOR[RESET]} "
BPP_OPTIONS[USER]="user"
BPP_OPTIONS[VENV_PATHS]="venv env virtual-env .venv .environment environment"
BPP_OPTIONS[VERBOSE_ERROR]=1

BPP_DATA[OLDPWD]=""
# Command to "decorate" text.  By default `bpp_decorate` wraps it in ❰ and ❱
# This is run on each "CMD" entry.
BPP_DATA[DECORATOR]="bpp_decorate" 

# Bash Options
export PROMPT_DIRTRIM=3

####### END SETTINGS #######
### Core System
function bpp_prompt_command {
    BPP_DATA[EXIT_STATUS]=$?
    PS1="${BPP_COLOR[RESET]}"
    max=${#BPP[*]}
    local i=0
    while [ "$i" -le $max ]; do
        module=${BPP[$i]}
        local IFS=" "
        bpp_exec_module $i $module
        i=$(( i + 1 ))
    done
    PS1="${PS1}${BPP_COLOR[RESET]} "
    BPP_DATA[OLDPWD]=$(pwd)
    BPP_DATA[EXIT_STATUS]=""
}
export PROMPT_COMMAND=bpp_prompt_command

function bpp-disable { BPP_ENABLED[$1]=0; }
function bpp-enable  { BPP_ENABLED[$1]=1; }
function bpp-options {
    if [[ $2 ]]; then
        BPP_OPTIONS[$1]=$2;
        case $1 in
            GLYPH*) _bpp_change_glyphs;;
        esac
    else
        echo $1 = ${BPP_OPTIONS[$1]}
    fi
}

function _bpp_options {
    KEYS=$(for i in "${!BPP_OPTIONS[@]}"; do
               echo $i;
           done)
    mapfile -t COMPREPLY < <(compgen -W "$KEYS" "$2")
    return 0
}

function _bpp_enable {
    KEYS=$(for i in "${!BPP_ENABLED[@]}"; do
               if [ ${BPP_ENABLED[$i]} == 0 ]; then
                   echo "$i";
               fi
           done)
    mapfile -t COMPREPLY < <(compgen -W "$KEYS" "$2")
    return 0
}

function _bpp_disable {
    KEYS=$(for i in "${!BPP_ENABLED[@]}"; do
               if [ ${BPP_ENABLED[$i]} == 1 ]; then
                   echo "$i";
               fi
           done)
    mapfile -t COMPREPLY < <(compgen -W "$KEYS" "$2")
    return 0
}

complete -F _bpp_enable bpp-enable
complete -F _bpp_disable bpp-disable
complete -F _bpp_options bpp-options

# Commands:
#   CMD - run command and append result to PS1, with decoration
#   CMDNL - run command and append result to PS1, with decoration, appends a newline
#   EXE - Execute command, but do not add to PS1
#   STR - Insert a string as is, without decoration
#   STRDEC - Insert a string with decoration
#   CMDRAW - Ran a command and insert result without decoration

function bpp_exec_module {
    INDEX=$1
    CMD=$2
    shift;shift
    ARGS=$*
    declare RET=""
    [[ $CMD ]] || return
    case $CMD in
        ## Execute CMD and decorate
        CMD) RET=$(${BPP_DATA[DECORATOR]} $($ARGS));;
        ## Execute CMD and decorate, add a newline if there's any output
        CMDNL) RET=$(${BPP_DATA[DECORATOR]} $($ARGS));
               [ -n "$RET" ] && RET+=${BPP_GLYPHS[NEWLINE]};;
        ## Execute CMD and do not decorator
        CMDRAW) RET=$($ARGS $INDEX);;
        ## Take a string and decorate it
        STRDEC) if [ "$ARGS" ]; then RET=$(${BPP_DATA[DECORATOR]} ${BPP_COLOR[INFO]}$ARGS;);fi;;
        ## A pre-formatted string.
        STR) RET="$ARGS";;
        ## Execute a command but don't append any output to PS1
        EXE) $ARGS;;
        ## NOOP
        NOOP) return;;
        ## Unknown
        *) echo "Unknown: $INDEX $CMD";;
    esac
    PS1+=${RET}${BPP_COLOR[RESET]}
}


### End Core System

### Decorators
function bpp_decorate {
    if [ -z "$*" ]; then return;fi
    echo "${BPP_COLOR[DECORATION]}${BPP_GLYPHS[OPEN]}${BPP_COLOR[RESET]}$*${BPP_COLOR[DECORATION]}${BPP_GLYPHS[CLOSE]}${BPP_COLOR[RESET]}"
}

### End Decorators
### Standard Modules
function bpp_date {
    if [[ ${BPP_ENABLED[DATE]} == 1 ]]; then
        DATE="${BPP_COLOR[INFO]}$(date +${BPP_OPTIONS[DATE_FORMAT]})"
    else
        DATE=""
    fi
    echo $DATE
}

function bpp_uptime {
    local cores
    cores=$(nproc --all)
    UPTIME=""
    if [[ ${BPP_ENABLED[UPTIME]} == 1 ]]; then
        function colorize_load {
            local load color relative_load adjusted_load
            load=$1
            color=${BPP_COLOR[GOOD]}
            # Relative load = (load - #cores) / #cores

            # This accounts for how "bad" the load is.  A load of 8 on a dual
            # core system is a lot worse than a load of 8 on a 64 core system.

            relative_load=$( bc <<< "scale=4; ($load - $cores) / ${cores}" )

            if [[ $(bc <<< "$relative_load > .5") = 1 ]]; then
                color=${BPP_COLOR[WARNING]}
            elif [[ $(bc <<< "$relative_load > 1.1") = 1 ]]; then
                color=${BPP_COLOR[CRITICAL]}
            fi

            if [ ${BPP_OPTIONS[UPTIME_BLOCK]} == 1 ]; then
                echo ${color}$load$(bpp_get_block_height $relative_load)
            else
                echo ${color}$load
            fi
        }

        BPP_OPTIONS[UPTIME_SEPERATOR]=${BPP_OPTIONS[UPTIME_SEPERATOR]:=}
        BPP_OPTIONS[UPTIME_BLOCK]=${BPP_OPTIONS[UPTIME_BLOCK]:=1}

        LOAD=$(uptime| sed 's/.*: //' | sed 's/, / /g')

        for val in $LOAD; do
            UPTIME+="$(colorize_load ${val})${BPP_OPTIONS[UPTIME_SEPERATOR]}"
        done
    fi

    echo $UPTIME
}

function bpp_user_and_host {
    (( BPP_ENABLED[USER] )) || return

    if [ -z "$SSH_CONNECTION" ]; then
        # Local
        HOSTCOLOR=${BPP_COLOR[GOOD]}
    else
        HOSTCOLOR=${BPP_COLOR[WARNING]}
    fi

    if [ -z "$USER" ]; then
        USER=${BPP_OPTIONS[USER]}
    fi

    if [ "$(whoami)" != "root" ]; then
        USERCOLOR=${BPP_COLOR[GOOD]}
    else
        USERCOLOR=${BPP_COLOR[CRITICAL]}
        HOSTCOLOR=${BPP_COLOR[CRITICAL]}
    fi

    if [[ -n "$SSH" || "${BPP_OPTIONS[HOST_LOCAL]}" != "0" ]]; then
        USERatHOST="${USERCOLOR}${USER}${BPP_COLOR[DECORATION]}@${HOSTCOLOR}\h"
    else
        USERatHOST="${USERCOLOR}${USER}"
    fi

    echo $USERatHOST
}

# bpp_error - show the exit code of the last process
declare -a BPP_ERRORS
BPP_ERRORS[1]="General error"
BPP_ERRORS[2]="Missing keyword, command, or permission problem"
BPP_ERRORS[126]="Permission problem or command is not an executable"
BPP_ERRORS[127]="Command not found"
BPP_ERRORS[128]="Invalid argument to exit"
BPP_ERRORS[129]="Fatal error signal 1"
BPP_ERRORS[130]="Terminated by Control-C"
BPP_ERRORS[131]="Fatal error signal 3"
BPP_ERRORS[132]="Fatal error signal 4"
BPP_ERRORS[133]="Fatal error signal 5"
BPP_ERRORS[134]="Fatal error signal 6"
BPP_ERRORS[135]="Fatal error signal 7"
BPP_ERRORS[136]="Fatal error signal 8"
BPP_ERRORS[137]="Fatal error signal 9"

function bpp_error {
    (( BPP_ENABLED[ERROR] )) || return
    (( BPP_DATA[EXIT_STATUS] )) || return

    local ERR=${BPP_DATA[EXIT_STATUS]}
    local EXIT MESSAGE

    if [[ "${BPP_DATA[EXIT_STATUS]}" -gt 255 ]]; then
        MESSAGE="Invalid Exit Status"
    else
        MESSAGE=${BPP_DATA[EXIT_STATUS]}
        (( BPP_OPTIONS[VERBOSE_ERROR] )) && MESSAGE+=" - ${BPP_ERRORS[$ERR]:-Unknown or nonstandard error}"
    fi
    EXIT="${BPP_COLOR[CRITICAL]}error: ${MESSAGE}"

    echo $EXIT
}

function bpp_dirinfo {
    (( BPP_ENABLED[DIRINFO] )) || return

    FILES="$(/bin/ls -F | grep -cv /$)${BPP_COLOR[GOOD]}${BPP_GLYPHS[FILE]}${BPP_COLOR[RESET]}"
    DIRSIZE="$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')"
    DIRS="$(/bin/ls -F | grep -c /$)${BPP_COLOR[GOOD]}${BPP_GLYPHS[FOLDER]}${BPP_COLOR[RESET]}"
    DIRINFO="${FILES} ${DIRS} ${DIRSIZE}"

    echo $DIRINFO
}

function bpp_set_title() {
    (( BPP_ENABLED[SET_TITLE] )) || return

    function set_title {
        if [[ ! -z $TMUX && -z $SSH ]]; then
            tmux rename-window -t${TMUX_PANE} "$*"
        elif [[ $TERM =~ screen ]]; then
            printf "\033k %s \033\\" "$*"
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

function bpp_emacs_ansiterm_path_info() {
    (( BPP_ENABLED[EMACS] )) || return

    local ssh_hostname

    TERM_USER="\033AnSiTu"
    TERM_PATH="\033AnSiTc"
    TERM_HOST="\033AnSiTh"
    SCREEN_START="\033P"
    SCREEN_STOP="\n\033\\"

    if [[ $LC_BPP_HOSTNAME ]]; then
        ssh_hostname=$LC_BPP_HOSTNAME
    else
        ssh_hostname=$(hostname -s)
    fi

    if [[ $TERM =~ "screen" ]]; then
        echo -en "\033P\033AnSiTu" $(whoami)"\n\033\\"
        echo -en "\033P\033AnSiTc" $(pwd)"\n\033\\"
        echo -en "\033P\033AnSiTh" ${ssh_hostname}"\n\033\\"
    else
        echo -e "${TERM_USER}" "${LOGNAME}" # $LOGNAME is more portable than using whoami.
        echo -e "${TERM_PATH}" "$(pwd)"
        echo -e "${TERM_HOST}" "${ssh_hostname}"
    fi
}


function bpp_emacs_vterm_path_info() {
    (( BPP_ENABLED[EMACS] )) || return

    local ssh_hostname

    VTERM_DIRTRACK="51;A"
    function _vterm_printf {
        if [[ "$TMUX" ]]; then
            # tell tmux to pass the escape sequences through
            # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
            printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [[ "${TERM}" =~ "screen" ]]; then
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$1"
        else
            printf "\e]%s\e\\" "$1"
        fi
    }

    function vterm_prompt(){
        _vterm_printf "${VTERM_DIRTRACK}${1}"
    }

    if [[ $LC_BPP_HOSTNAME ]]; then
        ssh_hostname=$LC_BPP_HOSTNAME
    else
        ssh_hostname=$(hostname -s)
    fi

    vterm_prompt "$(whoami)@${ssh_hostname}:$(pwd)"
}

function bpp_acpi {
    (( BPP_ENABLED[ACPI] )) || return
    local ACPI BATTERY_LEVEL CHARGE_STATUS CHARGE_ICON BATTERY_DISP BLOCK
    ACPI=$(acpi 2>/dev/null | head -1 | awk '{print $3 $4}' | tr ,% \ \ )
    BATTERY_LEVEL=${ACPI#* }
    CHARGE_STATUS=${ACPI/ *}
    if [[ ${BPP_OPTIONS[ACPI_HIDE_ABOVE]} &&
              "${BATTERY_LEVEL}" -gt "${BPP_OPTIONS[ACPI_HIDE_ABOVE]}" ]]; then
        return
    fi
    if [ -z $BATTERY_LEVEL ]; then
        BPP_ENABLED[ACPI]=0
        return
    fi
    CHARGE_ICON=""
    BATTERY_DISP=""
    BLOCK=""
    case $CHARGE_STATUS in
        "Discharging") CHARGE_ICON="${BPP_COLOR[WARNING]}${BPP_GLYPHS[DOWNARROW]}${BPP_COLOR[RESET]}";;
        "Charging")    CHARGE_ICON="${BPP_COLOR[GOOD]}${BPP_GLYPHS[ZAP]}${BPP_COLOR[RESET]}";;
        *)           CHARGE_ICON="${BPP_COLOR[GOOD]}$CHARGE_STATUS${BPP_COLOR[RESET]}";;
    esac
    CHARGE_ICON="${CHARGE_ICON}"
    BLOCK=$(bpp_get_block_height $BATTERY_LEVEL)
    case $BATTERY_LEVEL in
        100* | [987654]*) BATTERY_DISP="${BPP_COLOR[GOOD]}";;
        [32]*) BATTERY_DISP="${BPP_COLOR[WARNING]}";;
        *) BATTERY_DISP="${BPP_COLOR[CRITICAL]}";;
    esac
    BATTERY_DISP+="${BLOCK} ${BATTERY_LEVEL}"
    echo "${BATTERY_DISP}${CHARGE_ICON}${BPP_COLOR[RESET]}"
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
    (( BPP_ENABLED[TEMP] )) || return
    local TEMP

    BPP_OPTIONS[TEMP_CRIT]=${BPP_OPTIONS[TEMP_CRIT]:-65}
    BPP_OPTIONS[TEMP_WARN]=${BPP_OPTIONS[TEMP_WARN]:-55}

    if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
        TEMP=$(echo $(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -rn | head -1) 1000 / p | dc)
    else
        BPP_ENABLED[TEMP]=0 # Disable the module
        return
    fi

    if [[ -z $TEMP ]]; then
        # No attempts to get temperature were successful
        return
    fi

    if [[ "$TEMP" -lt "${BPP_OPTIONS[TEMP_HIDE_BELOW]}" ]]; then
        return
    fi

    COLOR=${BPP_COLOR[GOOD]}
    if [ $(echo "$TEMP > ${BPP_OPTIONS[TEMP_CRIT]}" | bc) == 1 ]; then
        COLOR="${BPP_COLOR[CRITICAL]}"
    elif [ $(echo "$TEMP > ${BPP_OPTIONS[TEMP_WARN]}" | bc) == 1 ]; then
        COLOR="${BPP_COLOR[WARNING]}"
    fi
    temp_status="${COLOR}$TEMP°${BPP_COLOR[RESET]}"
    echo $temp_status
}

function bpp_history {
    # Share history with other shells by storing and reloading the
    # history.
    history -a # Store my latest command
    history -n # Get commmands from other shells
}

function bpp-text {
    # bpp-text "Hello World" myvar
    # BPP=( ... CMD bpp-text myvar
    # If no "myvar" is given "text" is used.
    MESSAGE=$1
    KEY=${2:-text}
    BPP_TEXT[$KEY]="$MESSAGE"
}
function bpp-untext {
    KEY=$1
    unset BPP_TEXT[$KEY]
}

function bpp_text {
    KEY=${1:-text}

    TEXT=${BPP_TEXT[$KEY]}

    # Eval any expressions
    if [[ ${TEXT:0:1} == '$' ]]; then
        RES=$(eval echo -n $TEXT)
    else
        RES=$TEXT
    fi

    [[ "${RES}" ]] && \
        echo -n "${BPP_COLOR[INFO]}${RES}"
}
### Prompt Examples

function bpp-simple-prompt {
    BPP=('STR \u@\h:\w\$')
}

function bpp-compact-prompt {
    BPP_DATA[DECORATOR]=bpp_decorate
    BPP_ENABLED[VCS_REMOTE]=0
    export BPP=("EXE bpp_set_title"
                "EXE bpp_history"
                "CMD bpp_vcs"
                "STRDEC \\w"
                "STR \$")
}

function bpp-fancy-prompt {
    BPP_DATA[DECORATOR]=bpp_decorate
    BPP=("EXE bpp_set_title"
         "EXE bpp_history"
         "CMD bpp_error"
         "STR ${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}${BPP_GLYPHS[TOP]} "
         "CMD bpp_user_and_host"
         "CMD bpp_uptime"
         "CMD bpp_acpi"
         "CMD bpp_venv"
         "CMD bpp_cpu_temp"
         "CMD bpp_text top"
         "STR ${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}${BPP_GLYPHS[BOTTOM]}${BPP_COLOR[RESET]}"
         "CMD bpp_text bottom"
         "CMD bpp_vcs"
         "STR ${BPP_COLOR[DECORATION]}${BPP_GLYPHS[OPEN]}${BPP_COLOR[RESET]}\w${BPP_COLOR[DECORATION]}${BPP_GLYPHS[CLOSE]}\$")
}

function bpp-super-git-prompt {
    bpp-fancy-prompt
    BPP[12]=${BPP[11]} # Keep the STR as the last element
    BPP[10]="CMDRAW bpp_super_git"
    BPP[11]="STR \${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}\${BPP_GLYPHS[BOTTOM]}${BPP_COLOR[RESET]}"

}

function bpp_super_git {
    if [ "$(git status 2>&1 >/dev/null)" ]; then
        # Only if we're in a git project
        return
    fi
    if [[ ! $REMOTE ]]; then
        REMOTE=local
    fi
    # Header
    REMOTE=$(git remote)
    COLORED_BRANCH=$(_show_git_status)
    ORIGIN=$(git remote -v | grep ${REMOTE} | head -n1 | awk '{print $2}')

    echo -n ${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}${BPP_GLYPHS[MIDDLE]} branch: ${COLORED_BRANCH}${BPP_GLYPHS[NBS]}
    echo ${BPP_COLOR[DECORATION]}remote: ${BPP_COLOR[WARNING]}${REMOTE}${BPP_COLOR[RESET]}
    echo ${BPP_COLOR[DECORATION]}${BPP_GLYPHS[MIDDLE]} ${REMOTE}: ${BPP_COLOR[WARNING]}${ORIGIN}${BPP_COLOR[RESET]}

    while read STATUS; do
        echo "${BPP_COLOR[DECORATION]}${BPP_GLYPHS[MIDDLE]}${BPP_COLOR[RESET]} ${BPP_GOOD_COLOR}${STATUS}"
    done <<< $(git diff --stat --color)

    while read FILE; do
        if [[ ! -z $FILE ]]; then
            echo "${BPP_COLOR[DECORATION]}${BPP_GLYPHS[MIDDLE]} ${BPP_COLOR[WARNING]}${FILE}"
        fi
    done <<< $(git status --porcelain | grep ^??)
}
function bpp_venv {
    local envpath
    env_path=''
    env_prefix=''
    for P in ${BPP_OPTIONS[VENV_PATHS]}; do
        if [[ -f "./${P}/bin/activate" ]]; then
            env_path="./${P}/bin/activate"
            env_prefix=$P
            break;
        fi
    done

    if [[ ${BPP_ENABLED[VENV]} == 1 ]]; then
        current=$(readlink -f .)
        if [[ $VIRTUAL_ENV ]]; then
            here=$(basename $current)
            there=$(basename $VIRTUAL_ENV)
            if [[ ${current:0:${#VIRTUAL_ENV}} == ${VIRTUAL_ENV} ]]; then
                VENV="${BPP_COLOR[INFO]}venv: ${there}"
            elif [[ ! -z "$env_path" ]]; then
                VENV="${BPP_COLOR[CRITICAL]}venv: ${BPP_COLOR[WARNING]}${there} ${BPP_COLOR[CRITICAL]}vs${BPP_COLOR[WARNING]} $here"
            else
                VENV="${BPP_COLOR[WARNING]}venv: $(basename ${VIRTUAL_ENV})"
            fi
        elif [[ $env_path ]]; then
            VENV="${BPP_COLOR[WARNING]}venv available"
        fi
    fi
    echo $VENV
}

function bpp-venv {
    local ENVPATH
    for P in ${BPP_OPTIONS[VENV_PATHS]}; do
        if [[ -f "./${P}/bin/activate" ]]; then
            ENVPATH="./${P}/bin/activate"
            break
        fi
    done

    function load_env {
        if [[ $ENVPATH ]]; then
            source $ENVPATH;
            export VIRTUAL_ENV=$(readlink -f .)
            echo "Loaded virtual environment: $ENVPATH"
        else
            echo "No virtual environment found"
        fi
    }

    function unload_env {
        if [[ $VIRTUAL_ENV ]]; then
            unset VIRTUAL_ENV
            deactivate
            echo "Unloaded virtual environment: $ENVPATH"
        else
            echo "No virtual environment loaded"
        fi
    }

    function goto_env {
        if [[ $VIRTUAL_ENV ]]; then
            cd $VIRTUAL_ENV || exit
            echo "Returned to virtual environment"
        else
            echo "No virtual environment loaded"
        fi
    }

    case $1 in
        '') if [[ $VIRTUAL_ENV ]]; then unload_env; else load_env;fi;;
        'activate') load_env;;
        'cd') goto_env;;
        'deactivate') unload_env;;
        'disable') unload_env;;
        'go') goto_env;;
        'load') load_env;;
        'return') goto_env;;
        'unload') unload_env;;
        *) _bpp-venv; echo "Unknown action $1, try:${BOLD} ${COMPREPLY[*]} ${RESET}";;
    esac
}
function _bpp-venv {
    COMPREPLY=( $(compgen -W 'activate cd deactivate disable go load return unload' -- $2))
    return 0
}
complete -F _bpp-venv bpp-venv
function bpp_vcs {
    INDEX=$1
    local VCS_TYPE

    if [[ -z "$BPP_ENABLED[VCS]" || ${BPP_ENABLED[VCS]} == 0 ]]; then
        VCS=""
    elif [ -e .svn ] ; then
        VCS=$(bpp_svn)
        VCS_TYPE="svn"
    elif [[ $(git status 2> /dev/null) ]]; then
        VCS=$(bpp_git)
        VCS_TYPE="git"
    fi
    if [[ $VCS ]]; then
        if [[ ${BPP_ENABLED[VCS_TYPE]} == 0 ]]; then
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
            SVN="${BPP_COLOR[DECORATION]}svn:$REFS ${BPP_COLOR[CRITICAL]}m:${MODS}" # Modified
        else
            SVN="${BPP_COLOR[DECORATION]}svn:$REFS"
        fi
    fi
    echo $SVN
}

function bpp_git_shortstat() {
    (( BPP_ENABLED[VCS] == 1)) || return 0
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ "$BRANCH" ]] || return 0

    local STATS MODIFIED INSERTED DELETED TARGET
    TARGET=${1:-}
    STATS=$(git diff --shortstat $TARGET 2> /dev/null)

    local CHANGE_REGEX="([0-9]+) files? changed"
    if [[ $STATS =~ ${CHANGE_REGEX} ]]; then
        MODIFIED="${BASH_REMATCH[1]}"
    fi

    local INSERT_REGEX="([0-9]+) insertion"
    if [[ $STATS =~ ${INSERT_REGEX} ]]; then
        INSERTED="${BASH_REMATCH[1]}"
    fi

    local DELETE_REGEX="([0-9]+) deletion"
    if [[ $STATS =~ ${DELETE_REGEX} ]]; then
        DELETED="${BASH_REMATCH[1]}"
    fi

    if [[ -z "$MODIFIED" ]]; then
        return
    else
        echo "${BPP_COLOR[INFO]}${MODIFIED:-0},${BPP_COLOR[GOOD]}+${INSERTED:-0}${BPP_COLOR[INFO]},${BPP_COLOR[RED]}-${DELETED:-0}"
    fi

}

function bpp_git() {
    (( BPP_ENABLED[VCS] == 1)) || return

    GIT="";
    STATUS=$(bpp_git_status)
    DETAILS=$(bpp_git_shortstat)
    if [[ $DETAILS ]]; then
        STATUS="${STATUS} ${DETAILS}";
    fi
    if [[ ${BPP_ENABLED[VCS_REMOTE]} == 1 ]]; then
        REMOTE=$(git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')
        if [[ ! $REMOTE ]]; then
            REMOTE=local
        fi
        GIT="${BPP_COLOR[RESET]}${BPP_COLOR[INFO]}$REMOTE: $STATUS";
    else
        GIT="${BPP_COLOR[RESET]}$STATUS";
    fi
    echo $GIT
}

BPP_OPTIONS[GIT_STAT_AHEAD]=0
BPP_OPTIONS[GIT_STAT_STAGE]=0
function bpp_git_status() {
    command -v git 2>&1 > /dev/null || return
    local branch flags color
    branch=$(git rev-parse --abbrev-ref HEAD  2>/dev/null)
    if [[ -n "$branch" ]]; then
        git_status=$(git status 2> /dev/null)
        # If nothing changes the color, we can spot unhandled cases.
        color=${BPP_COLOR[INFO]}

        if [[ $(git stash show 2>/dev/null) ]]; then
            flags+="*"
        fi
        if [[ $git_status =~ 'working tree clean' ]]; then
            color=${BPP_COLOR[GOOD]}
        fi
        if [[ $git_status =~ 'Untracked files' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+="U"
        fi
        if [[ $git_status =~ 'Your branch is ahead' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+=">"
            (( BPP_OPTIONS[GIT_STAT_AHEAD] )) && \
                flags+="${BPP_COLOR[RESET]}($(bpp_git_shortstat HEAD~))$color"
        fi
        if [[ $git_status =~ 'Changes to be committed' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+="S"
            (( BPP_OPTIONS[GIT_STAT_STAGE] )) && \
                flags+="${BPP_COLOR[RESET]}($(bpp_git_shortstat --staged))$color"
        fi
        if [[ $git_status =~ 'Changes not staged' ]]; then
            color=${BPP_COLOR[WARNING]}
        fi
        if [[ $git_status =~ 'Changed but not updated' ||
                  $git_status =~ 'Unmerged paths' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+="!"
        fi
        if [[ $git_status =~ 'Your branch'.+diverged ]]; then
            color=${BPP_COLOR[CRITICAL]}
            flags+="{"
        fi
        if [[ $git_status =~ 'Your branch is behind' ]]; then
            color=${BPP_COLOR[CRITICAL]}
            flags+="<"
        fi

        if [[ -n "${flags}" ]]; then
            flags=":${flags}"
        fi
        echo -n "${color}${branch}${flags}${BPP_COLOR[RESET]}"
    fi
    return 0
}
### Tools

function bpp-show-colors {
    local ROWS=${1:-4}
    ## Show the 256 (we hope) colors available.
    for x in $(seq 0 255); do
        col=$(printf "%03d" $x)
        echo -ne "$(bpp_mk_color $x)Color ${col} $(bpp_mk_bgcolor $col)  "\
             "$(bpp_mk_color 0)${col}$(bpp_mk_color $x)34${RESET}\t"
        if [ $[ $x % ${ROWS} ] == 0 ] ; then
            echo
        fi
    done
}

function bpp-show-prompt {
    local j
    j=0
    for line in "${BPP[@]}"; do
        echo $j: $line
        j=$[ $j + 1 ];
    done | sed 's/\\\[[^]]*\]/[FMT]/g'
}

declare -A BPP_NOTES
if [[ "$BPP_NOTE" == 1 || -z "$BPP_NOTE" ]]; then
    if [ -f "${BPP_OPTIONS[NOTE_FILE]}" ]; then
        source "${BPP_OPTIONS[NOTE_FILE]}"
        export BPP_NOTES
    fi
fi

function bpp_note {
    local PWD
    PWD=$(pwd)
    if [[ "$BPP_ENABLED[NOTE]" == 0 ]]; then
        return
    fi

    if [[ "${BPP_DATA[OLDPWD]}" == "$PWD" ]]; then
        if [ "${BPP_OPTIONS[NOTE_ON_ENTRY]}" == "1" ]; then
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
        echo -n "${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}${BPP_GLYPHS[MIDDLE]} * ${BPP_COLOR[WARNING]}${LINE}"
    done <<< $(echo "$NOTE")
}

function bpp-note {
    local MESSAGE=$1
    local DIR=${2:-$(pwd)}
    BPP_NOTES[$DIR]=$MESSAGE
    BPP_DATA[OLDPWD]=""
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
    unset BPP_DATA[OLDPWD]
    _bpp_note_save
}

alias note=_bpp_note
alias noteadd=_bpp_note_add

function _bpp_note_save {
    declare -p BPP_NOTES > ${BPP_OPTIONS[NOTE_FILE]}
}
