# Collect-ADReplicationLogs.ps1

# Define the output file
$outputFile = "C:\Temp\ADReplicationLogs.txt"

# Ensure the output directory exists
if (!(Test-Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory
}

# Collect repadmin /showrepl output
Add-Content -Path $outputFile -Value "=== Repadmin /showrepl ===" -Encoding UTF8
repadmin /showrepl | Out-File -FilePath $outputFile -Append -Encoding UTF8

# Collect repadmin /replsummary output
Add-Content -Path $outputFile -Value "`n=== Repadmin /replsummary ===" -Encoding UTF8
repadmin /replsummary | Out-File -FilePath $outputFile -Append -Encoding UTF8

# Collect dcdiag output
Add-Content -Path $outputFile -Value "`n=== Dcdiag ===" -Encoding UTF8
dcdiag /e /c | Out-File -FilePath $outputFile -Append -Encoding UTF8

# Collect event logs for replication issues
Add-Content -Path $outputFile -Value "`n=== Event Logs (Directory Service) ===" -Encoding UTF8
Get-WinEvent -LogName "Directory Service" | Where-Object { $_.Id -in 1084, 1085, 1925, 1926 } | Format-List | Out-File -FilePath $outputFile -Append -Encoding UTF8

# Collect event logs for DFS replication issues
Add-Content -Path $outputFile -Value "`n=== Event Logs (DFS Replication) ===" -Encoding UTF8
Get-WinEvent -LogName "DFS Replication" | Where-Object { $_.Id -in 5002, 5004, 5008, 5012, 5014, 5018 } | Format-List | Out-File -FilePath $outputFile -Append -Encoding UTF8

# Final message
Add-Content -Path $outputFile -Value "`nCollection of AD replication logs is complete." -Encoding UTF8

Write-Output "AD replication logs have been collected and saved to $outputFile"
