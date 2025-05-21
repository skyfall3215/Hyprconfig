#!/bin/bash

# wttr.in kullanarak Burdur için hava durumu bilgisi alma
LOCATION="Burdur"
weather_info=$(curl -s "https://wttr.in/$LOCATION?format=3")

if [ -z "$weather_info" ]; then
    echo '{"text": "Weather Unavailable", "class": "unavailable"}'
    exit 0
fi

# Çıktı formatını düzenleme (emojileri koruyarak)
echo "{\"text\": \"$weather_info\", \"tooltip\": \"Burdur Hava Durumu\", \"class\": \"weather\"}"
