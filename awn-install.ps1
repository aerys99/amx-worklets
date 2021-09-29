#AWN Agent + Sysmon Asssistant
#
#Required Files - Agent, SysmonAssistant, Sysmon, Customer.json

#Evaluation
if ((Test-Path -Path "C:\Program Files (x86)\Arctic Wolf Networks\Agent") -and (Test-Path -Path "C:\Program Files (x86)\Arctic Wolf Networks\Sysmon Assistant")) 
{
	Write-Output "AWN Installed - Skipping" 
	exit 0
} 
else 
{ 
	Write-Output "AWN Needed - Installing" 
	Exit 1 
}

#Remediation

$appname1 = 'arcticwolfagent-2021-05_01.msi'
$appname2 = 'sysmonassistant-1_0_1.msi'
$exit1 = 0
$exit2 = 0

if (-not (Test-Path -Path "C:\Program Files (x86)\Arctic Wolf Networks\Agent")) {$exit1 = (Start-Process -FilePath 'msiexec.exe' -ArgumentList ('/qn', '/i', $appname1) -Wait -Passthru).ExitCode}
if (-not (Test-Path -Path "C:\Program Files (x86)\Arctic Wolf Networks\Sysmon Assistant")) {$exit2 = (Start-Process -FilePath 'msiexec.exe' -ArgumentList ('/qn', '/i', $appname2) -Wait -Passthru).ExitCode}
#$exit2 = (Start-Process -FilePath 'msiexec.exe' -ArgumentList ('/qn', '/i', $appname2) -Wait -Passthru).ExitCode
$exit = $exit1 -and $exit2
exit $exit
