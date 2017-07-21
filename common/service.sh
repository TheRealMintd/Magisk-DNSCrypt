#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread

while :; do
#check first server
        RESOLVER_NAME=d0wn-sg-ns1
        dnscrypt-proxy \
        --resolver-name="$RESOLVER_NAME" \
        --resolvers-list=/system/etc/dnscrypt-proxy/dnscrypt-resolvers.csv \
        --test=3600
        case "$?" in
                0 ) break;;
        esac
        sleep 1

# check second server (servers go down pretty often)
        RESOLVER_NAME=cisco
        dnscrypt-proxy \
        --resolver-name="$RESOLVER_NAME" \
        --resolvers-list=/system/etc/dnscrypt-proxy/dnscrypt-resolvers.csv \
        --test=3600
        case "$?" in
                0 ) break;;
        esac
        sleep 1
done

dnscrypt-proxy \
--daemonize \
--loglevel=3 \
--resolver-name="$RESOLVER_NAME" \
--resolvers-list=/system/etc/dnscrypt-proxy/dnscrypt-resolvers.csv && \
iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1 && \
iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 127.0.0.1