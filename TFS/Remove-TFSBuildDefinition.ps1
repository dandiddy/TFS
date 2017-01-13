# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Remove the TFS build definition
.EXAMPLE
     defs | % { rmdef $_.Name }

     Remove all build definitions from the project. The example is using aliases
#>
function Remove-TFSBuildDefinition {
    [CmdletBinding()]
    param(
        #Build defintion id [int] or name [string]
        $Id
    )
    check_credential

    if ( ![String]::IsNullOrEmpty($Id) -and ($Id.GetType() -eq [string]) ) { $Id = Get-TFSBuildDefinitions -Name $Id | % id }
    if ( [String]::IsNullOrEmpty($Id) ) { throw "Resource with that name doesn't exist" }
    Write-Verbose "Build definition id: $Id"

    $uri = "$(get-projUri)/_apis/build/definitions/$($Id)?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Delete'}
    invoke_rest $params
}

sal rmdef Remove-TFSBuildDefinition
