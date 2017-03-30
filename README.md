# config
Personal configuration files

## arch + f2fs
When arch bails and I'm in `rootfs` all on my own, two commands to live by:
```bash
$ fsck.f2fs -f /dev/nvme0n1p2
$ echo b > /proc/sysrq-trigger
```

## todo
1. Compile xmobar --with-alsa
2. Music manager such as beets
3. cmus is a CLI music player ftw

## about `manage.sh`
TODO

## notes
This assumes that during pacstrap, I have installed

- base
- base-devel
- vim
- git
- openssh
- connman
