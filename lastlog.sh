#!/bin/bash

# 55 23 28-31 * * if [ "$(date +%d -d tomorrow)" == "01" ]; then /home/ubuntu/script/lastlog.sh; fi

today=`date "+%Y%m%d"`
logfile=/home/ubuntu/script/lastlog_$today.txt

get_username() {
	username=$2
	times=$1
	printf "%16s\t%s\n" $username $times
}
export -f get_username

get_ip() {
	ip=$2
	times=$1
	country=`curl -s https://ipinfo.io/$ip | grep country | awk -F '"' '{print $4}'`
	printf "%16s\t%s\t%s\n" $ip $times $country
}
export -f get_ip

sudo lastb -1 | tail -1 > $logfile
echo "" >> $logfile

# 用户名
echo 'top_username:' >> $logfile
printf "%16s\t%s\n" USERNAME COUNTS >> $logfile
# 不可用for循环，因为for循环默认以空格为分隔符
sudo lastb | awk '{print $1}' | sort | uniq -c | sort -k 1,1nr | head -20 | xargs -n 2 -I {} bash -c "get_username {} >> $logfile"

echo "" >> $logfile

# IP
echo 'top_ip:' >> $logfile
printf "%16s\t%s\t%s\n" IP COUNTS COUNTRY >> $logfile
sudo lastb | awk '{print $3}' | sort | uniq -c | sort -k 1,1nr | head -20 | xargs -n 2 -I {} bash -c "get_ip {} >> $logfile"