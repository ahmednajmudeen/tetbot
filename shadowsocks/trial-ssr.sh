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
SSRTrial=trial`</dev/urandom tr -dc A-Z0-9 | head -c4`
Hariii=1
Passss=1
IP=$(curl -sS ifconfig.me);

CLIENT_EXISTS=$(grep -w $SSRTrial /usr/local/shadowsocksr/akun.conf | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m          ⇱ Trial SSR ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo "A client with the specified name was already created, please choose another name."
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"            
ss-menu
fi
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m          ⇱ Trial SSR ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

exp=`date -d "$Hariii days" +"%Y-%m-%d"`
lastport=$(cat /usr/local/shadowsocksr/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 )
if [[ $lastport == '' ]]; then
ssr_port=1443
else
ssr_port=$((lastport+1))
fi
ssr_password="$SSRTrial"
ssr_method="aes-256-cfb"
ssr_protocol="origin"
ssr_obfs="tls1.2_ticket_auth_compatible"
ssr_protocol_param="2"
ssr_speed_limit_per_con=0
ssr_speed_limit_per_user=0
ssr_transfer="838868"
ssr_forbid="bittorrent"
cd /usr/local/shadowsocksr
match_add=$(python mujson_mgr.py -a -u "${SSRTrial}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")
cd
echo -e "${Info} Penambahan user berhasil [username: ${SSRTrial}]"
echo -e "### $SSRTrial $exp" >> /usr/local/shadowsocksr/akun.conf
tmp1=$(echo -n "${ssr_password}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${ssr_obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "$IP:${ssr_port}:${ssr_protocol}:${ssr_method}:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"
/etc/init.d/ssrmu restart
service cron restart
IP=$(curl -sS ifconfig.me);
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m          ⇱ Trial SSR ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "User ：${SSRTrial}"
echo -e "IP : ${IP}"
echo -e "Port : ${ssr_port}"
echo -e "Password : ${ssr_password}"
echo -e "Encryption : ${ssr_method}"
echo -e "Protocol : ${Red_font_prefix}${ssr_protocol}"
echo -e "Obfs : ${Red_font_prefix}${ssr_obfs}"
echo -e "Device limit : ${ssr_protocol_param}"
echo -e "Expired On : ${exp} "
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Link SSR : ${ssr_link}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"            
ss-menu