This is a script to install GlobalProtect. It is designed to download a zipped package and then install. 

The plist in this folder will auto populate your portal URL. It also defines an on-demand connection setting which you may not want. 

If you want to just populate the portal you can create your own plist using hte commands below. Then suppply this custom plist in the zip file.

sudo defaults write ~/Desktop/com.paloaltonetworks.GlobalProtect.client.plist PanPortalList ENTERYOURVPNHERE
sudo plutil -convert xml1 ~/Desktop/com.paloaltonetworks.GlobalProtect.client.plist
