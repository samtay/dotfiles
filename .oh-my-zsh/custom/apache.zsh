alias restart-apache='sudo service apache2 restart'
alias watch-apache='less +F /var/log/apache2/error_log'

SITES_DIR=$HOME/git/sites
ZSH_SSL_CERT=$HOME/ssl/server.crt
ZSH_SSL_KEY=$HOME/ssl/server.key

VHOST_TEMPLATE="
<VirtualHost *:80>
  ServerName {site_tolower}.dev
  DocumentRoot $SITES_DIR/{site_toupper}/webroot
</VirtualHost>
"
VHOST_TEMPLATE_NOWEBROOT="
<VirtualHost *:80>
  ServerName {site_tolower}.dev
  DocumentRoot $SITES_DIR/{site_dir}
</VirtualHost>
"

add-site(){
  local site_tolower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  local site_toupper=$(echo "$1" | tr '[:lower:]' '[:upper:]')
  echo "$VHOST_TEMPLATE" | sed "s/{site_tolower}/$site_tolower/g" | sed "s/{site_toupper}/$site_toupper/g" | sudo tee /etc/apache2/sites-available/$site_tolower.conf > /dev/null
  echo "127.0.0.1 $site_tolower.dev" | sudo tee -a /etc/hosts > /dev/null
  enable-site "$site_tolower.conf"
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
  sudo a2dissite $site_tolower
  sudo rm /etc/apache2/sites-available/$site_tolower.conf
  sudo service apache2 reload
}

enable-site(){
  sudo a2ensite $1
}
