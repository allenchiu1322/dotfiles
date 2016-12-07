#!/bin/bash
if [ -f /home/$USER/tmp/hourly.weather ]; then
    if [ -f /usr/bin/ansiweather ]; then
        /usr/bin/ansiweather
        rm /home/$USER/tmp/hourly.weather
    fi
fi
