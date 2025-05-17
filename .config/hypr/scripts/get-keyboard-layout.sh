#!/bin/bash

# Bu script aktif klavye düzenini kontrol eder ve formatlar
# Script her çalıştırıldığında güncel durumu gösterir

# Hyprland'dan mevcut düzeni al
LAYOUT=$(hyprctl getoption input:kb_layout -j | jq -r '.str')
ACTIVE_IDX=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name | contains("Virtual") | not) | .active_layout')

# Düzenleri diziye ayır
IFS=',' read -ra LAYOUTS <<< "$LAYOUT"

# Aktif düzen indeksini al (0 veya 1)
if [[ "$ACTIVE_IDX" =~ ^[0-9]+$ ]]; then
    CURRENT_LAYOUT=${LAYOUTS[$ACTIVE_IDX]}
else
    # Eğer indeks alınamazsa ilk düzeni kullan
    CURRENT_LAYOUT=${LAYOUTS[0]}
fi

# Düzen ismini kısalt (turkish -> TR, us -> US)
case "${CURRENT_LAYOUT,,}" in
    "turkish"|"tr")
        echo "TR"
        ;;
    "us"|"english"|"en")
        echo "US"
        ;;
    *)
        # Diğer düzenler için ilk iki harfi büyük harfle göster
        echo "${CURRENT_LAYOUT:0:2}" | tr '[:lower:]' '[:upper:]'
        ;;
esac
