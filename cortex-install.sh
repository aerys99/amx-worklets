#!/bin/zsh
export TERM=xterm-256color

#----EDIT THESE VARIABLES

src_dl="https://hostname/uri/file.zip"
appid="CortexXDR"
install_pkg="Cortex XDR.pkg"
shacksum=4e9a44e54120e1751bdc4c0f8ebcd1741c7e4c29

#----END VARIABLES

#Any unapproved Extensions
ua_ext_initial="$(systemextensionsctl list | grep awaiting | wc -l)"

#Is it already installed
if [ -d "/Application/Cortex XDR.app" ]
        then
                echo Already Installed
                exit 0
        else
                echo Installing Cortex XDR
                mkdir /tmp/$appid
                echo Retrieving Zip File
#               curl -o /tmp/$appid.zip $src_dl
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
sudo installer -pkg /tmp/$appid/$install_pkg -target /
cp -r /tmp/$appid/Cortex\ XDR\ Uninstaller.app /Applications
echo Install Complete
rm -r /tmp/$appid
rm /tmp/$appid.zip
#Now we deal with permissions
#osascript -e 'display alert "Cortex XDR Installed. Please open System Settings. Then go to Security and Privacy. In the lower right hand corner you should see View Details. Click that and allow all. Thank you!" buttons {"Ok"}'

#Should we check to see if they did it?