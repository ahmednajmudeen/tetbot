#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

clear

x="ok"

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m               ⇱ SystemAdmin MENU ⇲               \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "
[\033[0;32m01\033[0m] • Backup Data VPS
[\033[0;32m02\033[0m] • Restore Data VPS
[\033[0;32m03\033[0m] • Webmin Menu
[\033[0;32m04\033[0m] • Update to Latest Kernel
[\033[0;32m05\033[0m] • Check Ram VPS
[\033[0;32m06\033[0m] • Reboot VPS
[\033[0;32m07\033[0m] • Speedtest VPS

[00] • Back to Main Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -ne "Select menu : "; read x

case "$x" in
   1 | 01)
   clear
   backup
   ;;
   2 | 02)
   clear
   restore
   ;;
   3 | 03)
   clear
   wbmn
   ;;
   4 | 04)
   clear
   kernel-updt
   ;;
   5 | 05)
   clear
   ram
   read -n 1 -s -r -p "Press any key to back on menu"
   system-menu
   ;;
   6 | 06)
   clear
   reboot
   ;;
   7 | 07)
   clear
   speedtest
   read -n 1 -s -r -p "Press any key to back on menu"
   system-menu
   ;;
   0 | 00)
   clear
   menu
   ;;
   *)
   system-menu
esac

#fim