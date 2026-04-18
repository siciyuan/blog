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
      width: 320px;
      background: linear-gradient(135deg, #4CAF50 0%, #81C784 100%);
      border-radius: 12px;
      box-shadow: 0 8px 32px rgba(76, 175, 80, 0.3);
      padding: 16px;
      z-index: 9999;
      transition: all 0.3s ease;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.1);
    `;

    // Create player header
    const header = document.createElement('div');
    header.className = 'player-header';
    header.style.cssText = `
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
      cursor: grab;
    `;

    const title = document.createElement('h4');
    title.style.cssText = `
      margin: 0;
      font-size: 16px;
      color: white;
      font-weight: 600;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
    `;
    title.textContent = `${this.options.title} - ${this.options.artist}`;

    const closeBtn = document.createElement('button');
    closeBtn.className = 'close-btn';
    closeBtn.style.cssText = `
      background: rgba(255, 255, 255, 0.2);
      border: none;
      border-radius: 50%;
      width: 24px;
      height: 24px;
      font-size: 14px;
      cursor: pointer;
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;
    `;
    closeBtn.innerHTML = '&times;';
    closeBtn.addEventListener('mouseenter', () => {
      closeBtn.style.background = 'rgba(255, 255, 255, 0.3)';
    });
    closeBtn.addEventListener('mouseleave', () => {
      closeBtn.style.background = 'rgba(255, 255, 255, 0.2)';
    });
    closeBtn.addEventListener('click', () => {
      container.style.opacity = '0';
      setTimeout(() => {
        container.style.display = 'none';
      }, 300);
    });

    header.appendChild(title);
    header.appendChild(closeBtn);

    // Create audio element
    const audio = document.createElement('audio');
    audio.controls = true;
    audio.preload = 'metadata';
    audio.style.cssText = `
      width: 100%;
      height: 40px;
      filter: invert(1) hue-rotate(180deg) saturate(1.2);
    `;

    const source = document.createElement('source');
    source.src = this.options.src;
    source.type = 'audio/mpeg';

    audio.appendChild(source);

    // Add visualizer placeholder
    const visualizer = document.createElement('div');
    visualizer.className = 'audio-visualizer';
    visualizer.style.cssText = `
      display: flex;
      align-items: center;
      justify-content: center;
      height: 40px;
      margin-top: 10px;
      gap: 4px;
    `;

    // Create visualizer bars
    for (let i = 0; i < 10; i++) {
      const bar = document.createElement('div');
      bar.style.cssText = `
        width: 4px;
        background: linear-gradient(to top, rgba(255, 255, 255, 0.6), rgba(255, 255, 255, 1));
        border-radius: 2px;
        height: ${Math.random() * 20 + 10}px;
        animation: pulse ${Math.random() * 0.5 + 0.5}s infinite ease-in-out alternate;
        animation-delay: ${i * 0.05}s;
      `;
      visualizer.appendChild(bar);
    }

    // Add animation styles
    const style = document.createElement('style');
    style.textContent = `
      @keyframes pulse {
        from { 
          height: 10px;
          opacity: 0.6;
        }
        to { 
          height: 30px;
          opacity: 1;
        }
      }
      .floating-audio-player:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 40px rgba(76, 175, 80, 0.4);
      }
      .player-header:active {
        cursor: grabbing;
      }
    `;
    document.head.appendChild(style);

    // Assemble player
    container.appendChild(header);
    container.appendChild(audio);
    container.appendChild(visualizer);

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
