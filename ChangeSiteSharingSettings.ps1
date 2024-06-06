Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

$csvFile = "C:\Temp\SiteCollections.csv"
$ProblemCsvOutputFilePath = "C:\Temp\SiteCollectionsProblemOutput.csv"

$ProblemSites = @()

try {
    #Connect to SharePoint Online
    Connect-SPOService -url "https://tenant-admin.sharepoint.com"

    #Get data from CSV and iterate through each site
    $SiteURLs = Import-Csv -Path $csvFile -Delimiter ","

    foreach ($row in $CSVData) {
        try {
            Write-Host "Processing site $($row.SiteURL)"
            Set-SPOSite -Identity $row.SiteURL -SharingCapability ExternalUserAndGuestSharing
        }
        catch {
            Write-Host -f yellow "`tError processing site $($row.SiteURL):" $_.Exception.Message
            $ProblemSites += $row.SiteURL
        }
    }
}
catch {
    Write-Host -f red "`tError:" $_.Exception.Message
}

$ProblemSites | Export-Csv $ProblemCsvOutputFilePath -NoTypeInformation