#!/bin/bash
echo -ne "Masukan ip router : "
read iprouter;
echo -ne "Masukan ip server : "
read ipserver;

touch /etc/network/if-up.d/iptables-dmz
echo '#!/bin/sh' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz
echo '#DNS' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A INPUT -p tcp -d '$iprouter' --dport 53 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -p tcp -d '$ipserver' --dport 53 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -t nat -A PREROUTING -p tcp -d '$iprouter' --dport 53 -j DNAT --to '$ipserver':53' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A INPUT -p udp -d '$iprouter' --dport 53 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -p udp -d '$ipserver' --dport 53 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -t nat -A PREROUTING -p udp -d '$iprouter' --dport 53 -j DNAT --to '$ipserver':53' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz

echo '#Webserver' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A INPUT -p tcp -d '$iprouter' --dport 80 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -p tcp -d '$ipserver' --dport 80 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -t nat -A PREROUTING -p tcp -d '$iprouter' --dport 80 -j DNAT --to '$ipserver':80' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz

echo '#FTP' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A INPUT -p tcp -d '$iprouter' --dport 21 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -p tcp -d '$ipserver' --dport 21 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -t nat -A PREROUTING -p tcp -d '$iprouter' --dport 21 -j DNAT --to '$ipserver':21' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz

echo '#FTP Passive' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A INPUT -p tcp -m multiport -d '$iprouter' --dport 5000:5005 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -p tcp -m multiport -d '$ipserver' --dport 5000:5005 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -t nat -A PREROUTING -p tcp -m multiport -d '$iprouter' --dport 5000:5005 -j DNAT --to '$ipserver'' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz

echo '#Mail' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A INPUT -p tcp -m multiport -d '$iprouter' --dport 80,25,110,143 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -p tcp -m multiport -d '$ipserver' --dport 80,25,110,143 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -t nat -A PREROUTING -p tcp -m multiport -d '$iprouter' --dport 80,25,110,143 -j DNAT --to '$ipserver'' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz

echo '#Samba' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A INPUT -p udp -m multiport -d '$iprouter' --dport 137:139 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -A FORWARD -p udp -m multiport -d '$ipserver' --dport 137:139 -j ACCEPT' > /etc/network/if-up.d/iptables-dmz
echo 'iptables -t nat -A PREROUTING -p tcp -m multiport -d '$iprouter' --dport 137:139 -j DNAT --to '$ipserver'' > /etc/network/if-up.d/iptables-dmz
echo '' > /etc/network/if-up.d/iptables-dmz

echo 'exit 0' > /etc/network/if-up.d/iptables-dmz

chmod +x /etc/network/if-up.d/iptables-dmz
read -n 1 -s -p "Press any key to continue"
