### Standard Modules
bpp_date() {
    [[ ${BPP_OPTIONS[DATE]} == 1 ]] || return

    DATE="${BPP_COLOR[INFO]}$(date +${BPP_OPTIONS[DATE_FORMAT]})"
    echo $DATE
}

bpp_uptime() {
    local cores
    cores=$(nproc --all)
    UPTIME=""
    if [[ ${BPP_OPTIONS[UPTIME]} == 1 ]]; then
        local relative_load ignore warn
        warn=.7
        display=.5

        BPP_OPTIONS[UPTIME_SEPERATOR]=${BPP_OPTIONS[UPTIME_SEPERATOR]:=}
        BPP_OPTIONS[UPTIME_BLOCK]=${BPP_OPTIONS[UPTIME_BLOCK]:=1}

        colorize_load() {
            local load color
            load=$1
            color=${BPP_COLOR[GOOD]}
            relative_load=$(echo "scale=4;  $val / ${cores} * 100" | bc)

            if [[ $(echo "$load > ${warn}" | bc) = 1 ]]; then
                color=${BPP_COLOR[WARNING]}
            elif [[ $(echo "$load > 1.1" | bc ) = 1 ]]; then
                color=${BPP_COLOR[CRITICAL]}
            fi

            if [[ ${BPP_OPTIONS[UPTIME_BLOCK]} == 1 ]]; then
                echo ${color}$load$(bpp_get_block_height $relative_load)
            else
                echo ${color}$load
            fi
        }


        load=$(uptime| sed 's/.*: //' | sed 's/, / /g')
        ignore=1
        for val in $load; do
            if [[ $(echo "$val > ${display}" | bc) == 1 ]]; then
                ignore=0
            fi
            UPTIME+="$(colorize_load ${val})${BPP_OPTIONS[UPTIME_SEPERATOR]}"
        done

        [[ $ignore == 0 ]] && echo $UPTIME
    fi

}

bpp_user_and_host() {
    [[ BPP_OPTIONS[USER] ]] || return

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
# BPP_ERRORS[0]="OK Successful termination"
BPP_ERRORS[1]="General Error"
BPP_ERRORS[2]="Missing keyword, command, or permission problem"
BPP_ERRORS[13]="Permission Denied"

BPP_ERRORS[64]="Command line usage error"
BPP_ERRORS[65]="Data format error"
BPP_ERRORS[66]="Cannot open input"
BPP_ERRORS[67]="Addressee unknown"
BPP_ERRORS[68]="Host name unknown"
BPP_ERRORS[69]="Service unavailable"
BPP_ERRORS[70]="Internal software error, Needed file/directory not_found/wrong_contents"
BPP_ERRORS[71]="System error"
BPP_ERRORS[72]="Critical OS file missing"
BPP_ERRORS[73]="Can\'t create (user) output file/directory"
BPP_ERRORS[74]="Input/output error"
BPP_ERRORS[75]="Temp failure; user is invited to retry"
BPP_ERRORS[76]="Remote error in protocol"
BPP_ERRORS[77]="Permission denied"
BPP_ERRORS[78]="Configuration error"

BPP_ERRORS[126]="Command invoked cannot execute"
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
BPP_ERRORS[255]="EXIT_OUT_LIMITS Exit status out of range(0..255)"

bpp_error() {
    local EXIT MESSAGE ERR

    [[ ${BPP_OPTIONS[ERROR]} == 0 ]] && return
    [[ ${BPP_DATA[EXIT_STATUS]} != 0 ]] || return

    ERR=${BPP_DATA[EXIT_STATUS]}

    if [[ "${BPP_DATA[EXIT_STATUS]}" -gt 255 ]]; then
        MESSAGE="Invalid Exit Status"
    else
        MESSAGE=${BPP_DATA[EXIT_STATUS]}
        [[ ${BPP_OPTIONS[VERBOSE_ERROR]} == 1 ]] && MESSAGE+=" - ${BPP_ERRORS[$ERR]:-Unknown or nonstandard error}"
    fi
    EXIT="${BPP_COLOR[CRITICAL]}error: ${MESSAGE}"

    BPP_DATA[EXIT_STATUS]=0

    echo $EXIT
}

bpp_dirinfo() {
    [[ ${BPP_OPTIONS[DIRINFO]} == 1 ]] || return

    FILES="$(/bin/ls -F | grep -cv /$)${BPP_COLOR[GOOD]}${BPP_GLYPHS[FILE]}${BPP_COLOR[RESET]}"
    DIRSIZE="$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')"
    DIRS="$(/bin/ls -F | grep -c /$)${BPP_COLOR[GOOD]}${BPP_GLYPHS[FOLDER]}${BPP_COLOR[RESET]}"
    DIRINFO="${DIRS} ${FILES} ${DIRSIZE}"

    echo $DIRINFO
}

bpp_set_title() {
    [[ BPP_OPTIONS[SET_TITLE] == 1 ]] || return

    set_title() {
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

bpp_emacs_ansiterm_path_info() {
    [[ BPP_OPTIONS[EMACS] == 1 ]] || return

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


bpp_emacs_vterm_path_info() {
    [[ BPP_OPTIONS[EMACS] == 1 ]] || return

    local ssh_hostname

    VTERM_DIRTRACK="51;A"
    _vterm_printf() {
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

    vterm_prompt () {
        _vterm_printf "${VTERM_DIRTRACK}${1}"
    }

    if [[ $LC_BPP_HOSTNAME ]]; then
        ssh_hostname=$LC_BPP_HOSTNAME
    else
        ssh_hostname=$(hostname -s)
    fi

    vterm_prompt "$(whoami)@${ssh_hostname}:$(pwd)"
}

bpp_acpi() {
    [[ ${BPP_OPTIONS[ACPI]} == 1 ]] || return
    local ACPI BATTERY_LEVEL CHARGE_STATUS CHARGE_ICON BATTERY_DISP BLOCK
    ACPI=$(acpi 2>/dev/null | head -1 | awk '{print $3 $4}' | tr ,% \ \ )
    BATTERY_LEVEL=${ACPI#* }
    CHARGE_STATUS=${ACPI/ *}
    if [[ ${BPP_OPTIONS[ACPI_HIDE_ABOVE]} &&
              "${BATTERY_LEVEL}" -gt "${BPP_OPTIONS[ACPI_HIDE_ABOVE]}" ]]; then
        return
    fi
    if [ -z $BATTERY_LEVEL ]; then
        BPP_OPTIONS[ACPI]=0
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

bpp_get_block_height() {
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

# this is bpp, not spp, we use bash functions
# shellcheck disable=SC3043,SC3054, SC3010
bpp_cpu_temp() {
    [[ ${BPP_OPTIONS[TEMP]} == 1 ]] || return
    local TEMP

    BPP_OPTIONS[TEMP_CRIT]=${BPP_OPTIONS[TEMP_CRIT]:-65}
    BPP_OPTIONS[TEMP_WARN]=${BPP_OPTIONS[TEMP_WARN]:-55}

    if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
        TEMP=$(echo $(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -rn | head -1) 1000 / p | dc)
    else
        BPP_OPTIONS[TEMP]=0 # Disable the module
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

bpp_history() {
    # Share history with other shells by storing and reloading the
    # history.
    history -a # Store my latest command
    history -n # Get commmands from other shells
}

bpp_text() {
    # bpp-text "Hello World" myvar
    # BPP=( ... CMD bpp-text myvar
    # If no "myvar" is given "text" is used.
    MESSAGE=$1
    KEY=${2:-text}
    BPP_TEXT[$KEY]="$MESSAGE"
}
alias bpp-text=bpp_text

bpp_untext() {
    KEY=$1
    unset BPP_TEXT[$KEY]
}
alias bpp-text=bpp_untext

bpp_text() {
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
