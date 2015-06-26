alias restart-apache='sudo apachectl restart'
alias watch-apache='less +F /var/log/apache2/error_log'

SITES_DIR=/Volumes/Sites/

VHOST_TEMPLATE="
<VirtualHost *:80>
  ServerName {temp}.dev
  DocumentRoot $SITES_DIR{temp}.dev
</VirtualHost>
"

VHOST_TEMPLATE_WEBROOT="
<VirtualHost *:80>
  ServerName {temp}.dev
  DocumentRoot $SITES_DIR{temp}.dev/webroot
</VirtualHost>
"

add-site(){
  echo "$VHOST_TEMPLATE" | sed "s/{temp}/$1/g" | sudo tee /etc/apache2/extra/vhosts.d/vhost-http-$1.conf > /dev/null
  echo "127.0.0.1 $1.dev" | sudo tee -a /etc/hosts > /dev/null
  sudo apachectl restart
}

add-site-with-webroot(){
  echo "$VHOST_TEMPLATE_WEBROOT" | sed "s/{temp}/$1/g" | sudo tee /etc/apache2/extra/vhosts.d/vhost-http-$1.conf > /dev/null
  echo "127.0.0.1 $1.dev" | sudo tee -a /etc/hosts > /dev/null
  sudo apachectl restart
}

