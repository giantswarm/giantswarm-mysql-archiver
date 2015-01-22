#!/bin/bash

# This script periodically runs a backup
# and uploads it to Amazon S3.
#
# Configuration is taken entirely from
# environment variables

# interval between backups in seconds
interval=$BACKUP_INTERVAL

# MySQL configuration
dbhost=$MYSQL_PORT_3306_TCP_ADDR
dbport=$MYSQL_PORT_3306_TCP_PORT
dbname=$DB_NAME
dbuser=$DB_USER
dbpass=$DB_PASSWORD

# Amazon S3 target bucket
bucket=$S3_BUCKET

# pattern to create subdirectories from dateelements,
# e. g. '%Y/%m/%d' or '%Y/%Y-%m-%d'
pathpattern=$PATH_DATEPATTERN

# initially wait a minute before first backup
#sleep 60
sleep 1

count=1

while [ 1 ]
do
    # set date-dependent path element
    datepath=`date +"$pathpattern"`
    
    # determine file name
    datetime=`date +"%Y-%m-%d_%H-%M"`
    filename=$dbname_$datetime.sql
    
    echo "Writing backup No. $count for $dbhost:$dbport/$dbname to s3://$bucket/$datepath/$filename.gz"
    
    mysqldump -h $dbhost -P $dbport -u $dbuser --password="$dbpass" $dbname > $filename

    gzip $filename
    aws s3 cp $filename.gz s3://$bucket/$datepath/$filename.gz && echo "Backup No. $count finished"
    rm $filename.gz
    
    # increment counter and for the time to pass by...
    count=`expr $count + 1`
    sleep $interval
done
