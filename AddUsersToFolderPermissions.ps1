#Config Variables
$SiteURL = "https://crescent.sharepoint.com/sites/marketing"
$FolderServerRelativeURL = "/sites/marketing/Shared Documents/2019"
$UserAccount = "Salaudeen@crescent.com"
$csvFile = Import-Csv -Path "C:\Temp\AddUsersToPermissions.csv" -Delimiter ","



#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -Credentials (Get-Credential)
 $UsersToAdd = @()
foreach ($row in $csvFile) {

    #Get the Folder from URL
    $Folder = Get-PnPFolder -Url $row.FolderServerRelativeURL
    $PathSegments = $row.FolderServerRelativeURL.Split("/")
    $ListName = $PathSegments[0]
     
    try{

        if($row.Permission -eq 'Read'){
            Set-PnPListItemPermission -List $ListName -Identity $Folder.ListItemAllFields -User $row.userEmail -AddRole "Read"
            Write-Host "Permission granted to $($row.userEmail) on Folder: $($FolderServerRelativeURL)"
        } else {
            Set-PnPListItemPermission -List $ListName -Identity $Folder.ListItemAllFields -User $row.userEmail -AddRole $row.RoleName

            Write-Host "Permission granted to $($row.userEmail) on Folder: $($FolderServerRelativeURL)"
        }
    } catch {
        Write-Host "Error Granting Permission to $($row.userEmail) on Folder: $($FolderServerRelativeURL)"
        Write-Host $_.Exception.Message
        $user = New-Object -TypeName PSObject -property @{
            UserEmail = $row.userEmail
            Folder = $row.ResourcePath
        }

        $UsersToAdd += $user

    }
    
}

