$SiteURL=""
$ListName="Documents"

Connect-PnPOnline -Url $SiteURL -UseWebLogin
Write-Host "Checking in all checked out files in list $($ListName)"

#Get all items in the list
$ListItems = Get-PnPListItem -List $ListName -Fields -PageSize 500 | Where {$_["FileLeafRef"] -like "*.*"}
$ListIndex = 0

foreach ($ListItem in $ListItems) {
    $ListIndex++
    Write-Host "Processing item $ListIndex of $($ListItems.Count)"
    
    #Get the file object
    $File = Get-PnPProperty -ClientObject $ListItem -Property File
    
    If ($File.Level -eq "Checkout") {
        #Check in the file
        Set-PnpFileCheckedIn -Url $File.ServerRelativeUrl -CheckinType MajorCheckIn

        Write-Host "File $($File.ServerRelativeUrl) checked in"
    }
}
Write-Host -f Green "All files checked in"