# backup-to-email ver. 1.1
# Required policies: ftp, read, policy, sensitive, test


#---------------------------------------------------------------------
# CONFIGURATION BLOCK STARTS HERE

# set recipient email address
:local emailRecipient "john.doe@example.com"

# set email subject line
:local emailSubject "MikroTik backup"

# set email body
:local emailBody "Please find attached..."

# set to true if you want a binary backup file
:local wantBackupFile true

# set to true if you want a configuration script file
:local wantConfigurationScript true

# set filename prefix (i.e. company name)
:local filenamePrefix "auto-backup"

# CONFIGURATION BLOCK ENDS HERE
#---------------------------------------------------------------------


:local attachmentList value=[:toarray ""]

:local filename value=([/system identity get name] . "_" . [/system package update get installed-version])
:if ([:len $filenamePrefix]>0) do={
  :set filename ($filenamePrefix . "_" . $filename)
}

:if ($wantBackupFile = true) do={
  /system backup save name=($filename . ".backup")
  :delay 10s
  :set attachmentList ($attachmentList, ($filename . ".backup"))
}

:if ($wantConfigurationScript = true) do={
  /export file=($filename . ".rsc")
  :delay 10s
  :set attachmentList ($attachmentList, ($filename . ".rsc"))
}

:if ([:len $attachmentList]>0) do={
  /tool e-mail send to=$emailRecipient subject=$emailSubject body=$emailBody file=$attachmentList
}
