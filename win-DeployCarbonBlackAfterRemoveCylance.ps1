#EVALUATION CODE

#If an old version of Cylance is installed we need to remove it
$targetversion = 2.0

$Cylance = Get-WmiObject -Class Win32_Product | where vendor -eq "Cylance, Inc."

if ($Cylance.version -lt $targetversion) {
    #Less Than Target need to uninstall
    Write-Output "We are lower than the target version so let's uninstall"
    Exit(1)
} else {
    #Greater than Target
    Write-Output "We are good to go on version"
    Exit(0)
}


#REMEDIATION CODE

$targetversion = 2.0
$Cylance = Get-WmiObject -Class Win32_Product | where vendor -eq "Cylance, Inc."
if($Cylance) {
    Write-Output "Running Remediation code"
    if ($Cylance.name -eq "Cylance Unified Agent") {
        #Less Than Target need to uninstall
       Write-Output "We are running the Unified Agent so proceeding to Uninstall"
        Write-Output "Uninstalling " $Cylance.name
        $exit = $Cylance.uninstall()
        Write-Output $exit.ReturnValue
        if($exit.ReturnValue -eq 0) {
           exit (Start-Process -FilePath 'msiexec.exe' -ArgumentList ('/q', '/i', '"installer_vista_win7_win8-64-3.7.0.1503.msi"', 'COMPANY_CODE=NHFQT1RAWE3U6XYCELT') -Wait -Passthru).ExitCode
       } else {
           Exit($exit.ReturnValue)
       }
    } else {
      #Greater than Target
       Write-Output "We are good to go on version so this must have been a manual run of the worklet"
       Exit(0)
    }
} else {
    Write-Output "We grabbed the Cylance WMI Object but it is null so we are just exiting. This shouldn't happen ever so if it does you need to investigate"
    Exit(1)
}