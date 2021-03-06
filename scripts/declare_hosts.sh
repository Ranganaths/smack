#! /bin/bash
# configures hosts

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# creates a backup of previous hosts
# and prevents multiple execution
backup_hosts()
{
  if ! [ -f "$HOSTS_BACKUP" ]; then
    sudo cp "$HOSTS" "$HOSTS_BACKUP"
    return 0

  else
    #echo "A backup of $HOSTS already exists, aborting"
    echo "Hosts already installed"
  fi

  return -1
}

# restores original hosts file
restore_hosts()
{
  if [ -f "$HOSTS_BACKUP" ]; then
    sudo mv "$HOSTS_BACKUP" "$HOSTS"
    return 0

  else
    #echo "No backup of $HOSTS to restore, aborting"
    echo "Hosts already uninstalled"
  fi

  return -1
}

# adds a declaration to hosts
append_host()
{
  if [[ $# -ge 2 ]]; then
    printf "$1 $2\n" | sudo tee --append $HOSTS &> /dev/null
  fi
}

# adds a declaration of the external ip in /etc/my_ip for further use
create_my_ip_file()
{
  if [[ $# -ge 1 ]]; then
    echo $1 | sudo tee $IP_FILE &> /dev/null
  fi
}

# adds a server declaration to hosts
decl_serv()
{
  if [[ $# -ge 2 ]]; then
    local IP="$1"
    local HOST="$2"
    local NUM="${HOST##*-}"
    local NODE=node$NUM

    if [[ $SELF = "$HOST" ]]; then
      create_my_ip_file $IP
      #IP="$LOCAL_IP"
    fi

    append_host "\n$IP" $HOST
    append_host $IP $NODE
  fi
}


if [ $# -ge 1 ]; then

  if restore_hosts ; then
    echo "Hosts restauration finished"
  fi

else

  # backup hosts
  if backup_hosts ; then

    # declare all servers
    decl_serv 213.32.72.246 server-1
    decl_serv 213.32.72.245 server-2
    decl_serv 213.32.72.62 server-3
    decl_serv 149.202.188.215 server-4
    decl_serv 149.202.190.228 server-5
    decl_serv 149.202.190.49 server-6
    decl_serv 213.32.79.191 server-7

    echo "Hosts installation finished"
  fi

fi;

