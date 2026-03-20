Write-Host "================================" -ForegroundColor Green
Write-Host "Next Theme Installation Script" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Set paths
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:GIT_PATH = "D:\Program Files\Git\bin"
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$env:NODE_PATH;$env:GIT_PATH;$npmGlobalPath;$env:PATH"

# Enter blog directory
Set-Location "my-hexo-blog"
Write-Host "Current directory: $(Get-Location)" -ForegroundColor Cyan
Write-Host ""

# Clone Next theme
Write-Host "Cloning Next theme from GitHub..." -ForegroundColor Yellow
try {
    git clone https://github.com/next-theme/hexo-theme-next.git themes/next
    Write-Host "Next theme cloned successfully!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "Error cloning Next theme: $_" -ForegroundColor Red
    Write-Host "Please check if Git is installed and try again" -ForegroundColor Yellow
    Read-Host "Press Enter to exit..."
    exit 1
}

# Copy Next theme config file
Write-Host "Copying Next theme config file..." -ForegroundColor Yellow
if (Test-Path "themes\next\_config.yml.example") {
    Copy-Item "themes\next\_config.yml.example" "themes\next\_config.yml" -Force
    Write-Host "Config file copied successfully!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "Config file not found, skipping..." -ForegroundColor Yellow
    Write-Host ""
}

# Update main config file to use Next theme
Write-Host "Updating main config file..." -ForegroundColor Yellow
$configPath = "_config.yml"
if (Test-Path $configPath) {
    $configContent = Get-Content $configPath -Raw
    $updatedConfig = $configContent -replace 'theme:\s*butterfly', 'theme: next'
    Set-Content $configPath $updatedConfig
    Write-Host "Theme setting updated to 'next'" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "Main config file not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

# Clean and generate files
Write-Host "Cleaning and generating files..." -ForegroundColor Yellow
try {
    hexo clean
    Write-Host "Files cleaned!" -ForegroundColor Green
    Write-Host "Generating files..."
    hexo generate
    Write-Host "Files generated successfully!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "Using full path to hexo..." -ForegroundColor Yellow
    & "$npmGlobalPath\hexo.cmd" clean
    & "$npmGlobalPath\hexo.cmd" generate
    Write-Host "Files generated successfully!" -ForegroundColor Green
    Write-Host ""
}

# Start server
Write-Host "Starting Hexo server..." -ForegroundColor Yellow
Write-Host "Server will start in a new window" -ForegroundColor Cyan
Write-Host "After server starts, visit: http://localhost:4000" -ForegroundColor Cyan
Write-Host "" 

# Open new window to start server
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -Command 'cd `"$PWD`"; hexo server'"

Write-Host "================================" -ForegroundColor Green
Write-Host "Next Theme Installation Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host "The server is starting in a new window..." -ForegroundColor Cyan
Write-Host "You can now access your blog at http://localhost:4000" -ForegroundColor Cyan
Write-Host "" 
Read-Host "Press Enter to exit..."