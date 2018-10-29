#loads the script Get-Software into the library for access in other scripts.DESCRIPTION
. D:\Users\Paul20\github\powershellprojects\Libraries\Get-Software.ps1
<#Check for Admin rights on the current run. This could also be accomplished via #requires -RunAsAdministrator. However, this could be more robust. #>
<#
        .SYNOPSIS
            Checks if the current Powershell instance is running with elevated privileges or not.
        .EXAMPLE
            PS C:\> Test-IsAdmin
        .OUTPUTS
            System.Boolean
                True if the current Powershell is elevated, false if not.
    #>
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
   results to a formatted table assigned to variable. Assign variable @jversion to @array and grep the values in the table, searching for anything relating
   to the Oracle Java Platform, either JRE or JDK both 32-bit and 64-bit and store in variable.
#>
