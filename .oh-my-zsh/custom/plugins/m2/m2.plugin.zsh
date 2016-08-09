# ------------------------------------------------------------------------------
# FILE: m2.plugin.zsh
# DESCRIPTION: oh-my-zsh m2 autocomplete file. Adapted from composer plugin 
# AUTHOR: Sam Tay (sam.chong.tay@gmail.com)
# VERSION: 1.0.0
# ------------------------------------------------------------------------------

# Keep this up to date by checking bin-magento list --raw --no-ansi
_bin_magento_get_command_list () {
  bin-magento --raw --no-ansi list | sed "s/[[:space:]].*//g"
}

_bin_magento () {
  compadd $(_bin_magento_get_command_list)
}

compdef _bin_magento bin-magento
