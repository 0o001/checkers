Write-Host "[Application Checking]"

$informationTexts = @{
    Success = @{Text = "Success"; BackgroundColor = "DarkGreen"}
    Error = @{Text = "Error"; BackgroundColor = "DarkRed"}
}

$appList = @(
                @{Name="Notepad++"; Path="$env:ProgramW6432\Notepad++"},
                @{Name="Url Rewrite"; Path="$env:SystemRoot\system32\inetsrv\rewrite.dll"},
                @{Name="Google Chrome"; Path="$env:ProgramW6432\Google\Chrome"},
                @{Name="Java 8"; Path="registry::HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit\1.8\"}
            )

foreach($app in $appList)
{
    Write-Host $app.Name -NoNewLine
    Write-Host " - " -NoNewLine
    $checkApplicationPath = Test-Path -Path $app.Path
    if($checkApplicationPath)
    {
        Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
    }
    else
    {
        Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
    }
}

$getDotNetFramework = (get-childitem -path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP" | Where-Object -FilterScript {$_.name -match "v4.7"} | Get-ItemProperty).Install

Write-Host ".NET Framework 4.7" -NoNewLine
Write-Host " - " -NoNewLine
if($getDotNetFramework -eq $true)
{
    Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
}
else
{
    Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
}
pause