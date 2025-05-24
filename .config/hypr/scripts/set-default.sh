#!/bin/bash

xdg-mime default org.gnome.Loupe.desktop image/jpeg
xdg-mime default org.gnome.Loupe.desktop image/png
xdg-mime default org.gnome.Loupe.desktop image/webp
xdg-mime default org.gnome.Loupe.desktop image/gif

xdg-settings set default-web-browser firefox.desktop
