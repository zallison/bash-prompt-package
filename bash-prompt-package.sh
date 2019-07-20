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
BPP_GLYPHS[NEWLINE]=$'\n'
BPP_GLYPHS[NBS]=" "
BPP_GLYPHS[ZAP]="⚡"
BPP_GLYPHS[DOWNARROW]="↓"
BPP_GLYPHS[TOP]="╔"
BPP_GLYPHS[MIDDLE]="║"
BPP_GLYPHS[BOTTOM]="╚"
BPP_GLYPHS[OPEN]="❰"
BPP_GLYPHS[CLOSE]="❱"

# Colors
function bpp_ps1_escape { echo "\[$*\]"; }
function bpp_mk_prompt_color { bpp_ps1_escape "$(bpp_mk_color $1)"; }
function bpp_mk_color { echo "\033[38;5;${1}m"; }
function bpp_mk_prompt_bgcolor { bpp_ps1_escape "$(bpp_mk_bgcolor $1)"; }
function bpp_mk_bgcolor { echo "\033[48;5;${1}m"; }

# Reset
BPP_COLOR[RESET]=$(bpp_ps1_escape "\033[m")

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
BPP_ENABLED[USER]=1
BPP_ENABLED[UPTIME]=1
BPP_ENABLED[DATE]=1
BPP_ENABLED[TEMP]=1
BPP_ENABLED[DIRINFO]=1
BPP_ENABLED[VCS]=1
BPP_ENABLED[VCS_REMOTE]=0
BPP_ENABLED[VCS_TYPE]=0
BPP_ENABLED[VENV]=1
BPP_ENABLED[ERROR]=1
BPP_ENABLED[ACPI]=1
BPP_ENABLED[SET_TITLE]=1
BPP_ENABLED[EMACS]=1

BPP_OPTIONS[UPTIME_BLOCK]=0 # A "graph" type display.
BPP_OPTIONS[UPTIME_SEPERATOR]="${BPP_COLOR[RESET]} "
BPP_OPTIONS[USER]="user"
BPP_OPTIONS[DATE_FORMAT]="%I:%M"
BPP_OPTIONS[VENV_PATHS]="venv env virtual-env .venv .environment environment"
BPP_OPTIONS[NOTE_ON_ENTRY]=1
BPP_OPTIONS[NOTE_FILE]="${HOME}/.bppnotes"

BPP_DATA[OLDPWD]=""
BPP_DATA[DECORATOR]="bpp_decorate" # Command to "decorate" text.  By
				   # default wraps it in ❰ and ❱

BPP_DATA[DECORATOR]=bpp_decorate

# Bash Options
export PROMPT_DIRTRIM=3

####### END SETTINGS #######
### Core System

function prompt_command {
    BPP_DATA[EXIT_STATUS]=$?
    PS1="${BPP_COLOR[RESET]}"
    for ((i=0; i<${#BPP[*]}; i++)); do
	module=${BPP[$i]}
	local IFS=" "
	bpp_exec_module $i $module
    done
    PS1="${PS1}${BPP_COLOR[RESET]} "
    BPP_DATA[OLDPWD]=$(pwd)
}
export PROMPT_COMMAND=prompt_command



# Commands:
#   CMD - run command and append result to PS1, with decoration
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
    case $CMD in
	CMD) RET=$(${BPP_DATA[DECORATOR]} $($ARGS $INDEX));;
	CMDRAW) RET=$($ARGS $INDEX);;
	STRDEC) if [ "$ARGS" ]; then RET=$(${BPP_DATA[DECORATOR]} ${BPP_COLOR[INFO]}$ARGS;);fi;;
	STR) RET="$ARGS";;
	EXE) $ARGS;;
	FILE) RET=$(${BPP_DATA[DECORATOR]} "$(head -1 $2)");;
	NOOP) return;;
	*) echo "Unknown: $CMD"
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
    if [ -z "$SSH_CONNECTION" ]; then
	# Local
	HOSTCOLOR=${BPP_COLOR[GOOD]}
    else
	HOSTCOLOR=${BPP_COLOR[WARNING]}
    fi
    if [[ ${BPP_ENABLED[USER]} == 1 ]]; then
	if [ -z "$USER" ]; then
	    USER=${BPP_OPTIONS[USER]}
	fi
	if [ "$(whoami)" != "root" ]; then
	    USERCOLOR=${BPP_COLOR[GOOD]}
	else
	    USERCOLOR=${BPP_COLOR[CRITICAL]}
	    HOSTCOLOR=${BPP_COLOR[CRITICAL]}
	fi

	USERatHOST="${USERCOLOR}${USER}${BPP_COLOR[DECORATION]}@${HOSTCOLOR}\h"
    else
	USERatHOST=""
    fi
    echo $USERatHOST
}

function bpp_error {
    if [[ "${BPP_ENABLED[ERROR]}" -eq "1" ]]; then
	if [[ "${BPP_DATA[EXIT_STATUS]}" -eq "0" || "${BPP_DATA[EXIT_STATUS]}" == "130" ]]; then
	    EXIT=""
	else
	    EXIT="${BPP_COLOR[CRITICAL]}❌ [err: ${BPP_DATA[EXIT_STATUS]}] ❌${WHITE}"
	fi
    else
	EXIT=""
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
    if [[ ! -z "$BPP_ENABLED[ACPI]" && ${BPP_ENABLED[ACPI]} != 0 ]]; then
	ACPI=$(acpi 2>/dev/null | head -1 | awk '{print $3 $4}' | tr ,% \ \ )
	BATTERY_LEVEL=${ACPI#* }
	CHARGE_STATUS=${ACPI/ *}
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
    if [[ ! -z "$BPP_ENABLED[TEMP]" && ${BPP_ENABLED[TEMP]} != 0 ]]; then

	BPP_OPTIONS[TEMP_CRIT]=${BPP_OPTIONS[TEMP_CRIT]:-65}
	BPP_OPTIONS[TEMP_WARN]=${BPP_OPTIONS[TEMP_WARN]:-55}

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

	COLOR=${BPP_COLOR[GOOD]}
	if [ $(echo "$TEMP > ${BPP_OPTIONS[TEMP_CRIT]}" | bc) == 1 ]; then
	    COLOR="${BPP_COLOR[CRITICAL]}"
	elif [ $(echo "$TEMP > ${BPP_OPTIONS[TEMP_WARN]}" | bc) == 1 ]; then
	    COLOR="${BPP_COLOR[WARNING]}"
	fi
	temp_status="${COLOR}$TEMP°${BPP_COLOR[RESET]}"
	echo $temp_status
    fi
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
	 "STR ${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}${BPP_GLYPHS[BOTTOM]}${BPP_COLOR[RESET]}"
	 "CMD bpp_vcs"
	 "STR ${BPP_COLOR[DECORATION]}${BPP_GLYPHS[OPEN]}${BPP_COLOR[RESET]}\w${BPP_COLOR[DECORATION]}${BPP_GLYPHS[CLOSE]}\$")
}

function bpp-super-git-prompt {
    bpp-fancy-prompt
    BPP[13]=${BPP[11]} # Keep the STR as the last element
    BPP[10]="STR \${BPP_GLYPHS[NEWLINE]}"
    BPP[11]="CMDRAW bpp_super_git"
    BPP[12]="STR \${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}\${BPP_GLYPHS[BOTTOM]}${BPP_COLOR[RESET]}"
    BPP[13]="STR ${BPP_COLOR[DECORATION]}\${BPP_GLYPHS[OPEN]}${BPP_COLOR[RESET]}\w${BPP_COLOR[DECORATION]}\${BPP_GLYPHS[CLOSE]}\$"
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

    echo -n ${BPP_COLOR[DECORATION]}${BPP_GLYPHS[MIDDLE]} branch: ${COLORED_BRANCH}${BPP_GLYPHS[NBS]}
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
	    if [[ ${current} == ${VIRTUAL_ENV} ]]; then
		VENV="${BLUE}venv: ${here}"
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
	    SVN="${BLUE}svn:$REFS ${BPP_COLOR[CRITICAL]}m:${MODS}" # Modified
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
    if [[ ${BPP_ENABLED[VCS_REMOTE]} == 1 ]]; then
	GIT="${BPP_COLOR[RESET]}$REMOTE: $STATUS";
    else
	GIT="${BPP_COLOR[RESET]}$STATUS";
    fi
    echo $GIT
}

function _show_git_status() {
    # Get the current git branch and colorize to indicate branch state
    # branch_name+ indicates there are stash(es)
    # branch_name? indicates there are untracked files
    # branch_name! indicates your branches have diverged
    local unknown untracked stash clean ahead behind staged dirty diverged
    unknown=${BPP_COLOR[GOOD]}
    untracked=${BPP_COLOR[GOOD]}
    stash=${BPP_COLOR[GOOD]}
    clean=${BPP_COLOR[GOOD]}
    ahead=${BPP_COLOR[WARNING]}
    behind=${BPP_COLOR[WARNING]}
    staged=${UNDERLINED}${BPP_COLOR[WARNING]}
    dirty=${BPP_COLOR[WARNING]}
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
	    echo -n "${color}${branch}${BPP_COLOR[RESET]}"
	fi
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
    if [[ ! -z "$BPP_NOTE" && "$BPP_NOTE" == 0 ]]; then
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
    BPP_DATA[OLDPWD]
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
