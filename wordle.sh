#!/bin/bash

: <<'notice'
 *
 * Copyright (C) 2022 Pulkit Agarwal
 *
 * About: Kang of famous Wordle Game
 *
notice

# Fancy Colors
# Reset
Color_Off="\033[0m"           # Text Reset

# Normal Bold
BGreen="\033[1;32m"           # Green

# Bold High Intensty colors
BIRed="\033[1;91m"            # Red
BIYellow="\033[1;93m"         # Yellow
BIBlue="\033[1;94m"           # Blue
BIPurple="\033[1;95m"         # Purple
BICyan="\033[1;96m"           # Cyan
BIWhite="\033[1;97m"          # White

# Execute database to get random word
. database.sh

# unset the current word if any and export new word
unset WORD

# Use Default word if input doesn't provide word
if [ "$#" -ne 1 ]; then
    WORD="${WORD_DATABASE^^}"
else
    WORD="${1^^}"
fi

# read char array length for loop
N="${#WORD}"

# Print Rules
Rules() {
    clear
    printf "%b============================================================================\n%b" "$BIPurple" "$Color_Off"
    printf "%b\nWelcome to Worble (Kang of Wordle)\n\n%b" "$BICyan" "$Color_Off"
    printf "%bRules: %b" "$BIRed" "$Color_Off"
    printf "%b1) You get certain number of chances to guess the correct word\n%b" "$BIBlue" "$Color_Off"
    printf "%b       2) Word that you entered should have some meaning\n%b" "$BIBlue" "$Color_Off"
    printf "%b\nHow To Play: %b" "$BIRed" "$Color_Off"
    printf "%b After each guess, the output color will change to show how\n" "$BIBlue"
    printf "              close your guess was to the word.\n"
    printf "              If the letter is in the word and in the correct spot, it will\n"
    printf "              show in green. But if the letter is in the word but in the\n"
    printf "              wrong spot, it will show in Orange. Else Normal\n"
    printf "%b\n============================================================================\n\n%b" "$BIPurple" "$Color_Off"
    sleep 2
}

# Function to Print Word for DEBUGGING
Debugging_Daily_Word() {
    printf "DEBUGGER IS ON: Today's word is: "
    for (( i=0; i<"$N"; i++)); do
        printf "%b${WORD:$i:1} %b" "$BGreen" "$Color_Off";
    done
    printf "\n\n"
}

# Function to read input from user
Read_Input() {
    printf "Enter your word: "
    read input
    input_word=${input^^}
    printf "\n"
    if [[ "${#input_word}" != "$N" ]]; then
        printf "%bInput Word should be of length $N %b\n" "$BIRed" "$Color_Off"
        Read_Input
    fi
}

# Function to check word is on place
Word_IsOnPlace() {
    # for every specific place of i, check if word belongs to that place to print it in green
    for (( i=0; i<"$N"; i++)); do
        if [[ "${input_word:$i:1}" == "${WORD:$i:1}" ]]; then
            printf "%b${input_word:$i:1} %b" "$BGreen" "$Color_Off"
        else
            # else check if word matches with any other char in WORD to print it Yellow
            for (( j=0; j<"$N"; j++)); do
                CONDITION=0
                if [[ "${input_word:$i:1}" == "${WORD:$j:1}" ]]; then
                    printf "%b${input_word:$i:1} %b" "$BIYellow" "$Color_Off"
                    # if word exists on any other location in char,
                    # set condition flag to 1
                    CONDITION=1
                    break
                fi
            done
            # since word doesn't exists on any other location since condition is 0
            # print word directly in no colour
            if [[ "$CONDITION" == 0 ]]; then
                printf "${input_word:$i:1} "
            fi
        fi
    done
    printf "\n\n"
}

# Function to check if entered word is correct then exit
Word_FinalCongoIfRight() {
    if [[ "$input_word" == "$WORD" ]]; then
        printf "%bCongratulations, You just found the word%b\n" "$BIWhite" "$Color_Off"
        for (( i=0; i<"$N"; i++)); do
            printf "%b${WORD:$i:1} %b" "$BGreen" "$Color_Off"
        done
        printf "\n"
        FLAG=1
    else
        Word_IsOnPlace
    fi
}

main() {
    ## Function Calls

    # Print rules and information first
    Rules

    # Only for debugging purposes
#    Debugging_Daily_Word

    # Once at the start print Input Length Msg
    printf "%bInput Word should be of length $N %b\n\n\n" "$BIRed" "$Color_Off"

    USER_LIMIT=0
    FLAG=0
    while [[ "$FLAG" != 1 && "$USER_LIMIT" != $(("$N" + 1)) ]]; do
        if [[ "$(("$N" + 1 - "$USER_LIMIT"))" == 1 ]]; then
            printf "%b$(("$N" + 1 - "$USER_LIMIT")) attempt remaining%b\n" "$BIPurple" "$Color_Off"
        else
            printf "%b$(("$N" + 1 - "$USER_LIMIT")) attempts remaining%b\n" "$BIPurple" "$Color_Off"
        fi
        Read_Input
        Word_FinalCongoIfRight
        # increment variable using POSIX faster and better
        USER_LIMIT=$((USER_LIMIT + 1))
    done
    if [[ "$FLAG" != 1 && "$USER_LIMIT" == $(("$N" + 1)) ]]; then
        printf "%bBetter luck next time!!%b\n" "$BIBlue" "$Color_Off"
    fi
}

# Off cursor for time being now
setterm -cursor off

main

# Turn back cursor on.
setterm -cursor on
