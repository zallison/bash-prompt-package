
function bpp_venv {
    local envpath
    env_path=''
    env_prefix=''
    for P in ${BPP_OPTIONS[VENV_PATHS]}; do
	if [[ -f "./${P}/bin/activate" ]]; then
	    env_path="./${P}/bin/activate"
	    env_prefix=$P
	    break;
	fi
    done

    if [[ ${BPP_ENABLED[VENV]} == 1 ]]; then
	current=$(readlink -f .)
	if [[ $VIRTUAL_ENV ]]; then
	    here=$(basename $current)
	    there=$(basename $VIRTUAL_ENV)
	    if [[ ${current} == ${VIRTUAL_ENV} ]]; then
		VENV="${BLUE}venv: ${here}"
	    elif [[ ! -z "$env_path" ]]; then
		VENV="${BPP_COLOR[CRITICAL]}venv: ${BPP_COLOR[WARNING]}${there} ${BPP_COLOR[CRITICAL]}vs${BPP_COLOR[WARNING]} $here"
	    else
		VENV="${BPP_COLOR[WARNING]}venv: $(basename ${VIRTUAL_ENV})"
	    fi
	elif [[ $env_path ]]; then
	    VENV="${BPP_COLOR[WARNING]}venv available"
	fi
    fi
    echo $VENV
}

function bpp-venv {
    local ENVPATH
    for P in ${BPP_OPTIONS[VENV_PATHS]}; do
	if [[ -f "./${P}/bin/activate" ]]; then
	    ENVPATH="./${P}/bin/activate"
	    break
	fi
    done

    function load_env {
	if [[ $ENVPATH ]]; then
	    source $ENVPATH;
	    export VIRTUAL_ENV=$(readlink -f .)
	else
	    echo "No virtual environment found"
	fi
    }

    function unload_env {
	if [[ $VIRTUAL_ENV ]]; then
	    unset VIRTUAL_ENV
	    deactivate
	else
	    echo "No virtual environment loaded"
	fi

    }

    function goto_env {
	if [[ $VIRTUAL_ENV ]]; then
	    cd $VIRTUAL_ENV || exit
	else
	    echo "No virtual environment loaded"
	fi
    }

    case $1 in
	'') if [[ $VIRTUAL_ENV ]]; then unload_env; else load_env;fi;;
	'activate') load_env;;
	'disable') unload_env;;
	'deactivate') unload_env;;
	'return') goto_env;;
	'go') goto_env;;
	*) _bpp-venv; echo "Unknown action $1, try: ${COMPREPLY[*]}";;
    esac
}
function _bpp-venv {
    COMPREPLY=( $(compgen -W 'activate deactivate return go disable' -- $2))
    return 0
}
complete -F _bpp-venv bpp-venv
