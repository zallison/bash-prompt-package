### Tools

_bpp_show_colors () {
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

_bpp_show_prompt() {
    local j
    j=0
    for line in "${BPP[@]}"; do
        echo $j: $line
        j=$[ $j + 1 ];
    done | sed 's/\\\[[^]]*\]/[FMT]/g';
}
