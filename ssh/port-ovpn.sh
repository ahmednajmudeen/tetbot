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
IP=$(curl -sS ifconfig.me);
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m           ⇱ Change Port OVPN ⇲           \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo ""
echo -e "[1]  Change Port TCP $ovpn"
echo -e "[2]  Change Port UDP $ovpn2"
echo -e "[x]  Exit"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p "Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port OpenVPN: " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/server/server-tcp-$ovpn.conf
rm -f /etc/openvpn/Tcp.ovpn
rm -f /home/vps/public_html/Tcp.ovpn
cat > /etc/openvpn/server/server-tcp-$vpn.conf<<END
port $vpn
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.6.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-tcp.log
verb 3
END
cat > /etc/openvpn/Tcp.ovpn <<-END
client
dev tun
proto tcp
remote $IP $vpn
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
echo '<ca>' >> /etc/openvpn/Tcp.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/Tcp.ovpn
echo '</ca>' >> /etc/openvpn/Tcp.ovpn
cp /etc/openvpn/Tcp.ovpn /home/vps/public_html/Tcp.ovpn
systemctl disable --now openvpn-server@server-tcp-$ovpn > /dev/null
systemctl enable --now openvpn-server@server-tcp-$vpn > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2, SSL 442/   - OpenVPN                 : TCP $vpn, UDP $ovpn2, SSL 442/g" /root/log-install.txt
sed -i "s/$ovpn/$vpn/g" /etc/stunnel/stunnel.conf
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
systemctl restart stunnel4
else
echo "Port $vpn is used"
fi
;;
2)
read -p "New Port OpenVPN: " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/server/server-udp-$ovpn2.conf
rm -f /etc/openvpn/Udp.ovpn
rm -f /home/vps/public_html/Udp.ovpn
cat > /etc/openvpn/server/server-udp-$vpn.conf<<END
port $vpn
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.7.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-udp.log
verb 3
explicit-exit-notify
END
cat > /etc/openvpn/Udp.ovpn <<-END
client
dev tun
proto udp
remote $IP $vpn
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
echo '<ca>' >> /etc/openvpn/Udp.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/Udp.ovpn
echo '</ca>' >> /etc/openvpn/Udp.ovpn
cp /etc/openvpn/Udp.ovpn /home/vps/public_html/Udp.ovpn
systemctl disable --now openvpn-server@server-udp-$ovpn2 > /dev/null
systemctl enable --now openvpn-server@server-udp-$vpn > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2, SSL 442/   - OpenVPN                 : TCP $ovpn, UDP $vpn, SSL 442/g" /root/log-install.txt
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
else
echo "Port $vpn is used"
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

menu
