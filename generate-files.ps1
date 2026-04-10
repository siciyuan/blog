# Set paths
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:GIT_PATH = "D:\Program Files\Git\bin"
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$env:NODE_PATH;$env:GIT_PATH;$npmGlobalPath;$env:PATH"

# Kill existing node processes to avoid port conflicts
echo "Killing existing node processes..."
try {
    Get-Process | Where-Object {$_.Name -eq 'node'} | Stop-Process -Force
    echo "Node processes killed successfully!"
} catch {
    echo "No node processes found or error killing processes."
}

# Enter blog directory
Set-Location "my-hexo-blog"

# Clean and generate files
echo "Cleaning files..."
try {
    hexo clean
    echo "Generating search.json..."
    node scripts/generate-search.js
    echo "Generating files..."
    hexo generate
    echo "Files generated successfully!"
} catch {
    echo "Using full path to hexo..."
    & "$npmGlobalPath\hexo.cmd" clean
    echo "Generating search.json..."
    & "$env:NODE_PATH\node.exe" scripts/generate-search.js
    & "$npmGlobalPath\hexo.cmd" generate
    echo "Files generated successfully!"
}

Read-Host "Press Enter to exit..."