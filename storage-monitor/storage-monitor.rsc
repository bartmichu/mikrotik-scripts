# storage-monitor ver. 1.0
# Required policies: ftp, read, policy, sensitive, test


#---------------------------------------------------------------------
# CONFIGURATION BLOCK STARTS HERE

# set recipient email address between quotes
:local emailRecipient "john.doe@example.com"

# set email subject line between quotes
:local emailSubject "Storage threshold exceeded"

# do you want the subject line prefixed with a system identity?
# set to true or false without quotes
:local addIdentityToSubject true

# set email body between quotes
:local emailBody "Used HDD space threshold is exceeded."

# what is the threshold for used space (percentage)?
# set to a number between 0 and 100 without quotes
:local usageThreshold 90

# CONFIGURATION BLOCK ENDS HERE
#---------------------------------------------------------------------


:local usage value=(100 - ((100 * [/system resource get free-hdd-space]) / [/system resource get total-hdd-space]))

:if ($usage > $usageThreshold) do={
  /log info "storage-monitor: threshold exceeded condition"

  :if ($addIdentityToSubject = true) do={
    :set emailSubject ([/system identity get name] . ": " . $emailSubject)
  }

  /tool e-mail send to=$emailRecipient subject=$emailSubject body=$emailBody
}

#/log info "storage-monitor: script completed"
