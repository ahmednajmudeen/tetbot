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
OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Change Port OHP ⇲            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo ""
echo -e "[1]  Change Port OHP SSH $OhpSSH"
echo -e "[2]  Change Port OHP Dropbear $OhpDB"
echo -e "[3]  Change Port OHP OVPN $OhpOVPN"
echo -e "[x]  Exit"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo -e ""
read -p "Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port OHP SSH : " ohp
if [ -z $ohp ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $ohp)
if [[ -z $cek ]]; then
sed -i "s/   - OHP SSH                 : $OhpSSH/   - OHP SSH                 : $ohp/g" /root/log-install.txt
systemctl restart ohp-ssh  > /dev/null 2>&1
echo -e "\e[032;1mPort $stl modified successfully\e[0m"
else
echo "Port $ohp is used"
fi
;;
2)
read -p "New Port OHP Dropbear : " ohp
if [ -z $ohp ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $ohp)
if [[ -z $cek ]]; then
sed -i "s/   - OHP DBear               : $OhpDB/   - OHP DBear               : $ohp/g" /root/log-install.txt
systemctl restart ohp-db  > /dev/null 2>&1
echo -e "\e[032;1mPort $stl modified successfully\e[0m"
else
echo "Port $ohp is used"
fi
;;
3)
read -p "New Port OHP OpenVPN : " ohp
if [ -z $ohp ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $ohp)
if [[ -z $cek ]]; then
sed -i "s/   - OHP OpenVPN             : $OhpOVPN/   - OHP OpenVPN             : $ohp/g" /root/log-install.txt
systemctl restart ohp-opn  > /dev/null 2>&1
echo -e "\e[032;1mPort $stl modified successfully\e[0m"
else
echo "Port $ohp is used"
fi
;;
x)
exit
menu
;;
*)
echo "Please enter an correct number"
;;
esac
read -n 1 -s -r -p "Press any key to back on menu"
setting-menu