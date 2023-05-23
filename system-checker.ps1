Write-Host "[System Checker]"
$informationTexts = @{
    Success = @{Text = "Success"; BackgroundColor = "DarkGreen"}
    Error = @{Text = "Error"; BackgroundColor = "DarkRed"}
    Warning = @{Text="Warning"; BackgroundColor = "DarkCyan"}
}
$getRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).sum / 1GB
$getDisks = (Get-CimInstance -ClassName Win32_LogicalDisk)
$getWindowsType = (Get-ComputerInfo).OsProductType
$getWindowsVersion = (Get-ComputerInfo).WindowsVersion

Write-Host RAM: $getRam GB -NoNewline
Write-Host " - " -NoNewline

if($getRam -ge 16)
{
    Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
}
else
{
    Write-Host $informationTexts.Error.Text "-" "Minimum RAM must be 16 GB" -BackgroundColor $informationTexts.Error.BackgroundColor
}

foreach($getDisk in $getDisks)
{
    $getDiskSpace = ($getDisk |  Measure-Object -Property Size -Sum).sum / 1GB

    Write-Host DISK $getDisk.DeviceID $getDiskSpace GB -NoNewline
    Write-Host " - " -NoNewline
    
    if($getDiskSpace -ge 128)
    {
        Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
    }
    else
    {
        Write-Host $informationTexts.Error.Text "-" "Minimum Disk must be 128 GB" -BackgroundColor $informationTexts.Error.BackgroundColor
    }
}

Write-Host Windows Type: $getWindowsType -NoNewline
Write-Host " - " -NoNewline

if($getWindowsType -eq "Server" -Or $getWindowsType -eq "DomainController")
{
    Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
}
else
{
    Write-Host $informationTexts.Error.Text "-" "Windows Type must be Server or DomainController" -BackgroundColor $informationTexts.Error.BackgroundColor
}

Write-Host Windows Version: $getWindowsVersion -NoNewline
Write-Host " - " -NoNewline

if($getWindowsVersion -ge 2012)
{
    Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
}
else
{
    Write-Host $informationTexts.Error.Text "-" "Windows Server version must be equal or greater than 2012" -BackgroundColor $informationTexts.Error.BackgroundColor
}

Write-Host Active Directory Version: -NoNewline
try
{
    $getADVersion = (Get-ADObject (Get-ADRootDSE).schemaNamingContext -Property objectVersion).objectVersion

    Write-Host " " $getADVersion -NoNewline

    if($getADVersion -ge 56)
    {
        Write-Host " - " -NoNewline
        Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor -NoNewline
    }
    else
    {
        throw
    }
}
catch
{
    Write-Host " - " -NoNewline
    Write-Host $informationTexts.Error.Text "-" "Active Directory version must be equal or greater than 2012" -BackgroundColor $informationTexts.Error.BackgroundColor -NoNewline
}
pause