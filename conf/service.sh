#!/bin/ash

if [ "$1" == "nginx" ]; then
    if [ "$2" == "start" ]; then
        /usr/bin/supervisorctl -c /etc/supervisord.conf start nginx
    elif [ "$2" == "stop" ]; then
        /usr/bin/supervisorctl -c /etc/supervisord.conf stop nginx
    elif [ "$2" == "restart" ]; then
        /usr/bin/supervisorctl -c /etc/supervisord.conf restart nginx
    else
        echo "use ./service nginx {start|stop|restart}"
        exit 0;
    fi
elif [ "$1" == "php-fpm" ]; then
    if [ "$2" == "php-fpm" ]; then
        /usr/bin/supervisorctl -c /etc/supervisord.conf start php-fpm
    elif [ "$2" == "php-fpm" ]; then
        /usr/bin/supervisorctl -c /etc/supervisord.conf stop php-fpm
    elif [ "$2" == "php-fpm" ]; then
        /usr/bin/supervisorctl -c /etc/supervisord.conf restart php-fpm
    else
        echo "use ./service php-fpm {start|stop|restart}"
        exit 0;
    fi
else
	echo "use ./service {nginx|php-fpm}"
	exit 0;
fi


