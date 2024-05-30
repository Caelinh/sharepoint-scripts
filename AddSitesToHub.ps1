$TenantSiteUrl = ""
$HubSiteUrl = ""
$csvFilePath = ""
$table = Import-Csv $csvFilePath -Delimiter ","

try {
    Connect-PnPOnline -Url $TenantSiteUrl -UseWebLogin

    $HubSite = Get-PnPHubSite -Identity $HubSiteUrl
    $SitesConnectedToHub = Get-PnPHubSiteAssociatedSites -Identity $HubSiteUrl

    foreach ($row in $table) {
        $SiteUrl = $row.SiteUrl
        $Site = Get-PnPSite -Identity $SiteUrl

        if ($SitesConnectedToHub -notcontains $SiteUrl) {
            Add-PnPHubSiteAssociation -Site $Site -HubSite $HubSite
            Write-Host "Site $SiteUrl added to hub $HubSiteUrl"
        }
        else {
            Write-Host "Site $SiteUrl is already connected to hub $HubSiteUrl"
        }
    }
}
catch {
    Write-Host $_.Exception.Message
}
finally {
    Disconnect-PnPOnline
}