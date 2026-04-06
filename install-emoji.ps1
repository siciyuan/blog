# Set paths
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:GIT_PATH = "D:\Program Files\Git\bin"
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$env:NODE_PATH;$env:GIT_PATH;$npmGlobalPath;$env:PATH"

# Enter blog directory
Set-Location "my-hexo-blog"

# Install hexo-filter-emoji
echo "Installing hexo-filter-emoji..."
npm install hexo-filter-emoji --save

echo "Installation complete!"
Read-Host "Press Enter to exit..."
