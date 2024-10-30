@echo off
setlocal enabledelayedexpansion

REM 设置FTP服务器信息
set FTP_SERVER=211.64.39.202
set FTP_USER=root
set FTP_PASSWORD=Wlzx_zyjyxy_202
set REMOTE_PATH=/front/test

REM 设置本地文件路径
set LOCAL_FILE=C:\Users\大帅比的电脑\OneDrive\桌面\订单管理系统前端\order-system\order-UI\bash\test.txt

REM 连接到FTP服务器并上传文件
(
    echo open !FTP_SERVER!
    echo !FTP_USER!
    echo !FTP_PASSWORD!
    echo binary
    echo cd !REMOTE_PATH!
    echo put !LOCAL_FILE!
    echo bye
) | ftp -n

if errorlevel 1 (
    echo FTP command failed.
    exit /b
)

echo Upload complete.
endlocal
