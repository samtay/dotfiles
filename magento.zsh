alias fix-permissions="sudo chmod -R 777 media var app/etc"
alias clear-cache-rm="sudo rm -rf var/cache var/full_page_cache"
alias clear-cache-n98="n98-magerun.phar cache:flush && n98-magerun.phar cache:clean"
alias clear-session="sudo rm -rf var/session"
alias watch-exception="less +F var/log/exception.log"
alias watch-system="less +F var/log/system.log"
alias reindex-site="n98-magerun.phar index:reindex:all"

