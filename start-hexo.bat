@echo off
chcp 65001 >nul
echo =================================
echo Hexo 博客启动脚本
echo =================================
echo.

rem 设置Node.js路径
set NODE_PATH=D:\Program Files\nodejs
set PATH=%NODE_PATH%;%PATH%

rem 添加npm全局路径
set NPM_GLOBAL_PATH=%USERPROFILE%\AppData\Roaming\npm
set PATH=%NPM_GLOBAL_PATH%;%PATH%

echo 检查Node.js安装...
if exist "%NODE_PATH%\node.exe" (
    echo 找到Node.js
    node --version
    echo.
) else (
    echo 未找到Node.js，请检查路径是否正确
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo 进入博客目录...
cd my-hexo-blog
echo 当前目录: %cd%
echo.

echo 启动Hexo服务器...
echo 服务器启动后，在浏览器中访问: http://localhost:4000
echo 按 Ctrl+C 停止服务器
echo.

hexo server

pause >nul