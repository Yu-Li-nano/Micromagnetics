@echo off
title ovf_Binary2Ascii
if "%1" == "-h" (
	echo.
	echo ***Please add the folderpath of 'mumax3-convert.exe' to PATH Environment Variables***
	echo The way of converting Binary '.ovf' to readble Ascii '.ovf' format is
	echo Binary '*.ovf' -^> '*.dump' -^> Ascii '*.ovf' -^> delete '*.dump'
	echo As converting Binary2Ascii directly will encounter an error.
	echo 1. if you'd like to convert all the Binary '.ovf', just type 'ovf2_Binary2Ascii.bat' in cmd without passing any arguments;
	echo 2. if you only plan to convert specific file^(s^), pass the keywords as AN argument ^(wildcard is supported^), e.g. type 'ovf_Binary2Ascii.bat eg' to convert all the '*eg*.ovf'.
	echo.
	echo More details about the 'mumax3-convert' can be found in 'https://godoc.org/github.com/mumax/3/cmd/mumax3-convert', or type 'mumax3-convert -h' in cmd.
	echo.
) else (
	if "%1" == "" (
	mumax3-convert -dump *.ovf
	mumax3-convert -ovf2=text *.dump
	del *.dump
	) else (
	mumax3-convert -dump *%1*.ovf
	mumax3-convert -ovf2=text *%1*.dump
	del *%1*.dump
	)
)
pause
:: remove 'pause' if you prefer this batch file to automatically exit after it is finished.