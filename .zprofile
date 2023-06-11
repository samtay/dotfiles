# export MOZ_ENABLE_WAYLAND=1
# if this doesnt work try ~/.config/environment.d/*.conf
# export MOZ_DBUS_REMOTE=1
export PATH="$PATH:$HOME/.scripts"

# If running from tty1 start sway
# if [ "$(tty)" = "/dev/tty1" ]; then
	# exec sway > /tmp/sway.log
# fi
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Setting PATH for Python 3.10
# The original version is saved in .zprofile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
# export PATH

# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
	exec dbus-run-session awesome
fi

#source "/home/sam/code/emsdk/emsdk_env.sh"
