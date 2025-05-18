#!/bin/bash

#Set user and group
umask 0000
#PUID=${PUID:-`id -u squeezeboxserver`}
#PGID=${PGID:-`id -g squeezeboxserver`}

# Set uid of user squeezeboxserver to $PUID
echo Set uid of user squeezeboxserver to $PUID
usermod -o -u "$PUID" squeezeboxserver

# Set id of group squeezeboxserver to $PGID and set gid of user squeezeboxserver to $PGID
echo Set id of group squeezeboxserver to $PGID
groupmod -o -g "$PGID" squeezeboxserver
echo Set gid of user squeezeboxserver to $PGID
usermod -g $PGID squeezeboxserver

#Add permissions
chown -R squeezeboxserver:squeezeboxserver /config /playlist

if [[ -f /config/custom-init.sh ]]; then
	echo "Running custom initialization script..."
	sh /config/custom-init.sh
fi

echo Starting Lyrion Music Server on port $HTTP_PORT...
if [[ -n "$EXTRA_ARGS" ]]; then
	echo "Using additional arguments: $EXTRA_ARGS"
fi

# Preparing /config folder
#mkdir -pv /config/prefs /config/logs /config/cache
mkdir -pv /config/prefs || echo "Erreur lors de la création du répertoire, continuation du script..."
mkdir -pv /config/logs || echo "Erreur lors de la création du répertoire, continuation du script..."
mkdir -pv /config/cache || echo "Erreur lors de la création du répertoire, continuation du script..."

su squeezeboxserver -s /bin/sh -c '/usr/bin/perl /lms/slimserver.pl --prefsdir /config/prefs --logdir /config/logs --cachedir /config/cache --httpport $HTTP_PORT $EXTRA_ARGS'
# /bin/sh -c '/usr/bin/perl /lms/slimserver.pl --prefsdir /config/prefs --logdir /config/logs --cachedir /config/cache --httpport $HTTP_PORT $EXTRA_ARGS'
