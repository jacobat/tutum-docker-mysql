#!/bin/bash
for x in `set | grep -E '^MY_CNF_' | sed -e s/=.*//`
do
  KEY=`echo $x | sed s/MY_CNF_// | tr '[:upper:]' '[:lower:]'`
  VALUE=${!x}
  echo $KEY=$VALUE >> /etc/mysql/conf.d/my.cnf
done


