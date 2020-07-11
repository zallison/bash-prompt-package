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
