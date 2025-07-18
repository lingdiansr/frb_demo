@echo off
REM Windows构建脚本
setlocal enabledelayedexpansion

set PROJECT_NAME=frb-demo
for /f "tokens=2 delims=:" %%a in ('findstr /c:"version:" pubspec.yaml') do (
    set VERSION=%%a
    set VERSION=!VERSION: =!
    for /f "tokens=1 delims=+" %%b in ("!VERSION!") do set VERSION=%%b
)

echo 开始构建 %PROJECT_NAME% v%VERSION%

REM 创建构建目录
if not exist "build\releases" mkdir build\releases

REM 清理之前的构建
flutter clean

REM 获取依赖
flutter pub get

REM 构建Windows应用
flutter build windows --release

REM 创建压缩包
cd build\windows\x64\runner\Release
powershell Compress-Archive -Path "*" -DestinationPath "..\..\..\..\..\build\releases\%PROJECT_NAME%-windows-x64.zip"
cd ..\..\..\..\..

echo Windows构建完成！
echo 构建产物位于: build\releases\
dir build\releases\
