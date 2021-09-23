#!/bin/bash

# Frenzy's personal fetch

# DISCLAIMER
# Don't try this at home, don't show it to children, don't show it your co-workers,
# don't show it to #bash at Freenode, don't show it to members of the POSIX committee,
# don't show it to Mr. Bourne, maybe show it to father McCarthy's ghost to give him a
# laugh. You have been warned, and you never found this in my repo.

# Dependancies
MYSELF="$(readlink -f "$0")"
MYDIR="${MYSELF%/*}"
# shellcheck source=./info.sh
source "$MYDIR/info.sh" # FETCH INFO
source "$MYDIR/constants.sh" # CONSTANTS OR SOMETHING IDFK
#------------------------------------------------------------#
# WARNING:                                                   #
# THIS FOLLOWING SECTION SHOWS THE ROADMAP FOR FRENCH.       #
# THEREFORE THE FOLLOWING DOC SECTION MAY NOT APPLY TO THIS  #
# VERSION AS FRENCH IS EARLY ACCESS AND I'M LAZY AF          #
#------------------------------------------------------------#

welcome() {
        printf "%b" "\
${yellow}███████ ██████  ███████ ███    ██ ███████  ██████ ██   ██ 
${yellow}██      ██   ██ ██      ████   ██    ███  ██      ██   ██ 
${blue}█████   ██████  █████   ██ ██  ██   ███   ██      ███████ 
${magenta}██      ██   ██ ██      ██  ██ ██  ███    ██      ██   ██ 
${magenta}██      ██   ██ ███████ ██   ████ ███████  ██████ ██   ██ 
${reset}

»»» The most overcomplicated fetch to exist
 
${blue}version ${yellow}${version[0]}${magenta}: ${green}${version[1]}${reset}

 » Requires bash v4.3+ 

Options:
   -v | --version -> version of the Script
   -h | --help    -> prints this section
   -c | --config  -> override default config location 
                     the file name is «boi» btw
   -a | --args    -> will output fetch info you want, sort of
                     EXAMPLE:  
                     » frenzch.sh --args cpu, resolution, uptime, kernel, panel
"
    exit 1
}

fetch_idk() {
    # READ CONFIG
    if test -f "$config_dir" ; then # In case the config is deleted or something idk
        source "$config_dir"
    else
        source "$MYDIR/config"
    fi
    
    info_shit
    get_term_size 
    padding=$(( (term_width-1)/2))
    clear
    [[ $term_height -ge 34 ]] && [[ $term_width -ge 130 ]] && big_fetch &&  exit 1
    [[ $term_height -ge 24 ]] && [[ $term_width -ge 47 ]] && medium_fetch && exit 1
    [[ $term_height -ge 15 ]] && [[ $term_width -ge 42 ]] && small_fetch && exit 1
    [[ $term_height -ge 14 ]] && [[ $term_width -ge 30 ]] && extra_small_fetch || printf "Please make the terminal window larger!"
}

info_shit() {
    # each of these variables contains info bout how their 
    # respective info will be printed, ie if info will be a short version or a long version

    for i in "${args[@]}" ; do
        case $i in
        us) # Get username or somemthing
            software_name[${#software_name[@]}]="$i"
            get_user
            ;;
        os)
            software_name[${#software_name[@]}]="$i"
            get_os
            ;;
        wm)
            software_name[${#software_name[@]}]="$i"
            get_wm
            ;;
        editor)
            software_name[${#software_name[@]}]="$i"
            get_editor
            ;;
        panel|bar)
            get_panel
            software_name[${#software_name[@]}]="$i"
            ;;
        resolution|display) # Get resolution
            hardware_name[${#hardware_name[@]}]="$i"
            get_resolution
            ;;
        ram|ram_free|ram_used) # Get RAM mema
            hardware_name[${#hardware_name[@]}]="ram"
            get_ram "$1"
            ;;
        device) # Get device (pc model) name
            hardware_name[${#hardware_name[@]}]="$i"
            get_device
            ;;
        gpu) # get graphics card
            hardware_name[${#hardware_name[@]}]="$i"
            get_gpu
            ;;
        kern)
            software_name[${#software_name[@]}]="$i"
            get_kernel
            ;;
        shell)
            software_name[${#software_name[@]}]="$i"
            ;;
        de)
            software_name[${#software_name[@]}]="$i"
            ;;
        cpu)
            hardware_name[${#hardware_name[@]}]="$i"
            ;;
        cpu_cores)
            hardware_name[${#hardware_name[@]}]="$i"
            ;;
        esac
    done

    declare -n i
    local j=0
    for i in "${hardware_name[@]}" ; do
        hardware+=([${hardware_name[j]}]="$i")
        unset i # Removes the vars created in info.sh
        ((j++))
    done

    declare -n i
    j=0
    for i in "${software_name[@]}" ; do
        software+=([${software_name[j]}]="$i")
        unset i # Removes the vars created in info.h
        ((j++))
    done ; unset j
}

extra_small_fetch() {
    local boi="\n"
    colors=( "$cyan" "$red" "$green" "$magenta" "$blue" "$yellow" "$green" "$magenta" "$red" "$cyan" "$yellow" "$blue" "$green")
    seed=${#colors[@]}

    for i in ${order[@]} ; do
        case $i in  
            software)
                for i in "${software_name[@]}" ; do
                    color=$(($RANDOM%${seed}))
                    color2=$(($RANDOM%${seed}))
                    boi+=$(printf "${colors[$color2]}%8s : ${colors[$color]}%-6s %0s" "$i" "${software["$i"]}" "\n")
                done
            ;;
            hardware)
                for i in "${hardware_name[@]}" ; do
                    color=$(($RANDOM%${seed}))
                    color2=$(($RANDOM%${seed}))
                    boi+=$(printf "${colors[$color2]}%8s : ${colors[$color]}%-6s %0s" "$i" "${hardware["$i"]}" "\n")
                done
                ;;
        esac
    done
    boi=$(printf '%b' "$boi")
    print="$print\\033[1B"
    print_textart "$boi" $(( (term_width/2 - 1) - 10 ))
    print="$print\\033[1B"
    printf "$print${reset}\n"
    unset boi
}

small_fetch() {

meep=$(printf '%b' "\
${cyan}        ______
${cyan}       /ゝ    フ
${cyan}      |   _  _|
${cyan}      /,ミ__Xノ
${cyan}    /       |
${cyan}   /  \    ノ
${cyan} __│  | |  |
${cyan}/ _|   | |  |
${cyan}|(_\___\_)__)
${cyan} \_つ${reset}")

    local maap="" ; local ten="          "
    local colors=( "$cyan" "$red" "$green" "$magenta" "$blue" "$yellow" "$green" "$magenta" "$red" "$cyan" "$yellow" "$blue" "$green")
    local seed=${#colors[@]} ; local fetch_begin=5 ; local fetch_end=3

    for i in ${order[@]} ; do
        case $i in  
            hardware)
                for i in "${hardware_name[@]}" ; do
                    color=$(($RANDOM%${seed}))
                    y="$i"
                    y="${y:0:10}${ten:0:$((10 - ${#y}))}"
                    maap+=$(printf "${colors[$color]}%s %s %s" "$y" "${hardware["$i"]}" "\n")
                done
                ;;
            software)
                for i in "${software_name[@]}" ; do
                    color=$(($RANDOM%${seed}))
                    y="$i"
                    y="${y:0:10}${ten:0:$((10 - ${#y}))}"
                    maap+=$(printf "${colors[$color]}%s %s %s" "$y" "${software["$i"]}" "\n")
                done
                ;;
        esac
    done ; unset seed ten colors
    maap=$(printf '%b' "$maap")
    END=$(( ${#software_name[@]} + ${#hardware_name[@]} ))
    print="$print\\033[${fetch_begin}E"
    print_textart "$maap\n" $(( $padding ))
    print="$print\\033[9999999D\\033[$(( $END+1 ))A"
    print_textart "$meep" $(( $padding - 23 ))
    print="$print\\033[${fetch_end}B"
    printf "$print\n"
}

medium_fetch() {  
    maap=""
    colors=($red $yellow $green $blue $magenta $cyan)
    seed=${#colors[@]} ; n=32 ; j=0
    ten=$(repeat_char $n ".")
    
    for i in ${order[@]} ; do
    case $i in
        software)
            [[ "$space" == 'true' ]] && maap+="\n"
            [[ "${#software_name}" -ne 0 ]] && {
                maap+="$(decor_thingy "∆" "»" "Software" 32 "${magenta}")\n"
                    for i in "${software_name[@]}" ; do 
                        y="$i"
                        y="${y:0:${n}} ${ten:0:$((${n} - ${#y} - ${#software["$i"]}))}"
                        color=$(($j%${seed})) ; ((j++))
                        maap+=$(printf "${colors[$color]}♥ ${reset}%s %s %s" "$y" "${software["$i"]}" "\n")
                    done ; j=0
                    space='true'
            }
        ;;
        hardware)
            [[ "$space" == 'true' ]] && maap+="\n"
            [[ "${#hardware_name}" -ne 0 ]] && {
                maap+="$(decor_thingy "∆" "»" "Hardware" 32 "${magenta}")\n"
                for i in "${hardware_name[@]}" ; do 
                    y="$i"
                    y="${y:0:${n}} ${ten:0:$((${n} - ${#y} - ${#hardware["$i"]}))}"
                    color=$(($j%${seed})) ; ((j++))
                    maap+=$(printf "${colors[$color]}♥ ${reset}%s %s %s" "$y" "${hardware["$i"]}" "\n")
                done
                space='true'
            }
        ;;
    esac
done
    
    meep=$(printf '%b' "\
${black}│                                            │
${black}│          ${cyan}˛-˛${reset}                               ${black}│
${black}│         ${cyan}(_._)_${reset}  _     ${magenta}, _${reset}                  ${black}│
${black}│        ${cyan}/${red}:${cyan}:${red}:${cyan}:${red}:${cyan}:\//${reset}    ${magenta}(| |${reset}           ${red}.|${reset}     ${black}│
${black}│    ${green}____${cyan}\______/'${green}______${magenta}|_|${green}______${reset}     ${red}||${reset}     ${black}│
${black}│    ${green}°__________________________°${reset}     ${red}||${reset}     ${black}│
${black}│      ${green}||${reset}                    ${green}||${reset}       ${red}||${reset}     ${black}│
${black}│      ${green}||${reset}                    ${green}||${reset}       ${red}||${reset}     ${black}│
${black}│      ${green}||${reset}                 ${red}___${green}||${red}______.||${reset}     ${black}│
${black}│      ${green}||${reset}                 ${red}‘__${green}||${red}_______’${reset}      ${black}│
${black}│      ${green}||${reset}                  ${red} /${green}||${reset}     ${red} \       ${black}│
${black}│${blue}――――――${green}||${blue}――――――――――――――――――${red}/${blue}―${green}||${blue}―――――――${red}\​${blue}――――――${black}│
${black}└────────────────────────────────────────────┘${reset}")

    END=$(( ${#software_name[@]} + ${#hardware_name[@]} ))
    empty=""
    for ((i=1;i<=$((END+3));i++)) ; do
        empty+="${black}│                                            │\n"
    done

    print_textart "${black}┌────────────────────────────────────────────┐\n" $(( $padding - 23 ))
    print_textart "${black}│                                            │\n" $(( $padding - 23 ))
    print_textart "$(printf '%b' "$empty")" $(( $padding - 23 ))
    print="$print\\033[9999999D\\033[$(( $END+2 ))A"
    print_textart "$(printf '%b' "$maap")\n" $(( (term_width - 37)/2 ))
    print_textart "$meep" $(( $padding - 23 ))
    printf "$print\n"
}

big_fetch() {
    
    # red yellow green blue magenta cyan

    colors=$(printf '%b' "\
 _________________________
/                         \
| +----------+----------+ |
| |   ${red}${italic}redy${reset}   | ${red_bg}  ${italic}redy  ${reset} | |
| +----------+----------+ |
| |  ${yellow}${italic}yellow${reset}  | ${yellow_bg} ${italic}yellow ${reset} | |
| +----------+----------+ |
| |  ${green}${italic}greeny${reset}  | ${green_bg} ${italic}greeny ${reset} | |
| +----------+----------+ |
| |   ${blue}${italic}blue${reset}   | ${blue_bg}  ${italic}blue  ${reset} | |
| +----------+----------+ |
| |   ${magenta}${italic}pink${reset}   | ${magenta_bg}  ${italic}pink  ${reset} | |
| +----------+----------+ |
| |   ${cyan}${italic}cyan${reset}   | ${cyan_bg}  ${italic}cyan  ${reset} | |
| +----------+----------+ |
\_________________________/
")

    meep=$(printf '%b' "\
${black}+------------------------------------${magenta}×${black}------------------------------------------------------------------------------------------------------+${reset}
${black}|${reset}                                    ${magenta}|${reset}                                                                                                      ${black}|
${black}|${reset}             ${yellow}O${reset}                      ${magenta}|${reset}                                                                                                      ${black}|
${black}|${reset}            ${red}(_)${reset}                     ${magenta}|${reset}                                                                                                      ${black}|
${black}|${reset}          ${red}_ )_( _${reset}                   ${magenta}A${reset}                                                                                                      ${black}|
${black}|${reset}        ${red}/\`_) H (_\`\  ${reset}              ${yellow}/|\                                                                                                     ${black}|
${black}|${reset}      ${red}.' (  { }  ) '.${reset}             ${yellow}/-|-\                                                                                                    ${black}|
${black}|${reset}    ${red}_/ /\` '-'='-' \`\ \_${reset}           ${yellow}\_|_/                                                                                                    ${black}|
${black}|${reset}   ${red}[_.'  ${yellow}I am old   ${red}'._]${reset}                                                                                                                   ${black}|
${black}|${reset}     ${red}| ${green}.-----------.${reset} ${red}|${reset}       ${green}o${reset}  ${green}o${reset}                                                                                                          ${black}|
${black}|${reset}     ${red}| ${green}|${cyan}  .-\"\"\"-.  ${green}| ${red}|${reset}       ${green}o${yellow}\/${green}o o${reset}          ${blue}.${reset}                                                                                             ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} /    /  \ ${green}| ${red}|${reset}      ${green}oo${yellow}|/o${reset}            ${blue}|${reset}                                                                                             ${black}|
${black}|${reset}     ${red}| ${green}|${cyan}|-   <   -|${green}| ${red}|${reset}      ${yellow} \|${green}o${reset}        ${yellow}_____${blue}|${reset}                                                                                             ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} \    \  / | ${red}|${reset}       ${magenta}_${yellow}|${magenta}__${reset}      ${yellow}|######|${reset}                                                                                            ${black}|
${black}|${reset}     ${red}| ${green}|${cyan}[\`'-...-'\`]| ${red}|${reset}      ${magenta}|....|${reset}     ${yellow}|######|${reset}                                                                                            ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} ;-.___.-; ${green}| ${red}|${reset}     ${green}__${magenta}\__/${green}_______${yellow}:${green}____${yellow}:${green}__${reset}                                                                                           ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}     ${green}°___________________°${reset}                                     ${cyan}o${reset}                                                     ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}        ${green} \\\\\ ${reset}        ${green} // ${reset}                     ${green}♥${reset} editor ....${cyan}o${reset}...${cyan}/​${reset}                                                      ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} |  ${yellow}|||${cyan}  | ${green}| ${red}|${reset}                                                           ${cyan}\ /​${reset}                                                       ${black}|
${black}|${reset}     ${red}| ${green}|${cyan} | ${yellow}_|||_ ${cyan}| ${green}| ${red}|${reset}           ${cyan}˛-˛${reset}                                 ${yellow}+------------${cyan}v${yellow}-----------+                                            ${black}|
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
${black}| ${blue}----------------------------------------------------------------------------------------------------------------------------------------- ${black}|
${black}+-------------------------------------------------------------------------------------------------------------------------------------------+${reset}")
    
    print_textart "$meep" $(( $padding - 70 ))
    printf "$print"

}

check_stuff

[ -z "$1" ] && fetch_idk

while test $# -gt 0; do
    case "$1" in
     -h | --help)
        welcome
        ;;
    -v | --version)
        printf "${blue}Version ${yellow}${version[0]}${magenta}: ${green}${version[1]}${reset}\n"
        exit 1
        ;;
    -c | --config)
        read -r config_dir <<< "$2"
        ;;
    -a | --args)
        shift
        # From https://stackoverflow.com/a/47500443
        args=() ; str="$@"
        while [[ "$str" =~ ([^,]+)(,[ ]+|$) ]] ; do
            args+=("${BASH_REMATCH[1]}")  # capture the field
            i=${#BASH_REMATCH}            # length of field + delimiter
            str=${str:i}                  # advance the string by that length
        done ; unset str                  # the loop deletes $str, yay
        ;;
    *)
        fetch_idk
        ;;
    esac
done

# TODO
# Fix the shit done in big fetch
# Generalize the Software and Hardware
# options such that user can change its order,
# or display or hide what it desires, kinda like neofetch of sorts
