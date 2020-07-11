
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
