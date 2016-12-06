#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

#Arret des brokers
echo 'Arret des brokers'
remote_run_sync ${MASTER} 'curl "http://'${MASTER}':7000/api/broker/stop?broker=*"'
#Suppression des brokers
echo 'Suppresssion des brokers'
remote_run_sync ${MASTER} 'curl "http://'${MASTER}':7000/api/broker/remove?broker=*"'

#Arret du scheduler
echo 'Arret du scheduler kafka'
remote_run_sync ${MASTER} 'sudo kill $(sudo lsof -t -i:7000)'
