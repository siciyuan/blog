Write-Host "================================" -ForegroundColor Green
Write-Host "Hexo Blog Start Script" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Set Node.js path
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:PATH = "$env:NODE_PATH;$env:PATH"

# Add npm global path to PATH
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$npmGlobalPath;$env:PATH"

Write-Host "Checking Node.js installation..."
if (Test-Path "$env:NODE_PATH\node.exe") {
    Write-Host "Node.js found"
    node --version
    Write-Host ""
} else {
    Write-Host "Node.js not found, please check the path" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "Entering blog directory..."
if (Test-Path "my-hexo-blog") {
    Set-Location "my-hexo-blog"
    Write-Host "Current directory: $(Get-Location)"
    Write-Host ""
} else {
    Write-Host "Blog directory not found, please run setup script first" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "Starting Hexo server..." -ForegroundColor Green
Write-Host "After server starts, visit: http://localhost:4000" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start Hexo server
try {
    hexo server
} catch {
    Write-Host "Using full path to hexo..." -ForegroundColor Yellow
    & "$npmGlobalPath\hexo.cmd" server
}

Read-Host "Press Enter to exit..."