Import-Module pnp.powershell

$userEmail = ""
$siteCollection = Import-Csv -Path "C:\Temp\SiteCollections.csv" -Delimiter ","
$siteURL = "https://tenant.sharepoint.com/sites/contoso"

Connect-PnPOnline -Url $siteURL -Interactive
try {
    #Get the site
    $site = Get-PnPSite -Includes GroupId

    add-PnPMicrosoft365GroupOwner -Identity $site.GroupId -User $userEmail

    Write-Host "User added as owner of the site $($siteURL)"
}
catch {
    Write-Host -f red "Error processing site $($siteURL):" $_.Exception.Message
}
