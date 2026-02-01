@echo off
powershell -NoProfile -Command "$CpuLoad = (Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average; Write-Output $CpuLoad.ToString()"