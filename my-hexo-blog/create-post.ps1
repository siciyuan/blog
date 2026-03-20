# 创建Hexo帖子的PowerShell脚本

# 获取用户输入的帖子标题
$title = Read-Host "请输入帖子标题"

# 生成当前日期（格式：YYYY-MM-DD）
$date = Get-Date -Format "yyyy-MM-dd"

# 生成文件名（格式：日期-标题.md，标题转为小写，空格替换为连字符）
$fileName = $title.ToLower() -replace "\s+" , "-" -replace "[^a-zA-Z0-9-]" , ""
$fileName = "$date-$fileName.md"

# 帖子文件路径
$postPath = Join-Path -Path "./source/_posts" -ChildPath $fileName

# 生成front-matter内容
$frontMatter = @"
---
title: $title
date: $date
categories:
  - 技术
  - 教程
tags:
  - 未分类
---

# $title

"@

# 确保source/_posts目录存在
if (-not (Test-Path "./source/_posts")) {
    New-Item -ItemType Directory -Path "./source/_posts" -Force
}

# 写入文件
$frontMatter | Out-File -FilePath $postPath -Encoding UTF8

