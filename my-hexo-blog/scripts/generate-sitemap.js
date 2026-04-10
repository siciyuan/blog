const fs = require('fs');
const path = require('path');

// 网站配置
const siteConfig = {
  url: 'https://world123.top',
  lastmod: new Date().toISOString().split('T')[0],
  changefreq: 'daily',
  priority: '1.0'
};

// 页面列表
const pages = [
  { path: '/', changefreq: 'daily', priority: '1.0' },
  { path: '/about/', changefreq: 'monthly', priority: '0.8' },
  { path: '/links/', changefreq: 'monthly', priority: '0.8' },
  { path: '/archives/', changefreq: 'daily', priority: '0.9' },
  { path: '/tags/', changefreq: 'monthly', priority: '0.8' },
  { path: '/categories/', changefreq: 'monthly', priority: '0.8' }
];

// 生成sitemap.xml
function generateSitemap() {
  let xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
`;

  pages.forEach(page => {
    xml += `  <url>
    <loc>${siteConfig.url}${page.path}</loc>
    <lastmod>${siteConfig.lastmod}</lastmod>
    <changefreq>${page.changefreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>
`;
  });

  xml += `</urlset>`;

  return xml;
}

// 保存文件
function saveFile(filePath, content) {
  fs.writeFileSync(filePath, content, 'utf8');
  console.log(`Generated: ${filePath}`);
}

// 主函数
function main() {
  const publicDir = path.join(__dirname, '..', 'public');
  
  // 确保public目录存在
  if (!fs.existsSync(publicDir)) {
    fs.mkdirSync(publicDir, { recursive: true });
  }
  
  // 生成sitemap.xml
  const sitemapXml = generateSitemap();
  saveFile(path.join(publicDir, 'sitemap.xml'), sitemapXml);
  
  // 生成baidusitemap.xml（与sitemap.xml内容相同）
  saveFile(path.join(publicDir, 'baidusitemap.xml'), sitemapXml);
  
  console.log('Sitemap generation completed!');
}

// 运行主函数
main();
