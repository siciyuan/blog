Write-Host "================================" -ForegroundColor Green
Write-Host "Hexo Theme Installation Script" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Set Node.js path
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:PATH = "$env:NODE_PATH;$env:PATH"

# Add Git path
$env:GIT_PATH = "D:\Program Files\Git\bin"
$env:PATH = "$env:GIT_PATH;$env:PATH"

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

Write-Host "Checking Git installation..."
if (Test-Path "$env:GIT_PATH\git.exe") {
    Write-Host "Git found"
    git --version
    Write-Host ""
} else {
    Write-Host "Git not found, please check the path" -ForegroundColor Red
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

Write-Host "Installing Butterfly theme..." -ForegroundColor Green
Write-Host "Butterfly is a beautiful and feature-rich Hexo theme" -ForegroundColor Cyan
Write-Host ""

# Install Butterfly theme
try {
    Write-Host "Cloning Butterfly theme from GitHub..."
    git clone https://github.com/jerryc127/hexo-theme-butterfly themes/butterfly
    Write-Host ""
    
    Write-Host "Installing required dependencies..."
    npm install hexo-renderer-pug hexo-renderer-stylus
    Write-Host ""
    
    Write-Host "Updating Hexo config..."
    # Read current config
    $configContent = Get-Content "_config.yml" -Raw
    
    # Update theme setting
    $updatedConfig = $configContent -replace 'theme:\s*landscape', 'theme: butterfly'
    
    # Write updated config
    Set-Content "_config.yml" $updatedConfig
    Write-Host "Theme setting updated to 'butterfly'"
    Write-Host ""
    
    Write-Host "Creating theme config file..."
    # Create theme config
    $themeConfig = @"
# Butterfly Theme Config
# Documentation: https://butterfly.js.org/

# Site
favicon: /favicon.ico

# Menu
menu:
  Home: /
  Archives: /archives/
  Categories: /categories/
  Tags: /tags/
  About: /about/

# Sidebar
sidebar:
  enable: true
  position: right
  display: post

# Social Links
social:
  GitHub: https://github.com/ || github
  Twitter: https://twitter.com/ || twitter
  Email: mailto:your@email.com || envelope

# Comment
giscus:
  enable: false
  repo: # your github repo
  repo_id: # your repo id
  category: # your category
  category_id: # your category id

# Analytics
google_analytics:
  enable: false
  id: # your google analytics id

# Search
local_search:
  enable: true

# Code Highlight
highlight:
  enable: true
  line_number: true
  auto_detect: true
  tab_replace: ''
"@
    
    Set-Content "_config.butterfly.yml" $themeConfig
    Write-Host "Theme config file created: _config.butterfly.yml"
    Write-Host ""
    
    Write-Host "Generating static files..."
    hexo clean
    hexo generate
    Write-Host ""
    
    Write-Host "================================" -ForegroundColor Green
    Write-Host "Butterfly theme installed successfully!" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Green
    Write-Host "To customize the theme, edit: _config.butterfly.yml"
    Write-Host "Run 'hexo server' to preview the new theme" -ForegroundColor Cyan
    Write-Host ""
    
} catch {
    Write-Host "Error installing theme: $_" -ForegroundColor Red
    Write-Host "Please check if Git is installed and try again" -ForegroundColor Yellow
    Write-Host ""
}

Read-Host "Press Enter to exit..."