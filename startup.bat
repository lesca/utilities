@echo off
setlocal EnableDelayedExpansion
set app[0]="C:\VHD\procexp.exe" /t /e
set app[1]=%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass "C:\VHD\mountVHD.ps1"
set app[2]=%localappdata%\Microsoft\Teams\Update.exe --processStart "Teams.exe"
set app[3]="C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
set app[4]=D:\bin\putty\PAGEANT.EXE "D:\bin\putty\lesca.ppk"
set app[5]="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
set app[6]="C:\Program Files (x86)\Yinxiang Biji\Yinxiang Biji\Evernote.exe"

for /l %%n in (0,1,6) do (
	REM add additional 5 sec for next application
	set /a countdown=5*%%n
	timeout !countdown!
	
	REM start application
	echo !app[%%n]!
	start "" !app[%%n]!
)
