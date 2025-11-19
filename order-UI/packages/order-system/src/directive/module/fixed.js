/**
 * v-fixed 固定布局指令
 * 用于固定某个元素，使其在滚动时保持固定位置
 * 
 * 使用方式：
 * v-fixed="'top'" - 固定在顶部（使用 fixed 定位）
 * v-fixed="'bottom'" - 固定在底部（使用 fixed 定位）
 * v-fixed="{ position: 'top', zIndex: 1000, offset: 0 }" - 自定义位置、层级和偏移（使用 fixed 定位）
 * v-fixed="{ mode: 'sticky', position: 'top', offset: 0 }" - 使用 sticky 定位模式（适合表头）
 * 
 * 参数说明：
 * - mode: 'fixed' | 'sticky' - 定位模式，默认为 'fixed'
 * - position: 'top' | 'bottom' - 固定位置，默认为 'top'
 * - zIndex: number - 层级，默认 1000（sticky 模式默认 99）
 * - offset: number - 偏移量（px），默认 0
 * - backgroundColor: string - 背景色，默认 '#fff'（sticky 模式默认不设置）
 * - boxShadow: string - 阴影，默认 '0 2px 8px rgba(0, 0, 0, 0.1)'（sticky 模式默认 '0 2px 4px rgba(0, 0, 0, 0.05)'）
 */

export default {
  inserted(el, binding) {
    const value = binding.value || {};
    const mode = typeof value === 'object' && value.mode ? value.mode : 'fixed';
    const position = typeof value === 'string' ? value : (value.position || 'top');
    const zIndex = typeof value === 'object' && value.zIndex !== undefined ? value.zIndex : (mode === 'sticky' ? 99 : 1000);
    const offset = typeof value === 'object' && value.offset !== undefined ? value.offset : 0;
    
    // 保存原始样式
    const originalStyles = {
      position: el.style.position || '',
      zIndex: el.style.zIndex || '',
      top: el.style.top || '',
      bottom: el.style.bottom || '',
      left: el.style.left || '',
      width: el.style.width || '',
      backgroundColor: el.style.backgroundColor || '',
      boxShadow: el.style.boxShadow || ''
    };
    
    // 保存到元素上，用于 unbind 时恢复
    el._fixedOriginalStyles = originalStyles;
    el._fixedMode = mode;
    
    if (mode === 'sticky') {
      // Sticky 模式：使用 CSS sticky 定位，更适合表头等场景
      el.style.position = 'sticky';
      el.style.zIndex = zIndex;
      
      // 根据位置设置 top 或 bottom
      if (position === 'bottom') {
        el.style.bottom = offset ? `${offset}px` : '0px';
        el.style.top = 'auto';
      } else {
        el.style.top = offset ? `${offset}px` : '0px';
        el.style.bottom = 'auto';
      }
      
      // 设置背景色和阴影（sticky 模式需要背景色避免内容透过）
      const computedStyle = window.getComputedStyle(el);
      if (!computedStyle.backgroundColor || computedStyle.backgroundColor === 'rgba(0, 0, 0, 0)' || computedStyle.backgroundColor === 'transparent') {
        const bgColor = typeof value === 'object' && value.backgroundColor ? value.backgroundColor : '#fff';
        el.style.backgroundColor = bgColor;
      }
      if (!el.style.boxShadow) {
        const shadow = typeof value === 'object' && value.boxShadow ? value.boxShadow : '0 2px 4px rgba(0, 0, 0, 0.05)';
        el.style.boxShadow = shadow;
      }
    } else {
      // Fixed 模式：使用 fixed 定位，适合搜索框、分页等
      const rect = el.getBoundingClientRect();
      const initialTop = rect.top;
      const initialLeft = rect.left;
      const initialWidth = rect.width;
      const initialHeight = rect.height;
      
      // 创建占位元素，避免内容被遮挡
      const placeholder = document.createElement('div');
      placeholder.style.height = `${initialHeight}px`;
      placeholder.style.width = '100%';
      placeholder.style.visibility = 'hidden';
      placeholder.className = 'fixed-placeholder';
      el.parentNode.insertBefore(placeholder, el);
      el._fixedPlaceholder = placeholder;
      
      el.style.position = 'fixed';
      el.style.zIndex = zIndex;
      el.style.width = `${initialWidth}px`;
      el.style.left = `${initialLeft}px`;
      
      // 设置背景色和阴影，避免内容透过
      const computedStyle = window.getComputedStyle(el);
      if (!computedStyle.backgroundColor || computedStyle.backgroundColor === 'rgba(0, 0, 0, 0)' || computedStyle.backgroundColor === 'transparent') {
        const bgColor = typeof value === 'object' && value.backgroundColor ? value.backgroundColor : '#fff';
        el.style.backgroundColor = bgColor;
      }
      if (!el.style.boxShadow) {
        const shadow = typeof value === 'object' && value.boxShadow ? value.boxShadow : '0 2px 8px rgba(0, 0, 0, 0.1)';
        el.style.boxShadow = shadow;
      }
      
      // 根据位置设置 top 或 bottom
      if (position === 'bottom') {
        el.style.bottom = offset ? `${offset}px` : '0px';
        el.style.top = 'auto';
      } else {
        el.style.top = offset ? `${initialTop + offset}px` : `${initialTop}px`;
        el.style.bottom = 'auto';
      }
      
      // 监听滚动和窗口大小变化，更新位置
      const updatePosition = () => {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        const scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;
        
        // 更新 left 位置（考虑横向滚动）
        el.style.left = `${initialLeft - scrollLeft}px`;
        
        // 对于顶部固定，保持初始 top 位置
        if (position === 'top') {
          el.style.top = offset ? `${initialTop + offset - scrollTop}px` : `${initialTop - scrollTop}px`;
        }
      };
      
      // 监听窗口大小变化，更新宽度和占位元素高度
      const updateWidth = () => {
        const rect = el.getBoundingClientRect();
        el.style.width = `${rect.width}px`;
        // 更新占位元素高度
        if (el._fixedPlaceholder) {
          el._fixedPlaceholder.style.height = `${rect.height}px`;
        }
      };
      
      // 初始更新位置
      updatePosition();
      
      // 绑定事件
      window.addEventListener('scroll', updatePosition, { passive: true });
      window.addEventListener('resize', () => {
        updatePosition();
        updateWidth();
      }, { passive: true });
      
      // 保存更新函数，用于 unbind
      el._fixedUpdatePosition = updatePosition;
      el._fixedUpdateWidth = updateWidth;
    }
  },
  
  update(el, binding) {
    // 如果值改变，重新应用
    if (binding.value !== binding.oldValue) {
      this.unbind(el);
      this.inserted(el, binding);
    }
  },
  
  unbind(el) {
    // 恢复原始样式
    if (el._fixedOriginalStyles) {
      Object.keys(el._fixedOriginalStyles).forEach(key => {
        if (el._fixedOriginalStyles[key]) {
          el.style[key] = el._fixedOriginalStyles[key];
        } else {
          el.style[key] = '';
        }
      });
    }
    
    // 移除事件监听（仅 fixed 模式需要）
    if (el._fixedMode === 'fixed') {
      if (el._fixedUpdatePosition) {
        window.removeEventListener('scroll', el._fixedUpdatePosition);
      }
      if (el._fixedUpdateWidth) {
        window.removeEventListener('resize', el._fixedUpdateWidth);
      }
      // 移除占位元素
      if (el._fixedPlaceholder && el._fixedPlaceholder.parentNode) {
        el._fixedPlaceholder.parentNode.removeChild(el._fixedPlaceholder);
      }
    }
    
    // 清理引用
    delete el._fixedOriginalStyles;
    delete el._fixedMode;
    delete el._fixedUpdatePosition;
    delete el._fixedUpdateWidth;
    delete el._fixedPlaceholder;
  }
};

