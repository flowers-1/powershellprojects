<# This script is designed to perform the pre-requisites for the App Server Installation of InfoLease 10 on a client system. This script does multiple
things:
    1. Checks for Administrative rights on the current run;
    2. Gets a list of the installed programs on the machine and searches the output for installed versions of the Apache Tomcat platform;
    3. If Apache Tomcat is NOT present, download it to directory where installer is running from;
    4. Configure the program as laid out in the install guide, asking for user input when necessary.DESCRIPTION
#>
#loads the script Get-Software into the library for access in other scripts.DESCRIPTION
. D:\Users\Paul20\github\powershellprojects\Get-Software.ps1
#Checks for Administrative rights on the current running installer session.
function Test-IsAdmin {
    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
        return $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
    } catch {
        throw "Failed to determine if the current user has elevated privileges. The error was: '{0}'." -f $_
    }
}

<# Get a list of the installed programs on the local machine using registry keys for generation. Once the list is generated, output the
   results to a formatted table assigned to variable. Assign variable @tmctversion to @array and grep the values in the table, searching for anything relating
   to the Apache Tomcat Platform and store in variable @tmctversion. Note: There may be a way to simplify this subroutine.
#>

$jhome = Get-Software | sls -Pattern "Java*" | ft -AutoSize

<#TODO Design a subroutine to validate the values assigned to @tmctversion are acutally valid. The below routine only tests for the presence
  of a value, even if that value is random and unrelated. For instance, assigning a value of "FOO" will still result in the script outputting "BAR" and continuing, even though "FOO"
  is not a valid value for the Tomcat software.
#>
