# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 05-Aug-2016.

<#
.SYNOPSIS
    Get the unified build logs for the TFS build

.EXAMPLE
    PS> Get-TFSBuildLogs

    Returns logs of the latest build

.EXAMPLE
    PS> Get-TFSBuildLogs 250

    Returns logs of the build by id

.EXAMPLE
    PS>  Get-TFSBuilds -Definitions MyDefinition | select -First 1 | % BuildNumber | % { Get-TFSBuildLogs $_ }

    Return logs of the latest build for given build definition
#>
function Get-TFSBuildLogs{
    [CmdletBinding()]
    param(
        #Id of the build, by default the latest build is used.
        [string]$Id
    )
    check_credential

    if ($Id -eq '') { $Id = Get-TFSBuilds -Top 1 | %{ $_.Id } }
    if ($Id -eq $null) { throw "Can't find latest build or there are no builds" }
    Write-Verbose "Build id: $Id"
    
    $uri = "$(get-projUri)/_apis/build/builds/$Id/logs?api-version=" + $global:tfs.api_version
    Write-Verbose "Logs URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params

    $lines = @()
    $root_server_name = $global:tfs.root_url -split '/' | select -Index 2
    foreach ( $url in $r.value.url ) {
        #TFS might return non FQDM so its best to replace its server name with the one user specified
        $new_url = $url -split '/'
        $new_url[2] = $root_server_name
        $new_url = $new_url -join '/'

        Write-Verbose "Log URI: $new_url"
        $params = @{ Uri = $new_url; Method = 'Get'}
        $l = invoke_rest $params
        $lines += $l.value -replace '\..+?Z'
        $lines += "="*150
    }
    $lines
}

sal blogs Get-TFSBuildLogs
