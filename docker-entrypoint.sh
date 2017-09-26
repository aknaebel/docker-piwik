#!/bin/bash -eux

echo >&2 "Setting Permissions:"
path='/var/www/piwik'
htuser='www-data'

if [ ! -e piwik.php ]; then
        tar cf - --one-file-system -C /tmp/piwik . | tar xf -
fi

chown -R ${htuser}:${htuser} ${path}

echo >&2 "Update GeoIP base"
curl -fsSL -o /var/www/piwik/misc/GeoIPCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
gunzip -f /var/www/piwik/misc/GeoIPCity.dat.gz

exec "$@"
