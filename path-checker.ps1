Write-Host "[Path Checker]"

$informationTexts = @{
    Success = @{Text = "Success"; BackgroundColor = "DarkGreen"}
    Error = @{Text = "Error"; BackgroundColor = "DarkRed"}
}

$websiteUrl = Read-Host -Prompt 'Input website url:'
$websiteProtocols = @("http", "https")
$websitePaths = @(
                ""
                "api",
                "css",
                "users"
            )
foreach($websiteProtocol in $websiteProtocols)
{
    foreach($websitePath in $websitePaths)
    {
    
        $url = "$($websiteProtocol+"://"+$websiteUrl+"/"+$websitePath)"
        Write-Host $url -NoNewLine
        Write-Host " - " -NoNewLine
        try
        {
            $res = Invoke-WebRequest -URI $url -UseDefaultCredentials -UseBasicParsing -Method Head -TimeoutSec 5 -ErrorAction Stop

            Write-Host $([int]$res.StatusCode) -NoNewLine
            Write-Host " - " -NoNewLine
            Write-Host $res.StatusDescription -BackgroundColor $informationTexts.Success.BackgroundColor
        }
        catch
        {
            Write-Host $([int]$_.Exception.Response.StatusCode.value__) -NoNewLine
            Write-Host " - " -NoNewLine
            Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor
        }
    }
}
pause