# Set paths
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:GIT_PATH = "D:\Program Files\Git\bin"
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$npmPath = "$env:NODE_PATH\npm.exe"
$env:PATH = "$env:NODE_PATH;$env:GIT_PATH;$npmGlobalPath;$env:PATH"

# Enter blog directory
Set-Location "my-hexo-blog"

# Install hexo-deployer-git plugin
echo "Installing hexo-deployer-git plugin..."
try {
    & "$npmPath" install hexo-deployer-git --save
    echo "Plugin installed successfully!"
} catch {
    echo "Failed to install plugin, continuing..."
}

# Clean and generate files
echo "Cleaning files..."
try {
    hexo clean
    echo "Generating files..."
    hexo generate
    echo "Files generated successfully!"
} catch {
    echo "Using full path to hexo..."
    & "$npmGlobalPath\hexo.cmd" clean
    & "$npmGlobalPath\hexo.cmd" generate
    echo "Files generated successfully!"
}

# Deploy to GitHub
echo "Deploying to GitHub..."
try {
    hexo deploy
    echo "Blog deployed successfully!"
    echo "You can access your blog at: https://siciyuan.github.io/blog"
} catch {
    echo "Using full path to hexo..."
    & "$npmGlobalPath\hexo.cmd" deploy
    echo "Blog deployed successfully!"
    echo "You can access your blog at: https://siciyuan.github.io/blog"
}

Read-Host "Press Enter to exit..."
