function Build-DockerImage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Dockerfile,

        [Parameter(Mandatory=$true)]
        [string]$Tag,

        [Parameter(Mandatory=$true)]
        [string]$Context,

        [Parameter(Mandatory=$false)]
        [string]$ComputerName
    )

    if ($ComputerName) {
        # Execute on remote host
        $scriptBlock = {
            param($Dockerfile, $Tag, $Context)
            docker build -t $Tag -f $Dockerfile $Context
        }
        Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -ArgumentList $Dockerfile, $Tag, $Context
    } else {
        # Execute locally
        docker build -t $Tag -f $Dockerfile $Context
    }
}

function Copy-Prerequisites {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,

        [Parameter(Mandatory=$true)]
        [string[]]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Destination
    )

    foreach ($p in $Path) {
        $destPath = "\\$ComputerName\$($Destination -replace ':','$')"
        Copy-Item -Path $p -Destination $destPath -Recurse
    }
}

function Run-DockerContainer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ImageName,

        [Parameter(Mandatory=$false)]
        [string]$ComputerName,

        [Parameter(Mandatory=$false)]
        [string[]]$DockerParams
    )

    $dockerCommand = "docker run " + ($DockerParams -join ' ') + " $ImageName"

    if ($ComputerName) {
        # Remote execution
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            param ($cmd)
            Invoke-Expression $cmd
        } -ArgumentList $dockerCommand
    } else {
        # Local execution
        Invoke-Expression $dockerCommand
    }
}



Export-ModuleMember -Function Build-DockerImage, Copy-Prerequisites, Run-DockerContainer

