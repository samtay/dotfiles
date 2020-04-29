#! /bin/bash
# xrandr -s 0

export PATH="$HOME/.local/bin:$PATH"
[[ -e ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -e ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec xmonad
