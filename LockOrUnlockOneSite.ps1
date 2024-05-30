Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

$AdminSiteUrl = ""

$SiteURL = ""

#Uncomment which state you want to set
$LockState = "Unlock"
$LockState = "readOnly"

Connect-SPOService -url $AdminSiteUrl

Write-Host "Processing site $SiteURL"

try {
    set-sposite -identity $SiteURL -LockState $LockState
    Write-Host -f Green "Site $($SiteURL) is now $($LockState)"
}
catch {
    Write-Host -f red "Failed to $($LockState) site $($SiteURL)"
}