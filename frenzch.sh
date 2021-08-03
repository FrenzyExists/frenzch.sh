#!/usr/bin/env bash

# Frenzy's personal fetch (querido Neofetch, vete pal' carajo)


# DISCLAIMER
# Don't try this at home, don't show it to children, don't show it your co-workers, 
# don't show it to #bash at Freenode, don't show it to members of the POSIX committee, 
# don't show it to Mr. Bourne, maybe show it to father McCarthy's ghost to give him a 
# laugh. You have been warned, and you never found this in my repo.

# CONSTANTS OR SOMETHING IDFK
red="\e[0;31m"
yellow="\e[0;33m"
green="\e[0;32m"
blue="\e[0;34m"
magenta="\e[0;35m"
cyan="\e[0;36m"
black="\e[0;30m"
black_2="\e[0;90m"
reset="\e[0m"
white="\e[0;97m"

red_bg="\e[0;30;101m"
green_bg="\e[0;30;102m"
yellow_bg="\e[0;30;103m"
blue_bg="\e[0;30;104m"
magenta_bg="\e[0;30;105m"
cyan_bg="\e[0;30;106m"

bold="\e[1m"
italic="\e[3m"


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
    col=$(stty size | awk '{print $2}')
    row=$(stty size | awk '{print $1}')
    if (( "$row" >= 34 )) && (( "$col" >= 142 )) ; then
        big_fetch
    else
        echo "Yo! Make the terminal window larger!"
    fi

}

info_shit() {
    for os in /etc/os-release /usr/lib/os-release; do
        [ -f $os ] && . $os && break
    done
    os=$( echo ${PRETTY_NAME})
    read -r _ _ version _ < /proc/version

    sh=$(basename $SHELL)
    os_type="${OSTYPE//[0-9.]/}"
    if [[ "$os_type" == "linux-gnu"* ]] ; then
        wm=$(echo $XDG_SESSION_DESKTOP)
    elif [[ "$os_type" == "darwin"* ]] ; then 
        if (( $(pgrep -lfc yabai) != 0 )) || (( $(pgrep -lfc amehtsysty) != 0 )) || (( $(pgrep -lfc spectacle) != 0 )); then
            wm="yabai"
        fi
    fi
    us="$USER"

    device_name=$(echo $(cat /sys/devices/virtual/dmi/id/product_name | tr '[:upper:]' '[:lower:]'))
    editor=$(basename $EDITOR)

    ram_mem="$(free -h | awk 'NR == 2 {printf("%s", $2)}' | tr '[:upper:]' '[:lower:]' | sed 's/[a-z]*//g') gb"

    res="$(xdpyinfo | awk '/dimensions:/ {printf("%s", $2)}')"
    
    # add more if you know some other bar or something idkf
    declare -a bar_list=("polybar" "tint2" "lemonbar" "eww")
    
    for b in "${bar_list[@]}" ; do
       if (( $(pgrep -lfc "$b") != 0 )) ; then
           bar="$b"
           break
        fi
    done
}


big_fetch() {
    info_shit

# The size of the each fetch itself is 32 characters long, since I'm a newb on this that's the size hardcoded
# I'll change this part, trust me

size=$(( 32 - $(echo $ram_mem | wc -m) - $(echo "ram" | wc -m) - 2))
ram_str=$(echo "ram" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$ram_mem" )

size=$(( 32 - $(echo $device_name | wc -m) - $(echo "laptop" | wc -m) - 2))
dev_str=$(echo "laptop" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$device_name" )

size=$(( 32 - $(echo $res    | wc -m) - $(echo "display" | wc -m) - 2))
res_str=$(echo "display" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$res" )

size=$(( 32 - $(echo $wm | wc -m) - $(echo "w. manager" | wc -m) - 2))
wm_str=$(echo "w. manager" $(echo " " | sed -e :a -e 's/^.\{1,'"$size"'\}$/.&/;ta') "$wm" )

printf "${black}+------------------------------------${magenta}×${black}------------------------------------------------------------------------------------------------------+${reset}\n"
printf "${black}|${reset}                                    ${magenta}|${reset}                                                                                                      ${black}|\n"
printf "${black}|${reset}             ${yellow}O${reset}                      ${magenta}|${reset}                                                                                                      ${black}|\n"
printf "${black}|${reset}            ${red}(_)${reset}                     ${magenta}|${reset}                                                                                                      ${black}|\n"
printf "${black}|${reset}          ${red}_ )_( _${reset}                   ${magenta}A${reset}                                                                       _________________________      ${black}|\n"
printf "${black}|${reset}        ${red}/\`_) H (_\`\  ${reset}              ${yellow}/|\                                                                     ${reset}/                         \     ${black}|\n"
printf "${black}|${reset}      ${red}.\' (  { }  ) \'.${reset}             ${yellow}/-|-\                                                                    ${reset}| +----------+----------+ |     ${black}|\n"
printf "${black}|${reset}    ${red}_/ /\` '-'='-' \`\ \_${reset}           ${yellow}\_|_/                                 ${reset}$us       ${os}              | |   ${red}${italic}redy${reset}   | ${red_bg}  ${italic}redy  ${reset} | |     ${black}|\n"
printf "${black}|${reset}   ${red}[_.'  ${yellow}I am old   ${red}'._]${reset}                                                                                   | +----------+----------+ |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}.-----------.${reset} ${red}|${reset}       ${green}o${reset}  ${green}o${reset}                                  ${magenta}∆${reset} Hardware ${yellow}»»»»»»»${blue}»»»»»»${green}»»»»»» ${magenta}∆${reset}        | |  ${yellow}${italic}yellow${reset}  | ${yellow_bg} ${italic}yellow ${reset} | |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan}  .-\"\"\"-.  ${green}| ${red}|${reset}       ${green}o${yellow}\/${green}o o${reset}          ${blue}.${reset}                     ${red}♥${reset} ${dev_str}        | +----------+----------+ |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} /    /  \ ${green}| ${red}|${reset}      ${green}oo${yellow}|/o${reset}            ${blue}|${reset}                     ${yellow}♥${reset} ${ram_str}        | |  ${green}${italic}greeny${reset}  | ${green_bg} ${italic}greeny ${reset} | |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan}|-   <   -|${green}| ${red}|${reset}      ${yellow} \|${green}o${reset}        ${yellow}_____${blue}|${reset}                     ${green}♥${reset} ${res_str}        | +----------+----------+ |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} \    \  / | ${red}|${reset}       ${magenta}_${yellow}|${magenta}__${reset}      ${yellow}|######|${reset}                                                            | |   ${blue}${italic}blue${reset}   | ${blue_bg}  ${italic}blue  ${reset} | |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan}[\`\'-...-\'\`]| ${red}|${reset}      ${magenta}|....|${reset}     ${yellow}|######|${reset}                    ${magenta}∆${reset} Software ${yellow}»»»»»»»${blue}»»»»»»${green}»»»»»» ${magenta}∆${reset}        | +----------+----------+ |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} ;-.___.-; ${green}| ${red}|${reset}     ${green}__${magenta}\__/${green}_______${yellow}:${green}____${yellow}:${green}__${reset}                   ${red}♥${reset} ${wm_str}        | |   ${magenta}${italic}pink${reset}   | ${magenta_bg}  ${italic}pink  ${reset} | |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}     ${green}°___________________°${reset}                   ${yellow}♥${reset} panel ..........${cyan}o${reset}..... ${bar}        | +----------+----------+ |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}        ${green} \\\\\ ${reset}        ${green} // ${reset}                     ${green}♥${reset} editor ....${cyan}o${reset}...${cyan}/​${reset}......... ${editor}        | |   ${cyan}${italic}cyan${reset}   | ${cyan_bg}  ${italic}cyan  ${reset} | |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}                                                           ${cyan}\ /​${reset}                       | +----------+----------+ |     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} | ${yellow}_|||_ ${cyan}| ${green}| ${red}|${reset}           ${cyan}˛-˛${reset}                                 ${yellow}+------------${cyan}v${yellow}-----------+${reset}            \_________________________/     ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} | ${yellow}>===< ${cyan}| ${green}| ${red}|${reset}          ${cyan}(_._)${reset}   _    ${magenta}, _${reset}                     ${yellow}|${reset}  ${cyan}______________${reset}      ${cyan}@ ${yellow}|${reset}                                            ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} | ${yellow}|___| ${cyan}| ${green}| ${red}|${reset}         ${cyan}/${red}:${cyan}:${red}:${cyan}:${red}:${cyan}:\//${reset}   ${magenta}(| |${reset}           ${red}.|${reset}        ${yellow}|${reset} ${cyan}/              \ ${reset}      ${yellow}|${reset}                                            ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}     ${green}____${cyan}\______/'${green}_____${magenta}|_|${green}______${reset}     ${red}||${reset}        ${yellow}|${reset} ${cyan}| inspired by  |${reset}  ${red}(\)  ${yellow}|${reset}                                            ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow};-;${cyan}  | ${green}| ${red}|${reset}     ${green}°_________________________°${reset}     ${red}||${reset}        ${yellow}|${reset} ${cyan}|              |${reset}       ${yellow}|${reset}                                            ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} |${reset} ${yellow}(   )${cyan} | ${green}| ${red}|${reset}       ${green}||${reset}                   ${green}||${reset}       ${red}||${reset}        ${yellow}|${reset} ${cyan}|    wooosh    |${reset}  ${red}(-)  ${yellow}|${reset}                                            ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}|${cyan} |${reset}  ${yellow}'-'  ${cyan}| ${green}| ${red}|${reset}       ${green}||${reset}                   ${green}||${reset}       ${red}||${reset}        ${yellow}|${reset} ${cyan}\              /${reset}       ${yellow}|${reset}                                            ${black}|\n"
printf "${black}|${reset}     ${red}| ${green}| ${cyan}'-------'${green} | ${red}|${reset}       ${green}||${reset}                ${red}___${green}||${red}______.||${reset}        ${yellow}|${reset}  ${cyan}-${red}o${green}o${blue}o${cyan}----------${reset}  ${green}:|||: ${yellow}|${reset}                                            ${black}|\n"
printf "${black}|${reset}    ${red}_| ${green}'-----------'${red} |_${reset}      ${green}||${reset}                ${red}‘__${green}||${red}_______’${reset}         ${yellow}+------------------------+${reset}                                            ${black}|\n"
printf "${black}|${reset}   ${red}[= === === ==== == =]${reset}     ${green}||${reset}                 ${red} /${green}||${reset}     ${red} \ ${reset}              ${red}/ ${reset}           ${red} \ ${reset}                                                 ${black}|\n"
printf "${black}|${blue} __${red}[__--__--___--__--__]${blue}_____${green}||${blue}_________________${red}/${blue}_${green}||${blue}_______${red}\​${blue}_____________${red}O${blue}_______________${red}O${blue}________________________________________________ ${black}|\n"
printf "| ${blue}----------------------------------------------------------------------------------------------------------------------------------------- ${black}|\n"
printf "${black}+-------------------------------------------------------------------------------------------------------------------------------------------+${reset}\n"
}

if [[ "$1" == "" ]] ; then
  fetch_idk
fi

while test $# -gt 0 ; do
    case "$1" in
        -h|--help)
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
# Make the options shown more dinamic and stop hardcoding shit you fucking lazybones
