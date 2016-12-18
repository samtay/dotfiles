#! /bin/bash
xrandr -s 0
[[ -e ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
exec xmonad
