try {

  $HighPerformanceScheme = (powercfg -l | Where-Object { $_ -like '*performance*' }).split()[3]

  # If the name changes at some point, better check if there's a value here...
  if ($null -eq $HighPerformanceScheme) {
    throw "Error: Couldn't find 'High Performance' power scheme from $(powercfg -l)"
  }

  powercfg -setactive $HighPerformanceScheme
} catch {
  Write-Warning -Message "Unable to set power plan to High Performance"
  Write-Warning $Error[0]
}