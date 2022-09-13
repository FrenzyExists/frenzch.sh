#!/bin/bash

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

version=("0.3" "Checkerboards and Cigarretes")
config_dir="$HOME/.config/frenzch.sh/boi"

declare -A hardware # Hardware Hash
declare -A software # Software Hash

declare -a hardware_name=()
declare -a software_name=()
