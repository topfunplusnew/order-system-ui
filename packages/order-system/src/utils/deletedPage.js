export function buildDeletedQueryParams(query = {}) {
	return {
		...query,
		queryNotDeleted: false
	};
}

export function getDeletedColumnLabel(label, isDeletedMode = false) {
	if (!isDeletedMode) {
		return label;
	}
	if (label === '最后修改时间') {
		return '删除时间';
	}
	if (label === '最后修改人') {
		return '删除人';
	}
	return label;
}

export function isDeletedPageRoute(route = {}) {
	const path = String(route.path || '').toLowerCase();
	const name = String(route.name || '').toLowerCase();
	return path.includes('deleted') || name.includes('deleted');
}
