param(
    [Parameter(
            HelpMessage = "kubectl namespace in which to install argocd",
            Mandatory = $false
    )]
    [Alias("n")]
    [string]
    $namespace = "argocd",

    [Parameter(
            HelpMessage = "installer location (local path or url)",
            Mandatory = $false,
            Position = 0
    )]
    [string]
    $installer = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml",

    [Parameter(
            HelpMessage = "confirm options",
            Mandatory = $false
    )]
    [switch]
    [Alias("y")]
    $autoConfirm = $false
)

$runFlag = $false

if ( $autoConfirm ) {
    $runFlag = $true
}
else {
    Write-Output "Argocd Server will be installed with the following settings:"
    Write-Output "    namespace: $namespace"
    Write-Output "    installer: $installer"
    $confirm = Read-Host -Prompt 'Confirm: [y/n]'
    if ( $confirm -like "*y" ) {
        Write-Output "confirmed"
        $runFlag = $true
    }
    else {
        Write-Output "not confirmed"
    }}
if ( $runFlag ) {
    write-output "creating namespace, $namespace"
    kubectl create namespace $namespace

    write-output "applying manifest"
    kubectl apply -n $namespace -f $installer
}