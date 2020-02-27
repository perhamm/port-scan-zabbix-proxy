#!/bin/bash
#usage(){ echo "Usage: ./$(basename $0) hostname. For example: ./$(basename $0) server1.example.com";}
#if [ -z $1 ]; then usage; exit 1; fi
IFS=$'\n'
declare -a servers=("2.2.2.2" "2.2.2.2")
echo -n '{"data":[' > /tmp/tmp4782389342
for i in "${servers[@]}"
do
LIST=$(nmap -sU -sS -Pn -p0-65535 $i --min-rate 5000 | grep 'open \|closed ')
for s in $LIST; do
        PORT=$(echo $s | cut -d/ -f1)
        PROTO=$(echo $s | cut -d/ -f2 | awk '{sub(/[[:space:]].*/,""); print}')
        SERVICE=$(echo $s | awk '{print $3}')
        echo -n '{"{#IP}":"'${i}'","{#PORT}":"'${PORT}'","{#PROTO}":"'${PROTO}'","{#SERVICE}":"'${SERVICE}'"},'
done 
done |sed -e 's:\},$:\}:' >> /tmp/tmp4782389342
echo -n ']}' >> /tmp/tmp4782389342
if [ -n  `cat /tmp/tmp4782389342`  ]
then zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k port-discovery -o `cat /tmp/tmp4782389342`
fi

unset IFS
