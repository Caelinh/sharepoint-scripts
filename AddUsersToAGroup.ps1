$SiteURL = "https://crescent.sharepoint.com/sites/marketing"
$csvFile = Import-Csv -Path "C:\Temp\AddUsersToPermissions.csv" -Delimiter ","
$Group = "Marketing Owners"
Connect-PnPOnline -Url $SiteURL -Credentials (Get-Credential)

foreach ($row in $csvFile) {
    try {
        $Group = Get-PnPGroup -Identity $Group
        Add-pnpgroupmember -Identity $Group -EmailAddress $row.userEmail
        Write-Host "User $($row.userEmail) added to Group: $($Group.Title)"
    } catch {
        Write-Host "Error Adding User $($row.userEmail) to Group: $($Group.Title)"
        Write-Host $_.Exception.Message
    }
}