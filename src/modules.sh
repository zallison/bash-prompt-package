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
    UPTIME=""
    if [[ ${BPP_ENABLED[UPTIME]} == 1 ]]; then
	BPP_OPTIONS[UPTIME_SEPERATOR]=${BPP_OPTIONS[UPTIME_SEPERATOR]:=}
	BPP_OPTIONS[UPTIME_BLOCK]=${BPP_OPTIONS[UPTIME_BLOCK]:=1}
	function colorize {
	    uptime=$1
	    cores=$(nproc --all)
	    color=""
	    relative_load=$(echo "5k 125 ${uptime} ${cores} / *p" | dc)
	    case $relative_load in
		[456]?.*) color=${BPP_COLOR[WARNING]};;
		0* | .* | [0-9].* | [0123]?.*) color=${BPP_COLOR[GOOD]};;
		*) color=${BPP_COLOR[CRITICAL]};;
	    esac
	    if [ ${BPP_OPTIONS[UPTIME_BLOCK]} == 1 ]; then
		echo ${color}$uptime$(bpp_get_block_height $relative_load)
	    else
		echo ${color}$uptime
	    fi
	}

	LOAD=$(uptime| sed 's/.*: //' | sed 's/, / /g')

	for val in $LOAD; do
	    UPTIME+="$(colorize ${val})${BPP_OPTIONS[UPTIME_SEPERATOR]}"
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
    local EXIT

    if [[ "${BPP_DATA[EXIT_STATUS]}" -gt 255 ]]; then
	EXIT="${BPP_COLOR[CRITICAL]}❌ [err: Invalid Exit Status ${ERR}] ❌${WHITE}"
    else
	local MESSAGE
	(( BPP_OPTIONS[VERBOSE_ERROR] )) && MESSAGE=" - ${BPP_ERRORS[$ERR]}"
	EXIT="${BPP_COLOR[CRITICAL]}❌ [err: ${BPP_DATA[EXIT_STATUS]}] ${MESSAGE} ❌${WHITE}"
    fi

    echo $EXIT
}

function bpp_dirinfo {
    if [[ ${BPP_ENABLED[DIRINFO]} == 1 ]]; then
	FILES="$(/bin/ls -F | grep -cv /$)${BPP_COLOR[GOOD]}🖺${BPP_COLOR[RESET]}"
	DIRSIZE="$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')"
	DIRS="$(/bin/ls -F | grep -c /$)${BPP_COLOR[GOOD]}📁${BPP_COLOR[RESET]}"
	DIRINFO="${FILES} ${DIRS} ${DIRSIZE}"
    else
	DIRINFO=""
    fi

    echo $DIRINFO
}

function bpp_set_title() {
    function set_title {
	if [[ -z ${BPP_ENABLED[SET_TITLE]} || ${BPP_ENABLED[SET_TITLE]} != 0 ]]; then
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
    if [ "${BPP_ENABLED[EMACS]}" -eq "0" ]; then
	return
    fi
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
	100* | [98765]*) BATTERY_DISP="${BPP_COLOR[GOOD]}";;
	[432]*) BATTERY_DISP="${BPP_COLOR[WARNING]}";;
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
    if [ -z $2 ]; then
	KEY=text
    fi
    if [ "${BPP_TEXT[$KEY]}" ]; then
	echo "${BPP_COLOR[INFO]}${BPP_TEXT[$KEY]}"
    fi
}
