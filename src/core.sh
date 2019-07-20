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
