#!/bin/bash

# Define the target URL
TARGET_URL="http://example.com"

# Define the output directory
OUTPUT_DIR="/path/to/output/directory"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Perform a basic scan using Nikto
nikto -h "$TARGET_URL" -output "$OUTPUT_DIR/nikto.txt"

# Perform an Nmap scan to identify open ports and services
nmap -sV -p- "$TARGET_URL" -oN "$OUTPUT_DIR/nmap.txt"

# Perform a directory and file enumeration using Dirb
dirb "$TARGET_URL" "$OUTPUT_DIR/dirb.txt"

# Perform a SQL injection test using Sqlmap
sqlmap -u "$TARGET_URL" --batch --output-dir="$OUTPUT_DIR/sqlmap"

# Perform a cross-site scripting (XSS) test using Xsser
xsser -u "$TARGET_URL" -o "$OUTPUT_DIR/xsser.html"

# Perform a local file inclusion (LFI) test using LFISuite
lfisuite -u "$TARGET_URL" -o "$OUTPUT_DIR/lfisuite.html"

# Perform a remote file inclusion (RFI) test using RFI-LFIRF
rfi-lfirf -u "$TARGET_URL" -o "$OUTPUT_DIR/rfi-lfirf.html"

# Perform a basic scan using Nikto
echo "Running Nikto scan..."
nikto -h $TARGET_URL

# Perform a vulnerability scan using OWASP ZAP
echo "Running OWASP ZAP scan..."
zap-cli --zap-path /usr/share/zaproxy/zap.sh --output /tmp/zap-report.html -t $TARGET_URL

# Perform a vulnerability scan using Nmap
echo "Running Nmap scan..."
nmap -p 80 $TARGET_URL

# Perform active reconnaissance with ffuf
echo "Running active reconnaissance with ffuf..."
ffuf -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u $TARGET_URL/FUZZ

# Perform passive reconnaissance with sublist3r
echo "Running passive reconnaissance with sublist3r..."
sublist3r -d $TARGET_URL -o /tmp/subdomains.txt

# Find hidden or secret endpoints with ffuf
echo "Finding hidden or secret endpoints with ffuf..."
ffuf -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u $TARGET_URL/FUZZ -e .html,.php,.asp,.aspx,.jsp,.txt,.js,.xml,.json,.sql -fs 404
