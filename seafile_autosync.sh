#!/bin/bash
echo "-------------------------------------------------------------------"

WebsiteName=[your_website_name]
Date=$(date +"%Y%m%d")

if [ ! -d "/data/backup/$WebsiteName/$Date" ]; then
    echo "未找到备份文件(`date +"%Y-%m-%d %H:%M:%S"`)"
    exit
fi

echo "同步开始(`date +"%Y-%m-%d %H:%M:%S"`)"

#同步文件
rclone copy /data/backup/$WebsiteName/$Date OneDrive:/Website/$WebsiteName/$Date

#删除本地备份
rm -rf /data/backup/$WebsiteName

#删除服务器旧备份
DELTIME=`date -d "7 days ago" +%Y%m%d`
echo "开始删除七天前（$DELTIME）的备份版本"
rclone purge OneDrive:/Website/$WebsiteName/$DELTIME
echo "同步完成(`date +"%Y-%m-%d %H:%M:%S"`)"
echo "-------------------------------------------------------------------"
