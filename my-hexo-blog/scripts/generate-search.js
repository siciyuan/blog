const fs = require('fs');
const path = require('path');

// 定义文件路径
const postsDir = path.join(__dirname, '..', 'source', '_posts');
const outputPath = path.join(__dirname, '..', 'source', 'search.json');

// 解析Front Matter（简单实现）
function parseFrontMatter(content) {
  const frontMatterMatch = content.match(/^---[\s\S]*?---/);
  if (!frontMatterMatch) {
    return { data: {}, content: content };
  }
  
  const frontMatter = frontMatterMatch[0];
  const contentWithoutFrontMatter = content.replace(frontMatter, '').trim();
  
  const data = {};
  const lines = frontMatter.split('\n').slice(1, -1); // 移除首尾的---
  
  lines.forEach(line => {
    const match = line.match(/^(\w+):\s*(.+)$/);
    if (match) {
      const [, key, value] = match;
      // 处理数组格式
      if (value.startsWith('[') && value.endsWith(']')) {
        data[key] = value.slice(1, -1).split(',').map(item => item.trim());
      } else {
        data[key] = value.trim(); // 添加trim()处理
      }
    }
  });
  
  return { data, content: contentWithoutFrontMatter };
}

// 读取所有Markdown文件
function readMarkdownFiles(dir) {
  const files = fs.readdirSync(dir);
  return files.filter(file => file.endsWith('.md')).map(file => {
    const filePath = path.join(dir, file);
    const content = fs.readFileSync(filePath, 'utf8');
    const { data, content: rawContent } = parseFrontMatter(content);
    
    // 生成URL
    let date;
    if (data.date) {
      // 尝试解析Front Matter中的日期
      try {
        date = new Date(data.date);
        // 验证日期是否有效
        if (isNaN(date.getTime())) {
          throw new Error('Invalid date');
        }
      } catch (e) {
        date = null;
      }
    }
    
    if (!date) {
      // 尝试从文件名中提取日期 (格式: YYYY-MM-DD-标题.md)
      const fileName = path.basename(file, '.md');
      const dateMatch = fileName.match(/^(\d{4})-(\d{2})-(\d{2})-/);
      if (dateMatch) {
        date = new Date(`${dateMatch[1]}-${dateMatch[2]}-${dateMatch[3]}`);
      } else {
        date = new Date();
      }
    }
    
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const fileName = path.basename(file, '.md');
    const url = `/${year}/${month}/${day}/${fileName}/`;
    
    // 提取内容（去除Markdown标记）
    const contentWithoutMarkdown = rawContent
      .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1') // 移除链接
      .replace(/!\[([^\]]+)\]\([^)]+\)/g, '') // 移除图片
      .replace(/```[\s\S]*?```/g, '') // 移除代码块
      .replace(/`[^`]+`/g, '') // 移除行内代码
      .replace(/#{1,6}\s/g, '') // 移除标题
      .replace(/\*\*([^*]+)\*\*/g, '$1') // 移除粗体
      .replace(/\*([^*]+)\*/g, '$1') // 移除斜体
      .replace(/\n/g, ' ') // 替换换行为空格
      .trim();
    
    return {
      title: data.title || fileName,
      url,
      date: data.date || date.toISOString(),
      categories: data.categories || [],
      tags: data.tags || [],
      content: contentWithoutMarkdown
    };
  });
}

// 生成search.json文件
function generateSearchJson() {
  try {
    const posts = readMarkdownFiles(postsDir);
    
    const searchData = {
      path: 'search.json',
      field: 'post',
      format: 'html',
      limit: 10000,
      content: true,
      data: posts
    };
    
    fs.writeFileSync(outputPath, JSON.stringify(searchData, null, 2), 'utf8');
    console.log(`search.json generated successfully at ${outputPath}`);
    
    // 同时复制到public目录
    const publicOutputPath = path.join(__dirname, '..', 'public', 'search.json');
    fs.writeFileSync(publicOutputPath, JSON.stringify(searchData, null, 2), 'utf8');
    console.log(`search.json copied to ${publicOutputPath}`);
  } catch (error) {
    console.error('Error generating search.json:', error);
  }
}

// 运行脚本
generateSearchJson();
