# Set paths
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:GIT_PATH = "D:\Program Files\Git\bin"
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$env:NODE_PATH;$env:GIT_PATH;$npmGlobalPath;$env:PATH"

# Enter blog directory
Set-Location "my-hexo-blog"

# Check if hexo-generator-searchdb is installed
echo "Checking hexo-generator-searchdb installation..."
& "$npmGlobalPath\npm.cmd" list hexo-generator-searchdb

echo "\nChecking hexo version..."
& "$npmGlobalPath\npm.cmd" list hexo

echo "\nRunning hexo clean..."
& "$npmGlobalPath\hexo.cmd" clean

echo "\nRunning hexo generate..."
& "$npmGlobalPath\hexo.cmd" generate

echo "\nChecking if search.json was generated..."
if (Test-Path "public\search.json") {
    echo "search.json was generated successfully!"
} else {
    echo "search.json was NOT generated!"
}

Read-Host "Press Enter to exit..."
