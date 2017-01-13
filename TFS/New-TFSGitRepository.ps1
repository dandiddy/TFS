# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 14-Apr-2016.

<#
.SYNOPSIS
    Get the TFS Git repositories
#>
function New-TFSGitRepository {
    [CmdletBinding()]
    param (
        #Name of the repository
        [string] $Name
    )
    check_credential

    $uri = "$(get-projUri)/_apis/git/repositories?api-version=" + $tfs.api_version
    Write-Verbose "URI: $uri"

    $pid = Get-TFSProject $global:tfs.project | % id
    Write-Verbose "Project id: $pid"

    $body = @{ name = $Name; project = @{ id = $pid } }
    $body = $body | ConvertTo-Json
    Write-Verbose $body

    $params = @{ Uri = $uri; Method = 'Post'; ContentType = 'application/json'; Body = $body}
    invoke_rest $params
}
