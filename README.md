# Bash Prompt Package

Bash prompt customization made easy!

[Examples](#examples)

[Built In Prompts](#built-in-prompts)

[All Functions](#all-functions)

[More Info](#more-info)

---

Try out some prompt, just download `bash-prompt-package.sh` and load it with `source`.

Try `bpp-simple-prompt`, `bpp-compact-prompt`, `bpp-fancy-prompt`, and `bpp-super-git-promt` for some inspiration.

Also `bpp-show-color [columns]` will show the colors available to you.

If you can't remember what your prompt is you can see it with `bpp-show-prompt`.


---

## Examples

how about some examples?

---

Here's a simple example,showing just the VCS (git or svn) status, as well as "\w", the current working directory.

    source bash-prompt-package.sh

    BPP=(
    "CMD bpp_vcs"
    "STRDEC \w"
    "STR $ ")


![simple prompt](./examples/prompt1.png)

After modifying a file you can see the status change

![simple prompt](./examples/prompt2.png)

Staging the files changes the status

![simple prompt](./examples/prompt3.png)

As does comitting it!

![simple prompt](./examples/prompt4.png)

---

Here's a two line prompt showing battery and cpu temp information.  The config looks something like


    source bash-prompt-package.sh
    
    BPP=("CMD bpp_error"
         "STR ${BPP_NEWLINE}${DECORATION_COLOR}${TOP} "
         "CMD bpp_user_and_host"
         "CMD bpp_uptime"
         "CMD bpp_acpi"
         "CMD bpp_venv"
         "CMD bpp_cpu_temp"
         "STR ${BPP_NEWLINE}${DECORATION_COLOR}${BOTTOM}${RESET}"
         "CMD bpp_vcs"
         "STR ${DECORATION_COLOR}${BPP_UTF8_OPEN}${RESET}\w${DECORATION_COLOR}${BPP_UTF8_CLOSE}\$${NON_BREAKING_SPACE}")


![simple prompt](./examples/prompt5.png)

---

Changing colors is easy too:

    export GOOD_COLOR=$PURPLE
    export WARNING_COLOR="${BRIGHTRED_BG}${BLACK}"
    export CRIT_COLOR=${BRIGHTRED_BG}${WHITE}

![simple prompt](./examples/prompt6.png)

256 colors to choose from!  Which 256 is up to your terminal emulator.

![colors](./examples/show-colors.png)

---

Other modules include `bpp_uptime` and `bpp_date`

![simple prompt](./examples/prompt7.png)

The `bpp_venv` modules is really handy for python virtual environment.  Use the command `bpp-venv` to quickly activate, deactive, or return to the root directory.  It also warns you when you change into a directory with a different virtual env, as seen below.

![simple prompt](./examples/prompt8.png)

---

![simple prompt](./examples/git-prompt.png)

----

There are some commands that don't add anything to the prompt but are still useful, these are called by `EXE` instead of `CMD`.

`bpp_set_title` (e.g. `"EXE bpp_set_title"`) will print the escape sequence to set the title of an xterm.

`bpp_send_emacs_path_info` - will print the escape sequence to tell emacs ansti-term the path info.

`bpp_history` - Write your history and reload it to sync history from all terms

---

## Built In Prompts

`bpp-simple-prompt` - As basic as it gets

`bpp-compact-prompt`- For when you have limited space and need limited info

`bpp-fancy-prompt`- A nice daily driver

`bpp-super-git-prompt` - More git info than you'll ever need!

## All Functions

`bpp_date` - Show the current date, according to `BPP_DATE_FORMAT`

`bpp_uptime` - Show and colorize uptime values

`bpp_user_and_host` - Show and colorize user@host (yellow for remote hosts, red if you're root)

`bpp_error` - Shows the error status of the last command

`bpp_venv` - Python virtual environment variable options

`bpp_vcs` - Show git or svn status information in a compact manner

`bpp_dirinfo` - Information about the current directory, number of files, size, etc.  Slow on remove file systems

`bpp_set_title` - Send the escape sequence to set the title for xterm, screen, tmux etc.

`bpp_send_emacs_path_info` - Send the current path info to emacs, allowing TRAMP to easily make connections

`bpp_acpi`- Battery info

`bpp_cpu_temp` - A simple average of CPU core temps

`bpp_history` - Share history among terminals

## More Info

Most functions will degrade gracefully, and can be controlled by environment variables.  For example to turn off display of the "date" module try `export BPP_DATE=0`

Each element is run through a "decorator" function, the built in one simple surronds the text with "❰" and "❱".  I'm sure someone out there can find a better use.

Check the [source code](bash-prompt-package.sh) of the [functions](#all-functions) for examples on how to write your own.  But if you can write bash, they're super easy!

Example:

    function bpp_date {
        if [[ ${BPP_DATE} == 1 ]]; then
            echo "${BPP_GOOD_COLOR}$(date +${BPP_DATE_FORMAT})"
        fi
    }
