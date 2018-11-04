# backup-to-email ver. 1.3
# Required policies: ftp, read, policy, sensitive, test


#---------------------------------------------------------------------
# CONFIGURATION BLOCK STARTS HERE

# set recipient email address
:local emailRecipient "john.doe@example.com"

# set email subject line
:local emailSubject "MikroTik backup"

# set to true if you want the subject line prefixed with system identity
:local putIdentityInSubject true

# set email body
:local emailBody "Please find attached..."

# set to true if you want a binary backup file
:local sendBackupFile true

# set to true if you want a configuration script file
:local sendConfigurationScript true

# set filename prefix (i.e. company name)
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
  :if ($putIdentityInSubject = true) do={
    :set emailSubject ([/system identity get name] . ": " . $emailSubject)
  }
  /tool e-mail send to=$emailRecipient subject=$emailSubject body=$emailBody file=$attachmentList
}
