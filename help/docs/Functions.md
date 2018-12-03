## Functional Dependency Libraries

### I. Introduction
  Four custom functions are included in this script package. These functions are located under the "/lib" folder and are as follows:

    1. Download-Requirements.ps1
    2. Filter-SoftwareOutput.ps1
    3. Get-Software.ps1
    4. Test-IsAdmin.ps1

  The following sections will go into further detail about what each of the functions does.

### II. Libraries

##### A) Download-Requirements

###### Subroutine 1: Get-Tomcat

The first part of the function

`(gwmi win32_operatingsystem | select osarchitecture).osarchitecture`


invokes the "Windows Management Instrumentation" (WMI) runtime from within the shell and queries the local machine for the bittiness of the OS. This is returned in the format `64-bit` or `32-bit`. Depending on the returned value, the script will download the appropriate version of Apache Tomcat. Before the download begins, the script will present the user with a prompt to enter a location to save the archive file and store the user entered location to the variable `$filepath`. A simple validation routine on the user input is then run

```
if(-Not(Test-Path -Path $workd)){
   New-Item -ItemType directory -Path $workd > $null
 }
```

to test if the path entered exists. If the path exists, do nothing. If the path does not exist, create the directory tree and send any `stdout` messages to `null`.
Once the folder path has been validated, a BITS (Background Intelligent Transfer Session) runtime is invoked using the command `Start-BitsTransfer` and downloads the specific bittiness-flavor of Tomcat to the user defined path.

In both bittiness cases, once Tomcat is downloaded, the script uses the `ExtractToDirectory` method from the C# runtime - `io.compression.zipfile` to extract the Tomcat archive to a user defined location, `$destination`, from the location it was downloaded to `$filepath`. Due to the constraints on inter-OS PowerShell commands and to prevent errors between system types, it is easier to perform the low-level API call then trying to invoke a native command.

###### Subroutine 2: Install-JavaRE

In a similar vein to the `Get-Tomcat` routine, the `Install-JavaRE` routine begins by querying the OS for its bittiness (which is returned in the format of either `32-bit` or `64-bit`) using the WMI runtime command:

`(gwmi win32_operatingsystem | select osarchitecture).osarchitecture`

Depending on what is returned from that command, the function will then download the appropriate Java Runtime Installer from Oracle and save it to a user determined location `$workd`. Once the file-path has been entered, the path will be validated thus:

```
if(-Not(Test-Path -Path $workd)){
   New-Item -ItemType directory -Path $workd > $null
 }
```

If the path exists, do nothing. If it does not exist, create the directory structure and send all `stdout` notifications to `null`.
Because we want the entire install process to be invisible to the user, we create a configuration (.cfg) file containing the information for the installer. This configuration file contains the following paramters:

```
INSTALL_SILENT = Enable #(enables installation without prompts)
AUTO_UPDATE = Enable #(enables and checks for newest version of Java)
SPONSORS = Disable #(disables the showing of "Ads" during the install)
REMOVEOUTOFDATEJRES = 1 #(removes any installed Java that is below installed version)
```

This file is then placed in the location where the installer was downloaded to, and saved as `jreInstall.cfg`.
When the installer is invoked, we initialize it to perform a silent install: `Start-Process -FilePath "$workd\jreInstall.exe" -ArgumentList INSTALLCFG="$workd\jreInstall.cfg"` While the installer is running in the background, we monitor for completion by querying the system process list for the executable `java.exe` using the following command:

`wmic PROCESS where "name like '%java%'" get Processid,Caption,Commandline`

We then query the system every 15 seconds to check for the running process. If the process is running, sleep for 15 seconds and then run again. Once the script detects that the process is no longer running, display a notification to the user that Java was installed successfully and then remove both the installer and the .cfg file, logging any errors to a text file.



##### C) Get-Software
This library consists of two subroutines - get the installed version of the Oracle Java platform and the installed version of Apache Tomcat.

In order to get a complete and accurate list of the software that is installed on the source machine, the script connects to the local machine and sets the following registry locations to the variable `$Paths` -

`SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall` (32-bit software key location)

AND

`SOFTWARE\\Wow6432node\\Microsoft\\Windows\\CurrentVersion\\Uninstall` (64-bit software key location)

Once those registry locations are set, the Win32 command `OpenRemoteBaseKey` is invoked to read the registry keys in question. Once the registry keys are opened for reading the variables `$regkey` and `$subkeys` are instantiated with the full key path and the sub-keys underneath. Once the variables are instantiated the function will then loop through each of the sub-keys, generating the following information, and binding them to the following variables:

```
$DisplayName = Display Name
$Date = Install Date
$Publisher = Publisher
$Version = Display Version
$UninstallString = Uninstall Command
$InstallLocation = Location of Installed Program
$InstallSource = Location of the cached installer file (MSI)
```
Once the information is bound to the variables, a new object - `pscustomobject` is created and the variables are passed to `write-object` which outputs the data to an array and stored as variable `$Object`.


##### B) Filter-SoftwareOutput
This library has been deprecated and has been replaced by filters applied in-line.


##### D) Test-IsAdmin
This function is meant to be invoked at the beginning of each script's runtime. The purpose is to make sure that when the script is run, it runs in an elevated session. If the script detects that the session is not elevated, it will error out and request the script be re-run with administrative privileges.
