[CmdletBinding()]
param()

#Trace-VstsEnteringInvocation $MyInvocation
try {
    # Get inputs.
    $github_repo = Get-VstsInput -Name 'githubRepo' -Require
    $github_organization = Get-VstsInput -Name 'githubOrganization' -Require
    $github_token = Get-VstsInput -Name 'githubToken' -Require
    $tag_name = Get-VstsInput -Name 'tagName' -Require
    $tag_message = Get-VstsInput -Name 'tagMessage' -Require
    $tag_commit = Get-VstsInput -Name 'tagCommit' -Require
    $tagger_name = Get-VstsInput -Name 'taggerName'
    $tagger_email = Get-VstsInput -Name 'taggerEmail'


    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = @{"Authorization"="token $github_token"; "Accept"="application/vnd.github.v3+json"}
    $body = @{
        tag = "$tag_name";
        message = "$tag_message";
        object = "$tag_commit";
        type = "commit";
        tagger = @{
            name = "$tagger_name";
            email = "$tagger_email";
        };
    } | ConvertTo-Json

    Write-Host "Creating Tag"
    $response = Invoke-Webrequest "https://api.github.com/repos/$github_organization/$github_repo/git/tags" -Headers $headers -Method POST -Body $body
    Write-Host $response | ConvertFrom-Json

    $refBody = @{
        ref = "refs/tags/$tag_name";
        sha = "$tag_commit"
    } | ConvertTo-Json

    Write-Host "Creating Reference"
    $refResponse = Invoke-WebRequest "https://api.github.com/repos/$github_organization/$github_repo/git/refs" -Headers $headers -Method POST -Body $refBody
    Write-Host $refResponse | ConvertFrom-Json 


    Write-Host "Upload completed successfully"

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}