#!/bin/bash
#
#DNS adblock/malware block for USG
#
#Orginal script: https://community.ubnt.com/t5/UniFi-Routing-Switching/Use-USG-to-block-sites-apps-like-ER/td-p/1497045
#
#Howto: SSH into your USG:
#sudo su -
#vi /config/user-data/update-adblock-dnsmasq.sh (add file content)
#ESC :wq
#chmod +x /config/user-data/update-adblock-dnsmasq.sh
#/config/user-data/update-adblock-dnsmasq.sh
#
#check if all went fine by nslookup on a box that uses your USG as DNS (default from DHCP)
#>nslookup zyban.1.p21.info (should return address: 0.0.0.0)
#
#crontab -l should show you now a line to automatically update once a day
#
#enjoy!
# @ar0xa

if grep -q adblock /var/spool/cron/crontabs/root
then
  echo "Cron OK"
else
 echo "0 3 * * 0 /config/user-data/update-adblock-dnsmasq.sh" >> /var/spool/cron/crontabs/root
fi

ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf"
temp_ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf.tmp"

# get two hosts files with 127.0.0.1 adress, extract out only ad blocking lists and write them to a temporary file
curl -s "http://sysctl.org/cameleon/hosts" "http://hosts-file.net/ad_servers.txt" "http://www.malwaredomainlist.com/hostslist/hosts.txt" | grep -w ^127.0.0.1$'\(\t\| \)' | sed 's/^127.0.0.1\s\{1,\}//' > $temp_ad_file

# get another two hosts files with 0.0.0.0 adress, extract out only ad blocking lists, remove whitespace at the end of some lines and output it to temp
curl -s "https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt" "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" "http://winhelp2002.mvps.org/hosts.txt" "http://someonewhocares.org/hosts/zero/hosts" | grep -w ^0.0.0.0 | cut -c 9- | sed 's/\s\{1,\}.*//' >> $temp_ad_file

#host only lists
curl -s "http://mirror1.malwaredomains.com/files/justdomains" "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist" "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt" "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"| grep -v "#" >> $temp_ad_file

# remove the carriage return at the end of each line of the temporary file, and convert it into a Dnsmasq format
sed -i -e 's/\r$//; s:.*:address=/&/0\.0\.0\.0:' $temp_ad_file

# get another hosts file in Dnsmasq format, and add the contents to a temporary file
curl -s "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=dnsmasq&showintro=0&mimetype=plaintext&useip=0.0.0.0" >> $temp_ad_file
curl -s "https://raw.githubusercontent.com/notracking/hosts-blocklists/master/domains.txt" | grep -v "#">> $temp_ad_file

if [ -f "$temp_ad_file" ]
then
# sort ad blocking list in the temp file and remove duplicate lines from it
 sort -o $temp_ad_file -t '/' -uk2 $temp_ad_file

# uncomment the line below, and modify it to remove your favorite sites from the ad blocking list
 sed -i -e '/spclient\.wg\.spotify\.com/d' $temp_ad_file
 mv $temp_ad_file $ad_file
else
 echo "Error building the ad list, please try again."
 exit
fi

#
## add some specific add hosts
#
echo 'address=/aa.i-stream.pl/0.0.0.0' >> $ad_file

#
## restart dnsmasq
/etc/init.d/dnsmasq force-reload
