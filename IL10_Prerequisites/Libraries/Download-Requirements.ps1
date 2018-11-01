<# This script contains the functions required to download the necessary files for the pre-requisites if they are missing from the target computer. The two functions created by this script are:
  1. Get-TomcatInstall;
  2. Get-JavaInstalll;

Both of the above functions, once created and pathed in the other scripts, will be able to be called as individuals instead of as a whole.
The method of downloading the installer files is Background Intelligent Transfer Service (BITS). Using Bits removes the need to call explicit file paths on the destination and will instead automatically download the file and save it using the name in the URL.
#>

function Get-Tomcat {
  #64 bit logic here
    if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit") {
    #Ask for user input in a GUI dialog box
   [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
    $filepath = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save Tomcat to", "Save As")
    #Test entered path for existence. If it does not exist, create the directory structure
    if(-Not(Test-Path -Path $filepath)){
      New-Item -ItemType directory -Path $filepath > $null
      }
    Start-BitsTransfer -Source "http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34-windows-x64.zip" -Destination $filepath
    }
  #32 bit logic here
else {
    #Ask for user input in a GUI dialog box
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
    $filepath = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save Tomcat to", "Save As")
    #Test entered path for existence. If it does not exist, create the directory structure
    if(-Not(Test-Path -Path $filepath)){
      New-Item -ItemType directory -Path $filepath > $null
      }
    Start-BitsTransfer -source "http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34-windows-x86.zip" -Destination $filepath
    }
    [System.Windows.MessageBox]::Show('Apache Tomcat has been downloaded to ' + $filepath,"Download Success")
}

function Get-JavaRE {
  if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit") {
    #64 bit logic here
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
    $filepath = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save Tomcat to", "Save As")
    #Test entered path for existence. If it does not exist, create the directory structure
    if(-Not(Test-Path -Path $filepath)){
      New-Item -ItemType directory -Path $filepath > $null
      }
    Start-BitsTransfer -Source "<Insert Direct Download Link for JavaRE x64 Offline Installer>" -Destination $filepath
  }
  else {
    #32 bit logic here
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
    $filepath = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save Tomcat to", "Save As")
    #Test entered path for existence. If it does not exist, create the directory structure
    if(-Not(Test-Path -Path $filepath)){
      New-Item -ItemType directory -Path $filepath > $null
      }
    Start-BitsTransfer -Source "<Insert Direct Download Link for JavaRE x86 Offline Installer>" -Destination $filepath
  }
    [System.Windows.MessageBox]::Show('Oracle Java Runtime Environment has been downloaded to ' + $filepath)
}

function Extract-Tomcat {


}
