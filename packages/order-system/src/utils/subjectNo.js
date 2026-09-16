/**
 * 科目编码（subjectNo）生成规则。
 *
 * 约定：子科目编码 = 父级编码 + 3 位序号，例如父级 1001 → 1001001、1001002……
 *
 * 之所以把规则从组件里抽成纯函数：
 * 1. 单测可以直接覆盖（组件里原有的规则与 watch 耦合，没有测试保护）；
 * 2. 编码是否允许被自动改写这类“数据安全”判断需要有一个唯一、显式的出处，
 *    避免以后再有人把生成逻辑挂回响应式 watcher 上，在「修改」时也把编码改掉。
 */

/** 子科目编码的序号位数 */
export const SUBJECT_NO_SEQ_WIDTH = 3;

/** 是否为有效的非根父级 id（根节点 0 / 空值都没有可继承的父级编码） */
export function isValidParentId(parentId) {
	return parentId !== null && parentId !== undefined && parentId !== '' && Number(parentId) !== 0;
}

/**
 * 是否允许自动生成并回填科目编码。
 *
 * 只有「新增」（recordId 为空）且选择了有效父级时才允许。
 * 「修改」时一律不允许：编码一旦被改写，历史数据里按编码建立的关联/回填就对不上了。
 */
export function shouldAutoGenerateSubjectNo({ recordId, parentId } = {}) {
	const isCreate = recordId === null || recordId === undefined || recordId === '';
	if (!isCreate) {
		return false;
	}
	return isValidParentId(parentId);
}

/**
 * 计算父级下下一个可用的子科目编码。
 * 父级编码取不到时返回空串，交给用户手动录入。
 */
export function buildChildSubjectNo(parentSubjectNo, siblingSubjectNos = []) {
	const baseNo = parentSubjectNo === null || parentSubjectNo === undefined ? '' : String(parentSubjectNo).trim();
	if (!baseNo) {
		return '';
	}
	const siblingNos = (siblingSubjectNos || []).filter(no => no !== null && no !== undefined && no !== '');
	const usedNos = new Set(siblingNos.map(no => String(no).trim()));
	let seq = siblingNos.length + 1;
	let candidate = baseNo + String(seq).padStart(SUBJECT_NO_SEQ_WIDTH, '0');
	// 历史数据里的序号可能被手工改过，跳过已被占用的编码，避免生成重复编码
	while (usedNos.has(candidate)) {
		seq += 1;
		candidate = baseNo + String(seq).padStart(SUBJECT_NO_SEQ_WIDTH, '0');
	}
	return candidate;
}
