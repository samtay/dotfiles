export MOZ_ENABLE_WAYLAND=1
# if this doesnt work try ~/.config/environment.d/*.conf
export MOZ_DBUS_REMOTE=1
export PATH="$PATH:$HOME/.scripts"

# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway > /tmp/sway.log
fi
