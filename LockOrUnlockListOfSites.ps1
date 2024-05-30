Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

$AdminSiteUrl = ""

Connect-SPOService -Url $AdminSiteUrl

#Uncomment which state you want to set
$LockState = "Unlock"
$LockState = "readOnly"

#Path to csv file with list of sites
$csvFilePath = ""
$table = Import-Csv $csvFilePath -Delimiter ","

foreach ($row in $table) {
    $SiteURL = $row.SiteUrl
    Write-Host "Processing site $SiteURL"

    try {
        set-sposite -identity $SiteURL -LockState $LockState
        Write-Host "Site $($SiteURL) is now $($LockState)"
    }
    catch {
        Write-Host -f red "Failed to $($LockState) site $($SiteURL)"}

}
Write-Host "All sites processed"