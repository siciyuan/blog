# 定义文件路径
$postsDir = Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "source\_posts"
$outputPath = Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "source\search.json"
$publicOutputPath = Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "public\search.json"

# 解析Front Matter
function Parse-FrontMatter {
    param([string]$content)
    
    $frontMatterMatch = $content -match '^---[\s\S]*?---'
    if (-not $frontMatterMatch) {
        return @{ data = @{}; content = $content }
    }
    
    $frontMatter = $Matches[0]
    $contentWithoutFrontMatter = $content -replace [regex]::Escape($frontMatter), '' | Trim-Whitespace
    
    $data = @{}
    $lines = $frontMatter -split '\n' | Select-Object -Skip 1 | Select-Object -SkipLast 1
    
    foreach ($line in $lines) {
        $match = $line -match '^(\w+):\s*(.+)$'
        if ($match) {
            $key = $Matches[1]
            $value = $Matches[2]
            # 处理数组格式
            if ($value -match '^\[.*\]$') {
                $data[$key] = $value.Substring(1, $value.Length - 2).Split(',') | ForEach-Object { $_.Trim() }
            } else {
                $data[$key] = $value.Trim()
            }
        }
    }
    
    return @{ data = $data; content = $contentWithoutFrontMatter }
}

# 移除空白字符
function Trim-Whitespace {
    param([string]$text)
    return $text.Trim()
}

# 读取所有Markdown文件
function Read-MarkdownFiles {
    param([string]$dir)
    
    $posts = @()
    $files = Get-ChildItem -Path $dir -Filter "*.md"
    
    foreach ($file in $files) {
        $filePath = $file.FullName
        $content = Get-Content -Path $filePath -Encoding UTF8 -Raw
        $result = Parse-FrontMatter -content $content
        $data = $result.data
        $rawContent = $result.content
        
        # 生成URL
        $date = $null
        if ($data.ContainsKey('date')) {
            try {
                $dateStr = $data['date']
                if ($dateStr -match ' ' -and $dateStr -match ':\d{2}:\d{2}') {
                    $date = [datetime]::ParseExact($dateStr, "yyyy-MM-dd HH:mm:ss", $null)
                } else {
                    $date = [datetime]::ParseExact($dateStr, "yyyy-MM-dd", $null)
                }
            } catch {
                $date = $null
            }
        }
        
        if (-not $date) {
            # 尝试从文件名中提取日期 (格式: YYYY-MM-DD-标题.md)
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
            $dateMatch = $fileName -match '^(\d{4})-(\d{2})-(\d{2})-'
            if ($dateMatch) {
                $year = $Matches[1]
                $month = $Matches[2]
                $day = $Matches[3]
                $date = [datetime]::ParseExact("$year-$month-$day", "yyyy-MM-dd", $null)
            } else {
                $date = Get-Date
            }
        }
        
        $year = $date.Year
        $month = $date.Month.ToString('00')
        $day = $date.Day.ToString('00')
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $url = "/$year/$month/$day/$fileName/"
        
        # 提取内容（去除Markdown标记）
        $contentWithoutMarkdown = $rawContent
        # 移除链接
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '\[([^\]]+)\]\([^)]+\)', '$1'
        # 移除图片
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '!\[([^\]]+)\]\([^)]+\)', ''
        # 移除代码块
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '```[\s\S]*?```', ''
        # 移除行内代码
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '`[^`]+`', ''
        # 移除标题
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '#{1,6}\s', ''
        # 移除粗体
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '\*\*([^*]+)\*\*', '$1'
        # 移除斜体
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '\*([^*]+)\*', '$1'
        # 替换换行为空格
        $contentWithoutMarkdown = $contentWithoutMarkdown -replace '\n', ' ' | Trim-Whitespace
        
        $post = @{
            title = if ($data.ContainsKey('title')) { $data['title'] } else { $fileName }
            url = $url
            date = if ($data.ContainsKey('date')) { $data['date'] } else { $date.ToString('o') }
            categories = if ($data.ContainsKey('categories')) { $data['categories'] } else { @() }
            tags = if ($data.ContainsKey('tags')) { $data['tags'] } else { @() }
            content = $contentWithoutMarkdown
        }
        $posts += $post
    }
    return $posts
}

# 生成search.json文件
function Generate-SearchJson {
    try {
        $posts = Read-MarkdownFiles -dir $postsDir
        
        $searchData = @{
            path = "search.json"
            field = "post"
            format = "html"
            limit = 10000
            content = $true
            data = $posts
        }
        
        # 确保输出目录存在
        $outputDir = Split-Path -Parent $outputPath
        if (-not (Test-Path -Path $outputDir)) {
            New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
        }
        
        $publicOutputDir = Split-Path -Parent $publicOutputPath
        if (-not (Test-Path -Path $publicOutputDir)) {
            New-Item -Path $publicOutputDir -ItemType Directory -Force | Out-Null
        }
        
        # 写入source目录
        $searchData | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
        Write-Host "search.json generated successfully at $outputPath"
        
        # 同时复制到public目录
        $searchData | ConvertTo-Json -Depth 10 | Out-File -FilePath $publicOutputPath -Encoding UTF8
        Write-Host "search.json copied to $publicOutputPath"
    } catch {
        Write-Host "Error generating search.json: $($_.Exception.Message)"
    }
}

# 运行脚本
Generate-SearchJson
