@echo off
title ovf2vtk
if "%1" == "-h" (
	echo.
	echo ***Please add the folderpath of 'mumax3-convert.exe' to PATH Environment Variables***
	echo 1. if you'd like to convert all the '.ovf' to '.vtk', just type 'ovf2vtk.bat' in cmd without passing any arguments;
	echo 2. if you only plan to convert specific file^(s^), pass the keywords as AN argument ^(wildcard is supported^), e.g. type 'ovf2vtk.bat eg' to convert all the '*eg*.ovf'.
	echo More details about the 'mumax3-convert' can be found in 'https://godoc.org/github.com/mumax/3/cmd/mumax3-convert', or type 'mumax3-convert -h' in cmd.
	echo.
) else (
	if "%1" == "" (
	mumax3-convert -vtk binary *.ovf
	) else (
	mumax3-convert -vtk binary *%1*.ovf
	)
)

pause
:: remove 'pause' if you prefer this batch file to automatically exit after it is finished.