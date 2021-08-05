#!/bin/sh

# Frenzy's personal fetch

# DISCLAIMER
# Don't try this at home, don't show it to children, don't show it your co-workers,
# don't show it to #bash at Freenode, don't show it to members of the POSIX committee,
# don't show it to Mr. Bourne, maybe show it to father McCarthy's ghost to give him a
# laugh. You have been warned, and you never found this in my repo.

# CONSTANTS OR SOMETHING IDFK
red="\033[0;31m"
yellow="\033[0;33m"
green="\033[0;32m"
blue="\033[0;34m"
magenta="\033[0;35m"
cyan="\033[0;36m"
black="\033[0;30m"
black_2="\033[0;90m"
reset="\033[0m"
white="\033[0;97m"

red_bg="\033[0;30;101m"
green_bg="\033[0;30;102m"
yellow_bg="\033[0;30;103m"
blue_bg="\033[0;30;104m"
magenta_bg="\033[0;30;105m"
cyan_bg="\033[0;30;106m"

bold="\033[1m"
italic="\033[3m"

welcome() {
        printf "%s" "\
███████ ██████  ███████ ███    ██ ███████  ██████ ██   ██ 
██      ██   ██ ██      ████   ██    ███  ██      ██   ██ 
█████   ██████  █████   ██ ██  ██   ███   ██      ███████ 
██      ██   ██ ██      ██  ██ ██  ███    ██      ██   ██ 
██      ██   ██ ███████ ██   ████ ███████  ██████ ██   ██ 
 
version 0.1: Carita Buena de Nena                                                         
Options:
    just fire up the damn thing wtf you expect?
"
        exit 1
}

fetch_idk() {
        col=$(stty size | cut -d' ' -f2)
        row=$(stty size | cut -d' ' -f1)
        if [ "$row" -ge 34 ] && [ "$col" -ge 140 ]; then
                big_fetch
        else
                echo "Yo! Make the terminal window larger!"
        fi
}

info_shit() {
        for os in /etc/os-release /usr/lib/os-release; do
                [ -f $os ] && . $os && break
        done
        os=$(echo "$PRETTY_NAME" | tr '[:upper:]' '[:lower:]')
        #read -r _ _ version _ </proc/version

        #sh=$(basename "$SHELL")
        OS=$(uname -s)
        case "$OS" in
                "Linux"|"GNU"*)
                        if [ "$XDG_SESSION_DESKTOP" ]; then
                                wm=$XDG_SESSION_DESKTOP
                        elif [ "$XDG_CURRENT_DESKTOP" ]; then
                                wm=$XDG_CURRENT_DESKTOP
                        else
                                # taken from neofetch
                                id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
                                id=${id##* }
                                wm=$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)
                                wm=${wm##*WM_NAME = \"}
                                wm=${wm%%\"*}
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
                "*") printf "Not Supported/n" ;;
        esac
        us="$(who | awk '!seen[$1]++ {printf $1}')"

        device_name=$(tr '[:upper:]' '[:lower:]' </sys/devices/virtual/dmi/id/product_name)
        # In case the $EDITOR variable is empty, posix attempt
        if [ -z "$EDITOR" ]; then
                : "${editor_boi:=$(command -v nvim)}" "${editor_boi:=$(command -v vim)}" "${editor_boi:=$(command -v emacs)}" "${editor_boi:=$(command -v vim)}"
                editor=$(basename $editor_boi)
        else
            editor=$(basename $EDITOR)
        fi

        ram_mem="$(free -h | awk 'NR == 2 {printf("%s", $2)}' | tr '[:upper:]' '[:lower:]' | sed 's/[a-z]*//g') gb"

        res="$(xrandr --current | grep ' connected' | grep -o '[0-9]\+x[0-9]\+')"

        # add more if you know some other bar or something idkf
        bar=$(ps -e | grep -m 1 -o \
                -e " i3bar$" \
                -e " dzen2$" \
                -e " tint2$" \
                -e " xmobar$" \
                -e " swaybar$" \
                -e " polybar$" \
                -e " lemonbar$" \
                -e " taffybar$")

        bar=${bar# }
}

#medium_fetch() {
#
#
#}

big_fetch() {
        info_shit

        # The size of the each fetch itself is 32 characters long, since I'm a newb on this that's the size hardcoded
        # I'll change this part, trust me

        # This section is the user with the os name. Originally hardcoded, this is the current dirty way to
        # center it atm

        left_pad=$((32 - $(echo $us | wc -m) - $(echo $os | wc -m) - 6))
        center_pad=$((32 - $(echo $us | wc -m) - $(echo $os | wc -m) - 3))
        right_pad=$((32 - $center_pad - $left_pad))

        # This section is the info with hearts. Currently is hardcoded until there's a way to generalize it
        # just like neofetch does

        us_os_str=$(echo $(echo "$us" | sed -e :a -e 's/^.\{1,'"$left_pad"'\}$/⠀&/;ta')$(echo "$os" | sed -e :a -e 's/^.\{1,'"$center_pad"'\}$/⠀&/;ta')$(echo "​" | sed -e :a -e 's/^.\{1,'"$right_pad"'\}$/⠀&/;ta'))

        size=$((32 - $(echo "$ram_mem" | wc -m) - $(echo "ram" | wc -m) - 2))
        ram_str=$(echo "ram" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$ram_mem")

        size=$((32 - $(echo "$device_name" | wc -m) - $(echo "device" | wc -m) - 2))
        dev_str=$(echo "device" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$device_name")

        size=$((32 - $(echo "$res" | wc -m) - $(echo "display" | wc -m) - 2))
        res_str=$(echo "display" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$res")

        size=$((32 - $(echo $wm | wc -m) - $(echo "w. manager" | wc -m) - 2))
        wm_str=$(echo "w. manager" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$wm")

        size=$((13 - $(echo "$bar" | wc -m)))
        bar_str=$(echo $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$bar")

        size=$((14 - $(echo "$editor" | wc -m)))
        editor_str=$(echo $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$editor")

        printf '%b' "\
${black}+------------------------------------${magenta}×${black}------------------------------------------------------------------------------------------------------+${reset}
${black}|${reset}                                    ${magenta}|${reset}                                                                                                      ${black}|
${black}|${reset}             ${yellow}O${reset}                      ${magenta}|${reset}                                                                                                      ${black}|
${black}|${reset}            ${red}(_)${reset}                     ${magenta}|${reset}                                                                                                      ${black}|
${black}|${reset}          ${red}_ )_( _${reset}                   ${magenta}A${reset}                                                                       _________________________      ${black}|
${black}|${reset}        ${red}/\`_) H (_\`\  ${reset}              ${yellow}/|\                                                                     ${reset}/                         \     ${black}|
${black}|${reset}      ${red}.' (  { }  ) '.${reset}             ${yellow}/-|-\                                                                    ${reset}| +----------+----------+ |     ${black}|
${black}|${reset}    ${red}_/ /\` '-'='-' \`\ \_${reset}           ${yellow}\_|_/                           ${reset}${us_os_str}       | |   ${red}${italic}redy${reset}   | ${red_bg}  ${italic}redy  ${reset} | |     ${black}|
${black}|${reset}   ${red}[_.'  ${yellow}I am old   ${red}'._]${reset}                                                                                   | +----------+----------+ |     ${black}|
${black}|${reset}     ${red}| ${green}.-----------.${reset} ${red}|${reset}       ${green}o${reset}  ${green}o${reset}                                  ${magenta}∆${reset} Hardware ${yellow}»»»»»»»${blue}»»»»»»${green}»»»»»» ${magenta}∆${reset}        | |  ${yellow}${italic}yellow${reset}  | ${yellow_bg} ${italic}yellow ${reset} | |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan}  .-\"\"\"-.  ${green}| ${red}|${reset}       ${green}o${yellow}\/${green}o o${reset}          ${blue}.${reset}                     ${red}♥${reset} ${dev_str}        | +----------+----------+ |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} /    /  \ ${green}| ${red}|${reset}      ${green}oo${yellow}|/o${reset}            ${blue}|${reset}                     ${yellow}♥${reset} ${ram_str}        | |  ${green}${italic}greeny${reset}  | ${green_bg} ${italic}greeny ${reset} | |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan}|-   <   -|${green}| ${red}|${reset}      ${yellow} \|${green}o${reset}        ${yellow}_____${blue}|${reset}                     ${green}♥${reset} ${res_str}        | +----------+----------+ |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} \    \  / | ${red}|${reset}       ${magenta}_${yellow}|${magenta}__${reset}      ${yellow}|######|${reset}                                                            | |   ${blue}${italic}blue${reset}   | ${blue_bg}  ${italic}blue  ${reset} | |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan}[\`'-...-'\`]| ${red}|${reset}      ${magenta}|....|${reset}     ${yellow}|######|${reset}                    ${magenta}∆${reset} Software ${yellow}»»»»»»»${blue}»»»»»»${green}»»»»»» ${magenta}∆${reset}        | +----------+----------+ |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} ;-.___.-; ${green}| ${red}|${reset}     ${green}__${magenta}\__/${green}_______${yellow}:${green}____${yellow}:${green}__${reset}                   ${red}♥${reset} ${wm_str}        | |   ${magenta}${italic}pink${reset}   | ${magenta_bg}  ${italic}pink  ${reset} | |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}     ${green}°___________________°${reset}                   ${yellow}♥${reset} panel ..........${cyan}o${reset}${bar_str}        | +----------+----------+ |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}        ${green} \\\\\ ${reset}        ${green} // ${reset}                     ${green}♥${reset} editor ....${cyan}o${reset}...${cyan}/​${reset}${editor_str}        | |   ${cyan}${italic}cyan${reset}   | ${cyan_bg}  ${italic}cyan  ${reset} | |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}                                                           ${cyan}\ /​${reset}                       | +----------+----------+ |     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} | ${yellow}_|||_ ${cyan}| ${green}| ${red}|${reset}           ${cyan}˛-˛${reset}                                 ${yellow}+------------${cyan}v${yellow}-----------+${reset}            \_________________________/     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} | ${yellow}>===< ${cyan}| ${green}| ${red}|${reset}          ${cyan}(_._)${reset}   _    ${magenta}, _${reset}                     ${yellow}|${reset}  ${cyan}______________${reset}      ${cyan}@ ${yellow}|${reset}                                            ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} | ${yellow}|___| ${cyan}| ${green}| ${red}|${reset}         ${cyan}/${red}:${cyan}:${red}:${cyan}:${red}:${cyan}:\//${reset}   ${magenta}(| |${reset}           ${red}.|${reset}        ${yellow}|${reset} ${cyan}/              \ ${reset}      ${yellow}|${reset}                                            ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}     ${green}____${cyan}\______/'${green}_____${magenta}|_|${green}______${reset}     ${red}||${reset}        ${yellow}|${reset} ${cyan}| inspired by  |${reset}  ${red}(\)  ${yellow}|${reset}                                            ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow};-;${cyan}  | ${green}| ${red}|${reset}     ${green}°_________________________°${reset}     ${red}||${reset}        ${yellow}|${reset} ${cyan}|              |${reset}       ${yellow}|${reset}                                            ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |${reset} ${yellow}(   )${cyan} | ${green}| ${red}|${reset}       ${green}||${reset}                   ${green}||${reset}       ${red}||${reset}        ${yellow}|${reset} ${cyan}|    wooosh    |${reset}  ${red}(-)  ${yellow}|${reset}                                            ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |${reset}  ${yellow}'-'  ${cyan}| ${green}| ${red}|${reset}       ${green}||${reset}                   ${green}||${reset}       ${red}||${reset}        ${yellow}|${reset} ${cyan}\              /${reset}       ${yellow}|${reset}                                            ${black}|
${black}|${reset}     ${red}| ${green}| ${cyan}'-------'${green} | ${red}|${reset}       ${green}||${reset}                ${red}___${green}||${red}______.||${reset}        ${yellow}|${reset}  ${cyan}-${red}o${green}o${blue}o${cyan}----------${reset}  ${green}:|||: ${yellow}|${reset}                                            ${black}|
${black}|${reset}    ${red}_| ${green}'-----------'${red} |_${reset}      ${green}||${reset}                ${red}‘__${green}||${red}_______’${reset}         ${yellow}+------------------------+${reset}                                            ${black}|
${black}|${reset}   ${red}[= === === ==== == =]${reset}     ${green}||${reset}                 ${red} /${green}||${reset}     ${red} \ ${reset}              ${red}/ ${reset}           ${red} \ ${reset}                                                 ${black}|
${black}|${blue} __${red}[__--__--___--__--__]${blue}_____${green}||${blue}_________________${red}/${blue}_${green}||${blue}_______${red}\​${blue}_____________${red}O${blue}_______________${red}O${blue}________________________________________________ ${black}|
| ${blue}----------------------------------------------------------------------------------------------------------------------------------------- ${black}|
${black}+-------------------------------------------------------------------------------------------------------------------------------------------+${reset}\n"
}


if [ -z "$1" ]; then
        fetch_idk
fi

while test $# -gt 0; do
        case "$1" in
                -h | --help)
                        welcome
                        ;;
                *)
                        fetch_idk
                        exit 1
                        ;;
        esac
done

# TODO
# Make medium fetch
# Make small fetch
# Fix the shit done in big fetch
# Generalize the Software and Hardware
# options such that user can change its order,
# or display or hide what it desires, kinda like neofetch of sorts
