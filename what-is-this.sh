#!/usr/bin/env bash

# GLOBALS

## Variables

DATECMD=$(date)
today=${DATECMD% ??:*} 
day=${today%% *}
ddMMYYY=${today#* }
day_in_epoch=$(date -d "$ddMMYYY" +%s)

## Arrays

declare -A arrday
arrday[Mon]=1
arrday[Tue]=2
arrday[Wed]=3
arrday[Thu]=4
arrday[Fri]=5
arrday[Sat]=6
arrday[Sun]=7

#echo "${!arrday[*]}"

#echo "The day in epoch is $day_in_epoch"

greetings() {
    echo "[ + ] Hello user! Confused about which day is \"this\" and which day is \"last\"?"
    echo "[ + ] Welcome to the \"ThisDayLastDay\" Figure-Outter"
}

initial_menu() {
    echo
    echo "Today is ${day}, ${ddMMYYY}."
    choose-target-day
}

choose-target-day() {
    PS3=$'Choose a target day\n>> '
    select opt in "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun" Exit; do
        case $opt in
            "Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun")
                echo "You have chosen to find out the date of This and Last $opt"
                DAYNUM="${arrday[$opt]}"
                THISLAST
                break
            ;;
            Exit)
                echo "[ ^_^ ] Good bye!"
                exit 0
            ;;
        esac
    done
}

THISLAST() {
    if [[ $day == $opt ]]; then
        target_last_date=$(date -d @$(( $day_in_epoch - $(( 7 * 86400 )) )))
        target_next_date=$(date -d @$(( $day_in_epoch + $(( 7 * 86400 )) )))
        
        echo "Last $opt is ${target_last_date% ??:*}"
        echo "Next $opt is ${target_next_date% ??:*}"
        
    else
        DAYNUM="${arrday[$opt]}"
        TODAYNUM="${arrday[$day]}"

        if [[ $TODAYNUM -gt $DAYNUM ]]; then
            DAYMULTIPLIER=$(( $TODAYNUM - $DAYNUM ))
            target_last_date=$(date -d @$(( $day_in_epoch - $(( $DAYMULTIPLIER * 86400 )) )))
            target_next_date=$(date -d @$(( $day_in_epoch + $(( $(( 7 - $DAYMULTIPLIER )) * 86400 )) )))

            echo "Last $opt is ${target_last_date% ??:*}"
            echo "Next $opt is ${target_next_date% ??:*}"

        else
            DAYMULTIPLIER=$(( $DAYNUM - $TODAYNUM ))
            target_last_date=$(date -d @$(( $day_in_epoch - $(( $(( 7 - $DAYMULTIPLIER )) * 86400 )) )))
            target_next_date=$(date -d @$(( $day_in_epoch + $(( $DAYMULTIPLIER * 86400 )) )))

            echo "Last $opt is ${target_last_date% ??:*}"
            echo "Next $opt is ${target_next_date% ??:*}"

        fi


    fi
}

greetings
initial_menu



