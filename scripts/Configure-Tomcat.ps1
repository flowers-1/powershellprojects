<# This script is designed to perform the pre-requisites for the App Server Installation of InfoLease 10 on a client system. This script does multiple
things:
    1. Checks for Administrative rights on the current run;
    2. Gets a list of the installed programs on the machine and searches the output for installed versions of the Apache Tomcat platform;
    3. If Apache Tomcat is NOT present, download it to directory where installer is running from;
    4. Configure the program as laid out in the install guide, asking for user input when necessary.
#>
#loads the script Get-Software into the library for access in other scripts.
. "..\lib\Get-Software.ps1"
. "..\lib\Test-IsAdmin.ps1"
. "..\lib\Download-Requirements"
#Checks for Administrative rights on the current running installer session.

Test-IsAdmin

<# Get a list of the installed programs on the local machine using registry keys for generation. Once the list is generated, output the
   results to a formatted table assigned to variable.
#>

$jhome = Get-InstalledJava
$tmctversion = Get-InstalledTomcat
