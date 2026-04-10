# 部署脚本：将public目录上传到blog仓库

# 设置Git路径
$gitPath = "D:\Program Files\Git\bin\git.exe"

Write-Host "开始部署public目录到blog仓库..."
Write-Host ""

# 进入public目录
Set-Location -Path ".\my-hexo-blog\public"

# 检查Git状态
Write-Host "检查Git状态..."
& $gitPath status
Write-Host ""

# 添加所有更改
Write-Host "添加所有更改..."
& $gitPath add .
Write-Host ""

# 提交更改
Write-Host "提交更改..."
$commitMessage = "Deploy public directory on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
& $gitPath commit -m $commitMessage
Write-Host ""

# 推送到远程仓库
Write-Host "推送到远程仓库..."
& $gitPath push origin main
Write-Host ""

Write-Host "部署完成！"

# 返回到原目录
Set-Location -Path "..\.."
