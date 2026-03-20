Write-Host "================================" -ForegroundColor Green
Write-Host "Hexo Theme Installation Script (npm)" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Set Node.js path
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:PATH = "$env:NODE_PATH;$env:PATH"

# Add npm global path to PATH
$npmGlobalPath = "