#!/bin/bash
#sql="\"ATTACH DATABASE '/home/elinux1/localdb.2' as 'raildb1';\""
#echo $sql;
#sqlite3 "$sql"
#sql="\"ATTACH DATABASE '/home/elinux1/localdb.2' as 'raildb1';DROP TABLE transaction_master;DETACH DATABASE 'raildb1';.exit\""
#echo $sql;
#sqlite3 "$sql"
#sql="\"DETACH DATABASE 'raildb1';\""
#echo $sql;
#sqlite3 "$sql"

# ATTACH DATABASE '/home/elinux1/localdb.2' as 'raildb1';
#sqlite3 DROP TABLE transaction_master;
#sqlite3 DETACH DATABASE 'raildb1';
#sqlite3 .exit

exec sqlite3 < /home/root/sqlite_to_csv/EXPORT-sqlite-csv > /tmp/exportDebug 2>&1 &
