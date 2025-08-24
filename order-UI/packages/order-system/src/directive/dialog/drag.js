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

		dialogHeaderEl.onmousedown = e => {
			// 添加拖拽状态类，禁用全局文字选择
			document.body.classList.add('dragging');

			// 禁用document的文字选中效果
			document.body.style.userSelect = 'none';
			document.body.style.webkitUserSelect = 'none';
			document.body.style.mozUserSelect = 'none';
			document.body.style.msUserSelect = 'none';

			// 阻止默认的文字选择行为
			e.preventDefault();
			document.onselectstart = () => false;
			document.ondragstart = () => false;

			// 添加拖拽时的阴影效果
			dragDom.style.boxShadow = '0 14px 50px rgba(0, 0, 0, 0.7), 0 8px 20px rgba(0, 0, 0, 0.15)';
			dragDom.style.transition = 'none'; // 禁用过渡效果，提高拖拽性能

			// 鼠标按下，计算当前元素距离可视区的距离
			const disX = e.clientX - dialogHeaderEl.offsetLeft;
			const disY = e.clientY - dialogHeaderEl.offsetTop;

			const dragDomWidth = dragDom.offsetWidth;
			const dragDomheight = dragDom.offsetHeight;

			const screenWidth = document.body.clientWidth;
			const screenHeight = document.body.clientHeight;

			const minDragDomLeft = dragDom.offsetLeft;
			const maxDragDomLeft = screenWidth - dragDom.offsetLeft - dragDomWidth;

			const minDragDomTop = dragDom.offsetTop;
			const maxDragDomTop = screenHeight - dragDom.offsetTop - dragDomheight;

			// 获取到的值带px 正则匹配替换
			let styL = getStyle(dragDom, 'left');
			let styT = getStyle(dragDom, 'top');

			if (styL.includes('%')) {
				styL = +document.body.clientWidth * (+styL.replace(/%/g, '') / 100);
				styT = +document.body.clientHeight * (+styT.replace(/%/g, '') / 100);
			} else {
				styL = +styL.replace(/\px/g, '');
				styT = +styT.replace(/\px/g, '');
			}

			document.onmousemove = function (e) {
				// 通过事件委托，计算移动的距离
				let left = e.clientX - disX;
				let top = e.clientY - disY;

				// 获取当前窗口尺寸
				const currentScreenWidth = window.innerWidth;
				const currentScreenHeight = window.innerHeight;

				// 计算最终位置
				const finalLeft = left + styL;
				const finalTop = top + styT;

				// 更严格的边界处理
				// 左边界：至少保留50px在屏幕内
				if (finalLeft < -dragDomWidth + 50) {
					left = -dragDomWidth + 50 - styL;
				}
				// 右边界：至少保留50px在屏幕内
				else if (finalLeft > currentScreenWidth - 50) {
					left = currentScreenWidth - 50 - styL;
				}

				// 上边界：不能超出屏幕顶部
				if (finalTop < 0) {
					top = -styT;
				}
				// 下边界：至少保留标题栏可见
				else if (finalTop > currentScreenHeight - 50) {
					top = currentScreenHeight - 50 - styT;
				}

				// 移动当前元素
				dragDom.style.cssText += `;left:${left + styL}px;top:${top + styT}px;`;

				// emit onDrag event
				vnode.child.$emit('dragDialog');
			};

			document.onmouseup = function () {
				// 移除拖拽状态类，恢复全局文字选择
				document.body.classList.remove('dragging');

				// 恢复document的文字选中效果
				document.body.style.userSelect = '';
				document.body.style.webkitUserSelect = '';
				document.body.style.mozUserSelect = '';
				document.body.style.msUserSelect = '';

				// 恢复默认的选择和拖拽行为
				document.onselectstart = null;
				document.ondragstart = null;

				// 恢复原始阴影效果
				dragDom.style.boxShadow = '';
				dragDom.style.transition = '';

				// 检查对话框是否脱离视窗，如果是则重新定位到屏幕中间
				const dialogRect = dragDom.getBoundingClientRect();
				const screenWidth = window.innerWidth;
				const screenHeight = window.innerHeight;

				// 检查顶部是否脱离视窗或者对话框大部分不可见
				if (dialogRect.top < 0 || dialogRect.bottom < 50 || dialogRect.left + 50 < 0 || dialogRect.right - 50 > screenWidth) {
					// 重新定位到屏幕中间
					const centerX = (screenWidth - dragDom.offsetWidth) / 2;
					const centerY = (screenHeight - dragDom.offsetHeight) / 2;

					// 添加平滑动画效果
					dragDom.style.transition = 'all 0.3s ease-out';
					dragDom.style.left = centerX + 'px';
					dragDom.style.top = centerY + 'px';
					dragDom.style.marginLeft = '0px';
					dragDom.style.marginTop = '0px';

					// 动画结束后清除过渡效果
					setTimeout(() => {
						dragDom.style.transition = '';
					}, 300);
				}

				document.onmousemove = null;
				document.onmouseup = null;
			};
		};
	}
};
