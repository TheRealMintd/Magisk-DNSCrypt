#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

dnscrypt-proxy /system/etc/dnscrypt-proxy/dnscrypt-proxy.conf

iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1