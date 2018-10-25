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

#Check for installed version of Tomcat.
$tmctversion = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | select DisplayName | where {$_.DisplayName -like "*Tomcat*"} | ft -hidetableheaders

<#TODO Design a subroutine to validate the values assigned to @tmctversion are acutally valid. The below routine only tests for the presence
  of a value. For instance, assigning a value of "FOO" will still result in the script outputting "BAR" and continuing, even though "FOO"
  is not a valid value for the Tomcat software. While the below routine will work for a very basic test, more robust testing is required.
#>
if(!$tmctversion){
    Write-Host "Please install Apache Tomcat"
    break
    }else{
    Write-Host "Continuing..."
    break
    }
