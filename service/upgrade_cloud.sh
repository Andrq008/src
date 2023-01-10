#!/bin/bash
docker pull nextcloud
docker stop root-app-1
docker rm root-app-1
docker-compose -f nextcloud_1.yml up -d
sleep 10
docker cp /srv/nextcloud/ssl/nextcloud.crt root-app-1:/etc/ssl/certs/nextcloud.crt
docker cp /srv/nextcloud/ssl/nextcloud.key root-app-1:/etc/ssl/private/nextcloud.key
docker cp /srv/nextcloud/apache2/default-ssl.conf root-app-1:/etc/apache2/sites-available/default-ssl.conf
docker exec root-app-1 a2enmod ssl
docker exec root-app-1 a2enmod headers
docker exec root-app-1 a2ensite default-ssl
docker exec root-app-1 service apache2 reload
docker exec root-app-1 apt update
docker exec root-app-1 apt install sudo
docker exec root-app-1 apt install nano