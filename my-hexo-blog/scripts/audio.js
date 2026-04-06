hexo.extend.tag.register('audio', function(args, content) {
  const src = args[0];
  const title = args[1] || '音乐';
  const artist = args[2] || '未知艺术家';
  
  return `
    <div class="hexo-audio-player">
      <h4>${title} - ${artist}</h4>
      <audio controls preload="metadata">
        <source src="${src}" type="audio/mpeg">
        您的浏览器不支持音频播放。
       </audio>
    </div>
  `;
});
