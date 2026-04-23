export function invokeDialogOpenedHooks(componentInstance) {
	if (!componentInstance) {
		return;
	}

	if (typeof componentInstance.handleDialogOpened === 'function') {
		componentInstance.handleDialogOpened();
	}

	if (Array.isArray(componentInstance.$children)) {
		componentInstance.$children.forEach(child => {
			invokeDialogOpenedHooks(child);
		});
	}
}
