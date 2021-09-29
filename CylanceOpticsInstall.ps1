#
#You need to upload hte CylanceOPTICS Installer to the Worklet


#Evaluation Code
if (Test-Path -Path "C:\Program Files\Cylance\Optics") 
{
	Write-Output "Cylance Installed - Skipping" 
	exit 0
} 
else 
{ 
	Write-Output "Cylance Optics Needed - Verifying PROTECT"
	if (Test-Path -Path "C:\Program Files\Cylance\Desktop") {
	  Write-Output "PROTECT Installed - Installing Optics"
	  Exit 1
	}  
	else
	{
	  Write-Output "Cylance PROTECT Needed - Use Unified Installer Worklet"
	  exit 0
	} 
}

#Remediation Code

$installer= 'CylanceOPTICSSetup.exe'
$arguments = ('-q')
if (Test-Path -Path "C:\Program Files\Cylance\Desktop") {
	  Write-Output "PROTECT Installed - Installing Optics"
	  exit (Start-Process -FilePath $installer -ArgumentList $arguments -Wait -Passthru).ExitCode
	}  
	else
	{
	  Write-Output "Cylance PROTECT Needed - Use Unified Installer Worklet"
	  exit 0
	}
