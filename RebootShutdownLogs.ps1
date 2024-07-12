# PowerShell script to identify reasons for a Windows Server reboot from an .evtx file
# Author: ChatGPT

# Function to convert EventID to readable reason
function Get-RebootReason {
    param(
        [int]$EventID,
        [string]$Message
    )

    switch ($EventID) {
        1074 { "Shutdown or restart by a user or process: $Message" }
        1076 { "Unexpected shutdown or system crash: $Message" }
        6005 { "Event log service started (boot): $Message" }
        6006 { "Event log service stopped (shutdown): $Message" }
        6008 { "Unexpected shutdown (dirty shutdown): $Message" }
        default { "Other: $Message" }
    }
}

# Path to the .evtx file
$evtxPath = "C:\temp\System.evtx"

# Check if the file exists
if (Test-Path $evtxPath) {
    Write-Host "Processing the file: $evtxPath"
    
    # Get all events from the .evtx file
    $allEvents = Get-WinEvent -Path $evtxPath

    # Output number of events read
    Write-Host "Total events read from the file: $($allEvents.Count)"

    # Filter the relevant events
    $filteredEvents = $allEvents | Where-Object { $_.Id -in 1074,1076,6005,6006,6008 } | Sort-Object TimeCreated -Descending

    # Output number of filtered events
    Write-Host "Total relevant events found: $($filteredEvents.Count)"

    # Output the reboot events
    foreach ($event in $filteredEvents) {
        $reason = Get-RebootReason -EventID $event.Id -Message $event.Message
        [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            EventID = $event.Id
            Reason = $reason
        } | Format-Table -AutoSize
    }
} else {
    Write-Host "The file $evtxPath does not exist."
}
