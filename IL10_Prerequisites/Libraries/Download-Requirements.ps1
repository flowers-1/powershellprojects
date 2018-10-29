<# This script contains the functions required to download the necessary files for the pre-requisites if they are missing from the target computer. The two functions created by this script are:
  1. Get-TomcatInstall;
  2. Get-JavaInstalll;

Both of the above functions, once created and pathed in the other scripts, will be able to be called as individuals instead of as a whole.
#>

function Get-Tomcat86 {
#Download the application to a specific location.

$filepath = Read-Host -Prompt "Please enter the location where Tomcat will be downloaded"
iwr 'http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34-windows-x86.zip' -OutFile $filepath
