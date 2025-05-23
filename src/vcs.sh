bpp_vcs() {
    INDEX=$1

    if [ -e .svn ] ; then
        VCS=$(bpp_svn)
        VCS_TYPE="svn"
    elif [[ $(git status 2> /dev/null) ]]; then
        VCS=$(bpp_git)
        VCS_TYPE="git"
    fi

    if [[ $VCS ]]; then
        if [[ ${BPP_OPTIONS[VCS_TYPE]} == 1 ]]; then
            VCS="${VCS_TYPE} ${VCS}"
        else
            VCS="${VCS}"
        fi
    fi

    echo ${VCS}
}

bpp_svn() {
    local SVN_STATUS
    SVN_STATUS=$(svn info 2>/dev/null)
    if [[ $SVN_STATUS != "" ]] ; then
        local REFS
        REFS=" $(svn info | grep "Repository Root" | sed 's/.*\///')"
        MODS=$(svn status | sed 's/ .*//' | grep -cE ^"(M|A|D)")
        if [[ ${MODS} != "0" ]] ; then
            SVN="${BPP_COLOR[DECORATION]}svn:$REFS ${BPP_COLOR[CRITICAL]}m:${MODS}" # Modified
        else
            SVN="${BPP_COLOR[DECORATION]}svn:$REFS"
        fi
    fi
    echo $SVN
}

bpp_git_shortstat() {
    [[ ${BPP_OPTIONS[VCS]} ]] || return 0
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ "$BRANCH" ]] || return 0

    local STATS MODIFIED INSERTED DELETED TARGET
    TARGET=${1:-}
    STATS=$(git diff --shortstat $TARGET 2> /dev/null)

    local CHANGE_REGEX="([0-9]+) files? changed"
    if [[ $STATS =~ ${CHANGE_REGEX} ]]; then
        MODIFIED="${BASH_REMATCH[1]}"
    fi

    local INSERT_REGEX="([0-9]+) insertion"
    if [[ $STATS =~ ${INSERT_REGEX} ]]; then
        INSERTED="${BASH_REMATCH[1]}"
    fi

    local DELETE_REGEX="([0-9]+) deletion"
    if [[ $STATS =~ ${DELETE_REGEX} ]]; then
        DELETED="${BASH_REMATCH[1]}"
    fi

    if [[ -z "$MODIFIED" ]]; then
        return
    else
        echo "${BPP_COLOR[INFO]}${MODIFIED:-0},${BPP_COLOR[GOOD]}+${INSERTED:-0}${BPP_COLOR[INFO]},${BPP_COLOR[RED]}-${DELETED:-0}"
    fi

}

bpp_git() {
    [[ ${BPP_OPTIONS[VCS]} == "1" ]] || return

    GIT="";
    STATUS=$(bpp_git_status)
    DETAILS=$(bpp_git_shortstat)

    if [[ $DETAILS ]]; then
        STATUS="${STATUS}${DETAILS}";
    fi

    if [[ ${BPP_OPTIONS[VCS_REMOTE]} == "1" ]]; then
        REMOTE=$(git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')
        if [[ ! $REMOTE ]]; then
            REMOTE=local
        fi
        GIT="${BPP_COLOR[RESET]}${BPP_COLOR[INFO]}$REMOTE: $STATUS";
    else
        GIT="${BPP_COLOR[RESET]}$STATUS";
    fi

    echo $GIT
}

bpp_git_status() {
    command -v git 2>&1 > /dev/null || return
    local branch flags color

    branch=$(__git_ps1 | cut -c 2- | sed 's/[()]//g')

    if [[ -n "$branch" ]]; then
        git_status=$(git status 2> /dev/null)
        # If nothing changes the color, we can spot unhandled cases.
        color=${BPP_COLOR[INFO]}

        if [[ $git_status =~ 'Changed but not updated' ||
                  $git_status =~ 'Unmerged paths' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+="!"
        fi

        if [[ $(git stash show 2>/dev/null) ]]; then
            flags+="*"
        fi

        if [[ $git_status =~ 'working tree clean' ]]; then
            color=${BPP_COLOR[GOOD]}
        fi

        if [[ $git_status =~ 'Untracked files' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+="U"
        fi

        if [[ $git_status =~ 'Your branch is ahead' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+=">"
            [[ $BPP_OPTIONS[GIT_STAT_AHEAD] == "1" ]] &&
                flags+="ahead:${BPP_COLOR[RESET]}($(bpp_git_shortstat HEAD~))"
        fi

        if [[ $git_status =~ 'Changes to be committed' ]]; then
            color=${BPP_COLOR[WARNING]}
            if [[ ${BPP_OPTIONS[GIT_STAT_STAGE]} == "1" ]]; then
                flags+=" (staged:$(bpp_git_shortstat --staged))"
            else
                flags+="S"
            fi
        fi

        if [[ $git_status =~ 'Changes not staged' ]]; then
            color=${BPP_COLOR[WARNING]}
            flags+="m"
        fi

        if [[ $git_status =~ 'Your branch'.+diverged ]]; then
            color=${BPP_COLOR[CRITICAL]}
            flags+="{"
        fi

        if [[ $git_status =~ 'Your branch is behind' ]]; then
            color=${BPP_COLOR[CRITICAL]}
            flags+="<"
        fi

        if [[ -n "${flags}" ]]; then
            flags=":${flags}"
        fi

        echo -n "${color}${branch}${flags}${BPP_COLOR[RESET]} "
    fi
    return 0
}
