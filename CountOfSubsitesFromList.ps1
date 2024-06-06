Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

$csvFile = "C:\Temp\SiteCollections.csv"
$table = Import-Csv -Path $csvFile -Delimiter ","

$adminURL = "https://tenant-admin.sharepoint.com"

#Connect to SharePoint Online
Connect-SPOService -url $adminURL

$subsiteCount = 0

#Iterate through all site collections and count the number of subsites
foreach ($site in $table) {
    $subsites = Get-SPOSite -Identity $site.SiteURL -Detailed
    $subsiteCount += ($subsites.WebsCount-1)
}

Write-Host "Total number of subsites in all site collections: $($subsiteCount)"