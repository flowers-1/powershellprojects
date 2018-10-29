<# This script creates the function "Get-Software". This function does five things:
  1. Queries local machine for all installed programs using the 'Get-Value' method, looking for the following:
    a) DisplayName ($DisplayName)
    b) Version ($DisplayVersion)
    c) InstallDate ($InstallDate)
    d) Publisher ($Publisher)
    e) Uninstall Path ($UninstallString)
  2. Using the method 'OpenSubKey', read each of the registry keys located at "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" &
  "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" and return the values for each into an empty array.
  3. Check for objects with empty displayname and prevents them from being populated.
  4. Filters out any Windows patches in the output using a RegEx to prevent population.
  5. Using "TRIM" and "TRIMEND", cleanup the output from the registry to prevent garbage output.
The function 'Get-Software' can be piped to other functions to either format the output for human readability or perform other functions on the dataset.
If this function is pathed in other scripts using dot-library [. <Drive-Letter>\(Path)] the function can be called as a standalone subroutine.
#>


function Get-Software {
  [OutputType('System.Software.Inventory')]
  [Cmdletbinding()]
  Param(
    [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [String[]]$computername=$env:ComputerName
  )
  Begin {
  }
  Process{
    foreach($Computer in $ComputerName){
      if(Test-Connection -ComputerName $Computer -Count 1 -Quiet){
        $Paths = @("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall","SOFTWARE\\Wow6432node\\Microsoft\\Windows\\CurrentVersion\\Uninstall")
        foreach ($Path in $Paths){
          Write-Verbose "Checking Path: $Path"
          try {   #Create an instance of the Registry Object and open the HKLM base key
            $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine', $Computer, 'Registry64')
          }
          Catch {
            Write-error $_
            Continue
          }
          try {   #Drill down into the Uninstall key using the OpenSubKey method
            $regkey=$reg.OpenSubKey($Path)
            $subkeys=$regkey.GetSubKeyNames()   #Retrieve an array of string that contains all the subkey names
            foreach($key in $subkeys){  #Open each Subkey and use the GetValue method to return the required values for each.
              Write-Verbose "Key: $key"
              $thiskey = $Path + "\\" + $key
              try {   #Prevents objects with empty DisplayName
                $thisSubKey=$reg.OpenSubKey($thisKey)
                $DisplayName = $thisSubKey.getValue("DisplayName")
                if($DisplayName -AND $DisplayName -NotMatch '^Update for|rollup|^Security Update|^Service Pack|^Hotfix'){
                  $Date = $thisSubKey.GetValue('InstallDate')
                  if($Date){
                    try{
                      $Date = [datetime]::ParseExact($Date, 'yyyyMMdd', $Null)
                    }
                    catch{
                      Write-Warning "$($Computer): $_ <$($Date)>"
                      $Date = $Null
                    }
                  }
                  $Publisher = try {  #Create New Object with empty Properties
                    $thisSubKey.GetValue('Publisher').Trim()
                  }
                  Catch{
                    $thisSubKey.GetValue('Publisher')
                  }
                  $version = try {  #Resolves some strangeness with trailing [char]0 on some strings
                    $thisSubKey.GetValue('DisplayVersion').TrimEnd(([char[]](32,0)))
                  }
                  Catch {
                    $thisSubKey.GetValue('DisplayVersion')
                  }
                  $UninstallString = try {
                    $thisSubKey.GetValue('UninstallString').Trim()
                  }
                  Catch{
                  $thisSubKey.GetValue('UninstallString')
                  }
                  $InstallLocation = try {
                    $thisSubKey.GetValue('InstallLocation').Trim()
                  }
                  Catch {
                    $thisSubKey.GetValue('InstallLocation')
                  }
                  $InstallSource = try {
                    $thisSubKey.GetValue('InstallSource').Trim()
                  }
                  Catch {
                    $thisSubKey.GetValue('InstallSource')
                  }
                  $HelpLink = Try {
                     $thisSubKey.GetValue('HelpLink').Trim()
                  }
                  Catch {
                    $thisSubKey.GetValue('HelpLink')
                  }
                  $Object = [pscustomobject] @{
                    Computername = $Computer
                    DisplayName = $DisplayName
                    Version = $Version
                    InstallDate = $Date
                    Publisher = $Publisher
                    UninstallString = $UninstallString
                    InstallLocation = $InstallLocation
                    InstallSource = $InstallSource
                    HelpLink = $thisSubKey.GetValue('HelpLink')
                    EstimatedSizeMB = [decimal]([math]::Round(($thisSubKey.GetValue('EstimatedSize')*1024)/1MB,2))
                  }
                  $Object.pstypenames.insert(0, 'System.Software.Inventory')
                  Write-Output $Object
                }
              }
              Catch {
                Write-Warning "$Key : $_"
              }
            }
          }
          Catch {}
          $reg.Close()
        }
      }
      Else {
        Write-Error "$($Computer): Unable to reach remote system."
      }
    }
  }
}
