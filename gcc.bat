@CHCP 65001 >NUL
@VERIFY OFF
@TITLE C Language : GCC-COMPILER v0.1.1
@ECHO OFF


REM CONFIG
:: Language
SET "LANGUAGE=GR" &:: EN or GR

:: File name
SET "FNAME=main"

:: Which file to compile
SET "TARGET=%CD%\%FNAME%.c"

:: Where to compile
SET "OUT=%CD%\%FNAME%.exe"

:: Path for the GCC compiler.
SET "COMPILER_PATH=C:\gcc"

:: Temp rememberme file.
SET "TMP_RMB=%TMP%\gcc_rememberme.cmd"


:: Overwrite target there is a file has opened before.
IF EXIST "%TMP_RMB%" (
	CALL "%TMP_RMB%"
)

:: Overwrite target if arguments are given.
SET ARG1=%1
SET ARG_OUT=%~dpn1
IF DEFINED ARG1 (
	SET TARGET=%ARG1:"=%
	SET "OUT=%ARG_OUT%.exe"
	(
		ECHO.SET TARGET=%ARG1:"=%
		ECHO.SET "OUT=%ARG_OUT%.exe"
	) > "%TMP_RMB%"
)


:: Detect whether GCC is installed.
IF EXIST "%COMPILER_PATH%\bin\gcc.exe" (
	:: If it is, run the compiler.
	GOTO COMPILER
) ELSE (
	:: If it isn't, install it automatically.
	GOTO INSTALLER
)

EXIT

:INSTALLER
ECHO.The compiler (GCC) is not installed on your computer.
CHOICE /C YN /N /M "Do you want to install GCC essentials (Y/N)?"

IF ERRORLEVEL 2 (
	:: If N is pressed, exit.
	EXIT 1
)

IF %LANGUAGE%==EN TITLE Downloading ...
IF %LANGUAGE%==GR TITLE Γίνεται λήψη ...
IF EXIST ".\gcc.zip" DEL /F /Q ".\gcc.zip"
CURL -S "https://img.comradeturtle.dev/assets/gcc.zip" --SSL-NO-REVOKE >".\gcc.zip"

ECHO.
IF %LANGUAGE%==EN (
	TITLE Installing ...
	ECHO.Installing ...
)
IF %LANGUAGE%==GR (
	TITLE Εγκατάσταση ...
	ECHO.Εγκατάσταση ...
)
SET VBS=".\gccInstaller.VBS"
IF EXIST "%VBS%" DEL /F /Q "%VBS%"
>%VBS% ECHO Set fso = CreateObject("Scripting.FileSystemObject")
>>%VBS% ECHO If NOT fso.FolderExists("%COMPILER_PATH%") Then
>>%VBS% ECHO fso.CreateFolder("%COMPILER_PATH%")
>>%VBS% ECHO End If
>>%VBS% ECHO set objShell = CreateObject("Shell.Application")
>>%VBS% ECHO set FilesInZip=objShell.NameSpace("%CD%\gcc.zip").items
>>%VBS% ECHO objShell.NameSpace("%COMPILER_PATH%").CopyHere(FilesInZip)
>>%VBS% ECHO Set fso = Nothing
>>%VBS% ECHO Set objShell = Nothing
CSCRIPT //NOLOGO "%VBS%"

IF %LANGUAGE%==EN ECHO.Cleaning up ...
IF %LANGUAGE%==GR ECHO.Καθαρισμός ...
IF EXIST "%VBS%" DEL /F /Q "%VBS%"
IF EXIST "%CD%\gcc.zip" DEL /F /Q "%CD%\gcc.zip"

EXIT

:COMPILER
IF NOT EXIST "%TARGET%" (
	IF %LANGUAGE%==EN ECHO.[1;31mFATAL[0m: [1mCompilation couldn't start, the requested file doesn't exist.[0m
	IF %LANGUAGE%==GR ECHO.[1;31mΣΦΑΛΜΑ[0m: [1mΗ συναρμολόγηση δεν μπόρεσε να ξεκινήσει, το αρχείο που εισάγατε δεν υπαρχει.[0m
	PAUSE>NUL
	EXIT 1
)

DEL /Q "%OUT%" 2>NUL

IF %LANGUAGE%==EN TITLE Compiling ...
IF %LANGUAGE%==GR TITLE Συναρμολόγηση ...
"C:\gcc\bin\gcc.exe" -Wall -Wextra -g3 "%TARGET%" -o "%OUT%"

IF EXIST "%OUT%" (
	START CMD /C TITLE  ^& "%OUT%" ^& PAUSE^>NUL
) ELSE (
	ECHO.
	IF %LANGUAGE%==EN ECHO.[1;31mFATAL[0m: [1mCompilation process failed, see above for hints.[0m
	IF %LANGUAGE%==GR ECHO.[1;31mΣΦΑΛΜΑ[0m: [1mΑποτυχία διαδικασίας συναρμολόγησης, δείτε παραπάνω για περισσότερες πληροφορίες.[0m
	PAUSE>NUL
	EXIT 1
)

EXIT
