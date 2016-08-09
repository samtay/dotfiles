# Get magento webroot
function get-magento-root() {
  local magentopath=`git rev-parse --show-toplevel`;
  if [ -d "$magentopath/webroot" ]; then
    magentopath="$magentopath/webroot"
  fi
  echo $magentopath;
}

# bin/magento from anywhere in git root
function bin-magento(){
  php $(get-magento-root)/bin/magento -vvv "$@"
}

# Install command with user friendly prompting
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

# Baseline clear cache
function clear-cache() {
  sudo rm -rf $(get-magento-root)/var/cache $(get-magento-root)/var/page_cache $(get-magento-root)/var/generation $(get-magento-root)/var/di
}

function sanitize-m2() {
  local url="$1"
  if [ -z "$url" ]; then
    read "url?Base URL (example: client.dev): "
  fi

  echo "Setting up site $url..."

  n99 config:set web/unsecure/base_url "http://$url/"
  n99 config:set web/secure/base_url "http://$url/"

  # If they have a CDN configured, the following URLs could be different and break things. Best to assert their values
  n99 config:delete web/unsecure/base_link_url
  n99 config:delete web/unsecure/base_static_url
  n99 config:delete web/unsecure/base_media_url

  n99 config:delete web/secure/base_link_url
  n99 config:delete web/secure/base_static_url
  n99 config:delete web/secure/base_media_url


  echo "Setting admin path to /admin..."
  n99 config:delete admin/url/custom
  n99 config:set admin/url/use_custom 0
  n99 config:set admin/url/use_custom_path 0

  echo "Relaxing security..."
  n99 config:set admin/security/session_lifetime 86400
  n99 config:set admin/security/password_is_forced 0
  n99 config:set admin/security/password_lifetime 1000

  # Turn on symlinks
  n99 config:set dev/template/allow_symlink 1

  echo "Turning off minification..."
  n99 config:set dev/css/merge_css_files 0
  n99 config:set dev/css/minify_files 0

  n99 config:set dev/js/enable_js_bundling 0
  n99 config:set dev/js/merge_files 0
  n99 config:set dev/js/minify_files 0
  n99 config:set dev/template/minify_html 0

  echo "Turning on js logging..."
  n99 config:set dev/js/session_storage_logging 1

  n99 config:delete web/cookie/cookie_domain
  n99 config:delete web/cookie/cookie_path

  echo "Setting search engine to mysql..."
  n99 config:set catalog/search/engine mysql

  echo "Creating admin user..."
  n99 admin:user:delete admin
  n99 admin:user:create --admin-user="admin" --admin-password="pass4admin" --admin-email="admin@blueacorn.com" --admin-firstname="Admin" --admin-lastname="Admin"

  echo "Flushing cache..."
  n99 cache:clean
  n99 cache:flush
}
