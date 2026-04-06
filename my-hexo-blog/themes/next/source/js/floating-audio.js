/**
 * Floating draggable audio player
 */

class FloatingAudioPlayer {
  constructor(options = {}) {
    this.options = {
      src: 'https://api-v2.cenguigui.cn/api/netease/?&type=mp3',
      title: '网易云音乐',
      artist: '网络音乐',
      position: {
        x: 20,
        y: 20
      },
      ...options
    };
    this.player = null;
    this.isDragging = false;
    this.offset = {
      x: 0,
      y: 0
    };
    this.init();
  }

  init() {
    this.createPlayer();
    this.bindEvents();
  }

  createPlayer() {
    // Create player container
    const container = document.createElement('div');
    container.id = 'floating-audio-player';
    container.className = 'floating-audio-player';
    container.style.cssText = `
      position: fixed;
      bottom: ${this.options.position.y}px;
      right: ${this.options.position.x}px;
      width: 300px;
      background: rgba(255, 255, 255, 0.95);
      border: 1px solid #ddd;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      padding: 10px;
      z-index: 9999;
      transition: all 0.3s ease;
      backdrop-filter: blur(5px);
    `;

    // Create player header
    const header = document.createElement('div');
    header.className = 'player-header';
    header.style.cssText = `
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
      cursor: move;
    `;

    const title = document.createElement('h4');
    title.style.cssText = `
      margin: 0;
      font-size: 14px;
      color: #333;
    `;
    title.textContent = `${this.options.title} - ${this.options.artist}`;

    const closeBtn = document.createElement('button');
    closeBtn.className = 'close-btn';
    closeBtn.style.cssText = `
      background: none;
      border: none;
      font-size: 16px;
      cursor: pointer;
      color: #999;
    `;
    closeBtn.innerHTML = '&times;';
    closeBtn.addEventListener('click', () => {
      container.style.display = 'none';
    });

    header.appendChild(title);
    header.appendChild(closeBtn);

    // Create audio element
    const audio = document.createElement('audio');
    audio.controls = true;
    audio.preload = 'metadata';
    audio.style.cssText = `
      width: 100%;
      height: 35px;
    `;

    const source = document.createElement('source');
    source.src = this.options.src;
    source.type = 'audio/mpeg';

    audio.appendChild(source);

    // Assemble player
    container.appendChild(header);
    container.appendChild(audio);

    // Add to document
    document.body.appendChild(container);

    this.player = container;
    this.audio = audio;
    this.header = header;
  }

  bindEvents() {
    if (!this.player || !this.header) return;

    // Drag events
    this.header.addEventListener('mousedown', (e) => {
      this.isDragging = true;
      this.offset.x = e.clientX - this.player.getBoundingClientRect().left;
      this.offset.y = e.clientY - this.player.getBoundingClientRect().top;
      this.player.style.cursor = 'grabbing';
    });

    document.addEventListener('mousemove', (e) => {
      if (!this.isDragging) return;

      const x = e.clientX - this.offset.x;
      const y = e.clientY - this.offset.y;

      // Constrain to viewport
      const maxX = window.innerWidth - this.player.offsetWidth;
      const maxY = window.innerHeight - this.player.offsetHeight;

      const constrainedX = Math.max(0, Math.min(x, maxX));
      const constrainedY = Math.max(0, Math.min(y, maxY));

      this.player.style.left = `${constrainedX}px`;
      this.player.style.top = `${constrainedY}px`;
      this.player.style.bottom = 'auto';
      this.player.style.right = 'auto';
    });

    document.addEventListener('mouseup', () => {
      if (this.isDragging) {
        this.isDragging = false;
        this.player.style.cursor = 'grab';
      }
    });

    // Touch events for mobile
    this.header.addEventListener('touchstart', (e) => {
      this.isDragging = true;
      const touch = e.touches[0];
      this.offset.x = touch.clientX - this.player.getBoundingClientRect().left;
      this.offset.y = touch.clientY - this.player.getBoundingClientRect().top;
      this.player.style.cursor = 'grabbing';
    });

    document.addEventListener('touchmove', (e) => {
      if (!this.isDragging) return;

      const touch = e.touches[0];
      const x = touch.clientX - this.offset.x;
      const y = touch.clientY - this.offset.y;

      // Constrain to viewport
      const maxX = window.innerWidth - this.player.offsetWidth;
      const maxY = window.innerHeight - this.player.offsetHeight;

      const constrainedX = Math.max(0, Math.min(x, maxX));
      const constrainedY = Math.max(0, Math.min(y, maxY));

      this.player.style.left = `${constrainedX}px`;
      this.player.style.top = `${constrainedY}px`;
      this.player.style.bottom = 'auto';
      this.player.style.right = 'auto';
    });

    document.addEventListener('touchend', () => {
      if (this.isDragging) {
        this.isDragging = false;
        this.player.style.cursor = 'grab';
      }
    });
  }

  play() {
    if (this.audio) {
      this.audio.play();
    }
  }

  pause() {
    if (this.audio) {
      this.audio.pause();
    }
  }

  setSrc(src) {
    if (this.audio) {
      const source = this.audio.querySelector('source');
      if (source) {
        source.src = src;
        this.audio.load();
      }
    }
  }
}

// Initialize floating audio player when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  new FloatingAudioPlayer();
});
