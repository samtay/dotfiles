function get-magento-root() {
  local magentopath=`git rev-parse --show-toplevel`;
  if [ -d "$magentopath/webroot" ]; then
    magentopath="$magentopath/webroot"
  fi  
  echo $magentopath;
}

function bin-magento(){
  php $(get-magento-root)/bin/magento -vvv "$@"
}

function install-m2(){
  local url="$1"
  local db="$2"
  if [ -z "$url" ]; then
    read "url?Base URL (example: client.dev): "
  fi
  if [ -z "$db" ]; then
    read "db?db-name: "
  fi
  php $(get-magento-root)/bin/magento setup:install --base-url="http://$url/" --backend-frontname=admin --db-host=localhost --db-name="$db" --db-user=root --db-password=root --admin-firstname=sam --admin-lastname=tay --admin-email=s@t.com --admin-user=samtay --admin-password=matrix7 --language=en_US --currency=USD --timezone=America/New_York --use-rewrites=1
}

function clear-cache() {
  sudo rm -rf $(get-magento-root)/var/cache $(get-magento-root)/var/page_cache $(get-magento-root)/var/generation $(get-magento-root)/var/di
}
