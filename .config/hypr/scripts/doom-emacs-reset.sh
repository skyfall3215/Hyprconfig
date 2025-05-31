#!/usr/bin/env sh


# Mevcut daemon'u kapat (kill-emacs komutu gönder)
emacsclient -e "(kill-emacs)"

# Bir saniye bekle (daemon kapanması için)
sleep 1

# Doom Emacs daemon'u yeniden başlat
# Burada doom config'in yeri varsayılıyor ~/.config/emacs
# Eğer farklıysa yolu değiştir
emacs --daemon --eval "(setq user-emacs-directory \"$HOME/.config/emacs/\")"

# Yeni daemon'a emacsclient ile bağlan
emacsclient -c
