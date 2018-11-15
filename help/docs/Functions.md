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
Once the folder path has been validated, a BITS (Background Intelligent Transfer Session) runtime is invoked using the command `Start-BitsTransfer` and downloads the specific bit-flavor of Tomcat to the user defined path.



  The second function, Extract-Tomcat, is fairly self-explanatory. This function will extract the ZIP file to a user-specified location. This is accomplished using the 'Extract-Archive' (or Expand-Archive) function. In order to gather the users' desired extraction location, a VBasic routine (Microsoft.VisualBasic) will display a window to the user to collect the location where the Tomcat platform should be extracted. The window will only accept a file path in the format "<drive_letter>:\<path>". Once this information is collected, a test will be performed on the input to determine if the path entered exists (Test-Path). If the path does not exist, the command will create the directory structure for it.

  The third function, Get-JavaRE, uses the API call GetWindowsManagementInstrumentation (GWMI) to query the OS for its bittiness. Depending on the result of the GWMI call, the function then invokes the partial subsystem, Microsoft.VisualBasic, to display a window to the user to collect the location where the Java Runtime Environment will be downloaded to. Once the user inputs the file path (in format "<drive_letter>:\<Path>"), a test is then performed on the input to determine if the path entered exists. This is done through the use of the command 'Test-Path'. If the path does not exist, the command 'New-Item' is invoked to create the directory structure. Once the directory structure is created, the current session will invoke a Background Intelligent Transfer Service (BITS) session to an official Oracle mirror and download the requested Java version, based on the GWMI result, to the user-entered path. Currently this download session is hard-coded to a specific URI. This should be changed in future releases so that it is based on a relative path.

  The fourth function, Install-JavaRE, uses 5the standard windows installer method to install the Oracle Java Platform quietly. Once installed, alert the user that the install is complete and continue on in the pre-requisite configuration process.


Library: Test-IsAdmin
    This function is simple, it checks the current running PowerShell session for Administrative privileges. If it is running as admin, continue. If it is not, display error to end user asking them to run the session again as admin.


Library: Get-Software
  This function creates the Get-Software subroutines. It does five things:
    1. Queries local machine for all installed programs using the 'Get-Value' method, looking for the following:
        a) DisplayName ($DisplayName)
        b) Version ($DisplayVersion)
        c) InstallDate ($InstallDate)
        d) Publisher ($Publisher)
        e) Uninstall Path ($UninstallString)
    2. Using the method 'OpenSubKey', read each of the registry keys located at "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" &
  "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" and return the values for each into an empty array.
    3. Check for objects with empty displayname and prevents them from being populated.
    4. Filters out any Windows patches and other non-essential items using a RegEx to prevent population.
    5. Using "TRIM" and "TRIMEND", cleanup the output from the registry to prevent garbage output and unnecessary characters.

There are two macro-functions within this library:
    1. Get-InstalledJava
    2. Get-InstalledTomcat

  It should be noted, this function could be done with a WMI call, however, the difference in runtime is unacceptable. Using a WMI call to win32 to enumerate the list of installed software takes, on average, 39.60877ms (based on debug timing). Using the above function takes approximately 6ms to enumerate - a 199.93% decrease in runtime. This is advantageous as the enumeration process will be practically invisible to the end-user.
