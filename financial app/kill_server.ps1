$process = Get-CimInstance Win32_Process | Where-Object {$_.CommandLine -like '*uvicorn*'}
if ($process) {
    Stop-Process -Id $process.ProcessId -Force
    Write-Host "Killed Uvicorn PID: $($process.ProcessId)"
} else {
    Write-Host "No Uvicorn process found."
}
