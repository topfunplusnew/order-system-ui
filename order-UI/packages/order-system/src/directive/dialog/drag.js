export default {
	bind(el, binding) {
		const value = binding.value;
		if (value === false) return;

		const dialogHeaderEl = el.querySelector('.el-dialog__header');
		const dragDom = el.querySelector('.el-dialog');

		if (!dialogHeaderEl || !dragDom) {
			return;
		}

		dialogHeaderEl.style.cursor = 'move';
		dragDom.style.position = 'absolute';
		dragDom.style.marginTop = '0px';

		const setInitialPosition = () => {
			let width = dragDom.style.width;
			if (width.includes('%')) {
				width = +document.body.clientWidth * (parseFloat(width) / 100);
			} else {
				width = parseFloat(width);
			}
			if (isNaN(width) || width <= 0) {
				width = dragDom.offsetWidth;
			}
			dragDom.style.left = `${(document.body.clientWidth - width) / 2}px`;
		};
		setInitialPosition();

		let isDragging = false;

		const onMouseMove = function (e) {
			if (!isDragging) return;

			const { disX, disY, styL, styT } = dialogHeaderEl._dragData;

			const l = e.clientX - disX;
			const t = e.clientY - disY;

			let finallyL = l + styL;
			let finallyT = t + styT;

			if (finallyT < 0) {
				finallyT = 0;
			}

			const clientWidth = document.body.clientWidth;
			const dialogWidth = dragDom.offsetWidth;
			if (finallyL + dialogWidth > clientWidth) {
				finallyL = clientWidth - dialogWidth;
			}

			const clientHeight = document.body.clientHeight;
			const dialogHeight = dragDom.offsetHeight;
			if (finallyT + dialogHeight > clientHeight) {
				finallyT = clientHeight - dialogHeight;
			}

			dragDom.style.left = `${finallyL}px`;
			dragDom.style.top = `${finallyT}px`;
		};

		const onMouseUp = function () {
			isDragging = false;
			document.removeEventListener('mousemove', onMouseMove);
			document.removeEventListener('mouseup', onMouseUp);
		};

		dialogHeaderEl.onmousedown = e => {
			isDragging = true;
			const disX = e.clientX - dialogHeaderEl.offsetLeft;
			const disY = e.clientY - dialogHeaderEl.offsetTop;

			const sty = dragDom.currentStyle || window.getComputedStyle(dragDom, null);
			let styL, styT;

			if (sty.left.includes('%')) {
				styL = +document.body.clientWidth * (parseFloat(sty.left) / 100);
			} else {
				styL = parseFloat(sty.left);
			}

			if (sty.top.includes('%')) {
				styT = +document.body.clientHeight * (parseFloat(sty.top) / 100);
			} else {
				styT = parseFloat(sty.top);
			}

			dialogHeaderEl._dragData = { disX, disY, styL, styT };

			document.addEventListener('mousemove', onMouseMove);
			document.addEventListener('mouseup', onMouseUp);
		};

		el._dragMouseUp = onMouseUp;
		el._dragMouseMove = onMouseMove;

		const onWindowResize = () => {
			setInitialPosition();
		};
		window.addEventListener('resize', onWindowResize);
		el._dragWindowResize = onWindowResize;
	},
	unbind(el) {
		const dialogHeaderEl = el.querySelector('.el-dialog__header');
		if (dialogHeaderEl) {
			dialogHeaderEl.onmousedown = null;
		}

		if (el._dragMouseMove) {
			document.removeEventListener('mousemove', el._dragMouseMove);
		}
		if (el._dragMouseUp) {
			document.removeEventListener('mouseup', el._dragMouseUp);
		}
		if (el._dragWindowResize) {
			window.removeEventListener('resize', el._dragWindowResize);
		}

		if (dialogHeaderEl && dialogHeaderEl._dragData) {
			delete dialogHeaderEl._dragData;
		}
	}
};
