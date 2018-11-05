# update-notifier ver. 0.1 EXPERIMENTAL
# Required policies: read,policy,write,test


#---------------------------------------------------------------------
# CONFIGURATION BLOCK STARTS HERE

# set recipient email address
:local emailRecipient "john.doe@example.com"

# set email subject line
:local emailSubject "MikroTik update available"

# set to true if you want the subject line prefixed with system identity
:local addIdentityToSubject true

# set email body
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
  :if ($addIdentityToSubject = true) do={
    :set emailSubject ([/system identity get name] . ": " . $emailSubject)
  }
  /tool e-mail send to=$emailRecipient subject=$emailSubject body=$emailBody
}

/log info "update-notifier script completed"
