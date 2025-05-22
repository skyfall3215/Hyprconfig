#!/bin/bash

# Güncellemeleri kontrol et ve sayısını döndür
updates=$(checkupdates 2>/dev/null | wc -l)

# Eğer checkupdates komutu hata verirse veya çıktı boşsa
if [ -z "$updates" ] || [ "$updates" -eq 0 ]; then
    # Güncelleme yoksa veya hata oluştuysa
    echo '{"text": " 0", "tooltip": "Güncelleme yok", "class": "no-updates"}'
else
    # Güncelleme varsa, sayısını ve bilgilerini göster
    tooltip=$(checkupdates 2>/dev/null | awk '{print $1 " -> " $4}' | tr '\n' ', ' | sed 's/,$//')
    echo '{"text": " '"$updates"'", "tooltip": "'"$tooltip"'", "class": "has-updates"}'
fi

