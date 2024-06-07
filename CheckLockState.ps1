$csvFile = "C:\Temp\SiteCollections.csv"
$sites = Import-Csv -Path $csvFile -Delimiter ","
$logFile = "C:\Temp\CheckLockState.log"

$adminURL = "https://crescent-admin.sharepoint.com"

#connect to sharepoint online
connect-sposervice -url $adminURL

$LockedSites = @()
$ProblemSites = @()

foreach ($site in $sites) {
    write-host -f yellow "Processing Site: $($site.URL)"
    try {
        Get-SPOSite $site.siteUrl | Select-object URL, LockState | ForEach-Object {
            $LockedSites += [PSCustomObject]@{
                siteURL = $_.URL
                LockState = $_.LockState
            }
        }
        
    }
    catch {
        write-host -f Red "Error onnecting to site $(site.siteUrl)"
        $ProblemSites += [PSCustomObject]@{
            siteURL = $site.URL
            Error = $_.Exception.Message
        }
    }
}
$LockedSites | Export-Csv -Path $logFile -NoTypeInformation
write-host -f Green "Locked Sites Report Generated: $logFile"