# backup-to-email ver. 1.4
# https://github.com/bartmichu/mikrotik-scripts/tree/master/backup-to-email
#
# Required policies: ftp, read, policy, sensitive, test


#---------------------------------------------------------------------
# CONFIGURATION BLOCK STARTS HERE

# set recipient email address between quotes
:local emailRecipient "john.doe@example.com"

# set email subject line between quotes
:local emailSubject "MikroTik backup"

# do you want the subject line prefixed with a system identity?
# set to true or false without quotes
:local addIdentityToSubject true

# set email body between quotes
:local emailBody "Please find attached..."

# do you want a binary backup file?
# set to true or false without quotes
:local sendBackupFile true

# do you want a configuration script file?
# set to true or false without quotes
:local sendConfigurationScript true

# set filename prefix (i.e. company name) between quotes
:local filenamePrefix "auto-backup"

# CONFIGURATION BLOCK ENDS HERE
#---------------------------------------------------------------------


:local attachmentList value=[:toarray ""]
:local filename value=([/system identity get name] . "_" . [/system package update get installed-version])

:if ([:len $filenamePrefix] > 0) do={
  :set filename ($filenamePrefix . "_" . $filename)
}

:if ($sendBackupFile = true) do={
  /system backup save name=($filename . ".backup")
  :delay 10s
  :set attachmentList ($attachmentList, ($filename . ".backup"))
}

:if ($sendConfigurationScript = true) do={
  /export file=($filename . ".rsc")
  :delay 10s
  :set attachmentList ($attachmentList, ($filename . ".rsc"))
}

:if ([:len $attachmentList] > 0) do={
  :if ($addIdentityToSubject = true) do={
    :set emailSubject ([/system identity get name] . ": " . $emailSubject)
  }
  /tool e-mail send to=$emailRecipient subject=$emailSubject body=$emailBody file=$attachmentList
}

#/log info "backup-to-email: script completed"
