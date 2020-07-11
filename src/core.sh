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
