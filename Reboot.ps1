# Get-RebootShutdownLogs.ps1
$logPath = "C:\Temp\System.evtx"
Get-WinEvent -Path $logPath | Where-Object { $_.Id -eq 1074 } | 
Select-Object Id, TimeCreated, LevelDisplayName, Message | 
Format-List
