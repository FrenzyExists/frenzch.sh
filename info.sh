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
                                #uid=${uid##*}
                                uid=$(echo $uid | grep -o '0x[0-9a-f]\+')
                                wm=$(xprop -id "$uid" -notype -len 100 -f _NET_WM_NAME 8t)
                                wm=$(echo $wm | grep -o '_NET_WM_NAME = \"[A-Za-z]\+"' | awk '{print $3}' | awk 'gsub(/"/, "", $0)')
                                #wm=$(echo $wm | grep WM_CLASS | awk '{print $4}')
                                #wm=${wm##*WM_NAME=\"}
                                #wm=${wm%%\"*}
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
        ram="$(rstrip "$(free -h | awk 'NR == 2 {printf("%s", $7)}')" "Gi") gb"
    else
        [[ $1 == "ram_used" ]] && ram="$(rstrip "$(free -h | awk 'NR == 2 {printf("%s", $3)}')" "Gi") gb"  || ram="$(rstrip "$(free -h | awk 'NR == 2 {printf("%s", $2)}')" "Gi") gb"
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
    read -r display <<< "$(xrandr --current | grep ' connected' | grep -o '[0-9]\+x[0-9]\+')"
}

get_kernel() { # The kernel
    read -r k_ver k_type <<< "$(uname -r | sed 's/-/\ /g')"
    k_type="$(echo $(echo $k_type | sed 's/[0-9]/\ /g') | sed -e 's/\b\([a-z]\+\)[ ,\n]\1/\1/g')"
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
        lspci > $HOME/Desktop/weeeee
        get_line_content "$HOME/Desktop/weeeee" "VGA"
        case $line_content in
          *"NVIDIA"*)
            IFS=[
            set -- $line_content
            gpu="$2"
            IFS=]
            set -- $gpu
            gpu="NVIDIA $1"
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

get_term_size() {
    read -r term_height term_width <<< "$(stty size)"
}
