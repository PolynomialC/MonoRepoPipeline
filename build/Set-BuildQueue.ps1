<#

NAME 
Set-BuildQueue

.DESCRIPTION
	Creates build queue for azure pipeline. Projects are built if updated or declared in the build variable.
	
.LINK
	https://github.com/nikolic-bojan/azure-yaml-build

Author:JackWharton
DoC:10.02.21

#>
$global:BuildQueueVariable = ""
$global:BuildSeparator = ";"

Function AppendQueueVariable([string]$folderName)
{
	$FolderNameWithSeparator = -join($folderName, $global:BuildSeparator)

	if ($global:BuildQueueVariable -notmatch $FolderNameWithSeparator)
	{
        $global:BuildQueueVariable = -join($global:BuildQueueVariable, $FolderNameWithSeparator)
	}
}

# Add services to queue declared from pipeline

if ($env:BUILDQUEUEINIT)
{
	Write-Host "Build Queue Init: $env:BUILDQUEUEINIT"
	Write-Host "##vso[task.setvariable variable=BuildQueue;isOutput=true]$env:BUILDQUEUEINIT"
	exit 0
}

# Get all files that were changed
$EditedFiles = git diff HEAD HEAD~ --name-only

# Check each file that was changed and add that Service to Build Queue
$EditedFiles | ForEach-Object {	
    Switch -Wildcard ($_ ) {		
        "service1/*" { 
			Write-Host "Service 1 changed"
			AppendQueueVariable "service1"
		}
        "service2/*" { 
			Write-Host "Service 2 changed" 
			AppendQueueVariable "service2"
		}
		"service3/*" { 
			Write-Host "Service 3 changed" 
			AppendQueueVariable "service3"
			AppendQueueVariable "service2"
		}
        # The rest of your path filters
    }
}

Write-Host "Build Queue: $global:BuildQueueVariable"
Write-Host "##vso[task.setvariable variable=BuildQueue;isOutput=true]$global:BuildQueueVariable"