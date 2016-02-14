function get-magento-root() {
  local magentopath=`git rev-parse --show-toplevel`;
  if [ -d "$magentopath/webroot" ]; then
    magentopath="$magentopath/webroot"
  fi
  echo $magentopath;
}
function get-blueacornui() {
  local siteroot=`git rev-parse --show-toplevel`;
  if [ -d "$siteroot/blueacornui" ]; then
    echo "$siteroot/blueacornui"
  else
    echo "blueacornui directory not found"
    exit 1
  fi
}

function compile-assets() {
  cd $(get-blueacornui) && grunt compile && cd -
}
function clear-cache-rm() {
  sudo rm -rf $(get-magento-root)/var/cache $(get-magento-root)/var/full_page_cache
}
function clear-session() {
  sudo rm -rf $(get-magento-root)/var/session
  sudo rm -rf $(get-magento-root)/var/session
}
function enable-errors() {
  sed -i.original 's/umask(0);/Mage::setIsDeveloperMode(true); ini_set("display_errors", 1); umask(0);/' $(get-magento-root)/index.php
  rm $(get-magento-root)/index.php.original
}
alias clear-cache-n98="n98-magerun.phar cache:flush && n98-magerun.phar cache:clean"
alias reindex-site="n98-magerun.phar index:reindex:all"
function fix-permissions() {
  sudo chmod -R 777 $(get-magento-root)/media $(get-magento-root)/var $(get-magento-root)/app/etc
  git config core.fileMode false
}
function watch-exception() {
  less +F $(get-magento-root)/var/log/exception.log
}
function watch-system() {
  less +F $(get-magento-root)/var/log/system.log
}

function sanitize() {
  echo "Setting up site $1..."

  echo "Disabling GA, setting up payment methods..."
  n98-magerun.phar config:set google/analytics/active 0
  n98-magerun.phar config:set payment/authorizenet/active 0
  n98-magerun.phar config:set payment/ccsave/active 1
  n98-magerun.phar config:delete web/cookie/cookie_domain

  echo "Unmerging js/css files..."
  n98-magerun.phar config:set dev/js/merge_files 0
  n98-magerun.phar config:set dev/css/merge_files 0

  echo "Setting up URL configuration..."
  n98-magerun.phar config:set web/unsecure/base_url "http://$1/"
  n98-magerun.phar config:set web/secure/base_url "http://$1/"
  n98-magerun.phar config:set web/unsecure/base_link_url '{{unsecure_base_url}}'
  n98-magerun.phar config:set web/unsecure/base_skin_url '{{unsecure_base_url}}skin/'
  n98-magerun.phar config:set web/unsecure/base_media_url '{{unsecure_base_url}}media/'
  n98-magerun.phar config:set web/unsecure/base_js_url '{{unsecure_base_url}}js/'
  n98-magerun.phar config:set web/secure/base_link_url '{{secure_base_url}}'
  n98-magerun.phar config:set web/secure/base_skin_url '{{secure_base_url}}skin/'
  n98-magerun.phar config:set web/secure/base_media_url '{{secure_base_url}}media/'
  n98-magerun.phar config:set web/secure/base_js_url '{{secure_base_url}}js/'

  echo "Relaxing security..."
  n98-magerun.phar config:set admin/security/session_cookie_lifetime 86400
  n98-magerun.phar config:set admin/security/password_is_forced 0
  n98-magerun.phar config:set admin/security/password_lifetime 1000

  echo "Allowing template symlinks...."
  n98-magerun.phar config:set dev/template/allow_symlink 1

  echo "Set default admin page to system configuration"
  n98-magerun.phar config:set admin/startup/page 'system/config'

  echo "Creating admin user and customer..."
  n98-magerun.phar admin:user:create samtay s@t.com matrix7 sam tay
  n98-magerun.phar customer:create s@t.com matrix sam tay 1

  echo "Enabling Logging for exceptions..."
  n98-magerun.phar dev:log --global --on
  n98-magerun.phar config:set dev/log/active 1
}

function create-customer() {
  n98-magerun.phar customer:create s@t.com matrix s t 0
}

delete-customers(){
  n98-magerun.phar db:query "SET foreign_key_checks = 0;TRUNCATE \`customer_address_entity\`;TRUNCATE \`customer_address_entity_datetime\`;TRUNCATE \`customer_address_entity_decimal\`;TRUNCATE \`customer_address_entity_int\`;TRUNCATE \`customer_address_entity_text\`;TRUNCATE \`customer_address_entity_varchar\`;TRUNCATE \`customer_entity\`;TRUNCATE \`customer_entity_datetime\`;TRUNCATE \`customer_entity_decimal\`;TRUNCATE \`customer_entity_int\`;TRUNCATE \`customer_entity_text\`;TRUNCATE \`customer_entity_varchar\`;SET foreign_key_checks = 1;"
}

getLocalXmlValue() {
  echo $1 | sed -n -e "s/.*<$2><!\[CDATA\[\(.*\)\]\]><\/$2>.*/\1/p" | head -n 1
}

getLocalXmlKey(){
  for f in `ls app/etc/local.xml*`
  do
    if [ ! -z $(getLocalXmlValue $f $1) ]
    then
      echo `getLocalXmlValue $f $1`
      return
    fi  
  done

}

magento-database-table-sizes(){
  n98-magerun.phar db:query --no-ansi "pager less -SFX; SELECT TABLE_SCHEMA, TABLE_NAME, (INDEX_LENGTH+DATA_LENGTH)/(1024*1024) AS SIZE_MB,TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA in ('$1') ORDER BY SIZE_MB DESC;"
}
