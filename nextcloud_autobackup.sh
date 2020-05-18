#!/bin/bash

DestDir=[Dest_Dir]
Date=$(date +"%Y%m%d")
DataDir=[Data_Dir]
NextcloudDir=[Nextcloud_Dir]

#turn on maintenance mode
sudo -u www-data php $NextcloudDir/occ maintenance:mode --on

echo "-------------------------------------------------------------------"
echo "备份开始(`date +"%Y-%m-%d %H:%M:%S"`)"

#backup database and nextcloud directory
sudo mysqldump --single-transaction -h localhost -u root -[mysql_password] nextcloud > ~/nextcloud-sqlbkp_$Date.bak
zip -q -r ~/nextcloud-$Date.zip $NextcloudDir
echo "备份成功(`date +"%Y-%m-%d %H:%M:%S"`)，开始同步"

#turn off maintenance mode
sudo -u www-data php $NextcloudDir/occ maintenance:mode --off

#sync database
rclone copy ~/nextcloud-sqlbkp_$Date.bak $DestDir/sql
rm ~/nextcloud-sqlbkp_$Date.bak
echo "数据库同步成功(`date +"%Y-%m-%d %H:%M:%S"`)"

#sync nextcloud
rclone copy ~/nextcloud-$Date.zip $DestDir/nextcloud
rm -f ~/nextcloud-$Date.zip
echo "主程序同步成功(`date +"%Y-%m-%d %H:%M:%S"`)"

#delete old backups
DELTIME=`date -d "7 days ago" +%Y%m%d`
echo "开始删除七天前（$DELTIME）的备份版本"
rclone purge $DestDir/sql/nextcloud-sqlbkp_$DELTIME.bak

echo "同步完成(`date +"%Y-%m-%d %H:%M:%S"`)"
echo "-------------------------------------------------------------------"