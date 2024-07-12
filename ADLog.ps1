# Collect-ADReplicationLogs.ps1

# Define the output file
$outputFile = "C:\Temp\ADReplicationLogs.txt"

# Ensure the output directory exists
if (!(Test-Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory
}

# Collect repadmin /showrepl output
Add-Content -Path $outputFile -Value "=== Repadmin /showrepl ==="
repadmin /showrepl * /csv | Out-File -FilePath $outputFile -Append

# Collect repadmin /replsummary output
Add-Content -Path $outputFile -Value "`n=== Repadmin /replsummary ==="
repadmin /replsummary | Out-File -FilePath $outputFile -Append

# Collect dcdiag output
Add-Content -Path $outputFile -Value "`n=== Dcdiag ==="
dcdiag /e /c | Out-File -FilePath $outputFile -Append

# Collect event logs for replication issues
Add-Content -Path $outputFile -Value "`n=== Event Logs (Directory Service) ==="
Get-WinEvent -LogName "Directory Service" | Where-Object { $_.Id -in 1084, 1085, 1925, 1926 } | Format-List | Out-File -FilePath $outputFile -Append

# Collect event logs for DFS replication issues
Add-Content -Path $outputFile -Value "`n=== Event Logs (DFS Replication) ==="
Get-WinEvent -LogName "DFS Replication" | Where-Object { $_.Id -in 5002, 5004, 5008, 5012, 5014, 5018 } | Format-List | Out-File -FilePath $outputFile -Append

# Final message
Add-Content -Path $outputFile -Value "`nCollection of AD replication logs is complete."

Write-Output "AD replication logs have been collected and saved to $outputFile"
