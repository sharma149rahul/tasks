function Build-DockerImage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Dockerfile,

        [Parameter(Mandatory=$true)]
        [string]$Tag,

        [Parameter(Mandatory=$true)]
        [string]$Context
    )

    # Execute the Docker build command locally
    $buildCommand = "docker build -t $Tag -f $Dockerfile $Context"
    Invoke-Expression $buildCommand
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

    # Formulate the Docker run command with PowerShell script parameters
    $dockerCommandArgs = $DockerParams -join ' '
    $dockerCommand = "docker run $ImageName $dockerCommandArgs"

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




Export-ModuleMember -Function Build-DockerImage, Run-DockerContainer

