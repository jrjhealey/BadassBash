#!/bin/bash
# An all-singing, all-dancing example script to write pretty and versatile commandline scripts

# A useful construct to control flow in the script (the script will exit if any processes within
# fail or exit abnormally.
set -eo pipefail

# Make your output colorful! This checks to see that there is an active terminal/interactive session
# and uses tput to assign colors. It's a bit less versatile (fewer colors) but supposedly more portable
# than ANSI escape characters. The use of a HEREDOC for `cat` below for the script usage requires this
# as ANSI characters cannot be used. If you want colorful --help, tput is the way to go

if [ -t 1 ] ; then
  ncols=$(tput colors)
  if [ -n "$ncols" ] && [ "$ncols" -ge 8 ] ; then
    bold="$(tput bold)"
    underline="$(tput smul)"
    rmunderline="$(tput rmul)"
    standout="$(tput smso)"
    black="$(tput setaf 0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    magenta="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    white="$(tput setaf 7)"
    default="$(tput sgr0)"
  fi
fi

# Some handy general logging and warning functions. They can be used as pipes or function calls
log(){
  # Logging function (prints to STDOUT in WHITE).
  echo -e >&1 "${white}${underline}INFO:${rmunderline} ${1:-$(</dev/stdin)}${default}"
}

err(){
  # Error function (prints to STDERR in RED).
  echo -e >&2 "${red}${underline}ERROR:${rmunderline} ${1:-$(</dev/stdin)}${default}"
}

warn(){
  # Warning function (prints to STDOUT in YELLOW/ORANGE).
  echo -e >&1 "${yellow}${underline}WARNING:${rmunderline} ${1:-$(</dev/stdin)}${default}"
}

# Using a cat HEREDOC (EOF) to write the usage of the script. cat supports tput colors.
# Using $0 means the scriptname will autopopulate itself when run.
usage(){
cat << EOF >&2
Usage: $0

This is a boilerplate/cookiecutter bash script to handle arguments from the commandline.
This is the help/usage information for the script. It might normally look something like...

 $ bash $0 -f -x arg positional

OPTIONS:
   -h | --help      Show this message.
   -f | --flag      Some boolean (truthy/falsy) flag.
   -x | --xarg      Some flag that takes an argument.
   -a | --array     Some argument that creates an array of items.

Through the use of tput, it also handles ${underline}${red}C${green}O${yellow}L${blue}O${magenta}R${cyan}F${white}U${black}L${default} ${underline}${red}O${green}U${yellow}T${blue}P${magenta}U${cyan}T${default}

EOF
}
# EOF demarcates end of the HEREDOC

# Now begin handling arguments from the commandline. One option for providing the GNU style
# long and short arguments, is to simply reset the long arg to its counterpart short arg
# which is what the case-loop below does.

for arg in "$@"; do                       # for every arg in the commandline array ("$@")
 shift                                    # Shift by one so as to skip the script name
 case "$arg" in
   "--help")      set -- "$@" "-h"   ;;   # Match the args, and reset that particular "$@"
   "--flag")      set -- "$@" "-f"   ;;   # value to the equivalent short arg
   "--xarg")      set -- "$@" "-x"   ;;   #
   "--arr")       set -- "$@" "-a"   ;;   #
   *)             set -- "$@" "$arg" ;;   # Lastly, deal with any unmatched args.
 esac
done

# Call getopts assigns the arguments to variables for use in the script
while getopts "hfx:a:" OPTION ; do         # Letters in quotes correspond to the short arguments.
  case $OPTION in                         # Letters followed by a ":" are expecting an argument.
    h) usage; exit 0    ;;    # -> Output usage and exit normally.
    f) flag="True"      ;;    # -> Flag is boolean, so if it exists, set it to true (or false)
    x) xarg=$OPTARG     ;;    # -> Set the argument of xarg to the variable $xarg (contained in $OPTARG)
    a) arr+=($OPTARG)   ;;    # -> Append -a arguments to an array (useful for gathering filenames etc).
                              #    This requires that -a be given for each filename though.
  esac
done

# Lastly, check for the case where no arguments were provided at all, and take this as a signal to just
# print the script usage to the screen (with an error code).
if [[ $# -eq 0 ]] ; then
    usage ; exit 1
fi

# Now, check for the existence of required arguments, and/or populate with with default behaviours
# if required.
if [[ -z $flag ]]; then
 warn "Flag is not set, assuming default of FALSE"
 flag="False"
fi

# Exit the script if a required argument is not given (for example)
if [[ -z $xarg ]]; then
 usage ; err "xarg not supplied. Exiting." ; exit 1
fi

# If an optional argument wasn't given, perhaps warn and continue on or set some default.
if [[ -z $arr ]]; then
 warn "No array name was specified. Continuing with an empty array."
fi


# All helper functions etc must be declared above, before they are called to do any actual work.
# Below this line the actual script begins and performs tasks.

log  "I am now running the script processes!"
log  "Hi, I'm flag: ${flag}"
warn "Hi, I'm xarg: ${xarg}"
err  "Hi, I'm array: ${arr[*]}"
# A useful block for dealing with Truthy/Falsey booleans (covers all cases of T/TRUE/True/true etc
if [[ $flag =~ ^[Tt][Rr][Uu][Ee]$ ]] || [[ $flag =~ ^[Tt]$ ]] || [[ -z $flag ]] ; then
  log "Doing something"
elif [[ $flag =~ ^[Ff][Aa][Ll][Ss][Ee]$ ]] || [[ $flag =~ ^[Ff]$ ]] ; then
  log "Doing nothing because false"
  :   # Do nothing if false-y
else
 err 'Unrecognised argument to flag (should be T(rue), F(alse) or empty - case insensitive).'
fi
