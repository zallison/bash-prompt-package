# BPP Environment Options

# These can be turned off at runtime to disable a running module
BPP_OPTIONS[ACPI]=1
BPP_OPTIONS[DATE]=1
BPP_OPTIONS[DIRINFO]=1
BPP_OPTIONS[EMACS]=1
BPP_OPTIONS[ERROR]=1
BPP_OPTIONS[NOTES]=1
BPP_OPTIONS[SET_TITLE]=1
BPP_OPTIONS[TEMP]=1
BPP_OPTIONS[UPTIME]=1
BPP_OPTIONS[USER]=1
BPP_OPTIONS[VCS]=1
BPP_OPTIONS[VCS_REMOTE]=0
BPP_OPTIONS[VCS_TYPE]=0
BPP_OPTIONS[VENV]=1

BPP_OPTIONS[ACPI_HIDE_ABOVE]=65
BPP_OPTIONS[DATE_FORMAT]="%I:%M"
BPP_OPTIONS[HOST_LOCAL]=${BPP_OPTIONS[HOST_LOCAL]:-1}
BPP_OPTIONS[GLYPHS]=${BPP_OPTIONS[GLYPHS]-utf}
BPP_OPTIONS[NOTE_FILE]="${HOME}/.bppnotes"
BPP_OPTIONS[NOTE_ON_ENTRY]=1
BPP_OPTIONS[TEMP_CRIT]=65
BPP_OPTIONS[TEMP_WARN]=55
BPP_OPTIONS[TEMP_HIDE_BELOW]=50
BPP_OPTIONS[UPTIME_BLOCK]=0 # A "graph" type display.
BPP_OPTIONS[UPTIME_SEPERATOR]="${BPP_COLOR[RESET]} "
BPP_OPTIONS[USER]="user"
BPP_OPTIONS[VENV_PATHS]="venv env virtual-env .venv .environment environment"
BPP_OPTIONS[VERBOSE_ERROR]=1

BPP_DATA[OLDPWD]=""

# Command to "decorate" text.  By default `bpp_decorate` wraps it in ❰ and ❱
# This is run on each "CMD" entry.

BPP_DATA[DECORATOR]="bpp_decorate"

export BPP_DATA

# Examples:
#
# # my_decorate () {
# #     # Return nothing if we have nothing to decorate
# #     [ -z "$*" ] && return
# #     echo "[$*]" # bpp_decorate foo -> [foo]
# # }
#
# # default_decorate () {
# #     # Return nothing if we have nothing to decorate
# #     [ -z "$*" ] && return
# #
# #     # The text to decorate
# #     args="$*"
# #
# #     # Simple decoartion - decoration colored glyph (utf, ascii etc) for open and close.
# #     pre_decoration="${BPP_COLOR[DECORATION]}${BPP_GLYPHS[OPEN]}${BPP_COLOR[RESET]}"
# #     post_decorations="${BPP_COLOR[DECORATION]}${BPP_GLYPHS[CLOSE]}${BPP_COLOR[RESET]}"
# #
# #     # Put it all together
# #     result="${pre_decoration}${args}${post_decorations}"
# #
# #     # Return the entire thing in one string
# #     echo "${result}"
# # }


# Bash Options
export PROMPT_DIRTRIM=3

####### END SETTINGS #######
