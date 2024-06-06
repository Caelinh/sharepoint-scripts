Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

$CSVData = Import-Csv -Path "C:\Temp\SiteCollections.csv" -Delimiter ","
$ProblemCsvOutputFilePath = "C:\Temp\SiteCollectionsProblemOutput.csv"

#Email address of the user to add as site collection admin
$UserEmail = ""

$ProblemSites = @()

#Connect to SharePoint Online
Connect-SPOService -url "https://tenant-admin.sharepoint.com"

try {
    foreach ($row in $CSVData) {
        try {
            #Add user as site collection admin
            Write-Host "Adding user as site collection admin for $($row.SiteURL)"
            Set-SPOUser -Site $row.SiteURL -LoginName $UserEmail -IsSiteCollectionAdmin $true | Out-Null
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