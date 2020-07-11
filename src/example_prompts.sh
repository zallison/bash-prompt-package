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
         "CMD bpp_text top"
         "STR ${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}${BPP_GLYPHS[BOTTOM]}${BPP_COLOR[RESET]}"
         "CMD bpp_text bottom"
         "CMD bpp_vcs"
         "STR ${BPP_COLOR[DECORATION]}${BPP_GLYPHS[OPEN]}${BPP_COLOR[RESET]}\w${BPP_COLOR[DECORATION]}${BPP_GLYPHS[CLOSE]}\$")
}

function bpp-super-git-prompt {
    bpp-fancy-prompt
    BPP[12]=${BPP[11]} # Keep the STR as the last element
    BPP[10]="CMDRAW bpp_super_git"
    BPP[11]="STR \${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}\${BPP_GLYPHS[BOTTOM]}${BPP_COLOR[RESET]}"

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

    echo -n ${BPP_GLYPHS[NEWLINE]}${BPP_COLOR[DECORATION]}${BPP_GLYPHS[MIDDLE]} branch: ${COLORED_BRANCH}${BPP_GLYPHS[NBS]}
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
