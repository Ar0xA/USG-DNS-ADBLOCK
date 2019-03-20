# Ubiquiti USG DNS Based adblocker
## What does this do
This uses your [Ubiquiti Security Gateway](https://www.ubnt.com/unifi-routing/usg/) device as a DNS blackhole, much like [pi-hole](https://pi-hole.net/) does. It will download daily various known and trusted blacklists for advertisement, spyware, malware and tracking networks and makes it so that their DNS address resolves to 0.0.0.0 instead of the actual IP address. The result is that no data is downloaded from, or uploaded to, those networks.

## versions
20190320 (jsamuel1 fork)
* added persistance on firmware upgrade via config.gateway.json

20171203 (Ar0xA baseline)
* added first youtube adblocking

20171121
First release
* added pi-hole domains as suggsted by @recrudesce
* added https://github.com/notracking/hosts-blocklists

## How to install

1. SSH into your CloudKey or Controler.

2. If you don't have an existing config.gateway.json, copy the file here into the <unifi_base>/data/sites/site_ID directory.

* On a CloudKey, with the default site, the command to run will be:

```bash
curl -o /srv/unifi/data/sites/default/config.gateway.json https://raw.githubusercontent.com/jsamuel1/USG-DNS-ADBLOCK/master/config.gateway.json
```

3. You should then run a Force Provision on the Security Gateway from the unifi controllers web gui.

4. Once your device has re-started, it will wait 2 minutes before installing the adblocking dnsmasq config.

Check if all went fine by nslookup on a box that uses your USG as DNS (default from DHCP)<br>

```bash
nslookup aa.i-stream.pl
```

should return address: 0.0.0.0

## Appendix
Originally taken from https://community.ubnt.com/t5/UniFi-Routing-Switching/Use-USG-to-block-sites-apps-like-ER/td-p/1497045

For information about config.gateway.json, see https://help.ubnt.com/hc/en-us/articles/215458888-UniFi-USG-Advanced-Configuration for details.
