#! /bin/bash
# xrandr -s 0

[[ -e ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -e ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
xrandr --newmode "2560x1080_45.00" 167.75 2560 2696 2960 3360 1080 1083 1093 1111 -hsync +vsync
xrandr --addmode DP-1 "2560x1080_45.00"
xrandr --output DP-1 --mode "2560x1080_45.00"
exec xmonad
