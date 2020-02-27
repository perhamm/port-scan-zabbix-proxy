#!/bin/bash
ip="1.1.1.1 2.2.2.2 3.3.3.3"
TOKEN=111111111:1111111111111111111111111111111111
chat_id=-111111111111
if [[ $(nmap -sS -p80,443 $ip --min-rate 5000 | grep open) ]]; then zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k findopenhttp_stn  -o 1 ; else `curl -X POST      -H 'Content-Type: application/json'      -d '{"chat_id": "$chat_id", "text": "Не обнаружено открытых портов tcp80/443 на ip $ip. Возможно, в Диаскане отсутсвует интернет STN. "}'      https://api.telegram.org/bot$TOKEN/sendMessage > /dev/null`; zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k findopenhttp_stn  -o 0 ;fi



