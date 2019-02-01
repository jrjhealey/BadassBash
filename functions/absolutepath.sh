# Return the absolute path of a relative system path
abspath() {
if [ -d "$1" ]; then
  (cd "$1"; pwd)
elif [ -f "$1" ]; then
  if [[ $1 = /* ]]; then
    echo "$1"
    elif [[ $1 == */* ]]; then
      echo "$(cd "${1%/*}"; pwd)/${1##*/}"
    else
      echo "$(pwd)/$1"
  fi
fi
}
