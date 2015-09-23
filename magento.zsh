function clear-cache-rm() {
  if [ -d webroot ]; then
    sudo rm -rf webroot/var/cache webroot/var/full_page_cache
  else
    sudo rm -rf var/cache var/full_page_cache
  fi
}
function clear-session() {
  if [ -d webroot ]; then
    sudo rm -rf webroot/var/session
  else
    sudo rm -rf var/session
  fi
}
alias clear-cache-n98="n98-magerun.phar cache:flush && n98-magerun.phar cache:clean"
alias reindex-site="n98-magerun.phar index:reindex:all"
alias fix-permissions="sudo chmod -R 777 media var app/etc && git config core.fileMode false"
alias watch-exception="less +F var/log/exception.log"
alias watch-system="less +F var/log/system.log"

function sanitize() {
  BASE_URL="http://$1/";
  n98-magerun.phar db:query "update core_config_data set value = '$BASE_URL' where path = 'web/unsecure/base_url';"
  n98-magerun.phar db:query "update core_config_data set value = '$BASE_URL' where path = 'web/secure/base_url';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'payment/authorizenet/active';"
  n98-magerun.phar db:query "update core_config_data set value = '1' where path = 'payment/ccsave/active';"
  n98-magerun.phar db:query "delete from core_config_data where path = 'web/cookie/cookie_domain';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'dev/js/merge_files';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'dev/css/merge_files';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}' where path = 'web/unsecure/base_link_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}skin/' where path = 'web/unsecure/base_skin_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}media/' where path = 'web/unsecure/base_media_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}js/' where path = 'web/unsecure/base_js_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}' where path = 'web/secure/base_link_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}skin/' where path = 'web/secure/base_skin_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}media/' where path = 'web/secure/base_media_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}js/' where path = 'web/secure/base_js_url';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'admin/security/password_is_forced';"
  n98-magerun.phar db:query "update core_config_data set value = '1000' where path = 'admin/security/password_lifetime';"
  n98-magerun.phar db:query "update core_config_data set value = '86400' where path = 'admin/security/session_cookie_lifetime';"
  n98-magerun.phar config:set admin/security/session_cookie_lifetime 86400
  n98-magerun.phar admin:user:create samtay s@t.com matrix7 sam tay
  n98-magerun.phar config:set admin/startup/page 'system/config'
}
