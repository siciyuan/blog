Write-Host "================================" -ForegroundColor Green
Write-Host "Hexo Blog Setup Script" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

Write-Host "Starting..."

# Set Node.js path
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:PATH = "$env:NODE_PATH;$env:PATH"

# Add npm global path to PATH
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$npmGlobalPath;$env:PATH"

Write-Host "`nChecking Node.js installation..."
Write-Host "Node.js path: $env:NODE_PATH"

if (Test-Path "$env:NODE_PATH\node.exe") {
    Write-Host "Node.js found"
    node --version
    Write-Host "`nnpm version:"
    npm --version
    Write-Host ""
} else {
    Write-Host "Node.js not found, please check the path" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "Installing Hexo CLI..."
npm install -g hexo-cli
Write-Host ""

Write-Host "Checking if hexo command is available..."
try {
    $hexoVersion = hexo --version
    Write-Host "Hexo found: $hexoVersion"
    Write-Host ""
} catch {
    Write-Host "Hexo command not found, trying with full path..." -ForegroundColor Yellow
    $hexoPath = "$npmGlobalPath\hexo.cmd"
    if (Test-Path $hexoPath) {
        Write-Host "Hexo found at: $hexoPath"
        Write-Host ""
    } else {
        Write-Host "Hexo not found, please check npm installation" -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        exit 1
    }
}

Write-Host "Creating Hexo blog directory..."
New-Item -ItemType Directory -Name "my-hexo-blog" -Force | Out-Null
Write-Host ""

Write-Host "Entering blog directory..."
Set-Location "my-hexo-blog"
Write-Host ""

Write-Host "Initializing Hexo blog..."
try {
    hexo init
} catch {
    Write-Host "Using full path to hexo..."
    & "$npmGlobalPath\hexo.cmd" init
}
Write-Host ""

Write-Host "Installing dependencies..."
npm install
Write-Host ""

Write-Host "Generating static files..."
try {
    hexo generate
} catch {
    Write-Host "Using full path to hexo..."
    & "$npmGlobalPath\hexo.cmd" generate
}
Write-Host ""

Write-Host "================================" -ForegroundColor Green
Write-Host "Hexo blog setup completed!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host "Blog directory: $(Get-Location)"
Write-Host "Run the following commands to start local server:"
Write-Host "cd my-hexo-blog"
Write-Host "hexo server"
Write-Host ""
Read-Host "Press Enter to exit..."