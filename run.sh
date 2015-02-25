#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

if [[ ! -f $VOLUME_HOME/server_id ]] ; then
  echo '[mysqld]' >> $VOLUME_HOME/server_id
  echo "server_id=$RANDOM" >> $VOLUME_HOME/server_id
fi

cp $VOLUME_HOME/server_id /etc/mysql/conf.d/server_id.cnf

/set_my_cnf_from_env.sh
/make_slave_of.sh

# -e "SLAVE_OF=mysql-master" -e "MY_CNF_EXTRA=log-bin=master"
exec mysqld_safe
