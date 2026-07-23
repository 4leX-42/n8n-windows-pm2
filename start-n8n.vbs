' Launch start-n8n.ps1 hidden (no console window). Self-locating.
Dim fso, dir
Set fso = CreateObject("Scripting.FileSystemObject")
dir = fso.GetParentFolderName(WScript.ScriptFullName)
CreateObject("WScript.Shell").Run "powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & dir & "\start-n8n.ps1""", 0, False
