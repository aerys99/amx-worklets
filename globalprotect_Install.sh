#!/bin/zsh
export TERM=xterm-256color

#----EDIT THESE VARIABLES

#Zip file should include the plist config file, the GlobalProtect.pkg and the install_system_extensions.xml
#Other files in the zip will not be used

src_dl="[INSERT DISTRIBUTION SOURCE HERE]"
appid="pangpinstall"
install_pkg="GlobalProtect.pkg"
shacksum="[ZIP FILE CHECKSUM HERE]"
configfile="com.paloaltonetworks.GlobalProtect.settings.plist"
configdst="/Library/Preferences"

#----END VARIABLES

#Any unapproved Extensions
ua_ext_initial="$(systemextensionsctl list | grep awaiting | wc -l)"

#For GP we need to allow System Extensions, if we are doing SSLDecrypt we need CA Cert and Intermediate CA (OnPAN)

#Is it already installed
if [ -d "/Application/GlobalProtect.app" ]
	then
		echo Already Installed
		exit 0
	else
		echo Installing GlobalProtect Client
		mkdir /tmp/$appid
		echo Retrieving Zip File
		curl -o /tmp/$appid.zip $src_dl
#		curl -o /tmp/$profilename $profile_dl
		cd /tmp
		calcsum=`shasum $appid.zip | awk '{print $1}'`
		echo $calcsum
		echo $shacksum
		if [[ "$shacksum" = "$calcsum" ]]
			then
				Install=1
				echo Checksums Match - Proceed to Install
			else
				Install=0
				echo Checksum FAILED - Exiting
				exit 1
		fi
fi

#We have Downloaded and Verified the File So let's do this

unzip /tmp/$appid.zip -d /tmp/$appid
echo Unzipped

#Now we install
cd /tmp/$appid
echo Running Installer
echo Copying Initial Portal Config
sudo cp /tmp/$appid/$configfile $configdst
echo Installing
#Command below will require them to type in their password but PW shouldn't be required for the MDM server to run the script
sudo installer -pkg /tmp/$appid/$install_pkg -applyChoiceChangesXML install_system_extensions.xml -target /
echo Copying Initial Portal Config
sudo cp /tmp/$appid/$configfile $configdst
#This line puts the uninstaller in their apps folder. I did this for testing but we probably don't need to for actual deployment so remove or comment out
#cp -r /tmp/$appid/Cortex\ XDR\ Uninstaller.app /Applications

#Complete and cleanup temp files
echo Install Complete
rm -r /tmp/$appid
rm /tmp/$appid.zip
#Now we deal with permissions

#Now we need to deal with Full Disk Permissions
#This is probably better handled by an MDM Policy
