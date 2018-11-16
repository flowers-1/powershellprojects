## Functional Dependency Libraries

##### Introduction
  Four custom functions are included in this script package. These functions are located under the "/lib" folder and are as follows:

    1. Download-Requirements.ps1
    2. Filter-SoftwareOutput.ps1
    3. Get-Software.ps1
    4. Test-IsAdmin.ps1

  The following sections will go into further detail about what each of the functions does.



##### Library: *Download-Requirements*

  This library is made up of two functions:
    1. Get-Tomcat
    2. Get-JavaRE



###### Subroutine: Get-Tomcat

This first function performs two critical functions:
    - Downloads the Apache Tomcat archive from an official mirror; and
    - Extracts the downloaded archive to a location specified by the user.

The first part of the function

`(gwmi win32_operatingsystem | select osarchitecture).osarchitecture`


invokes the "Windows Management Instrumentation" runtime from within the shell and queries the local machine for the bittiness of the OS. This is returned in the format `64-bit` or `32-bit`. Depending on the returned value, the script will download the appropriate version of Apache Tomcat. Before the download begins, the script will present the user with a prompt to enter a location to save the archive file and store the user entered location to the variable `$filepath`. A simple validation routine on the user input is then run

`if(-Not(Test-Path -Path $filepath)){  New-Item -ItemType directory -Path $filepath > $null }`

If the path entered exists, do nothing. If the path does not exist, create the directory tree and send any `stderr` messages to `null`.
Once the folder path has been validated, a BITS (Background Intelligent Transfer Session) runtime is invoked using the command `Start-BitsTransfer` and downloads the specific bittiness-flavor of Tomcat to the user defined path.

In both bittiness cases, once Tomcat is downloaded, the script uses the `ExtractToDirectory` method from the Microsoft C# runtime - `io.compression.zipfile` to extract the Tomcat archive to a user defined location - `$destination` from the location it was downloaded to. Due to the constraints on inter-OS PowerShell commands, it is easier to perform the low-level API call then trying to invoke a native command.

###### Subroutine: Install-JavaRE
