#Enter tenant Admin URL
$adminURL = "https://tenant-admin.sharepoint.com"

#Azure group ID
$groupID = "00000000-0000-0000-0000-000000000000"
$loginName = "c:0t.c|tenant|"+$groupID

#Path to csv file with list of sites
$csvFilePath = "C:\Temp\SiteCollections.csv"
$table = Import-Csv $csvFilePath -Delimiter ","

#Path to output csv file
$csvOutputFilePath = "C:\Temp\SiteCollectionsOutput.csv"

Connect-SPOService -url $adminURL
$ProblemSites = @()

foreach ($row in $table) {
    try {
        $Site = Get-SPOSite -Identity $row.SiteURL

        #Add Azure AD group to site collection
        Write-Host -f Yellow "Adding Azure AD group to site collection $($Site.URL)"
        Set-SPOUser -Site $Site.URL -LoginName $loginName -IsSiteCollectionAdmin $true
        Write-Host -f Green "Azure AD group added to site collection $($Site.URL)"
    }
    catch {
        Write-Host -f red "Failed to add Azure AD group to site collection $($SiteURL)"
        $ProblemSites += $SiteURL
    }
}
$ProblemSites | Export-Csv $csvOutputFilePath -NoTypeInformation