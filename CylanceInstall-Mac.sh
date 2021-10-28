#
#You will need to upload PROTECT Installer (pkg), OPTICS Installer (pkg) and cyagent_install_token
#
#EVALUATION CODE

#!/bin/bash

app_name="CylancePROTECT"
#version="20.4.30.2774"
check_file="/Applications/Cylance/Optics/Uninstall CylanceOPTICS.app"
check_file2="/Applications/Cylance/Uninstall CylancePROTECT.app"

application_path="/Applications/${app_name}.app"

# check if app exists
if [[ -e "$check_file2" ]]; then
	echo "Application ${app_name} found"
	exit 0
else
  echo "Application ${app_name} not found"
  exit 1
fi

#REMEDIATION CODE

#!/bin/bash

installer -pkg CylancePROTECT.pkg -target /
darwinVersion=$(uname -r | cut -d "." -f1)
if [[ "$darwinVersion" -lt 20 ]]; then
  echo "We are not on Big Sur or Monterey so installing OPTICS"
  installer -pkg CylanceOPTICS.pkg -target /
  exit 0
fi
