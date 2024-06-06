Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

#Site to enable scripts
$mySiteURL = "https://tenant.sharepoint.com/sites/contoso"

Connect-SPOService -url "https://tenant-admin.sharepoint.com"

try {
    Write-Host "Enabling scripts on site $($mySiteURL)"
    Set-SPOSite -Identity $mySiteURL -DenyAddAndCustomizePages 0
}
catch {
    Write-Host -f red "Error enabling scripts on site $($mySiteURL)"
}

Write-Host "Script execution completed"