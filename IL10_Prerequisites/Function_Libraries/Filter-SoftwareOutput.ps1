<#



#>
function Get-InstalledJava {
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
        $Paths = @("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall","SOFTWARE\\Wow6432node\\Microsoft\\Windows\\CurrentVersion\\Uninstall");
        foreach ($Path in $Paths){
          Write-Verbose "Checking Path: $Path";
          try {   #Create an instance of the Registry Object and open the HKLM base key
            $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine', $Computer, 'Registry64');
          }
          Catch {
            Write-error $_;
            Continue;
          }
          try {   #Drill down into the Uninstall key using the OpenSubKey method
            $regkey=$reg.OpenSubKey($Path);
            $subkeys=$regkey.GetSubKeyNames();   #Retrieve an array of string that contains all the subkey names
            foreach($key in $subkeys){  #Open each Subkey and use the GetValue method to return the required values for each.
              Write-Verbose "Key: $key";
              $thiskey = $Path + "\\" + $key;
              try {   #Prevents objects with empty DisplayName
                $thisSubKey=$reg.OpenSubKey($thisKey);
                $DisplayName = $thisSubKey.getValue("DisplayName");
                if($DisplayName -AND $DisplayName -Match 'Java'){
                  $Date = $thisSubKey.GetValue('InstallDate');
                  if($Date){
                    try{
                      $Date = [datetime]::ParseExact($Date, 'yyyyMMdd', $Null);
                    }
                    catch{
                      Write-Warning "$($Computer): $_ <$($Date)>";
                      $Date = $Null;
                    }
                  }
                  $Publisher = try {  #Create New Object with empty Properties
                    $thisSubKey.GetValue('Publisher').Trim();
                  }
                  Catch{
                    $thisSubKey.GetValue('Publisher');
                  }
                  $version = try {  #Resolves some strangeness with trailing [char]0 on some strings
                    $thisSubKey.GetValue('DisplayVersion').TrimEnd(([char[]](32,0)));
                  }
                  Catch {
                    $thisSubKey.GetValue('DisplayVersion');
                  }
                  $UninstallString = try {
                    $thisSubKey.GetValue('UninstallString').Trim();
                  }
                  Catch{
                  $thisSubKey.GetValue('UninstallString');
                  }
                  $InstallLocation = try {
                    $thisSubKey.GetValue('InstallLocation').Trim();
                  }
                  Catch {
                    $thisSubKey.GetValue('InstallLocation');
                  }
                  $InstallSource = try {
                    $thisSubKey.GetValue('InstallSource').Trim();
                  }
                  Catch {
                    $thisSubKey.GetValue('InstallSource');
                  }
                  $HelpLink = Try {
                     $thisSubKey.GetValue('HelpLink').Trim();
                  }
                  Catch {
                    $thisSubKey.GetValue('HelpLink');
                  }
                  $Object = [pscustomobject] @{
                    DisplayName = $DisplayName;
                    UninstallString = $UninstallString;
                    InstallLocation = $InstallLocation;
                    #HelpLink = $thisSubKey.GetValue('HelpLink');
                    #EstimatedSizeMB = [decimal]([math]::Round(($thisSubKey.GetValue('EstimatedSize')*1024)/1MB,2));
                  }
                  $Object.pstypenames.insert(0, 'System.Software.Inventory');
                  Write-Output $Object;
                }
              }
              Catch {
                Write-Warning "$Key : $_";
              }
            }
          }
          Catch {}
          $reg.Close();
        }
      }
      Else {
        Write-Error "$($Computer): Unable to reach remote system.";
      }
    }
  }
}
function Get-InstalledTomcat {
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
        $Paths = @("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall","SOFTWARE\\Wow6432node\\Microsoft\\Windows\\CurrentVersion\\Uninstall");
        foreach ($Path in $Paths){
          Write-Verbose "Checking Path: $Path";
          try {   #Create an instance of the Registry Object and open the HKLM base key
            $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine', $Computer, 'Registry64');
          }
          Catch {
            Write-error $_;
            Continue;
          }
          try {   #Drill down into the Uninstall key using the OpenSubKey method
            $regkey=$reg.OpenSubKey($Path);
            $subkeys=$regkey.GetSubKeyNames();   #Retrieve an array of string that contains all the subkey names
            foreach($key in $subkeys){  #Open each Subkey and use the GetValue method to return the required values for each.
              Write-Verbose "Key: $key";
              $thiskey = $Path + "\\" + $key;
              try {   #Prevents objects with empty DisplayName
                $thisSubKey=$reg.OpenSubKey($thisKey);
                $DisplayName = $thisSubKey.getValue("DisplayName");
                if($DisplayName -AND $DisplayName -Match 'Apache Tomcat'){
                  $Date = $thisSubKey.GetValue('InstallDate');
                  if($Date){
                    try{
                      $Date = [datetime]::ParseExact($Date, 'yyyyMMdd', $Null);
                    }
                    catch{
                      Write-Warning "$($Computer): $_ <$($Date)>";
                      $Date = $Null;
                    }
                  }
                  $Publisher = try {  #Create New Object with empty Properties
                    $thisSubKey.GetValue('Publisher').Trim();
                  }
                  Catch{
                    $thisSubKey.GetValue('Publisher');
                  }
                  $version = try {  #Resolves some strangeness with trailing [char]0 on some strings
                    $thisSubKey.GetValue('DisplayVersion').TrimEnd(([char[]](32,0)));
                  }
                  Catch {
                    $thisSubKey.GetValue('DisplayVersion');
                  }
                  $UninstallString = try {
                    $thisSubKey.GetValue('UninstallString').Trim();
                  }
                  Catch{
                  $thisSubKey.GetValue('UninstallString');
                  }
                  $InstallLocation = try {
                    $thisSubKey.GetValue('InstallLocation').Trim();
                  }
                  Catch {
                    $thisSubKey.GetValue('InstallLocation');
                  }
                  $InstallSource = try {
                    $thisSubKey.GetValue('InstallSource').Trim();
                  }
                  Catch {
                    $thisSubKey.GetValue('InstallSource');
                  }
                  $HelpLink = Try {
                     $thisSubKey.GetValue('HelpLink').Trim();
                  }
                  Catch {
                    $thisSubKey.GetValue('HelpLink');
                  }
                  $Object = [pscustomobject] @{
                    DisplayName = $DisplayName;
                    UninstallString = $UninstallString;
                    #InstallLocation = $InstallLocation;
                    #HelpLink = $thisSubKey.GetValue('HelpLink');
                    #EstimatedSizeMB = [decimal]([math]::Round(($thisSubKey.GetValue('EstimatedSize')*1024)/1MB,2));
                  }
                  $Object.pstypenames.insert(0, 'System.Software.Inventory');
                  Write-Output $Object;
                }
              }
              Catch {
                Write-Warning "$Key : $_";
              }
            }
          }
          Catch {}
          $reg.Close();
        }
      }
      Else {
        Write-Error "$($Computer): Unable to reach remote system.";
      }
    }
  }
}
