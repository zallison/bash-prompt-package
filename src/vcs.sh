
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
