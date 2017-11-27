<h1>Ubiquity USG DNS Based adblocker</h1>

<b>NOTE: after a firmware upgrade, the script needs to be executed again manually to re-create the crontab job and refill the dnsmasq list.</b>
<br>
<h1>versions</h1>
V.1 added pi-hole domains as suggsted by @recrudesce 

<h1>Howto install</h1>

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

