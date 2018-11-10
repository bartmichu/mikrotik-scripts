# update-monitor
This script will send you email notification if it finds a newer version of RouterOS package on MikroTik servers or when it finds that a RouterBOOT loader update is awaiting installation on your device. However, it will not apply any updates for you.


## Installation
1. Configure and test the SMTP server settings (*Tools -> Email*).
2. Add content of ```update-monitor.rsc``` file as a new script named ```update-monitor``` and select all required policies.
3. Adjust configuration to your needs and save changes.
4. Schedule script execution with GUI or use this command:
   ```
   /system scheduler add name="update-monitor" on-event="/system script run update-monitor" start-time=07:00:00 interval=24h
   ```
This script uses built-in functionality to check official MikroTik servers and works with default firewall configuration without any modification. But if you have implemented a restrictive filtering policy on the output chain then you will have to add appropriate rules.


## Configuration
* ```emailRecipient``` (text string between quotes) - recipient email address
* ```emailSubject``` (text string between quotes) - email subject line
* ```addIdentityToSubject``` (boolean value without quotes) - set to true if you want the subject line prefixed with system identity
* ```emailBody``` (text string between quotes) - email body


## Removal
Remove both schedule and script named ```update-monitor``` using GUI or with these commands:
```
/system scheduler remove "update-monitor"
/system script remove "update-monitor"
```