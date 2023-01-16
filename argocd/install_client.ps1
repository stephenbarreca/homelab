# install client
param(
    [Parameter(
            HelpMessage = "location to install client exe",
            Mandatory = $false
    )]
    [Alias("o")]
    [string]
    $exe_path = "argocd.exe"
)
$version = (Invoke-RestMethod https://api.github.com/repos/argoproj/argo-cd/releases/latest).tag_name
$url = "https://github.com/argoproj/argo-cd/releases/download/" + $version + "/argocd-windows-amd64.exe"
Write-Output "downloading exe from url: $url"
Invoke-WebRequest -Uri $url -OutFile $exe_path
Write-Output "exe downloaded to local path, $exe_path"
