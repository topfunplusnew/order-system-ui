import { parseTime } from '@/utils/ruoyi';

export class PaymentApply {
	constructor({
		fundsDate = parseTime(new Date()),
		payType = '未选择类型',
		moneyAmount = 0,
		otherAcountsName = '无',
		otherBankNo = '无',
		companyName = '无',
		companyId = null,
		companyType = '无',
		reason = '无',
		applyPerson = '无',
		applyPersonID = '无',
		comments = '无备注',
		extraInfo = null
	} = {}) {
		this.fundsDate = fundsDate;
		this.payType = payType;
		this.moneyAmount = moneyAmount;
		this.otherAcountsName = otherAcountsName;
		this.otherBankNo = otherBankNo;
		this.companyName = companyName;
		this.companyId = companyId;
		this.companyType = companyType;
		this.reason = reason;
		this.applyPerson = applyPerson;
		this.applyPersonID = applyPersonID;
		this.comments = comments;
		this.extraInfo = extraInfo ? new ExtraInfo(extraInfo) : null;
	}
}

export class ExtraInfo {
	constructor({ sourceInfos = [] } = {}) {
		this.sourceInfos = sourceInfos.map(info => new SourceInfo(info));
	}

	pushSourceInfo(info) {
		this.sourceInfos.push(info);
	}
}

export class SourceInfo {
	constructor({ tableName = null, tableId = null } = {}) {
		this.tableName = tableName;
		this.tableId = tableId;
	}
}
