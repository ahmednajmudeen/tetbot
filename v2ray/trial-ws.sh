#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

clear
WSTrial=trial`</dev/urandom tr -dc A-Z0-9 | head -c4`
Hariii=1
Passss=1
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $WSTrial =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		
		CLIENT_EXISTS=$(grep -w $WSTrial /etc/v2ray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)

exp=`date -d "$Hariii days" +"%Y-%m-%d"`
sed -i '/#vmessWSTLS$/a\### '"$WSTrial $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$WSTrial""'"' /etc/v2ray/config.json
sed -i '/#vmessWS$/a\### '"$WSTrial $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$WSTrial""'"' /etc/v2ray/config.json

cat>/etc/v2ray/$WSTrial-tls.json<<EOF
      {
      "v": "2",
      "ps": "${WSTrial}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/v2rayws",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF
cat>/etc/v2ray/$WSTrial-none.json<<EOF
      {
      "v": "2",
      "ps": "${WSTrial}",
      "add": "${domain}",
      "port": "${none}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/v2rayws",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF

vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmesslink1="vmess://$(base64 -w 0 /etc/v2ray/$WSTrial-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /etc/v2ray/$WSTrial-none.json)"
systemctl restart v2ray > /dev/null 2>&1
service cron restart > /dev/null 2>&1
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m      ⇱ V2ray/Vmess Account ⇲      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks : ${WSTrial}"
echo -e "Domain : ${domain}"
echo -e "port TLS : ${tls}"
echo -e "port none TLS : ${none}"
echo -e "id : ${uuid}"
echo -e "alterId : 0"
echo -e "Security : auto"
echo -e "network : ws"
echo -e "path none : /v2rayws"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "link TLS : ${vmesslink1}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "link none TLS : ${vmesslink2}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Expired On : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
rm /etc/v2ray/$WSTrial-tls.json > /dev/null 2>&1
rm /etc/v2ray/$WSTrial-none.json > /dev/null 2>&1
read -n 1 -s -r -p "Press any key to back on menu"

v2ray-menu