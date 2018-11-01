<# This script contains the functions required to download the necessary files for the pre-requisites if they are missing from the target computer. The two functions created by this script are:
  1. Get-TomcatInstall;
  2. Get-JavaInstalll;

Both of the above functions, once created and pathed in the other scripts, will be able to be called as individuals instead of as a whole.
The method of downloading the installer files is Background Intelligent Transfer Service (BITS). Using Bits removes the need to call explicit file paths on the destination and will instead automatically download the file and name it as called in the URL.
#>


function Get-Tomcat86 {
$filepath = Read-Host -Prompt "Please enter the location where Tomcat will be downloaded to"
Start-BitsTransfer -source "http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34-windows-x86.zip" -Destination $filepath
}

function Get-Tomcat64 {
$filepath = Read-Host -Prompt "Please enter the location where Tomcat will be downloaded to"
Start-BitsTransfer -Source "http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34-windows-x64.zip" -Destination $filepath
}

function Get-Java86 {
$filepath = Read-Host -Prompt "Please enter the location where the Java Runtime will be downloaded to"
Start-BitsTransfer -Source "<Insert Direct Download Link for JavaRE x86 Offline Installer>" -Destination $filepath
}

function Get-Java64 {
$filepath = Read-Host -Prompt "Please enter the location where the Java Runtime will be downloaded to"
Start-BitsTransfer -Source "<Insert Direct Download Link for JavaRE x64 Offline Installer>" -Destination $filepath
}
