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

if(!$tmctversion){
    Write-Host "Please install Apache Tomcat"
    break
    }else{
    Write-Host "Continuing..."
    break
    }
