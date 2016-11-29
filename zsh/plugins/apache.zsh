alias restart-apache='sudo apachectl restart'

SITES_DIR=$HOME/git/sites
ZSH_SSL_CERT=$HOME/ssl/server.crt
ZSH_SSL_KEY=$HOME/ssl/server.key

VHOST_TEMPLATE="
<VirtualHost *:80>
  ServerName {site_tolower}.dev
  ServerAlias {site_tolower}.dev
  DocumentRoot $SITES_DIR/{site_toupper}/webroot
  ErrorLog "/var/log/httpd/{site_tolower}-error_log"
  CustomLog "/var/log/httpd/{site_tolower}-access_log" common
  <Directory "$SITES_DIR/{site_toupper}/webroot">
    Require all granted
  </Directory>
</VirtualHost>
"
VHOST_TEMPLATE_NOWEBROOT="
<VirtualHost *:80>
  ServerName {site_tolower}.dev
  ServerAlias {site_tolower}.dev
  DocumentRoot $SITES_DIR/{site_dir}
</VirtualHost>
"

add-site(){
  local site_tolower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  local site_toupper=$(echo "$1" | tr '[:lower:]' '[:upper:]')
  echo "$VHOST_TEMPLATE" | sed "s/{site_tolower}/$site_tolower/g" | sed "s/{site_toupper}/$site_toupper/g" | sudo tee /etc/httpd/conf/vhosts/$site_tolower.dev > /dev/null
  echo "127.0.0.1 $site_tolower.dev" | sudo tee -a /etc/hosts > /dev/null
  echo "Include conf/vhosts/$site_tolower.dev" | sudo tee -a /etc/httpd/conf/httpd.conf > /dev/null
  restart-apache
}

add-site-no-webroot(){
  local site_tolower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  echo "$VHOST_TEMPLATE_NOWEBROOT" | sed "s/{site_tolower}/$site_tolower/g" | sed "s/{site_dir}/$1/g" | sudo tee /etc/apache2/sites-available/$site_tolower.conf > /dev/null
  echo "127.0.0.1 $site_tolower.dev" | sudo tee -a /etc/hosts > /dev/null
  enable-site "$site_tolower.conf"
  restart-apache
}

remove-site(){
  local site_tolower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  sudo rm /etc/httpd/conf/vhosts/$1.dev
  restart-apache
}
