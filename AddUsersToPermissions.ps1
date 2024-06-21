#Config Variables
$SiteURL = "https://crescent.sharepoint.com/sites/marketing"
$ListName="Documents"
$FolderServerRelativeURL = "/sites/marketing/Shared Documents/2019"
$UserAccount = "Salaudeen@crescent.com"
$csvFile = Import-Csv -Path "C:\Temp\AddUsersToPermissions.csv" -Delimiter ","



#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -Credentials (Get-Credential)
 
foreach ($row in $csvFile) {

    #Get the Folder from URL
    $Folder = Get-PnPFolder -Url $row.FolderServerRelativeURL
     
    #Grant Permission to a Folder
    Set-PnPListItemPermission -List $ListName -Identity $Folder.ListItemAllFields -User $row.userEmail -AddRole $row.RoleName

    Write-Host "Permission granted to $($row.userEmail) on Folder: $($FolderServerRelativeURL)"
    
}
