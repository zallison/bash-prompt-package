# BPP Environment Options

# These can be turned off at runtime to disable a running module
BPP_ENABLED[USER]=1
BPP_ENABLED[UPTIME]=1
BPP_ENABLED[DATE]=1
BPP_ENABLED[TEMP]=1
BPP_ENABLED[DIRINFO]=1
BPP_ENABLED[VCS]=1
BPP_ENABLED[VCS_REMOTE]=0
BPP_ENABLED[VCS_TYPE]=0
BPP_ENABLED[VENV]=1
BPP_ENABLED[ERROR]=1
BPP_ENABLED[ACPI]=1
BPP_ENABLED[SET_TITLE]=1
BPP_ENABLED[EMACS]=1

BPP_OPTIONS[UPTIME_BLOCK]=0 # A "graph" type display.
BPP_OPTIONS[UPTIME_SEPERATOR]="${BPP_COLOR[RESET]} "
BPP_OPTIONS[USER]="user"
BPP_OPTIONS[DATE_FORMAT]="%I:%M"
BPP_OPTIONS[VENV_PATHS]="venv env virtual-env .venv .environment environment"
BPP_OPTIONS[NOTE_ON_ENTRY]=1
BPP_OPTIONS[NOTE_FILE]="${HOME}/.bppnotes"

BPP_DATA[OLDPWD]=""
BPP_DATA[DECORATOR]="bpp_decorate" # Command to "decorate" text.  By
				   # default wraps it in ❰ and ❱

BPP_DATA[DECORATOR]=bpp_decorate

# Bash Options
export PROMPT_DIRTRIM=3

####### END SETTINGS #######
