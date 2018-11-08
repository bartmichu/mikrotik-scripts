# update-monitor ver. 1.1
# Required policies: read,policy,write,test


#---------------------------------------------------------------------
# CONFIGURATION BLOCK STARTS HERE

# set recipient email address between quotes
:local emailRecipient "john.doe@example.com"

# set email subject line between quotes
:local emailSubject "MikroTik update available"

# do you want the subject line prefixed with a system identity?
# set to true or false without quotes
:local addIdentityToSubject true

# set email body between quotes
:local emailBody "System or firmware update is available for this device."

# CONFIGURATION BLOCK ENDS HERE
#---------------------------------------------------------------------


:local isUpdateAvailable false

/system package update check-for-updates once
:delay 15s

:if ([/system package update get installed-version] != [/system package update get latest-version]) do={
  :set isUpdateAvailable true
}

:if ([/system routerboard get routerboard] = true) do={
  :if ([/system routerboard get current-firmware] != [/system routerboard get upgrade-firmware]) do={
    :set isUpdateAvailable true
  }
}

:if ($isUpdateAvailable = true) do={
  /log info "update-monitor: system or firmware update available"

  :if ($addIdentityToSubject = true) do={
    :set emailSubject ([/system identity get name] . ": " . $emailSubject)
  }

  /tool e-mail send to=$emailRecipient subject=$emailSubject body=$emailBody
}

/log info "update-monitor: script completed"
