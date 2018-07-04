#!/bin/bash
echo "-------------------------------------------------------------------"
echo "备份开始(`date +"%Y-%m-%d %H:%M:%S"`)"

WebsiteName=[your_website_name]
Date=$(date +"%Y%m%d")

#创建备份目录(一天备份一次)
mkdir -p /data/backup/$WebsiteName/$Date

cd /data/backup/$WebsiteName

#停止Seafile服务器
/data/seafile/seafile-server-latest/seafile.sh stop
/data/seafile/seafile-server-latest/seahub.sh stop

#导出数据库
sqlite3 /data/seafile/seafile-data/seafile.db .dump > /data/backup/$WebsiteName/$Date/seafile.db.bak
sqlite3 /data/seafile/ccnet/misc/config.db .dump > /data/backup/$WebsiteName/$Date/config.db.bak
sqlite3 /data/seafile/ccnet/GroupMgr/groupmgr.db .dump > /data/backup/$WebsiteName/$Date/groupmgr.db.bak
sqlite3 /data/seafile/ccnet/PeerMgr/usermgr.db .dump > /data/backup/$WebsiteName/$Date/usermgr.db.bak
sqlite3 /data/seafile/ccnet/OrgMgr/orgmgr.db .dump > /data/backup/$WebsiteName/$Date/orgmgr.db.bak
sqlite3 /data/seafile/seahub.db .dump > /data/backup/$WebsiteName/$Date/seahub.db.bak

#备份文件
zip -q -r /data/backup/$WebsiteName/$Date/$WebsiteName.zip /data/seafile

#启动Seafile服务器
/data/seafile/seafile-server-latest/seafile.sh start
/data/seafile/seafile-server-latest/seahub.sh start

echo "备份成功(`date +"%Y-%m-%d %H:%M:%S"`)，文件夹为：/data/backup/$WebsiteName/$Date"
echo "-------------------------------------------------------------------"
