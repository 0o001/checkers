Write-Host "[Website IIS Installer]"

$informationTexts = @{
    Success = @{Text = "Success"; BackgroundColor = "DarkGreen"}
    Error = @{Text = "Error"; BackgroundColor = "DarkRed"}
    Warning = @{Text="Warning"; BackgroundColor = "DarkCyan"}
}

Write-Host "Please Run Powershell as 64bit" -NoNewLine
Write-Host " - " -NoNewLine
if ([Environment]::Is64BitProcess -eq [Environment]::Is64BitOperatingSystem)
{
  Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
}
else
{
    Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
    exit
}

$websiteDefaultName = "website.local"
$websiteName = Read-Host -Prompt "Input website website name (default: $websiteDefaultName)"

if(-not($websiteName))
{
    $websiteName = $websiteDefaultName
}

$iisDefaultName = "website.local"
$iisName = Read-Host -Prompt "Input website iis name (default: $iisDefaultName)"

if(-not($iisName))
{
    $iisName = $iisDefaultName
}

$iisDefaultFolderPath = "$((get-location).Drive.Name):\Web"
$iisFolderPath = Read-Host -Prompt "Input website folder path (default: $iisDefaultFolderPath)"

if(-not($iisFolderPath))
{
    $iisFolderPath = $iisDefaultFolderPath
}

Import-Module WebAdministration

Write-Host "Adding Website Paths on IIS Application Pool" -NoNewLine
Write-Host " - " -NoNewLine

try
{
    $iisPath = $("IIS:\AppPools\" + $iisName)
    New-Item -Path $iisPath -Force > $null
    Set-ItemProperty -Path $iisPath -Name managedRuntimeVersion -Value "v4.0"
    Set-ItemProperty -Path $iisPath -Name enable32BitAppOnWin64 -Value $true

    Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
}
catch
{
    Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
}


Write-Host "Adding Website on ISS" -NoNewLine
Write-Host " - " -NoNewLine

$rootPath = "websiteUI"
$virtualDirectoryPaths = @("websiteFolder1", "websiteFolder2", "websiteFolder3")

try
{
    New-WebSite -Name $iisName -Port 80 -HostHeader $websiteName -PhysicalPath $($iisFolderPath + "\" + $iisName + "\" + $rootPath) -ApplicationPool $iisName -Force > $null
    New-WebBinding -Name $iisName -IPAddress "*" -Port 443 -HostHeader $websiteName -Protocol https > $null

    Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor -NoNewLine
    Write-Host " - " -NoNewLine
    Write-Host "Do not forget to define an SSL certificate for 443 port" -BackgroundColor $informationTexts.Warning.BackgroundColor
}
catch
{
    Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
}

foreach($virtualDirectoryPath in $virtualDirectoryPaths)
{
    Write-Host "Adding Virtual Directory" -NoNewLine
    Write-Host " - " -NoNewLine
    Write-Host $virtualDirectoryPath -NoNewLine
    Write-Host " - " -NoNewLine
    
    try
    {
        New-WebApplication -Name $virtualDirectoryPath -Site $iisName -PhysicalPath $($iisFolderPath + "\" + $iisName + "\" + $virtualDirectoryPath) -ApplicationPool $iisName > $null

        Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
    }
    catch
    {
        Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
    }
}

Write-Host "Starting Application Pool" -NoNewLine
Write-Host " - " -NoNewLine

try
{
    Start-WebAppPool -Name $iisName

    if((Get-WebAppPoolState -Name $iisName).Value -eq "Started")
    {
        Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
    }
    else
    {
        throw
    }
}
catch
{
    Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
}
pause