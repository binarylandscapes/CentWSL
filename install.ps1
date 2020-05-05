param(
[parameter(Mandatory=$false)][string]$user = $env:UserName.ToLower(),
[parameter(Mandatory=$true)][string]$email = "username@domain.com"
)

Start-Transcript -path C:\TEMP\install-wsl.log -append

# Set distro name
$wslDistro = (Get-ChildItem -Path .\CentOS*.exe).Name
$distroName = $wslDistro.Split('.')[0]
$wslPath = "C:\Users\$user\.wsl\$distroName"
$TargetFile = "$wslPath\$wslDistro"
$ShortcutFile = "C:\Users\$user\Desktop\$distroName WSL.lnk"

# Uninstall previous WSL distro if present
If (Test-Path $wslPath) {
    Write-Host -ForegroundColor Yellow ("`nUninstalling previous Windows Subsystem for Linux (WSL), $distroName Linux")
    Start-Process $wslPath\$wslDistro -ArgumentList "clean" -NoNewWindow -Wait
    Get-ChildItem -Path $wslPath -Recurse | Remove-Item -force -recurse
    Remove-Item -Force $wslPath
    Remove-Item -Force $ShortcutFile
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $distroName Linux FOUND and REMOVED.")
}
Else {
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $distroName Linux NOT found.")
}

# Install WSL Distro
Write-Host -ForegroundColor Yellow ("`nInstalling Windows Subsystem for Linux (WSL), $distroName Linux to $wslPath")
Invoke-Command -ScriptBlock { Copy-Item -Recurse -Path .\ -Destination $args[0] -Force } -ArgumentList $wslPath

Start-Process wsl.exe -ArgumentList "--set-default-version 2" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run cd /usr/share/texlive/texmf-dist/tex/latex/acrotex; sudo latex acrotex.ins" -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo mktexlsr" -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.autocrlf false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.symlinks false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system rebase.autosquash true" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system lfs.activitytimeout 0" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system credential.helper 'cache --timeout 30000'" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git lfs install"  -NoNewWindow -Wait
Write-Host -ForegroundColor Green ("`nInstallation of Windows Subsystem for Linux (WSL), $distroName Linux is complete")

# Configure user for WSL Distro
Write-Host -ForegroundColor Yellow ("`nConfiguring user:$user for Windows Subsystem for Linux (WSL), $distroName Linux")
Write-Host -ForegroundColor Yellow ("`nSet password for $user when prompted")
Start-Process $wslPath\$wslDistro -ArgumentList "run adduser $user --uid 1000" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run passwd $user -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run usermod -aG wheel $user" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "config --default-uid 1000" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "config --default-term wt" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run echo export PLANTUML=/usr/local/plantuml.jar >> ~/.bash_profile"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run echo neofetch >> ~/.bash_profile"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run echo from pprint import pprint >> ~/.pyrc"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run echo export DISPLAY=:1 >> ~/.bash_profile"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global user.name $user"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global user.email '$email'"  -NoNewWindow -Wait

# Create desktop shortcut for user
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

# Cleanup
Remove-Item -Force $wslPath\rootfs.tar.gz
Remove-Item -Force $wslPath\addWSLfeature.ps1
Remove-Item -Force $wslPath\install.ps1

Write-Host -ForegroundColor Green ("`nUser Configuration of user:$user for Windows Subsystem for Linux (WSL), $distroName Linux is complete")

Stop-Transcript
