#####
# This script disables the IPV6 listen:
#      listen [::]:8080 default_server;
# that is in the default nginx.conf file provided by the S2I nginx build image
# so that it will not crash when run on hosts that don't have IPV6 enabled.
#
# It also delete's the root location rule in the default server block
# so an alternate root location rule can be loaded for react applications
# via a *.conf file loaded in the nginx-default-cfg folder:
#        location / {
#        }
#
# Author: Tim Taylor (mpx1@cdc.gov, ttaylor@mitre.org)
# Date: 31 Jul 2019
# Revised: David Tsao (dht4@cdc.gov)
# Date: 1 Aug 2019
#####

# We have write access to the nginx.conf file, but not to the directory that
# contains it, so we can't use the 'sed -i' argument to modify the file in place
cp "$NGINX_CONF_PATH" /tmp
sed -i "/\[::\]:8080/ s/listen/#listen/" /tmp/nginx.conf
# Adapted from https://stackoverflow.com/a/23483717:
sed -ri '/location \/ {/,/.*\}/d' /tmp/nginx.conf
cp /tmp/nginx.conf $NGINX_CONF_PATH
rm /tmp/nginx.conf
