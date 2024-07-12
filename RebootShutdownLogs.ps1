# Get-RebootShutdownLogs.ps1
Get-EventLog -LogName System -Source "User32" -EntryType Information | Where-Object {
    $_.EventID -eq 1074
} | Select-Object EventID, TimeGenerated, EntryType, Message | Format-Table -AutoSize
