#!/bin/vbash

# This script is based on the ubnt community message at:
# https://community.ubnt.com/t5/UniFi-Routing-Switching/Deploying-USG-scripts-through-controller/td-p/2140097

#the following lines remove the runonprovision scheduled task
#do not modify below this line until 'end no edit'

readonly logFile="/var/log/runonprovision.log"

source /opt/vyatta/etc/functions/script-template

configure > ${logFile}
delete system task-scheduler task runonprovision  >> ${logFile}
commit >> ${logFile}
save >> ${logFile}
#exit

#end no edit

/usr/bin/curl --silent -o /config/user-data/update-adblock-dnsmasq.sh https://raw.githubusercontent.com/jsamuel1/USG-DNS-ADBLOCK/master/update-adblock-dnsmasq.sh
sudo /bin/chmod a+x /config/user-data/update-adblock-dnsmasq.sh
sudo /config/user-data/update-adblock-dnsmasq.sh

crontab -l > /config/scripts/testworked.log