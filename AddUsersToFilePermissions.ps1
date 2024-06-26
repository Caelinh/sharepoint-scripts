$SiteURL = ""
$csvFile = Import-Csv -Path "C:\Temp\AddUsersToPermissions.csv" -Delimiter ","

Connect-PnPOnline -Url $SiteURL -Credentials (Get-Credential)

$UsersToAdd = @()
$FolderCount = 0
$FolderIndex = 0

foreach ($row in $csvFile) {
    $FolderIndex++
    $ProgressPercentage = ($FolderIndex / $csvFile.Count) * 100
    Write-Progress -Activity "Processing Folders" -Status "$($FolderIndex) of $($FolderCount) files processed." -PercentComplete $ProgressPercentage

    $PathSegments = $row.FolderServerRelativeURL.Split("/")
    $ListName = $PathSegments[0]
    $FileName = $PathSegments[-1]
    $FolderServerRelativeURL = $row.ResourcePath.Substring(0,$row.ResourcePath.LastIndexOf("/$($FileName)"))

    try {
        
    }
    catch {
        $_.Exception.Message

        Write-Host -f red "Error Granting Permission to $($row.userEmail) on File: $($FileName)"
        $user = New-Object -TypeName PSObject -property @{
            UserEmail = $row.userEmail
            Folder = $row.ResourcePath
            File = $FileName
        }
        $UsersToAdd += $user
    }
}
$UsersToAdd | Export-Csv -Path "C:\Temp\UsersToAdd.csv" -NoTypeInformation