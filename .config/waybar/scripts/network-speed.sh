#!/bin/bash

INTERFACE="$(ip route get 8.8.8.8 2>/dev/null | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')"

if [[ -z "$INTERFACE" ]]; then
    echo '{"text": "No Connection", "class": "disconnected"}'
    exit 0
fi

# İlk ölçüm
R1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
T1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
sleep 1
# İkinci ölçüm
R2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
T2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

# Hız hesaplama (Mbps)
RBPS=$(( (R2 - R1) * 8 / 1000000 ))
TBPS=$(( (T2 - T1) * 8 / 1000000 ))

# Daha düşük değerlerde Kbps kullanma
if [[ $RBPS -lt 1 ]]; then
    RKBPS=$(( (R2 - R1) * 8 / 1000 ))
    RUNIT="Kbps"
else
    RKBPS=$RBPS
    RUNIT="Mbps"
fi

if [[ $TBPS -lt 1 ]]; then
    TKBPS=$(( (T2 - T1) * 8 / 1000 ))
    TUNIT="Kbps"
else
    TKBPS=$TBPS  
    TUNIT="Mbps"
fi

# Çıktı formatı
echo "{\"text\": \"↓ ${RKBPS} ${RUNIT} ↑ ${TKBPS} ${TUNIT}\", \"tooltip\": \"Network usage\nDownload: $RKBPS $RUNIT\nUpload: $TKBPS $TUNIT\nInterface: $INTERFACE\", \"class\": \"connected\"}"
