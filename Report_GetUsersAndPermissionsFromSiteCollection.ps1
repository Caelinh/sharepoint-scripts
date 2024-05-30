$SiteURLs = Import-Csv -Path "C:\Temp\SiteCollections.csv" -Delimiter ","

#Set paths of output files
$csvOutputFilePath = "C:\Temp\SiteCollectionsOutput.csv"
$ProblemCsvOutputFilePath = "C:\Temp\SiteCollectionsProblemOutput.csv"

#Connect to SharePoint Online
Connect-SPOService -url "https://tenant-admin.sharepoint.com"

$siteCount = $SiteURLs.Count
$siteIndex = 0

#Prepare output arrays
$ProblemSites = @()
$GroupsData = @()

foreach ($site in $SiteURLs) { 
    $groups = @()
    $siteIndex
    $progressPercentSite = ($siteIndex / $siteCount) * 100
    Write-Progress -Activity "Processing sites" -Status "$siteIndex of $siteCount sites processed" -PercentComplete $progressPercentSite -Id 1

    try {
        # Get all groups in the site
        $groups = Get-SPOSiteGroup -Site $site.SiteURL

        #Initialize progress variables for groups within current site
        $groupCount = $groups.Count
        $groupIndex = 0

        foreach ($Group in $Groups) {
            $groupIndex++
            $progressPercentGroup = ($groupIndex / $groupCount) * 100
            Write-Progress -Activity "Processing groups in Site $($site.SiteURL)" -Status "$groupIndex of $groupCount groups processed" -PercentComplete $progressPercentGroup -Id 2
            $GroupsData += [PSCustomObject]@{
                SiteURL = $site.SiteURL
                GroupName = $Group.Title
                Permissions = $Group.Roles -join ", "
                Users = $Group.Users -join ", "
            }
        }
    }
    catch {
        $GroupsData += [PSCustomObject]@{
            SiteURL = $site.SiteURL
            GroupName = "Error"
            Permissions = "Error"
            Users = "Error"
        }
        $ProblemSites += $site.SiteURL
        Write-Host -f red "Failed to get groups for site $($site.SiteURL)"
        continue
    }
}
$GroupsData | Export-Csv $csvOutputFilePath -NoTypeInformation
$ProblemSites | Export-Csv $ProblemCsvOutputFilePath -NoTypeInformation
Write-Host "All sites processed"

Disconnect-SPOService