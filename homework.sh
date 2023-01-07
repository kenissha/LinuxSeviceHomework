#!/bin/bash

hostname=localhost
userAndDb=postgres

inotifywait -m -e create -e delete --format '%e %f' /home/rifat/Masaüstü/bsm | while read file; do

  now=$(date -Iseconds)

  if [[ $file = *"CREATE"* ]]; then

    psql -h $hostname -U $userAndDb -d $userAndDb -c "INSERT INTO dosyalar (name, createdtime) VALUES ('$(echo "$file" | cut -d' ' -f2)', '$now');"

  elif [[ $file = *"DELETE"* ]]; then

    psql -h $hostname -U $userAndDb -d $userAndDb -c "UPDATE dosyalar SET deleted=true, deletedtime='$now' WHERE name='$(echo "$file" | cut -d' ' -f2)';"
  fi
done
