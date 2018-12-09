# config
Personal configuration files

## TODO
1. rewrite `manage` for spinning up macOS, installing brew, coreutils, chunkwm+skhd and printing SID disable instructions
1. install vimplug during `manage` bootstrap:

    ```
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ```

1. Port more of the xmonad shortcuts to skhd, e.g. opening surf cam
1. Look up modality support in chunkwm as a substitute for xmonad submaps
1. Adapt the alt+shift+t toggle theme support to macOS, may require using termite?
