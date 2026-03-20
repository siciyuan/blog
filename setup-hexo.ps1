Write-Host "================================" -ForegroundColor Green
Write-Host "Hexo 博客一键搭建脚本" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

Write-Host "开始执行..."

# 设置Node.js路径
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:PATH = "$env:NODE_PATH;$env:PATH"

Write-Host "`n检查Node.js安装..."
Write-Host "Node.js路径: $env:NODE_PATH"

if (Test-Path "$env:NODE_PATH\node.exe") {
    Write-Host "找到Node.js"
    node --version
    Write-Host "`nnpm版本:"
    npm --version
    Write-Host ""
} else {
    Write-Host "未找到Node.js，请检查路径是否正确" -ForegroundColor Red
    Read-Host "按Enter键退出..."
    exit 1
}

Write-Host "安装Hexo CLI..."
npm install -g hexo-cli
Write-Host ""

Write-Host "创建Hexo博客目录..."
New-Item -ItemType Directory -Name "my-hexo-blog" -Force | Out-Null
Write-Host ""

Write-Host "进入博客目录..."
Set-Location "my-hexo-blog"
Write-Host ""

Write-Host "初始化Hexo博客..."
hexo init
Write-Host ""

Write-Host "安装依赖..."
npm install
Write-Host ""

Write-Host "生成静态文件..."
hexo generate
Write-Host ""

Write-Host "================================" -ForegroundColor Green
Write-Host "Hexo博客搭建完成！" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host "博客目录: $(Get-Location)"
Write-Host "运行以下命令启动本地服务器:"
Write-Host "cd my-hexo-blog"
Write-Host "hexo server"
Write-Host ""
Read-Host "按Enter键退出..."