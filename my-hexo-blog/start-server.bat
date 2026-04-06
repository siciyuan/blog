@echo off

REM Set paths
set NODE_PATH="D:\Program Files\nodejs"
set GIT_PATH="D:\Program Files\Git\bin"
set npmGlobalPath=%USERPROFILE%\AppData\Roaming\npm
set PATH=%NODE_PATH%;%GIT_PATH%;%npmGlobalPath%;%PATH%

REM Start Hexo server
echo Starting Hexo server on http://localhost:4000...
hexo server
