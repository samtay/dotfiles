# needed to run xmonad
export PATH="$HOME/.local/bin:$PATH"

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip
# pip zsh completion end

export PATH="$HOME/.cargo/bin:$PATH"

# fix wide monitor
xrandr --newmode "2560x1080_45.00" 167.75 2560 2696 2960 3360 1080 1083 1093 1111 -hsync +vsync
xrandr --addmode DP-1 "2560x1080_45.00"
xrandr --output DP-1 --mode "2560x1080_45.00"

# set monitor output
xrandr --output "eDP-1" --off --output "DP-1" --auto
