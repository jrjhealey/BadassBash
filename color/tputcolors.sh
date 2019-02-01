# Output all colors via tput

# To use in a script, suggest using like so
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

# Then call variables like so:

echo -e "Some ${red}red text${default}"

for c in {0..255}; do
 tput setaf $c; tput setaf $c | cat -v; echo =$c
done

