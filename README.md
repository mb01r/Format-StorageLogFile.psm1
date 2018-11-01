# Format-StorageLogFile.psm1
  <#
  .SYNOPSIS
  Takes a storage analytics log file and formats its it for further processing.

  .DESCRIPTION
  Format-StorageLogFile.psm1 takes an Azure Storage version 1 log file, parses each line in the file and assosiates each field to the field name.

  .PARAMETER Path
  Path to the log file

  .OUTPUTS
  psobject

  .EXAMPLE
  C:\logs\0000001.log | Format-StorageLogFile | ConvertTo-Json | Out-File $env:HOMEPATH\storagelogs.json

  .link
  https://docs.microsoft.com/en-us/rest/api/storageservices/Storage-Analytics-Log-Format?redirectedfrom=MSDN
  #>
