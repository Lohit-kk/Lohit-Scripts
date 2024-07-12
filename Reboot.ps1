# Get-RebootShutdownLogs.ps1
$logPath = "C:\Temp\System.evtx"
Get-WinEvent -Path $logPath -FilterHashtable @{LogName='System'; Id=1074} | 
Select-Object Id, TimeCreated, LevelDisplayName, Message | 
Format-List
