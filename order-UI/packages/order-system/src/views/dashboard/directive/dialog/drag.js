export default {
	bind(el, binding, vnode) {
		const dialogHeaderEl = el.querySelector('.el-dialog__header');
		const dragDom = el.querySelector('.el-dialog');
		dialogHeaderEl.style.cssText += ';cursor:move;';
		dragDom.style.cssText += ';top:0px;';

		// 获取原有属性 ie dom元素.currentStyle 火狐谷歌 window.getComputedStyle(dom元素, null);
		const getStyle = (function () {
			if (window.document.currentStyle) {
				return (dom, attr) => dom.currentStyle[attr];
			} else {
				return (dom, attr) => getComputedStyle(dom, false)[attr];
			}
		})();

		// 性能优化：节流函数，限制执行频率
		const throttle = (func, limit) => {
			let inThrottle;
			return function () {
				const args = arguments;
				const context = this;
				if (!inThrottle) {
					func.apply(context, args);
					inThrottle = true;
					setTimeout(() => (inThrottle = false), limit);
				}
			};
		};

		dialogHeaderEl.onmousedown = e => {
			// 性能优化：缓存DOM引用和预计算值
			let animationFrameId = null;
			let pendingUpdate = false;
			let currentLeft = 0;
			let currentTop = 0;

			// 添加拖拽状态类，禁用全局文字选择
			document.body.classList.add('dragging');

			// 优化：使用transform替代left/top，避免触发layout
			dragDom.style.boxShadow = '0 12px 48px rgba(0, 0, 0, 0.25), 0 4px 16px rgba(0, 0, 0, 0.15)';
			dragDom.style.transition = 'none';
			dragDom.style.willChange = 'transform'; // 启用硬件加速

			// 预计算所有必要的值，避免在mousemove中重复计算
			const disX = e.clientX - dialogHeaderEl.offsetLeft;
			const disY = e.clientY - dialogHeaderEl.offsetTop;
			const dragDomWidth = dragDom.offsetWidth;
			const dragDomHeight = dragDom.offsetHeight;

			// 缓存屏幕尺寸
			const screenWidth = window.innerWidth;
			const screenHeight = window.innerHeight;

			// 缓存初始位置
			let styL = getStyle(dragDom, 'left');
			let styT = getStyle(dragDom, 'top');

			if (styL.includes('%')) {
				styL = +document.body.clientWidth * (+styL.replace(/%/g, '') / 100);
				styT = +document.body.clientHeight * (+styT.replace(/%/g, '') / 100);
			} else {
				styL = +styL.replace(/\px/g, '');
				styT = +styT.replace(/\px/g, '');
			}

			// 性能优化：使用requestAnimationFrame节流更新
			const updatePosition = () => {
				if (!pendingUpdate) return;

				// 计算最终位置
				const finalLeft = currentLeft + styL;
				const finalTop = currentTop + styT;

				// 边界约束计算
				let constrainedLeft = currentLeft;
				let constrainedTop = currentTop;

				// 左边界：至少保留50px在屏幕内
				if (finalLeft < -dragDomWidth + 50) {
					constrainedLeft = -dragDomWidth + 50 - styL;
				}
				// 右边界：至少保留50px在屏幕内
				else if (finalLeft > screenWidth - 50) {
					constrainedLeft = screenWidth - 50 - styL;
				}

				// 上边界：不能超出屏幕顶部
				if (finalTop < 0) {
					constrainedTop = -styT;
				}
				// 下边界：至少保留标题栏可见
				else if (finalTop > screenHeight - 50) {
					constrainedTop = screenHeight - 50 - styT;
				}

				// 使用transform替代left/top，性能更好
				const transformX = constrainedLeft + styL;
				const transformY = constrainedTop + styT;
				dragDom.style.transform = `translate(${transformX}px, ${transformY}px)`;

				// 重置left/top以避免冲突
				dragDom.style.left = '0px';
				dragDom.style.top = '0px';

				pendingUpdate = false;

				// emit onDrag event（降低频率）
				if (vnode.child && typeof vnode.child.$emit === 'function') {
					vnode.child.$emit('dragDialog');
				}
			};

			// 节流的mousemove处理器
			const throttledMouseMove = throttle(e => {
				// 只计算位置，不立即更新DOM
				currentLeft = e.clientX - disX;
				currentTop = e.clientY - disY;

				// 如果没有待处理的更新，请求动画帧
				if (!pendingUpdate) {
					pendingUpdate = true;
					animationFrameId = requestAnimationFrame(updatePosition);
				}
			}, 16); // 约60fps

			document.onmousemove = throttledMouseMove;

			document.onmouseup = function () {
				// 清理动画帧
				if (animationFrameId) {
					cancelAnimationFrame(animationFrameId);
				}

				// 移除拖拽状态类，恢复全局文字选择
				document.body.classList.remove('dragging');

				// 恢复原始样式
				dragDom.style.boxShadow = '';
				dragDom.style.transition = '';
				dragDom.style.willChange = 'auto';

				// 获取当前实际位置（从transform中计算）
				const currentTransform = dragDom.style.transform;
				if (currentTransform && currentTransform !== 'none') {
					const translateRegex = /translate\(([^,]+),\s*([^)]+)\)/;
					const match = currentTransform.match(translateRegex);
					if (match) {
						const translateX = parseFloat(match[1]);
						const translateY = parseFloat(match[2]);

						// 检查是否需要重新定位
						const needsReposition = translateY < 0 || translateY > screenHeight - 50 || translateX + 50 < 0 || translateX > screenWidth - 50;

						if (needsReposition) {
							// 重新定位到屏幕中间
							const centerX = (screenWidth - dragDomWidth) / 2;
							const centerY = (screenHeight - dragDomHeight) / 2;

							// 添加平滑动画效果
							dragDom.style.transition = 'transform 0.3s ease-out';
							dragDom.style.transform = `translate(${centerX}px, ${centerY}px)`;

							// 动画结束后清除过渡效果
							setTimeout(() => {
								dragDom.style.transition = '';
							}, 300);
						}
					}
				}

				document.onmousemove = null;
				document.onmouseup = null;
			};
		};
	}
};
