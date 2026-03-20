@echo off
chcp 65001 >nul
echo =================================
echo Hexo 博客一键搭建脚本
echo =================================
echo.
echo 开始执行...
echo 按任意键继续...
pause >nul

rem 设置Node.js路径
set NODE_PATH=D:\Program Files\nodejs
set PATH=%NODE_PATH%;%PATH%

echo.
echo 检查Node.js安装...
echo Node.js路径: %NODE_PATH%
if exist "%NODE_PATH%\node.exe" (
    echo 找到Node.js
    node --version
    echo.
    echo npm版本:
    npm --version
    echo.
) else (
    echo 未找到Node.js，请检查路径是否正确
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo 安装Hexo CLI...
npm install -g hexo-cli
echo.

echo 创建Hexo博客目录...
mkdir my-hexo-blog
echo.

echo 进入博客目录...
cd my-hexo-blog
echo.

echo 初始化Hexo博客...
hexo init
echo.

echo 安装依赖...
npm install
echo.

echo 生成静态文件...
hexo generate
echo.

echo =================================
echo Hexo博客搭建完成！
echo =================================
echo 博客目录: %cd%
echo 运行以下命令启动本地服务器:
echo cd my-hexo-blog
echo hexo server
echo.
echo 按任意键退出...
pause >nul