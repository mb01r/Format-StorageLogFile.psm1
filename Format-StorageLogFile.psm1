function Format-StorageLogFile {
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

  [OutputType([psobject])]
  [CmdletBinding()]
  param(
      [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
      [string]$Path
  )

  Process{
      if (Test-Path $path) {

          $fileContent = (Get-Content -Path $Path).split("`n")
          [regex]$pattern = ';+(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'

          foreach($logEntry in $fileContent){
              if ($logEntry.Substring(0,3) -eq "1.0") {
                  $formatEntry = $logEntry.Replace(";;",";empty;").Replace(";;",";empty;") # Adds 'null' into empty log fields. There needs to be 2 replace methods format triple simicolons ;;;
                  $field = ($formatEntry -split $pattern).Replace('"','') # Removes quotations around the fields that have them.
                  $log = [ordered]@{
                      "version-number"=$field[0]
                      "request-start-time"=$field[1]
                      "operation-type"=$field[2]
                      "request-status"=$field[3]
                      "http-status-code"=$field[4]
                      "end-to-end-latency-in-ms"=$field[5]
                      "server-latency-in-ms"=$field[6]
                      "authentication-type"=$field[7]
                      "requester-account-name"=$field[8]
                      "owner-account-name"=$field[9]
                      "service-type"=$field[10]
                      "request-url"=$field[11]
                      "requested-object-key"=$field[12]
                      "request-id-header"=$field[13]
                      "operation-count"=$field[14]
                      "requester-ip-address"=$field[15]
                      "request-version-header"=$field[16]
                      "request-header-size"=$field[17]
                      "request-packet-size"=$field[18]
                      "response-header-size"=$field[19]
                      "response-packet-size"=$field[20]
                      "request-content-length"=$field[21]
                      "request-md5"=$field[22]
                      "server-md5"=$field[23]
                      "etag-identifier"=$field[24]
                      "last-modified-time"=$field[25]
                      "conditions-used"=$field[26]
                      "user-agent-header"=$field[27]
                      "referrer-header"=$field[28]
                      "client-request-id"=$field[29]
                  }
              }
              else{
                  Write-Verbose "Only version 1 Storage logs supported."
              }
              New-Object -TypeName psobject -Property $log
          }
      }
      else{
          Write-Verbose "Path does not exist."
      }
  }
}