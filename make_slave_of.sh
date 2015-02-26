#!/bin/bash

if [[ ! -z "$MAKE_SLAVE_OF" ]] ; then
   if [[ -z `mysql -NBe "SHOW SLAVE STATUS"` ]]; then
       OUTPUT=`mysql -NBe "SHOW MASTER STATUS" -h$MAKE_SLAVE_OF -u$MYSQL_USER -p$MYSQL_PASS`
       OUTPUT_ARRAY=($OUTPUT)
       mysql -e "change master to master_host='$MAKE_SLAVE_OF', master_user='$MYSQL_USER', master_password='$MYSQL_PASS', master_log_file='${OUTPUT_ARRAY[0]}', master_log_pos=${OUTPUT_ARRAY[1]}"
       mysql -e "slave start"
   fi
fi
