#! /bin/bash
xrandr -s 0
[[ -e ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -e ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
feh --bg-scale 8ceUm7i.png &
exec xmonad
