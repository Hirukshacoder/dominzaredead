#!/bin/bash

url=$1

if [ ! -d $url ];then
        mkdir $url
        
fi 

if [ ! -d $url/recon ];then
        mkdir $url/recon
fi      

echo "[+] Downloading golang *"

sudo apt install -y golang
echo ""

echo "[+] Downloading assetfinder *"
go install github.com/tomnomnom/assetfinder@latest
echo ""
echo "[+] Grabbing subdomains with assetsfinder *"

assetfinder $url >> $url/recon/assets.txt
cat $url/recon/assets.txt | grep $1 >> $url/recon/domains.txt
rm $url/recon/assets.txt

echo "[+] Downloading http probe *"
go install github.com/tomnomnom/httprobe@latest

echo ""

echo "[+] Exploring alive domains"
cat $url/recon/domains.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/active.txt

echo ""

echo "[*] All your data is saved in the recon folder as domains.txt"
