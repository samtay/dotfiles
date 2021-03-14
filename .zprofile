export MOZ_ENABLE_WAYLAND=1
export PATH="$PATH:$HOME/.scripts"

# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway > /tmp/sway.log
fi
