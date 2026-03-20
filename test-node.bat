@echo off
chcp 65001 >nul
echo 测试Node.js和npm

echo 设置Node.js路径...
set NODE_PATH=D:\Program Files\nodejs
set PATH=%NODE_PATH%;%PATH%
echo Node.js路径: %NODE_PATH%

echo 检查node.exe是否存在...
if exist "%NODE_PATH%\node.exe" (
    echo node.exe 存在
) else (
    echo node.exe 不存在
    pause
    exit /b 1
)

echo 测试node命令...
node --version
echo 错误码: %errorlevel%

pause

echo 测试npm命令...
npm --version
echo 错误码: %errorlevel%

pause