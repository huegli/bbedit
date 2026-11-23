#!/bin/zsh
# Search the extracted manual. Prints page number + matching lines.
# usage: manual/search.sh <regex> [context-lines]
#        manual/search.sh -p <page> [<page>]     print page(s) in full
#        manual/search.sh -o                     print the outline (table of contents)
here=${0:A:h}; t=$here/text/manual.txt
[[ -f $t ]] || { echo "Run manual/build.sh first" >&2; exit 1; }
case $1 in
  -o) cat $here/text/outline.txt ;;
  -p) awk -v a=$2 -v b=${3:-$2} '/^=== PAGE [0-9]+ ===$/{p=$3+0} p>=a && p<=b' $t ;;
  *)  awk -v pat="$1" -v c=${2:-0} -v IGNORECASE=1 '
        /^=== PAGE [0-9]+ ===$/{p=$3; next}
        tolower($0) ~ tolower(pat) {printf "p.%s: %s\n", p, $0}' $t ;;
esac
