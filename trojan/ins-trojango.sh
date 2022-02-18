#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
_INSTALL(){
	mkdir -p /usr/lib/trojan-go >/dev/null 2>&1
	wget -q -N --no-check-certificate https://github.com/p4gefau1t/trojan-go/releases/download/$(curl -fsSL https://api.github.com/repos/p4gefau1t/trojan-go/releases | grep '"tag_name":' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')/trojan-go-linux-amd64.zip 
	unzip -o -d /usr/lib/trojan-go/ ./trojan-go-linux-amd64.zip >/dev/null 2>&1
	mv /usr/lib/trojan-go/trojan-go /usr/local/bin/ >/dev/null 2>&1
	chmod +x /usr/local/bin/trojan-go
    rm -rf ./trojan-go-linux-amd64.zip >/dev/null 2>&1
}

_INSTALL