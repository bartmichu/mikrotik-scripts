# storage-monitor ver. 0.1 EXPERIMENTAL
# Required policies: TBD


#---------------------------------------------------------------------
# CONFIGURATION BLOCK STARTS HERE

# set recipient email address
:local emailRecipient "john.doe@example.com"

# set email subject line
:local emailSubject "Storage threshold exceeded"

# set to true if you want the subject line prefixed with system identity
:local addIdentityToSubject true

# set email body
:local emailBody "Used HDD space threshold is exceeded."

# set used space threshold (percentage)
:local usageThreshold 90

# CONFIGURATION BLOCK ENDS HERE
#---------------------------------------------------------------------


:local usage value=(100 - ((100 * [/system resource get free-hdd-space]) / [/system resource get total-hdd-space]))

:if ($usage > $usageThreshold) do={
  :if ($addIdentityToSubject = true) do={
    :set emailSubject ([/system identity get name] . ": " . $emailSubject)
  }
  /tool e-mail send to=$emailRecipient subject=$emailSubject body=$emailBody
}

/log info "storage-monitor: script completed"
