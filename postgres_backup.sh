#!/bin/bash

backup_dir="/backups/instance_backup"
if [ ! -d "$backup_dir" ]
then
	mkdir $backup_dir
fi
logfile="/backups/logfile.log"
timeslot=`date '+%H:%M'`
dateslot=`date '+%d-%b-%Y'`
touch $logfile
databases=`psql -h localhost -U postgres -q -c "\l" | sed -n 4,/\eof/p | grep -v rows\) | awk {'print $1'} | grep -v \| |grep -v template | grep -v postgres`

for i in $databases; do
        if [ "$i" != "demo" ] && [ "$i" != "dev" ]
        then
                timeinfo=`date '+%T %x'`
                echo "Backup and Vacuum complete at $timeinfo for time slot $timeslot on database: $i " >> $logfile
                /usr/bin/vacuumdb -z -h localhost -U postgres $i >/dev/null 2>&1
                /usr/bin/pg_dump $i -h 127.0.0.1 -U postgres | gzip > "$backup_dir/postgresql-$i-pro-$dateslot-$timeslot-143-database.gz"
		# ##need to send another server(storage server )  uncomment following line
                #scp -i /root/.ssh/id_rsa -P 9550 $backup_dir/postgresql-$i-pro-$dateslot-$timeslot-143-database.gz root@server:/code_backup/backup_143
        fi
done
## if you want to delete the main server backups clean enable following line (if you are using SCP then enable to eliminate replication of DB's
#rm -rf $backup_dir/*
