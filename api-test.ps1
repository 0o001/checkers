Write-Host "[API Test]" "`n"

$informationTexts = @{
    Success = @{Text = "Success"; BackgroundColor = "DarkGreen"}
    Error = @{Text = "Error"; BackgroundColor = "DarkRed"}
    Warning = @{Text="Warning"; BackgroundColor = "DarkCyan"}
}

$logFolder = "logs"
New-Item -ItemType Directory -Path $logFolder -Force | Out-Null

$apis = @(
    @{
        "name"="Get Users"
        "method"="GET"
        "url"="api/v2/users?size=1"
        "body"=$null | ConvertTo-Json
    },
    @{
        "name"="Post Users"
        "method"="POST"
        "url"="api/v2/users"
        "body"=@{
            "myParams1"="hello"
        } | ConvertTo-Json
    }
)

$header = @{
"Accept"="application/json"
"Content-Type"="application/json"
}

$apiDefaultURL = "http://localhost:8081"
$apiURL = Read-Host -Prompt "Input API website name (default: $apiDefaultURL)"

if(-not($apiURL))
{
    $apiURL = $apiDefaultURL
}

foreach ($api in $apis) {
    Write-Host "Request for $($api.name) API" -NoNewline
    Write-Host " - " -NoNewline

    $response = Invoke-RestMethod -Uri $($apiURL + '/' + $api.url) -Method $api.method -Body $api.body -Headers $header | ConvertTo-Json
    
    if($response.error) {
        Write-Host $informationTexts.Error.Text -BackgroundColor $informationTexts.Error.BackgroundColor -NoNewline
    } else {
        Write-Host $informationTexts.Success.Text -BackgroundColor $informationTexts.Success.BackgroundColor -NoNewline
    }

    $logFile = "$logFolder\$($api.name).json"
    $response | Out-File -FilePath $logFile

    Write-Host " - " -NoNewline
    Write-Host "(Response write to $logFile file)"
}

pause