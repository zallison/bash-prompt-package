# UTF Glyphs

utf8_p() {
    local junk pos result get_pos pause clear_results
    clear_results=1 # Move to front of line, print spaces, move back to the
                    # front of the line.  Like we never did anything!

    pause=0         # Time to pause to allows the result to be read (if using
                    # clear_results)

    get_pos="\033[6n" # Term escape code to ask for position
    result=0 #

    # Print the test on a single line
    echo -en "\nUnicode test: "
    echo -en "€❱❰╔╚"  # Unicode test characters
    echo -en ${get_pos}  # ask the terminal for the position
    echo -n " "

    read -t 2 -s -d\[ junk || return 1   # discard the first part of the response
    read -t 2 -s -d R pos    # store the position in bash variable 'foo'
    pos="${pos/*;}"

    result=0 # Assume ANSI
    if [[ ${pos} == "20" ]]; then
        # If we're as position 20 everything rendered correctly
        result=1
    elif [[ ${pos} == "30" ]]; then
        # A term that doesn't support UTF8 comes in at 30.
        :
    else
        # This "shouldn't happen"
        echo Error: ${pos} >&2
    fi

    if [[ ${result} == 1 ]]; then
        echo -n "... UTF8"
    else
        echo -n"   ... ANSI."
    fi

    # Maybe pause so results can be read
    [[ ${clear_results} == 1  && ${pause} != 0 ]] && sleep ${pause}

    # Erase line
    echo -ne "\r                                        \r"

    return ${result}
}

utf8_p
utf8_status=$?

function _bpp_change_glyphs {
    if [[ "${BPP_OPTIONS[GLYPH]}" = "utf" && ${utf8_status} == "1"  ]]; then
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
