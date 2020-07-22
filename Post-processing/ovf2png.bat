@echo off
title ovf2png
if "%1" == "-h" (
	echo.
	echo ***Please add the folderpath of 'mumax3-convert.exe' to PATH Environment Variables***
	echo 1. if you'd like to convert all the '.ovf' to '.png', just type 'ovf2png.bat' in cmd without passing any arguments;
	echo 2. if you only plan to convert specific file^(s^), pass the keywords as AN argument ^(wildcard is supported^), e.g. type 'ovf2png.bat eg' to convert all the '*eg*.ovf'.
	echo.
) else (
	if "%1" == "" (
	mumax3-convert -png *.ovf
	) else (
	mumax3-convert -png *%1*.ovf
	)
)

pause
:: remove 'pause' if you prefer this batch file to automatically exit after it is finished.