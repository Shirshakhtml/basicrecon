#!/bin/bash


TARGET_URL="http://example.com"


domain=$(echo "$TARGET_URL" | sed -E 's|https?://||')
OUTPUT_DIR="/path/to/output/directory"
mkdir -p "$OUTPUT_DIR"


nikto -h "$TARGET_URL" -output "$OUTPUT_DIR/nikto.txt"
nmap -sV -p- "$TARGET_URL" -oN "$OUTPUT_DIR/nmap.txt"
dirb "$TARGET_URL" "$OUTPUT_DIR/dirb.txt"
sqlmap -u "$TARGET_URL" --batch --output-dir="$OUTPUT_DIR/sqlmap"
xsser -u "$TARGET_URL" -o "$OUTPUT_DIR/xsser.html"
lfisuite -u "$TARGET_URL" -o "$OUTPUT_DIR/lfisuite.html"
rfi-lfirf -u "$TARGET_URL" -o "$OUTPUT_DIR/rfi-lfirf.html"
zap-cli --zap-path /usr/share/zaproxy/zap.sh --output /tmp/zap-report.html -t $TARGET_URL
ffuf -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u $TARGET_URL/FUZZ
sublist3r -d $TARGET_URL -o /tmp/subdomains.txt
ffuf -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u $TARGET_URL/FUZZ -e .html,.php,.asp,.aspx,.jsp,.txt,.js,.xml,.json,.sql -fs 404

subfinder -d "$TARGET_URL" -all -o subdomains.txt
echo "Resolving subdomains ..."
wget https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt
echo 8.8.8.8 >> trusted.txt
echo 8.8.4.4 >> trusted.txt
massdns -r resolvers.txt -t A -o S subdomains.txt -w resolved0.txt
cat resolved0.txt | awk '{print $1}' | sed 's/\.$//' | sort -u | anew resolved.txt
rm -rf resolved0.txt
dnsx -l subdomains.txt -r resolvers.txt -a -resp -o resolved1.txt
cat resolved1.txt | anew resolved.txt
rm -rf resolved1.txt
puredns resolve subdomains.txt -r resolvers.txt --resolvers-trusted trusted.txt | anew resolved2.txt
cat resolved2.txt | anew resolved.txt 
rm -rf resolved2.txt


echo "HTTPX on resolved.txt ..."
cat resolved.txt | httpx -sc -title  -td -fr -cname


echo "IP Address Enumeration ..."
cat resolved.txt | xargs -I {} -n 1 dig +short {} | xargs -n 1 -I {} whois -h whois.cymru.com {} | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | anew IPs.txt
cat resolved.txt | dnsx -silent -a -resp-only | anew IPs.txt

echo "Running Port Scanning"
sudo nmap -iL IPs.txt -oN nmap-fullscan-ip.txt
sudo nmap -iL resolved.txt -p0-65535 -vv -oN nmap-fullscan-subs.txt
