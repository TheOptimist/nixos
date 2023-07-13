Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
trap {
    Write-Host
    Write-Host "ERROR: $_"
    ($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1' | Write-Host
    ($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1' | Write-Host
    Write-Host
    Write-Host 'Sleeping for 15m to give you time to look around the virtual machine before self-destruction...'
    Start-Sleep -Seconds (15*60)
    Exit 1
}

Write-Host "$(whoami): Disabling services"

$Services = @(
  'ALG'                                         # Application Layer Gateway Service
  'autotimesvc'                                 # Cellular Time (from NITZ messages)
  'BDESVC'                                      # BitLocker Drive Encryption Service
  'BTAGService'                                 # Bluetooth Audio Gateway Service
  'BthAvctpSvc'                                 # AVCTP Service
  'bthserv'                                     # Bluetooth Support Service
  'defragsvc'                                   # Defragmentation (optimize drives)
  'diagnosticshub.standardcollector.service'    # Microsoft (R) Diagnostics Hub Standard Collector Service
  'DiagTrack'                                   # Connected User Experience and Telemetry
  #'DoSvc'                                       # Delivery Optimization
  'DPS'                                         # Diagnostic Policy Service
  'fdPHost'                                     # Function Discovery Provider Host
  'FDResPub'                                    # Manual Function Discovery Resource Publication
  'fhsvc'                                       # File History Service
  'icssvc'                                      # Windows Mobile Hotspot Service
  'lfsvc'                                       # Geolocation Service
  'lltdsvc'                                     # Link-Layer Topology Discovery Mapper
  'lmhosts'                                     # TCP/IP NetBIOS helper
  'NetLogon'                                    # Domain authentication
  'PhoneSvc'                                    # Phone Service
  'p2pimsvc'                                    # Peer Networking Identity Manager
  'p2psvc'                                      # Peer Networking Grouping
  'PNRPsvc'                                     # Peer Name Resolution Protocol
  'SEMgrSvc'                                    # Payments and NFC/SE Manager
  'SensorDataService'                           # Sensor Data Service
  'SensorService'                               # Sensor Service
  'SensrSvc'                                    # Sensor Monitoring Service
  'SharedAccess'                                # Internet Connection Sharing (ICS)
  'TrkWks'                                      # Distributed link Tracking Client
  'wcncsvc'                                     # Windows Connect Now (Config Registrar)
  'WdiServiceHost'                              # Diagnostic Service Host
  'WdiSystemHost'                               # Diagnostic System Host
  'WFDSConMgrSvc'                               # Wi-Fi Direct Services Connection Manager Service
  'wisvc'                                       # Windows Insider Service
  'WlanSvc'                                     # WLAN AutoConfig
  'workfolderssvc'                              # Work folders
  'WpcMonSvc'                                   # Parental Controls
) | ForEach-Object {
    Get-Service -Name $_ | Set-Service -StartupType Disabled
}