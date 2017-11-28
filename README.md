<h1>Ubiquiti USG DNS Based adblocker</h1>

<b>NOTE: after a firmware upgrade, the script needs to be executed again manually to re-create the crontab job and refill the dnsmasq list. <br><br>
So after a firmware upgrade, log in using SSH, sudo to root and run /config/user-data/update-adblock-dnsmasq.sh</b>
<br>
<h1>What does this do</h1>
This uses your <a href="https://www.ubnt.com/unifi-routing/usg/">Ubiquiti Security Gateway</a> device as a DNS blackhole, much like <a href="https://pi-hole.net/">pi-hole</a> does. It automatically, daily, downloads various known and trusted blacklists for advertisement, spyware, malware and tracking networks and makes it so that their DNS address resolves to 0.0.0.0 instead of the actual IP address. The result is that no data is downloaded from, or uploaded to, those networks.<br>

<h1>versions</h1>
20171121<br>
First release<br>
-added pi-hole domains as suggsted by @recrudesce <br>
-added https://github.com/notracking/hosts-blocklists<br>
<br>
<h1>How to install</h1>

SSH into your USG:<br>
<br>
sudo su -<br>
curl -o /config/user-data/update-adblock-dnsmasq.sh https://raw.githubusercontent.com/Ar0xA/USG-DNS-ADBLOCK/master/update-adblock-dnsmasq.sh<br>
chmod +x /config/user-data/update-adblock-dnsmasq.sh<br>
/config/user-data/update-adblock-dnsmasq.sh<br>


Check if all went fine by nslookup on a box that uses your USG as DNS (default from DHCP)<br>
nslookup aa.i-stream.pl (should return address: 0.0.0.0)<br>
<br>
crontab -l should show you now a line to automatically update once a day<br>
<br>
Originally taken from https://community.ubnt.com/t5/UniFi-Routing-Switching/Use-USG-to-block-sites-apps-like-ER/td-p/1497045

