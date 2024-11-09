@echo off
setlocal

set "localFile=./ordersdist"
set "remoteUser=root"
set "remoteHost=211.64.39.202"
set "remotePath=/"
set "logFile=F:\scp_log.txt"

echo Sending files...
echo ------------------------------------------------------

:: 检查 ../ 目录下是否存在 orderdist 文件夹
if exist "%localFile%" (
    echo The directory "%localFile%" does exist.
) else (
    echo  "%localFile%" does not exist. Please check.
)

echo Packaging package.json...
npm run build:stage
if errorlevel 1 (
    echo Packaging failed. Please check the npm command.
    exit /b 1
)
echo Package done!





pause
endlocal
