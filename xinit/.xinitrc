#! /bin/bash
xrandr -s 0
/usr/bin/synclient HorizTwoFingerScroll=1 &
export _JAVA_AWT_WM_NONREPARENTING=1 # fix for phpstorm & xmonad
exec xmonad
