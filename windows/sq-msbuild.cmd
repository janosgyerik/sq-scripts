@echo off

setlocal

set project_key=%1
shift

if "%1" == "" (
    set step1=1
    set step2=1
    set step3=1
) else (
    set step1=
    set step2=
    set step3=
)

:loop
if not "%1" == "" (
    if "%1" == "1" (
        set step1=1
    )
    if "%1" == "2" (
        set step2=1
    )
    if "%1" == "3" (
        set step3=1
    )
    shift
    goto:loop
)


set msbuild=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe
set msbuild=C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe

set dump=/d:sonar.scanner.dumpToFile=dump
set dump=

set scanner=C:\work\tools\msbuild\msbuild.sonarqube.runner
set scanner=C:\dev\git\sonar\sonar-scanner-msbuild\deploymentartifacts\buildagentpayload\release\work\msbuild.sonarqube.runner

if not defined step1 goto:step2

%scanner% begin /key:%project_key% /name:%project_key% /version:0.1 /d:sonar.verbose=true %dump%

call:checkerror begin
if defined err goto:eof

:step2
if not defined step2 goto:step3

"%msbuild%" /t:rebuild

call:checkerror build
if defined err goto:eof

:step3
if not defined step3 goto:eof

%scanner% end

call:checkerror end


goto:eof

:checkerror

echo errorlevel=%errorlevel%

if %errorlevel% == 0 (
    set err=
    echo *** step success: %~1
) else (
    set err=1
    echo *** step FAILED: %~1
)

