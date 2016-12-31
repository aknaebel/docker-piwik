# docker-isso

## Description:

This docker image provide a [piwik](https://piwik.org/) service based on [Alpine Linux](https://hub.docker.com/_/alpine/) using php7-fpm

## Usage:
```
docker run --name mariadb -d \
-e MYSQL_ROOT_PASSWORD=password \
-e MYSQL_DATABASE=piwik \
-e MYSQL_USER=piwik \
-e MYSQL_PASSWORD=piwik_password \
--restart=always mariadb

docker run --name piwik -d -p 9000:9000 \
--link mariadb \
-v /piwik/data:/var/www/piwik \
--restart=always aknaebel/piwik
```

## Docker-compose:
``` 
version: '2'
services:
    mariadb:
        image: mariadb
        volumes:
            - ./mariadb/data:/var/lib/mysql
        environment:
            - MYSQL_ROOT_PASSWORD=password
            - MYSQL_DATABASE=piwik
            - MYSQL_USER=piwik
            - MYSQL_PASSWORD=piwik_password

    piwik:
        image: aknaebel/piwik
        links:
            - mariadb
            - mail
        expose:
            - 9000
        ports:
            - "9000:9000"
        volumes:
            - /piwik/data:/var/www/piwik
        restart: always
```

```
docker-compose up -d
```

## Piwik stuff

### Volume:
The image provide a volume in **/var/www/piwik**. You must use it with your web server to get the CSS and JS files

### Documentation
See the [official documentation](https://piwik.org/) to configure a specific option of your vimbadmin image
