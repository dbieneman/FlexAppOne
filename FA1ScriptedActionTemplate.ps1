# Edit here
$AppName = "AppName" # case-sensitive
$DownloadPath = "https://fa1poc.blob.core.windows.net/fa1/poc"
$FlexAppPath = "C:\ProgramData\FlexAppOne"

# Do not edit past here
$ProgressPreference = 'SilentlyContinue'
mkdir $FlexAppPath

# Download and install FlexApp service
if (!(Test-Path "C:\Program Files\ProfileUnity\Flexapp\ContainerService\x64\VirtFsService.exe"))
{
Invoke-WebRequest -OutFile "$FlexAppPath\Installer.exe" -URI "$DownloadPath/installer.exe"
Start-Process -FilePath "$FlexAppPath\Installer.exe" -ArgumentList "-i"
}

#Download .cmd, .xml, and .exe files
Invoke-WebRequest -OutFile "$FlexAppPath\$AppName.exe" -URI "$DownloadPath/$AppName.exe"
Invoke-WebRequest -OutFile "$FlexAppPath\$AppName.exe.xml" -URI "$DownloadPath/$AppName.exe.xml"
Invoke-WebRequest -OutFile "$FlexAppPath\$AppName.exe.cmd" -URI "$DownloadPath/$AppName.exe.cmd"

# Create scheduled task to mount app on restart
Start-Process -FilePath "schtasks.exe" -ArgumentList "/Create /XML `"$FlexAppPath\$AppName.exe.xml`" /tn `"(FA1)\$AppName.exe`" /ru system"

# Mount app
Start-Process -FilePath "$FlexAppPath\$AppName.exe" -ArgumentList "--system --index 999"
timeout /t 5
Start-Process -FilePath "$FlexAppPath\$AppName.exe" -ArgumentList "--system --ctl --addtostart --skipactivation"
