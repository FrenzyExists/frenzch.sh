#!/bin/bash

# A small bash lib which uses functions from Bash bible
# written by Bash Jesus (Dylan Araps)

# force string into lowercase
lower() {
    # Usage: lower "string"
    printf '%s\n' "${1,,}"
}

# praints file from stdin
# also yes i have no idea how i can use this
print_ascii() {
  printf "$prefix_format"
  while IFS= read -r line || [ -n "$line" ]; do
    printf "%s\n" "$line"
  done < /dev/stdin
}

rstrip() {
    # Usage: rstrip "string" "pattern"
    printf '%s\n' "${1%%$2}"
}

lstrip() {
    # Usage: lstrip "string" "pattern"
    printf '%s\n' "${1##$2}"
}

greater_equal() { # Compares floats
    printf '%s\n%s\n' "$2" "$1" | sort --check=quiet --version-sort
}

# gets the first line containing a certain string from a file
# usage get_line <file> <string to search for>
# outputs in a variable called line_content
get_line_content() {
  while read -r line; do 
    case "$line" in
      *"${2}"*) line_content="$line"; return;;
    esac
  done < "$1"
}

contains_element () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# multiplies a char n times
repeat_char() {
    local a="$1"
    local b="$2"
    printf -v c "%${a}s"
    printf '%s' "${c// /$b}"
}

# Centers elements
print_textart() {
	#element_padded=$(printf '%s' "$1" | sed -e "s/^/${2:+\\\\033[${2}C}/g" -e 's/%/%%/g' -e 's/\\\\/\\\\\\/g')
    element_padded=$(printf '%s' "$1" | sed -e "s/^/${2:+\\\\033[${2}C}/g" -e 's/%/%%/g' -e 's/\\\\/\\\\\\/g')
	print="$print\\033[0m$element_padded"
}

# Generates a decorator thingy
decor_thingy() { # Example: decor_thingy "∆" "»" "How Are We" 32 "\033[0;35m"
    # Output: ∆ How Are We »»»»»»»»»»»»»»»»»»»»» ∆ 
    # Also the triangles would be magenta
    [[ "$5" != "" ]] && { local p="$5$1${reset} $3" ; local c=18 ; } || { local p="$1 $3" ; local c=0 ; }
    local b="$2"
    local n="$4"
    local tan=$(repeat_char $n $b)
    y="$tan"
    y="${p:0:${n}} ${tan:0:$(( ${n} - ${#p} + ${c} ))} $5$1"
    printf '%b'  "$y\n"
    unset b n y p c
}

# Neatly adds padding
padder_thingy() { # Example: "♥ device" "xps xps 13 9343" "." 
    printf "EEEEEE"
}
