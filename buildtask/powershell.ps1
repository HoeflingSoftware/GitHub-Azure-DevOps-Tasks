[CmdletBinding()]
param()

#Trace-VstsEnteringInvocation $MyInvocation
try {
    # Get inputs.
    $input_source = Get-VstsInput -Name 'sourceDirectory' -Require
    $input_version = Get-VstsInput -Name 'moduleVersion' -Require

    # get all dnn manifest files based on the source
    Write-Host "Finding all *.dnn manifest files recursively from $input_source"
    $manifestFiles = Get-ChildItem $input_source -name -recurse *.dnn

    Foreach ($manifest in $manifestFiles)
    {
        $path = "$input_source\$manifest"
        Write-Host "Updating version information for $path . . ."

        # load XML file
        $xml = New-Object XML
        $xml.Load($path)

        # select node and update version
        $nodes = $xml.SelectNodes("/dotnetnuke/packages/package")
        $nodes.SetAttribute("version", $input_version)

        $xml.Save($path)   
    }

    Write-Host "Version number updated in all manifest file" 

    # Fail if any errors.
    # if ($failed) {
    #     Write-VstsSetResult -Result 'Failed' -Message "Error detected" -DoNotThrow
    # }
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}