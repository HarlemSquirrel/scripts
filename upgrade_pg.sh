#!/usr/bin/env bash

## upgrade_pg.sh
# A friendly script for upgrading PostgreSQL on ArchLinux
# Adapted from https://wiki.archlinux.org/index.php/PostgreSQL#Upgrading_PostgreSQL

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "  $0 must be run as root!" 1>&2
   exit 1
fi

## Set the old version that we want to upgrade from.
FROM_VERSION=$(< /var/lib/postgres/data/PG_VERSION)

pacman -S --needed postgresql-old-upgrade
chown postgres:postgres /var/lib/postgres/
su - postgres -c "mv /var/lib/postgres/data /var/lib/postgres/data-${FROM_VERSION}"
su - postgres -c 'mkdir /var/lib/postgres/data'
su - postgres -c "initdb --locale $LANG -E UTF8 -D /var/lib/postgres/data"
su - postgres -c "pg_upgrade -b /opt/pgsql-${FROM_VERSION}/bin/ -B /usr/bin/ -d /var/lib/postgres/data-${FROM_VERSION} -D /var/lib/postgres/data"
