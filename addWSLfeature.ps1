Start-Transcript -path C:\TEMP\addWSLfeature.log -append
$wslState = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if ($wslState.State -eq "Disabled") {
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
	Write-Host -ForegroundColor Yellow ("`nWindows Subsystem for Linux (WSL) is enabled, system will now restart")
}
Write-Host -ForegroundColor Green ("`nWindows Subsystem for Linux (WSL) is enabled")
Stop-Transcript
