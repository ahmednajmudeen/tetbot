#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

clear
VLESSTrial=trial`</dev/urandom tr -dc A-Z0-9 | head -c4`
Hariii=1
Passss=1
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $VLESSTrial =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		
		CLIENT_EXISTS=$(grep -w $VLESSTrial /etc/v2ray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$Hariii days" +"%Y-%m-%d"`
sed -i '/#vlessWSTLS$/a\#& '"$VLESSTrial $exp"'\
},{"id": "'""$uuid""'","email": "'""$VLESSTrial""'"' /etc/v2ray/config.json
sed -i '/#vlessWS$/a\#& '"$VLESSTrial $exp"'\
},{"id": "'""$uuid""'","email": "'""$VLESSTrial""'"' /etc/v2ray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vlessws&security=tls&encryption=none&type=ws#${VLESSTrial}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vlessws&encryption=none&type=ws#${VLESSTrial}"
systemctl restart v2ray
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m      ⇱ V2ray/Vless Account ⇲      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Remarks : ${VLESSTrial}"
echo -e "Domain : ${domain}"
echo -e "port TLS : $tls"
echo -e "port none TLS : $none"
echo -e "id : ${uuid}"
echo -e "Encryption : none"
echo -e "network : ws"
echo -e "path : /vlessws"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "link TLS: ${vlesslink1}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "link none TLS : ${vlesslink2}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Expired On : $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"

v2ray-menu