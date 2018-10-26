<# This script is designed to perform the pre-requisites for the App Server Installation of InfoLease 10 on a client system. This script does multiple
things:
    1. Checks for Administrative rights on the current run;
    2. Gets a list of the installed programs on the machine and searches the output for installed versions of the Apache Tomcat platform;
    3. 

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
$array = @()

foreach($pc in $computers){

    $computername=$pc.computername

#Define the variable to hold the location of Currently Installed Programs
    $UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"

#Create an instance of the Registry Object and open the HKLM base key
    $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computername)

#Drill down into the Uninstall key using the OpenSubKey Method
    $regkey=$reg.OpenSubKey($UninstallKey)

#Retrieve an array of string that contain all the subkey names
    $subkeys=$regkey.GetSubKeyNames()

#Open each Subkey and use GetValue Method to return the required values for each
    foreach($key in $subkeys){

        $thisKey=$UninstallKey+"\\"+$key
        $thisSubKey=$reg.OpenSubKey($thisKey)
        $obj = New-Object PSObject
        $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computername
        $obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))
        $obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))
        $obj | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($thisSubKey.GetValue("InstallLocation"))
        $obj | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($thisSubKey.GetValue("Publisher"))
        $array += $obj
    }
}
$tmctversion = $array | Where-Object { $_.DisplayName } | select ComputerName, DisplayName, DisplayVersion, Publisher | where {$_.DisplayName -like "Apache*"} | ft -hidetableheaders

echo $tmctversion

<#TODO Design a subroutine to validate the values assigned to @tmctversion are acutally valid. The below routine only tests for the presence
  of a value, even if that value is random and unrelated. For instance, assigning a value of "FOO" will still result in the script outputting "BAR" and continuing, even though "FOO"
  is not a valid value for the Tomcat software.
#>
