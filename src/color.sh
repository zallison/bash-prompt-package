# Colors
function bpp_ps1_escape { echo "\[$*\]"; }
function bpp_mk_prompt_color { bpp_ps1_escape "$(bpp_mk_color $1)"; }
function bpp_mk_color { echo "\033[38;5;${1}m"; }
function bpp_mk_prompt_bgcolor { bpp_ps1_escape "$(bpp_mk_bgcolor $1)"; }
function bpp_mk_bgcolor { echo "\033[48;5;${1}m"; }

# Reset
BPP_COLOR[RESET]=$(bpp_ps1_escape "\033[m")

## Named Colors for 0-15
# Foreground
BPP_COLOR[BLACK]=$(bpp_mk_prompt_color 0)
BPP_COLOR[RED]=$(bpp_mk_prompt_color 1)
BPP_COLOR[GREEN]=$(bpp_mk_prompt_color 2)
BPP_COLOR[ORANGE]=$(bpp_mk_prompt_color 3)
BPP_COLOR[BLUE]=$(bpp_mk_prompt_color 4)
BPP_COLOR[PURPLE]=$(bpp_mk_prompt_color 5)
BPP_COLOR[CYAN]=$(bpp_mk_prompt_color 6)
BPP_COLOR[GREY]=$(bpp_mk_prompt_color 7)
BPP_COLOR[DARKGREY]=$(bpp_mk_prompt_color 8)
BPP_COLOR[BRIGHTRED]=$(bpp_mk_prompt_color 9)
BPP_COLOR[BRIGHTGREEN]=$(bpp_mk_prompt_color 10)
BPP_COLOR[YELLOW]=$(bpp_mk_prompt_color 11)
BPP_COLOR[BRIGHTBLUE]=$(bpp_mk_prompt_color 12)
BPP_COLOR[BRIGHTPURPLE]=$(bpp_mk_prompt_color 13)
BPP_COLOR[BRIGHTCYAN]=$(bpp_mk_prompt_color 14)
BPP_COLOR[WHITE]=$(bpp_mk_prompt_color 15)

# Background
BPP_BGCOLOR[BLACK]=$(bpp_mk_prompt_bgcolor 0)
BPP_BGCOLOR[RED]=$(bpp_mk_prompt_bgcolor 1)
BPP_BGCOLOR[GREEN]=$(bpp_mk_prompt_bgcolor 2)
BPP_BGCOLOR[ORANGE]=$(bpp_mk_prompt_bgcolor 3)
BPP_BGCOLOR[BLUE]=$(bpp_mk_prompt_bgcolor 4)
BPP_BGCOLOR[PURPLE]=$(bpp_mk_prompt_bgcolor 5)
BPP_BGCOLOR[CYAN]=$(bpp_mk_prompt_bgcolor 6)
BPP_BGCOLOR[GREY]=$(bpp_mk_prompt_bgcolor 7)
BPP_BGCOLOR[DARKGREY]=$(bpp_mk_prompt_bgcolor 8)
BPP_BGCOLOR[BRIGHTRED]=$(bpp_mk_prompt_bgcolor 9)
BPP_BGCOLOR[BRIGHTGREEN]=$(bpp_mk_prompt_bgcolor 10)
BPP_BGCOLOR[YELLOW]=$(bpp_mk_prompt_bgcolor 11)
BPP_BGCOLOR[BRIGHTBLUE]=$(bpp_mk_prompt_bgcolor 12)
BPP_BGCOLOR[BRIGHTPURPLE]=$(bpp_mk_prompt_bgcolor 13)
BPP_BGCOLOR[BRIGHTCYAN]=$(bpp_mk_prompt_bgcolor 14)
BPP_BGCOLOR[WHITE]=$(bpp_mk_prompt_bgcolor 15)

# Options (depends on terminal support)
BPP_COLOR[BOLD]="\[\033[1m\]"
BPP_COLOR[DIM]="\[\033[2m\]"
BPP_COLOR[UNDERLINED]="\[\033[4m\]"
BPP_COLOR[BLINK]="\[\033[7m\]"
BPP_COLOR[INVERT]="\[\033[8m\]"

export BPP_COLOR BPP_BGCOLOR

# Options
if [[ $TERM = *256* ]]; then
    BPP_COLOR[DECORATION]=${BPP_COLOR[RESET]}$(bpp_mk_prompt_color 25) # blue-ish
    BPP_COLOR[GOOD]="$(bpp_mk_prompt_color 47)" # Bright green
    BPP_COLOR[WARNING]=${BPP_BGCOLOR[DARKGREY]}${BPP_COLOR[BOLD]}${BPP_COLOR[YELLOW]}
    BPP_COLOR[CRITICAL]=${BPP_COLOR[BRIGHTRED]}
    BPP_COLOR[INFO]=${BPP_COLOR[GREY]}
else
    BPP_COLOR[DECORATION]=${BPP_COLOR[RESET]}${BPP_COLOR[CYAN]}
    BPP_COLOR[GOOD]=${BPP_COLOR[BOLD]}${BPP_COLOR[GREEN]}
    BPP_COLOR[WARNING]=${BPP_COLOR[DARKGREY]}${BPP_COLOR[BOLD]}${BPP_COLOR[YELLOW]}
    BPP_COLOR[CRITICAL]=${BPP_COLOR[BRIGHTRED]}
    BPP_COLOR[INFO]=${BPP_COLOR[GREY]}
fi


