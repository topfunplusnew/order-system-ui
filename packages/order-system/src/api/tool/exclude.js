// 将form中的字段赋值为空
export function excludeParams(target, params) {
	const p = params || ['addtime', 'userId', 'UserName', 'delFlag', 'submitflag', 'cancelFlag', 'createBy', 'createTime', 'updateBy', 'updateTime', 'isedit', 'userName'];
	p.forEach(item => {
		delete target[item];
	});
	return target;
}
