#loads the script Get-Software into the library for access in other scripts.DESCRIPTION
. D:\Users\Paul20\github\powershellprojects\IL10_Prerequisites\Function_Libraries\Get-Software.ps1
. D:\Users\Paul20\github\powershellprojects\IL10_Prerequisites\Function_Libraries\Test-IsAdmin.ps1
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

$LMSoftwareInventory = Get-Software | ft -Property DisplayName,InstallLocation | Out-String
