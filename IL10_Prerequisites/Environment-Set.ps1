#loads the script Get-Software into the library for access in other scripts.DESCRIPTION
. "..\Function_Libraries\Get-Software.ps1"
. "..\Function_Libraries\Test-IsAdmin.ps1"
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
Test-IsAdmin

<# Invoke the Get-Software function and assign the output to variable $LMSoftwareInventory.
#>

$LMSoftwareInventory = Get-InstalledJava | Format-Wide -Property InstallLocation -Column 1 | Out-string
