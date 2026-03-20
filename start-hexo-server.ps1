# Set paths
$env:NODE_PATH = "D:\Program Files\nodejs"
$env:GIT_PATH = "D:\Program Files\Git\bin"
$npmGlobalPath = "$env:USERPROFILE\AppData\Roaming\npm"
$env:PATH = "$env:NODE_PATH;$env:GIT_PATH;$npmGlobalPath;$env:PATH"

# Enter blog directory
Set-Location "my-hexo-blog"

# Start Hexo server
echo "Starting Hexo server..."
try {
    hexo server -p 4001
} catch {
    echo "Using full path to hexo..."
    & "$npmGlobalPath\hexo.cmd" server -p 4001
}
