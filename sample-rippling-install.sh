#!/bin/zsh
clear
export TERM=xterm-256color
echo terminal equals $TERM
#check to see if endpoint installed
if [ -d "/Library/Application Support/Websense Endpoint" ]
then
echo Directory found. Treating as Upgrade.
else
echo Directory not found. Treating as Install
#make install Directories 
echo making directories
mkdir /Library/Application\ Support/Websense\ Endpoint
mkdir /Library/Application\ Support/Websense\ Endpoint/EPClassifier
mkdir /tmp/EndpointInstaller
fi

#get agent package from AWS
echo getting file
#download link. change the link below to match the dowload link of current file
down_link="https://pltsci-it-dlp-007752809900.s3-us-west-2.amazonaws.com/21.07_FORCEPOINT-ONE-ENDPOINT-Mac.zip"
#checksum value. change the value below to match the checksum of current file (using cksum <filename>)
chksum="3394021193"

filename="/tmp/agent.zip"
# Get file from AWS
curl -o /tmp/agent.zip $down_link

#perform checksum test
echo Validating Installer File
cksum=`cksum /tmp/agent.zip | awk '{print $1}'`
if [ "$cksum" -ne "$chksum" ]
then
echo checksum mismatch. Not installing package
#echo $cksum
Install=0
else
echo checksum matches. Proceeding with installation
Install=1
fi
if [ "$Install" -eq "1" ]
then
#Install package

#unzip to /tmp
echo unzipping
tar -xvf /tmp/agent.zip -C /tmp/

#install endpoint
echo installing packages
sudo installer -pkg /tmp/EndpointInstaller/WebsenseEndpoint.pkg -target / 
else
echo exiting without install
fi

#Do some cleanup
echo Cleaning up
rm -rf /tmp/EndpointInstaller
rm -f /tmp/agent.zip
echo sleep then updating
sleep 60
echo forcing update
/usr/local/sbin/wepsvc --update --wsdlp
echo done
