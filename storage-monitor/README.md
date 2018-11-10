# storage-monitor
This script will send you email notification if used space on your device is greater than selected threshold value.


## Installation
1. Add content of ```storage-monitor.rsc``` file as a new script named ```storage-monitor``` and select all required policies.
2. Adjust configuration to your needs and save changes.
3. Schedule script execution with GUI or use this command:
   ```
   /system scheduler add name="storage-monitor" on-event="/system script run storage-monitor" start-time=07:00:00 interval=24h
   ```


## Configuration
* ```emailRecipient``` (string) - recipient email address
* ```emailSubject``` (string) - email subject line
* ```addIdentityToSubject``` (boolean) - set to true if you want the subject line prefixed with system identity
* ```emailBody``` (string) - email body
* ```usageThreshold``` (number) - used space threshold (percentage)


## Removal
Remove both schedule and script named ```storage-monitor``` using GUI or with these commands:
```
/system scheduler remove "storage-monitor"
/system script remove "storage-monitor"
```