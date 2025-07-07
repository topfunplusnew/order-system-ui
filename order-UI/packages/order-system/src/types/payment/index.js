import { parseTime } from '@/utils/ruoyi';

export class PaymentApply {
	constructor({
		fundsDate = parseTime(new Date()),
		payType = '',
		moneyAmount = 0,
		otherAcountsName = '',
		otherBankNo = '',
		companyName = '',
		companyId = null,
		companyType = '',
		reason = '',
		applyPerson = '',
		applyPersonID = '',
		comments = '',
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
