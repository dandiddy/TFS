# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the TFS processes
#>
function Get-TFSProcesses {
    [CmdletBinding()]
    param(
    )
    check_credential
    
    $uri = "$(get-collectionUri)/_apis/process/processes?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    $r.value
}
