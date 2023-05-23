Write-Host "[Host Check]"

$informationTexts = @{
    Success = @{Text = "Success"; BackgroundColor = "DarkGreen"}
    Error = @{Text = "Error"; BackgroundColor = "DarkRed"}
}

$tcpHosts = @(
                @{ IP = "google.com"; port = 443 },
                @{ IP = "mustafauzun.co"; port = 80 }
            )
foreach($tcpHost in $tcpHosts)
{
    $connect = Test-NetConnection -ComputerName $tcpHost.IP -InformationLevel "Detailed" -Port $tcpHost.port -WarningAction SilentlyContinue

    Write-Host $tcpHost.IP : $tcpHost.port -NoNewLine
    Write-Host " - " -NoNewLine
    
    if($connect.TcpTestSucceeded)
    {
        Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor
    }
    else
    {
        Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
    }

}
pause