<# This script contains the functions required to download the necessary files for the pre-requisites if they are missing from the target computer. The two functions created by this script are:
  1. Get-TomcatInstall;
  2. Get-JavaInstalll;

Both of the above functions, once created and pathed in the other scripts, will be able to be called as individuals instead of as a whole.
The method of downloading the installer files is Background Intelligent Transfer Service (BITS). Using Bits removes the need to call explicit file paths on the destination and will instead automatically download the file and save it using the name in the URL.
#>

#Downloads either the 32 or 64-bit Apache Tomcat program from an official mirror, depending on the users OS Architecture, and saves it to a user specified location.
function Get-Tomcat {
  #64 bit logic here
    if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit") {
    #Ask for user input in a GUI dialog box
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null;
    $filepath = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save Tomcat to", "Save As");
    #Test entered path for existence. If it does not exist, create the directory structure
    if(-Not(Test-Path -Path $filepath)){
      New-Item -ItemType directory -Path $filepath > $null;
      }
    Start-BitsTransfer -Source "http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34-windows-x64.zip" -Destination $filepath;
    }
  #32 bit logic here
else {
    #Ask for user input in a GUI dialog box
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null;
    $filepath = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save Tomcat to", "Save As");
    #Test entered path for existence. If it does not exist, create the directory structure
    if(-Not(Test-Path -Path $filepath)){
      New-Item -ItemType directory -Path $filepath > $null;
      }
    Start-BitsTransfer -source "http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34-windows-x86.zip" -Destination $filepath;
    }
    [System.Windows.MessageBox]::Show('Apache Tomcat has been downloaded to ' + $filepath,"Download Success");
}

#Extracts the downloaded Apache Tomcat program to a user specified location. TODO Code both 32 and 64-bit logic for extraction.
function Extract-Tomcat {
  if ((Get-CimInstance Win32_OperatingSystem).version -gt "6.1.7600"){ #Windows Server 2012 and higher logic here

  }
else{ #Windows Server 2012 and lower here logic here
  Add-Type -assembly "system.io.compression.filesystem"
  [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null;
  $destination = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location where you want to extract Tomcat to", "Unzip Location");
  $downloadfile = Get-childitem -Path $filepath -Name "apache-*"
  if(-Not(Test-Path -Path $destination)){
    New-Item -ItemType directory -Path $destination > $null;
    }
  [io.compression.zipfile]::ExtractToDirectory($FilePath, $destination);
  }
  [System.Windows.MessageBox]::Show('Apache Tomcat has been downloaded to ' + $filepath,"Download Success");
}
function Install-JavaRE {
  if((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit") {
  #Read working directory paths by using the user supplied path stored in @filepath
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null;
    $workd = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save the JavaRE installer to", "Save As");
    if(-Not(Test-Path -Path $workd)){
      New-Item -ItemType directory -Path $workd > $null;
      }
    #create configuration file for silent InstallLocation
    $text = '
    INSTALL_SILENT = Enable
    AUTO_UPDATE = Enable
    SPONSORS = Disable
    REMOVEOUTOFDATEJRES = 1
    '
    $text | Set-Content "$workd\jreinstall.cfg"

    #download executable, this is the small online installer
    $source = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=235724_2787e4a523244c269598db4e85c51e0c"
    $destination = "$workd\jreInstall.exe"
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($source, $destination)

    #Install silently
    Start-Process -FilePath "$workd\jreInstall.exe" -ArgumentList INSTALLCFG="$workd\jreInstall.cfg"

    #Wait 180 seconds for the installation to finish
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(180)
    }
    Write-Progress -Activity "Installing the Java Runtime Environment" -Status "Installing, please standby..." -SecondsRemaining 0 -Completed

    #Remove the installer file from working directory
    rm -Force $workd\jre*.exe
    rm -Force $workd\jre*.cfg
  }
  else{
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null;
    $workd = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter the location you want to save the JavaRE installer to", "Save As");
    if(-Not(Test-Path -Path $workd)){
      New-Item -ItemType directory -Path $workd > $null;
      }
    #create configuration file for silent InstallLocation
    $text = '
    INSTALL_SILENT = Enable
    AUTO_UPDATE = Enable
    SPONSORS = Disable
    REMOVEOUTOFDATEJRES = 1
    '
    $text | Set-Content "$workd\jreinstall.cfg"

    #download executable, this is the small online installer
    $source = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=235724_2787e4a523244c269598db4e85c51e0c"
    $destination = "$workd\jreInstall.exe"
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($source, $destination)

    #Install silently
    Start-Process -FilePath "$workd\jreInstall.exe" -ArgumentList INSTALLCFG="$workd\jreInstall.cfg"

    #Wait 180 seconds for the installation to finish
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(180)
    }
    Write-Progress -Activity "Installing the Java Runtime Environment" -Status "Installing, please standby..." -SecondsRemaining 0 -Completed

    #Remove the installer file from working directory
    rm -Force $workd\jre*.exe
    rm -Force $workd\jre*.cfg
  }
}
