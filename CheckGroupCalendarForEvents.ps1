$csvFile = "C:\Temp\SiteCollections.csv"
$table = Import-Csv -Path $csvFile -Delimiter ","

#PATH TO THE LOG FILE
$logFile = "C:\Temp\CheckGroupCalendarForEvents.log"

$adminURL = "https://crescent-admin.sharepoint.com"

#Get Credentials to connect
connect-sposervice -url $adminURL
Connect-MgGraph -Scopes "Group.Read.All","Calendars.Read","Calendars.ReadBasic","Group.ReadWrite.All"

@SitesWithEvents = @()

#Iterate through each site collection
foreach ($site in $table) {
    write-host -f Yellow "Processing Site: $($site.URL)"
    try {
        $connectedSite = get-sposite -Identity $site.URL
        
    }
    catch {
        write-host -f Red "Couldn't connect to site: $($site.siteURL) $($_.Exception.Message)"
    }
    try {
        $Mgroup = Get-MgGroup -Filter "displayName eq '$($connectedSite.Title)'"

        #get the events from the group calendar
        $events = Get-MgCalendarEvent -GroupId $Mgroup.Id
        if($events.Count -gt 0) {
            $SitesWithEvents += [PSCustomObject]@{
                siteURL = $site.URL
                Events = $events.Length
            }]$site.URL
            write-host -f Green "Events found in $($site.URL)"
        }
        
    }
    catch {
        write-host "No group associated."
        
    }
}

$SitesWithEvents | Export-Csv -Path $logFile -NoTypeInformation