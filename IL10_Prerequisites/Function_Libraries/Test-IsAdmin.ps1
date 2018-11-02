<# This function tests the current PS environment to make sure that it is running as administrator. If it is not, error out
#>

function Test-IsAdmin {
    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
        return $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
    } catch {
        throw [System.Windows.MessageBox]::Show('Session is not running as Administrator. Please restart and run as administrator','Error')
    }
}
