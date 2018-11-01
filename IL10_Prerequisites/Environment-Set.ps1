#loads the script Get-Software into the library for access in other scripts.DESCRIPTION
. D:\Users\Paul20\github\powershellprojects\IL10_Prerequisites\Function_Libraries\Get-Software.ps1
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

<# Invoke the function Get-Software. Assign the output of Get-Software to variable $LMSoftwareInventory.
#>

$LMSoftwareInventory = Get-Software | ft -Property DisplayName,InstallLocation | Out-String
