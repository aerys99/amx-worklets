#
#You will need to upload PROTECT Installer (pkg), OPTICS Installer (pkg) and cyagent_install_token
#
#This requires OPTICS3 and Protect 1594 or later because it runs on BigSur/Monterey
#
#EVALUATION CODE

#!/bin/bash

app_name="CylanceOPTICS"
#version="20.4.30.2774"
check_file="/Applications/Cylance/Optics/Uninstall CylanceOPTICS.app"
check_file2="/Applications/Cylance/Uninstall CylancePROTECT.app"

application_path="/Applications/${app_name}.app"

# check if app exists
if [[ -e "$check_file" ]]; then
	echo "Application ${app_name} found"
	exit 0
else
  echo "Application ${app_name} not found"
  exit 1
fi

#REMEDIATION CODE

#!/bin/bash
check_file="/Applications/Cylance/Optics/Uninstall CylanceOPTICS.app"
check_file2="/Applications/Cylance/Uninstall CylancePROTECT.app"

# check if app exists
if [[ -e "$check_file2" ]]; then
	if [ "$(grep 1594 /Applications/Cylance/CylanceUI.app/Contents/Info.plist | wc -l)" -gt 0 ] then
		echo "PROTECT 1594 Installed, Good to Go!"
	else
		echo "Old PROTECT Installed, must uninstall first"
		sudo /Applications/Cylance/Uninstall\ CylancePROTECT.app/Contents/MacOS/Uninstall\ CylancePROTECT
		echo "Installing Protect 1594"
		installer -pkg CylancePROTECT.pkg -target /
		echo "1594 Installed, Moving On"

	fi
else
	echo "PROTECT not installed, Let's install 1594"
	installer -pkg CylancePROTECT.pkg -target /
	echo "1594 Installed, Moving On"
fi
#  echo "We are not on Big Sur or Monterey so installing OPTICS"
echo "Installing OPTICS3"
installer -pkg CylanceOPTICS3.pkg -target /
exit 0
#fi
