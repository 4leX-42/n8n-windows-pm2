# Creates Desktop + Start Menu shortcuts ("n8n" / "Stop n8n") pointing at the .vbs launchers.
$here      = Split-Path -Parent $MyInvocation.MyCommand.Path
$wscript   = "$env:WINDIR\System32\wscript.exe"
$icon      = Join-Path $here 'n8n.ico'
$desktop   = [Environment]::GetFolderPath('Desktop')
$startmenu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
$ws        = New-Object -ComObject WScript.Shell

$defs = @(
  @{ Name = 'n8n';      Vbs = (Join-Path $here 'start-n8n.vbs'); Desc = 'Start n8n and open the UI (localhost:5678)' },
  @{ Name = 'Stop n8n'; Vbs = (Join-Path $here 'stop-n8n.vbs');  Desc = 'Stop n8n and kill the pm2 daemon' }
)

foreach ($dir in @($desktop, $startmenu)) {
  foreach ($d in $defs) {
    $lnk = Join-Path $dir "$($d.Name).lnk"
    $s = $ws.CreateShortcut($lnk)
    $s.TargetPath        = $wscript
    $s.Arguments         = '"' + $d.Vbs + '"'
    $s.IconLocation      = "$icon,0"
    $s.Description        = $d.Desc
    $s.WorkingDirectory  = $here
    $s.Save()
    Write-Host "created: $lnk"
  }
}
