# UTF Glyphs
utf8_p() {
    [[ BPP_OPTIONS["ASSUME_UTF8"] == 1 ]] && return 1
    local pos col result get_pos pause clear_results
    clear_results=1 # Move to front of line, print spaces, move back to the
                    # front of the line.  Like we never did anything!

    pause=0         # Seconds to pause to allows the result to be read (if using
                    # clear_results)

    get_pos="\033[6n" # Term escape code to ask for position
    result=0 # Assume ANSI.

    old_settings=$(stty -g) # Save terminal settings
    stty -icanon -echo min 0 time 3
    ## icanon: enable special characters: erase, kill, werase, rprnt
    ## -echo: echo input
    ##

    # Print the test on a single line, but not the top line
    echo
    echo -n "Unicode test: "
    echo -n "€❱❰╔╚"  # Unicode test characters
    echo -en "${get_pos}"  # ask the terminal for the position

    # response: ^[v;hR  - i.e cursor at row v, col h

    pos=$(dd count=1 2>/dev/null) # Read response
    pos=${pos%%R*}                # Remove "Junk"
    pos=${pos##*\[}               #
    col=${pos##*;}                # Get the column number
    # row=${pos%%;*}  - unused -  # Get the row number

    stty "$old_settings" # Reset Term

    if [[ ${col} == "20" ]]; then
        result=1 # UTF8 Output successful
        echo -n " ... UTF8"
    elif [[ ${col} == "30" ]]; then
        echo -n "  ... ANSI." : # Only uses ASCII
    else
        echo "bpp: unknown text type \"${col}\"" >&2 # Unexpected value
    fi

    # Maybe pause so results can be read
    [[ ${clear_results} == 1  && ${pause} != 0 ]] && sleep ${pause}

    # Erase line
    echo -ne "\r                                        \r"

    return ${result}
}

if [[ ! "${UTF8_STATUS}" ]]; then
    declare -a status_map
    status_map[0]=FAILED
    status_map[1]=ENABLED

    if utf8_p; then
        UTF8_STATUS=1
    else
        UTF8_STATUS=0
    fi

    declare -x UTF8_STATUS=${status_map[$res]}
fi

_bpp_change_glyphs() {
    if [[ "${BPP_OPTIONS[GLYPH]}" = "utf" && ${UTF8_STATUS} == "ENABLED"  ]]; then
        BPP_GLYPHS[BOTTOM]="╚"
        BPP_GLYPHS[OPEN]="❰"
        BPP_GLYPHS[CLOSE]="❱"
        BPP_GLYPHS[DOWNARROW]="↓"
        BPP_GLYPHS[FILE]="💾"
        BPP_GLYPHS[FOLDER]="📂"
        BPP_GLYPHS[MAIL]="📬"
        BPP_GLYPHS[MIDDLE]="║"
        BPP_GLYPHS[NBS]=" " # Non-breaking space
        BPP_GLYPHS[NEWLINE]=$'\n'
        BPP_GLYPHS[TOP]="╔"
        BPP_GLYPHS[ZAP]="⚡"
    else
        BPP_GLYPHS[BOTTOM]=""
        BPP_GLYPHS[CLOSE]=")"
        BPP_GLYPHS[DOWNARROW]="↓"
        BPP_GLYPHS[FILE]="f"
        BPP_GLYPHS[FOLDER]="F"
        BPP_GLYPHS[MAIL]="Mail"
        BPP_GLYPHS[MIDDLE]=""
        BPP_GLYPHS[NBS]=" " # Non-breaking space
        BPP_GLYPHS[NEWLINE]=$'\n'
        BPP_GLYPHS[OPEN]="("
        BPP_GLYPHS[TOP]=""
        BPP_GLYPHS[ZAP]="Z"
    fi

    export BPP_GLYPHS;
}
