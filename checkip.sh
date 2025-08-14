#!/bin/bash
# Script cek IP da& subdomain (brute-force)
# Usage: checkip_root.sh domain.com

if [ -z "$1" ]; then
    echo "Usage: checkip_root.sh domain.com"
    exit 1
fi

DOMAIN=$1
DOMAIN=$(echo $DOMAIN | sed -E 's
WORDLIST="subdomains.txt"  

echo "🌐 Domain utama  : $DOMAIN"

TMP_IPS=$(mktemp)

dig +short A $DOMAIN >> $TMP_IPS
dig +short AAAA $DOMAIN >> $TMP_IPS

if [ ! -f "$WORDLIST" ]; then
    echo "❌ Wordlist $WORDLIST tidak ditemukan"
    exit 1
fi

echo "🔎 Mengecek subdomain dari $WORDLIST ..."
while read sub; do
    FULL_DOMAIN="$sub.$DOMAIN"
    IPV4=$(dig +short A $FULL_DOMAIN)
    IPV6=$(dig +short AAAA $FULL_DOMAIN)
    if [ ! -z "$IPV4" ] || [ ! -z "$IPV6" ]; then
        echo "✅ Subdomain ditemukan: $FULL_DOMAIN"
        echo "$IPV4" >> $TMP_IPS
        echo "$IPV6" >> $TMP_IPS
    fi
done < $WORDLIST

ALL_IPS=$(cat $TMP_IPS | grep -v '^$' | sort -u)
rm $TMP_IPS

if [ -z "$ALL_IPS" ]; then
    echo "❌ Tidak ada IP ditemukan"
    exit 1
fi

echo
read -p "Scan semua port? (y/n, default top-20) : " scan_all
if [ "$scan_all" = "y" ] || [ "$scan_all" = "Y" ]; then
    PORT_OPTION="-p-"
else
    PORT_OPTION="--top-ports 20"
fi

for IP in $ALL_IPS; do
    echo
    echo "🔍 IP      : $IP"
    LOC=$(curl -s https://ipinfo.io/$IP | grep -E '"city"|"region"|"country"' | sed 's/[",]//g' | awk '{print $2}' | xargs echo)
    ISP=$(curl -s https://ipinfo.io/$IP | grep '"org"' | cut -d':' -f2- | tr -d '",')
    echo "📍 Lokasi  : $LOC"
    echo "🏢 ISP     : $ISP"
    echo "🔓 Port terbuka:"
    nmap $PORT_OPTION $IP
done
