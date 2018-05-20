<#
    .DESCRIPTION
        This script enable key in windows registry for showing seconds in time in tray.
        It adds key wit name ShowSecondsInSystemClock to path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced 
        It also disables seconds in tray with -disableSeconds parameter
    .SYNOPSIS 
      This script enable key in windows registry for showing seconds in time in tray.
    .EXAMPLE
      It add seconds to tray:

      show-trayseconds.ps1
      
      It delete seconds from tray and restart explorer:
      
      show-trayseconds.ps1 -disableSeconds -restartExplorer
    
    .EXAMPLE    
#>


[CmdletBinding()]
param (
  [Switch]$enableSeconds,
  [Switch]$disableSeconds,                                # This parameter will turn-off seconds in tray
  [switch]$restartExplorer                                # This parameter will restart explorer process
)

$sysClockValue = "1"                                      # Value for register key ShowSecondsInSystemClock

function Show-TraySeconds () {
  New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
  -Name ShowSecondsInSystemClock -PropertyType DWord -Value $sysClockValue -Force
}

#Function for restarting explorer
function Restart-Explorer () {
  Stop-Process -Name explorer
}

#If it choosed parameter -disableSeconds then sysClockValue equal zero
if ($PSBoundParameters.ContainsKey("disableSeconds")) {
  $sysClockValue = "0"
} elseif ($PSBoundParameters.ContainsKey("enableSeconds")) {
  $sysClockValue = "1"
}

Show-TraySeconds

#Restarting explorer.exe if paramter was choosed
if ($PSBoundParameters.ContainsKey("restartExplorer")) {
  Restart-Explorer
}