
# Colors
function bpp_ps1_escape { echo "\[$*\]"; }
function bpp_mk_prompt_color { bpp_ps1_escape "$(bpp_mk_color $1)"; }
function bpp_mk_color { echo "\033[38;5;${1}m"; }
function bpp_mk_prompt_bgcolor { bpp_ps1_escape "$(bpp_mk_bgcolor $1)"; }
function bpp_mk_bgcolor { echo "\033[48;5;${1}m"; }

# Reset
BPP_COLOR[RESET]=$(bpp_ps1_escape "\033[m")
BPP_COLOR[RESETTERM]="\033[m"

# Options (depends on terminal support)
BPP_COLOR[BOLD]="\[\033[1m\]"
BPP_COLOR[DIM]="\[\033[2m\]"
BPP_COLOR[UNDERLINED]="\[\033[4m\]"
BPP_COLOR[BLINK]="\[\033[7m\]"
BPP_COLOR[INVERT]="\[\033[8m\]"

export BPP_COLOR BPP_BGCOLOR
