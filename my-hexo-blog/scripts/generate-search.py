import os
import json
import re
from datetime import datetime

# 定义文件路径
posts_dir = os.path.join(os.path.dirname(__file__), '..', 'source', '_posts')
output_path = os.path.join(os.path.dirname(__file__), '..', 'source', 'search.json')
public_output_path = os.path.join(os.path.dirname(__file__), '..', 'public', 'search.json')

# 解析Front Matter
def parse_front_matter(content):
    front_matter_match = re.match(r'^---[\s\S]*?---', content)
    if not front_matter_match:
        return {"data": {}, "content": content}
    
    front_matter = front_matter_match.group(0)
    content_without_front_matter = content.replace(front_matter, '').strip()
    
    data = {}
    lines = front_matter.split('\n')[1:-1]  # 移除首尾的---
    
    for line in lines:
        match = re.match(r'^(\w+):\s*(.+)$', line)
        if match:
            key, value = match.groups()
            # 处理数组格式
            if value.startswith('[') and value.endswith(']'):
                data[key] = [item.strip() for item in value[1:-1].split(',')]
            else:
                data[key] = value.strip()
    
    return {"data": data, "content": content_without_front_matter}

# 读取所有Markdown文件
def read_markdown_files(dir):
    posts = []
    for file in os.listdir(dir):
        if file.endswith('.md'):
            file_path = os.path.join(dir, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            result = parse_front_matter(content)
            data = result["data"]
            raw_content = result["content"]
            
            # 生成URL
            date = None
            if "date" in data:
                try:
                    # 尝试解析日期字符串
                    date_str = data["date"]
                    # 处理不同格式的日期
                    if " " in date_str:
                        date = datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
                    else:
                        date = datetime.strptime(date_str, "%Y-%m-%d")
                except:
                    date = None
            
            if not date:
                # 尝试从文件名中提取日期 (格式: YYYY-MM-DD-标题.md)
                file_name = os.path.splitext(file)[0]
                date_match = re.match(r'^(\d{4})-(\d{2})-(\d{2})-', file_name)
                if date_match:
                    year, month, day = date_match.groups()
                    date = datetime(int(year), int(month), int(day))
                else:
                    date = datetime.now()
            
            year = date.year
            month = f"{date.month:02d}"
            day = f"{date.day:02d}"
            file_name = os.path.splitext(file)[0]
            url = f"/{year}/{month}/{day}/{file_name}/"
            
            # 提取内容（去除Markdown标记）
            content_without_markdown = raw_content
            # 移除链接
            content_without_markdown = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', content_without_markdown)
            # 移除图片
            content_without_markdown = re.sub(r'!\[([^\]]+)\]\([^)]+\)', '', content_without_markdown)
            # 移除代码块
            content_without_markdown = re.sub(r'```[\s\S]*?```', '', content_without_markdown)
            # 移除行内代码
            content_without_markdown = re.sub(r'`[^`]+`', '', content_without_markdown)
            # 移除标题
            content_without_markdown = re.sub(r'#{1,6}\s', '', content_without_markdown)
            # 移除粗体
            content_without_markdown = re.sub(r'\*\*([^*]+)\*\*', r'\1', content_without_markdown)
            # 移除斜体
            content_without_markdown = re.sub(r'\*([^*]+)\*', r'\1', content_without_markdown)
            # 替换换行为空格
            content_without_markdown = content_without_markdown.replace('\n', ' ').strip()
            
            post = {
                "title": data.get("title", file_name),
                "url": url,
                "date": data.get("date", date.isoformat()),
                "categories": data.get("categories", []),
                "tags": data.get("tags", []),
                "content": content_without_markdown
            }
            posts.append(post)
    return posts

# 生成search.json文件
def generate_search_json():
    try:
        posts = read_markdown_files(posts_dir)
        
        search_data = {
            "path": "search.json",
            "field": "post",
            "format": "html",
            "limit": 10000,
            "content": True,
            "data": posts
        }
        
        # 确保输出目录存在
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        os.makedirs(os.path.dirname(public_output_path), exist_ok=True)
        
        # 写入source目录
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(search_data, f, ensure_ascii=False, indent=2)
        print(f"search.json generated successfully at {output_path}")
        
        # 同时复制到public目录
        with open(public_output_path, 'w', encoding='utf-8') as f:
            json.dump(search_data, f, ensure_ascii=False, indent=2)
        print(f"search.json copied to {public_output_path}")
    except Exception as e:
        print(f"Error generating search.json: {e}")

# 运行脚本
if __name__ == "__main__":
    generate_search_json()
