[CmdletBinding()]
param()

#Trace-VstsEnteringInvocation $MyInvocation
try {
    # Get inputs.
    $github_repo = Get-VstsInput -Name 'githubRepo' -Require
    $github_organization = Get-VstsInput -Name 'githubOrganization' -Require
    $github_token = Get-VstsInput -Name 'githubToken' -Require
    $artifact_file = Get-VstsInput -Name 'artifact' -Require
    $artifact_display_name = Get-VstsInput -Name 'artifactDisplayName' -Require



    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $response = Invoke-Webrequest "https://api.github.com/repos/$github_organization/$github_repo/releases" -Headers @{"Authorization"="token $github_token"; "Accept"="application/vnd.github.v3+json"} 
    $content = $response.Content | ConvertFrom-Json

    $uploadUrl = $content[0].upload_url
    $uploadUrl = $uploadUrl.Split("{")[0]
    $uploadUrl = $uploadUrl + "?name=" + $artifact_display_name

    Write-Host $uploadUrl

    $fileBinary = [IO.File]::ReadAllBytes($artifact_file)

    $response = Invoke-WebRequest $uploadUrl -Method POST -Body $fileBinary -Headers @{"Authorization"="token $github_token"; "Accept"="application/vnd.github.v3+json"; "Content-Type"="application/zip"}
    Write-Host $response | ConvertFrom-Json

    Write-Host "Upload completed successfully"

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}