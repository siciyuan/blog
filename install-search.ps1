# Set paths
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:GIT_PATH = "D:\Program Files\Git\bin"
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$env:NODE_PATH;$env:GIT_PATH;$npmGlobalPath;$env:PATH"

# Enter blog directory
Set-Location "my-hexo-blog"

# Install hexo-generator-searchdb
echo "Installing hexo-generator-searchdb..."
npm install hexo-generator-searchdb --save

echo "Installation complete!"
Read-Host "Press Enter to exit..."
