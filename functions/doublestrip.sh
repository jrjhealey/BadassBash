# This function emulates $(basename) using bash's inbuilt regex ability

doublestrip(){
[[ $1 =~ ^.*/(.*)\. ]] && echo "${BASH_REMATCH[1]}"
}
