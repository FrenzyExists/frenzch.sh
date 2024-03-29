#!/bin/bash

# Library encharged of obtaining system info
# Currently compatible with windows and Linux

MYSELF="$(readlink -f "$0")"
MYDIR="${MYSELF%/*}"

source "$MYDIR/bash_jesus.sh"

check_stuff() {
    type -p bash &>/dev/null || {
        printf "Error, no bash installed!\nInstall it you fucking idiot...\n"
        exit 1
    }
    if [[ "$(id -u)" == 0 ]] ; then
        printf "Yo, you're in root... wtf?\n"
        exit 1
    fi
}

get_wm() { # Get Window Manager
        OS=$(uname -s)
        case "$OS" in
                "Linux"|"GNU"*)
                        if [ "$XDG_SESSION_DESKTOP" ]; then
                                wm=$XDG_SESSION_DESKTOP
                        elif [ "$XDG_CURRENT_DESKTOP" ]; then
                                wm=$XDG_CURRENT_DESKTOP
                        else
                                # taken from neofetch
                                uid=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
                                uid=$(echo $uid | grep -o '0x[0-9a-f]\+')
                                wm=$(xprop -id "$uid" -notype -len 100 -f _NET_WM_NAME 8t)
                                wm=$(echo $wm | grep -o '_NET_WM_NAME = "[A-Za-z]\+"' | awk '{print $3}' | awk 'gsub(/"/, "", $0)')
                        fi
                        ;;
                "Darwin")
                        if [ $(pgrep -lfc yabai) != 0 ] || [ $(pgrep -lfc amehtsysty) != 0 ] || [ $(pgrep -lfc spectacle) != 0 ]; then
                                wm="yabai"
                        fi
                        ;;
                "CYGWIN"*|"MSYS"*|"MINGW"*)
                        OS="windows"
                        wm="explorer"
                        break
                        ;;
                "*")
                        OS="unknown"
                        wm="unknown"
                    ;;
        esac
}

get_user() { # Gets host name
    us="$(who | awk '!seen[$1]++ {printf $1}')"
}

get_ram() { # Get Memory ram
    if [[ $1 == "ram_free" ]] ; then
        ram="$(free -h | awk 'NR == 2 {printf("%s", $7)}' | sed 's/Gi//') gb"
    else
        [[ $1 == "ram_used" ]] && ram="$(free -h | awk 'NR == 2 {printf("%s", $3)}' | sed 's/Gi//') gb"  || ram="$(free -h | awk 'NR == 2 {printf("%s", $2)}' | sed 's/Gi//') gb"
    fi
}

get_editor() { # Get Current Editor
    # In case the $EDITOR variable is empty, posix attempt
    if [ -z "$EDITOR" ]; then
        : "${editor_boi:=$(command -v nvim)}" "${editor_boi:=$(command -v vim)}" "${editor_boi:=$(command -v emacs)}" "${editor_boi:=$(command -v vim)}"
        editor=$(basename $editor_boi)
    else
        editor=$(basename "${VISUAL:-$EDITOR}")
    fi
}

get_device() { # Get Device model name
    device=$(tr '[:upper:]' '[:lower:]' < /sys/devices/virtual/dmi/id/product_name)
}

get_os() { # Get Operating system name
    for os in /etc/os-release /usr/lib/os-release; do
        [ -f $os ] && . $os && break
    done
    os=$(lower "$PRETTY_NAME")
}

get_panel() { # all the panels
    # add more if you know some other bar or something idkf
    bar=$(ps -e | grep -m 1 -o \
            -e "i3bar$" \
            -e "dzen2$" \
            -e "tint2$" \
            -e "xmobar$" \
            -e "swaybar$" \
            -e "polybar$" \
            -e "lemonbar$" \
            -e "taffybar$" \
            -e "awesome$")
        bar=${bar#}

        if [[ "$bar" == "awesome" ]] ; then
            bar="wibar"
        elif [[ "$bar" == ""  ]]; then
            bar="no bar"
        fi
}

get_resolution() { # screen resolution    
    local display_count="$(xrandr --current | grep ' connected' | grep -wo '[0-9]\+x[0-9]\+' | wc -l)"
    if [[ "${display_count}" > 1 ]]; then
        display="$(xrandr --current | grep ' connected' | grep -wo '[0-9]\+x[0-9]\+' | uniq -c)"
        display="$(echo $display)"
    else
        display="$(xrandr --current | grep ' connected' | grep -wo '[0-9]\+x[0-9]\+')"
    fi
}
get_resolution
get_kernel() {
    read -r k_ver k_type <<< "$(uname -r | sed 's/-/\ /g')"
    k_ver=${k_ver%%-*} # Remove everything after first -
    k_type=$(echo "$k_type" | sed -e 's/[0-9]/ /g' -e 's/\s\+/ /g') # Remove all numbers and extra spaces
    k_type=$(echo "$k_type" | sed 's/\b\([[:alpha:]]\+\)[[:space:]]\+\1\b/\1/g')
    kern="$(uname --kernel-name) $k_ver - $k_type"
}

get_uptime() {
    IFS=. read -r s _ < /proc/uptime

    # Convert the uptime from seconds into days, hours and minutes.
    d=$((s / 60 / 60 / 24))
    h=$((s / 60 / 60 % 24))
    m=$((s / 60 % 60))

    # Only append days, hours and minutes if they're non-zero.
    case "$d" in ([!0]*) uptime="${uptime}${d}d "; esac
    case "$h" in ([!0]*) uptime="${uptime}${h}h "; esac
    case "$m" in ([!0]*) uptime="${uptime}${m}m "; esac
}

#FIX THIS CRAP
get_cpu() {
  case $OSTYPE in
    Linux)
      get_line /proc/cpuinfo 5
      IFS=":"
      set -- $line
      cpu="$2"
      IFS=" "
    ;;
    Darwin) cpu=" $(sysctl -n machdep.cpu.brand_string)"
    trim_all $cpu
    cpu=$trimmed_string
    set -- $cpu
    if [ "$1" = "Intel(R)" ]; then
      cpu_vendor="Intel "
      cpu=${cpu##Intel(R) }
      if [ "$2" = "Core(TM)2" ]; then
        cpu_series="Core 2"
        cpu=${cpu##Core(TM)2}
      fi
    fi
    cpu=${cpu_vendor}${cpu_series}${cpu};;
  esac
}

# FIX THIS
get_gpu() { # Get Graphics Card
    OS=$(uname -s)
    case $OS in
      Linux)
        lspci > "/tmp/getgpu"
        get_line_content "/tmp/getgpu" "VGA"
        case $line_content in
          *"NVIDIA"*)
            IFS=[
            set -- $line_content
            gpu="$2"
            IFS=]
            set -- $gpu
            gpu="NVIDIA $1"
            IFS=" ";;
        *"Intel"*)
            IFS=:
            set -- $line_content
            gpu=$3
            gpu="${gpu/*Intel/Intel}"
            gpu="${gpu/\(R\)}"
            gpu="${gpu/Corporation }"
            gpu="${gpu/ \(*}"
            gpu="${gpu/Integrated Graphics Controller}"
            gpu="${gpu/*Xeon*/Intel HD Graphics}"
            IFS=" ";;
          *)
            IFS=:
            set -- $line_content
            gpu=$3
            IFS=" ";;
          esac;;
      Darwin)
        gpu=$(system_profiler SPDisplaysDataType | get_file_content /dev/stdin "Chipset Model:")
        IFS=":"
        set -- $gpu
        gpu=$2
        
        IFS=" ";;
    esac
}

# get_gpu
echo "$gpu"
get_term_size() {
    
    read -r term_height term_width <<< "$(stty size)"
}

get_shell() {
    shell_boi="$(ps -p $$ -o args= | awk '{print $1}')"
    shell="$(basename "$shell_boi")"
}

get_cpu() {
    # Get CPU name
    name=$(grep "model name" /proc/cpuinfo | awk -F ': ' '{print $2}' | uniq)
    # Clean CPU name
    name=$(echo $name | sed 's/(R)//g; s/Core(TM)//g; s/ @ / /g; s/CPU//g; s/[[:space:]]\+/ /g; s/^ *//; s/ *$//')
    # Get number of CPU cores
    cores=$(grep -c '^processor' /proc/cpuinfo)
    # Get CPU frequency
    # freq=$(grep "cpu MHz" /proc/cpuinfo | awk -F ': ' '{print $2}' | head -1)
    # Clean CPU frequency
    # freq=$(echo "scale=3; $freq/1000" | bc | sed 's/0*$//; s/\.$//')
    # Format output string
    cpu="$name ($cores)"
}

get_terminal() {
    term="$TERM_PROGRAM"
    if [[ -z "$term" ]] ; then
        term="$TERM"
    fi
}