## Functional Dependency Libraries

### I. Introduction
  Four custom functions are included in this script package. These functions are located under the "/lib" folder and are as follows:

    1. Download-Requirements.ps1
    2. Filter-SoftwareOutput.ps1
    3. Get-Software.ps1
    4. Test-IsAdmin.ps1

  The following sections will go into further detail about what each of the functions does.

### II. Libraries

##### A) *Download-Requirements*

###### Subroutine 1: Get-Tomcat

The first part of the function

`(gwmi win32_operatingsystem | select osarchitecture).osarchitecture`


invokes the "Windows Management Instrumentation" (WMI) runtime from within the shell and queries the local machine for the bittiness of the OS. This is returned in the format `64-bit` or `32-bit`. Depending on the returned value, the script will download the appropriate version of Apache Tomcat. Before the download begins, the script will present the user with a prompt to enter a location to save the archive file and store the user entered location to the variable `$filepath`. A simple validation routine on the user input is then run

`if(-Not(Test-Path -Path $filepath)){  New-Item -ItemType directory -Path $filepath > $null }`

to test if the path entered exists. If the path exists, do nothing. If the path does not exist, create the directory tree and send any `stdout` messages to `null`.
Once the folder path has been validated, a BITS (Background Intelligent Transfer Session) runtime is invoked using the command `Start-BitsTransfer` and downloads the specific bittiness-flavor of Tomcat to the user defined path.

In both bittiness cases, once Tomcat is downloaded, the script uses the `ExtractToDirectory` method from the C# runtime - `io.compression.zipfile` to extract the Tomcat archive to a user defined location, `$destination`, from the location it was downloaded to `$filepath`. Due to the constraints on inter-OS PowerShell commands and to prevent errors between system types, it is easier to perform the low-level API call then trying to invoke a native command.

###### Subroutine 2: Install-JavaRE

In a similar vein to the `Get-Tomcat` routine, the `Install-JavaRE` routine begins by querying the OS for its bittiness (which is returned in the format of either `32-bit` or `64-bit`) using the WMI runtime command:

`(gwmi win32_operatingsystem | select osarchitecture).osarchitecture`

Depending on what is returned from that command, the function will then download the appropriate Java Runtime from Oracle.
