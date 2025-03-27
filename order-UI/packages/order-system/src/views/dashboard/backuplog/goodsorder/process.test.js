// 对数据处理流程的测试
import _ from 'lodash';
import { typeFilter } from '@/views/dashboard/backuplog/goodsorder/index';
import { JsonUtils } from '@/views/dashboard/backuplog';
import { TableName } from '@/api/tool/enums';

const compareData = [
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3947,
		tableName: 'recovermoney',
		backupTime: '2025-03-25 18:58:06',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "bankNo": "39923923909011", "params": {}, "remark": null, "userId": 1, "addtime": "2025-03-25 18:58:05", "delFlag": 0, "endTime": null, "comments": "发发", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "86716b3d-7a3a-4678-9eb3-c2b27384101b", "recoverNO": "88e5006a-e9a4-4de8-93da-5cc6e059680e", "startTime": null, "createTime": null, "updateTime": null, "acountsName": "张明", "moneyAmount": 21414.0, "recoverDate": "2025-03-25 18:58:07", "selfBankCardType": null, "otherBankCardType": null}',
		logicBackupType: 'insert',
		uuid: '06daf8b8-e567-4cd7-b310-46a652275f20',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3944,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:57:28',
		backupType: 'update',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo:
			'{"id": 21, "type": "押金", "reason": "正式", "target": "清晰", "userId": 1, "addtime": "2025-03-25 18:57:21", "delFlag": 0, "UserName": "maolei", "comments": "叫我呢", "futuresNO": "787e7f63-1e79-4448-b0e0-ba63a856e4a2", "selfBankNo": "39923923909011", "targetType": "其他", "futuresDate": "2025-03-25 18:56:55", "moneyAmount": 314425.0, "update_time": null, "selfBankName": "中国银行", "targetBankNo": " 5687468", "targetBankName": "发生过", "selfAcountsName": "张明", "targetAcountsName": "二", "futuresMarginCompany": "将军"}',
		originalInfoId: '21',
		changedInfo: '{"update_time": "2025-03-25 18:57:28", "targetBankNo": 1232131313132123, "targetBankName": "中国银行", "targetAcountsName": "张明"}',
		logicBackupType: 'update',
		uuid: '55296502-c3c2-4845-b0ae-89cec22e282a',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3943,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:57:21',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "押金", "params": {}, "reason": "正式", "remark": null, "target": "清晰", "userId": 1, "addtime": "2025-03-25 18:57:21", "delFlag": 0, "comments": "叫我呢", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "787e7f63-1e79-4448-b0e0-ba63a856e4a2", "checkState": null, "createTime": null, "selfBankNo": "39923923909011", "targetType": "其他", "updateTime": null, "futuresDate": "2025-03-25 18:56:55", "moneyAmount": 314425.0, "selfBankName": "中国银行", "targetBankNo": " 5687468", "targetBankName": "发生过", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "二", "futuresMarginCompany": "将军"}',
		logicBackupType: 'insert',
		uuid: '02eb092f-3343-4e4b-a270-a63065ebf79e',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3942,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:56:43',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "押金", "params": {}, "reason": "八点档", "remark": null, "target": "对象", "userId": 1, "addtime": "2025-03-25 18:56:42", "delFlag": 0, "comments": "随其", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "86716b3d-7a3a-4678-9eb3-c2b27384101b", "checkState": null, "createTime": null, "selfBankNo": "321391239120-391", "targetType": "客户", "updateTime": null, "futuresDate": "2025-03-25 18:56:24", "moneyAmount": 2342153.0, "selfBankName": "中国银行", "targetBankNo": "34568", "targetBankName": "客户开户行", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "客户1", "futuresMarginCompany": "今日"}',
		logicBackupType: 'insert',
		uuid: 'b9bffe61-ca1a-47e7-9016-970a33b1987a',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3941,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:56:15',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "押金", "params": {}, "reason": "哈积极hi", "remark": null, "target": "今日", "userId": 1, "addtime": "2025-03-25 18:56:15", "delFlag": 0, "comments": "32451", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "570bf3bd-4a90-4938-8dcd-144a660d3f51", "checkState": null, "createTime": null, "selfBankNo": "321391239120-391", "targetType": "供应商", "updateTime": null, "futuresDate": "2025-03-25 18:56:00", "moneyAmount": 23425.0, "selfBankName": "中国银行", "targetBankNo": "测试供应商", "targetBankName": "测试供应商开户行", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "测试供应商", "futuresMarginCompany": "今日"}',
		logicBackupType: 'insert',
		uuid: '7ea0e635-b920-4fc2-bd28-ed422c119059',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3940,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:55:48',
		backupType: 'update',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo:
			'{"id": 18, "type": "厂家保证金", "reason": "二恶", "target": "啊父亲", "userId": 1, "addtime": "2025-03-25 18:55:38", "delFlag": 0, "UserName": "maolei", "comments": "法", "futuresNO": "2a19b43c-f6a1-4dd2-a1b4-5df66d8f8c0a", "selfBankNo": "399239239090293", "targetType": "供应商", "futuresDate": "2025-03-25 18:55:23", "moneyAmount": 3423.0, "update_time": null, "selfBankName": "中国银行", "targetBankNo": "测试供应商", "targetBankName": "测试供应商开户行", "selfAcountsName": "张明", "targetAcountsName": "测试供应商", "futuresMarginCompany": "暨和拿回家"}',
		originalInfoId: '18',
		changedInfo: '{"target": "啊父亲尔请", "targetType": "客户", "update_time": "2025-03-25 18:55:47"}',
		logicBackupType: 'update',
		uuid: '7e111359-a6f1-4c08-9e4f-8315a863162a',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3939,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:55:39',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "厂家保证金", "params": {}, "reason": "二恶", "remark": null, "target": "啊父亲", "userId": 1, "addtime": "2025-03-25 18:55:38", "delFlag": 0, "comments": "法", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "2a19b43c-f6a1-4dd2-a1b4-5df66d8f8c0a", "checkState": null, "createTime": null, "selfBankNo": "399239239090293", "targetType": "供应商", "updateTime": null, "futuresDate": "2025-03-25 18:55:23", "moneyAmount": 3423.0, "selfBankName": "中国银行", "targetBankNo": "测试供应商", "targetBankName": "测试供应商开户行", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "测试供应商", "futuresMarginCompany": "暨和拿回家"}',
		logicBackupType: 'insert',
		uuid: 'eec5700e-f963-4479-a904-8cbd897f29f7',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3938,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:54:24',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "厂家保证金", "params": {}, "reason": "吉安市u", "remark": null, "target": "不死", "userId": 1, "addtime": "2025-03-25 18:54:24", "delFlag": 0, "comments": "345", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "c4141544-23fb-460f-964a-e870947fa6d7", "checkState": null, "createTime": null, "selfBankNo": "己方公司公户测试", "targetType": "客户", "updateTime": null, "futuresDate": "2025-03-25 18:54:06", "moneyAmount": 35452.0, "selfBankName": "己方公司公户测试", "targetBankNo": "34568", "targetBankName": "客户开户行", "selfAcountsName": "己方公司公户测试", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "客户1", "futuresMarginCompany": "保证金"}',
		logicBackupType: 'insert',
		uuid: '1bb88b56-13cd-4f67-acd1-6e86e8aa9a90',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3937,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:53:54',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "厂家保证金", "params": {}, "reason": "原因", "remark": null, "target": "加厚的覅", "userId": 1, "addtime": "2025-03-25 18:53:53", "delFlag": 0, "comments": "j", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "785866af-2272-49db-9e85-39e743d8d051", "checkState": null, "createTime": null, "selfBankNo": "321391239120-391", "targetType": "供应商", "updateTime": null, "futuresDate": "2025-03-25 18:53:33", "moneyAmount": 34254.0, "selfBankName": "中国银行", "targetBankNo": "测试供应商", "targetBankName": "测试供应商开户行", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "测试供应商", "futuresMarginCompany": "骗人仔"}',
		logicBackupType: 'insert',
		uuid: '68c9585e-d6ae-48fc-8b98-b40f3e1af3a4',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3936,
		tableName: 'recovermoney',
		backupTime: '2025-03-25 18:53:08',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "bankNo": "39923923909011", "params": {}, "remark": null, "userId": 1, "addtime": "2025-03-25 18:53:07", "delFlag": 0, "endTime": null, "comments": "尽快发垃圾", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "3b66ff1c-eb3d-42e1-bf0d-08287ccca3b0", "recoverNO": "8854b5c3-c9ea-4515-9521-608120699595", "startTime": null, "createTime": null, "updateTime": null, "acountsName": "张明", "moneyAmount": 864525.0, "recoverDate": "2025-03-25 18:53:04", "selfBankCardType": null, "otherBankCardType": null}',
		logicBackupType: 'insert',
		uuid: '21dce24d-c9d0-41e4-b61e-352b70543a28',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3933,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:52:29',
		backupType: 'update',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo:
			'{"id": 15, "type": "期货保证金", "reason": "金鸡奖", "target": "u嗲花", "userId": 1, "addtime": "2025-03-25 18:52:22", "delFlag": 0, "UserName": "maolei", "comments": "教案课件和", "futuresNO": "3b66ff1c-eb3d-42e1-bf0d-08287ccca3b0", "selfBankNo": "己方公司公户测试", "targetType": "客户", "futuresDate": "2025-03-25 18:51:58", "moneyAmount": 34566.0, "update_time": null, "selfBankName": "己方公司公户测试", "targetBankNo": "67959", "targetBankName": "开户行客户2", "selfAcountsName": "己方公司公户测试", "targetAcountsName": "客户2", "futuresMarginCompany": "去昂"}',
		originalInfoId: '15',
		changedInfo: '{"update_time": "2025-03-25 18:52:28", "targetBankNo": 34568, "targetBankName": "客户开户行", "targetAcountsName": "客户1"}',
		logicBackupType: 'update',
		uuid: 'dc9a34b0-e56c-4ced-9d79-481002a6947b',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3932,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:52:23',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "期货保证金", "params": {}, "reason": "金鸡奖", "remark": null, "target": "u嗲花", "userId": 1, "addtime": "2025-03-25 18:52:22", "delFlag": 0, "comments": "教案课件和", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "3b66ff1c-eb3d-42e1-bf0d-08287ccca3b0", "checkState": null, "createTime": null, "selfBankNo": "己方公司公户测试", "targetType": "客户", "updateTime": null, "futuresDate": "2025-03-25 18:51:58", "moneyAmount": 34566.0, "selfBankName": "己方公司公户测试", "targetBankNo": "67959", "targetBankName": "开户行客户2", "selfAcountsName": "己方公司公户测试", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "客户2", "futuresMarginCompany": "去昂"}',
		logicBackupType: 'insert',
		uuid: '73f48f83-e8a8-441c-892e-84c58249259b',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3931,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:51:34',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "期货保证金", "params": {}, "reason": "是吗", "remark": null, "target": "全省才", "userId": 1, "addtime": "2025-03-25 18:51:33", "delFlag": 0, "comments": "乔家", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "04234932-a51e-4269-acde-e43eae3176e8", "checkState": null, "createTime": null, "selfBankNo": "321391239120-391", "targetType": "员工", "updateTime": null, "futuresDate": "2025-03-25 18:51:07", "moneyAmount": 3435.0, "selfBankName": "中国银行", "targetBankNo": "34568", "targetBankName": "客户开户行", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "客户1", "futuresMarginCompany": "dfa"}',
		logicBackupType: 'insert',
		uuid: 'e1409604-6263-4eaf-af25-a82cf6416caf',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3930,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:50:59',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": "期货保证金", "params": {}, "reason": "是吗", "remark": null, "target": "全省才", "userId": 1, "addtime": "2025-03-25 18:50:58", "delFlag": 0, "comments": "ff", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "6f715f19-463d-4c78-9ed8-3244d0365377", "checkState": null, "createTime": null, "selfBankNo": "321391239120-391", "targetType": "客户", "updateTime": null, "futuresDate": "2025-03-25 18:50:32", "moneyAmount": 3435.0, "selfBankName": "中国银行", "targetBankNo": "34568", "targetBankName": "客户开户行", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "客户1", "futuresMarginCompany": "历史天王"}',
		logicBackupType: 'insert',
		uuid: '215db6a0-3c41-43f9-86e2-43eb7b1881e5',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3927,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:46:06',
		backupType: 'update',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo:
			'{"id": 12, "type": null, "reason": "jtaij", "target": "无", "userId": 1, "addtime": "2025-03-25 18:45:59", "delFlag": 0, "UserName": "maolei", "comments": "erq", "futuresNO": "d46bb7a3-16a7-4509-851e-e158c720fc80", "selfBankNo": "321391239120-391", "targetType": null, "futuresDate": "2025-03-25 18:45:46", "moneyAmount": 3434.0, "update_time": null, "selfBankName": "中国银行", "targetBankNo": "48798680", "targetBankName": "施工方", "selfAcountsName": "张明", "targetAcountsName": "发电公司", "futuresMarginCompany": null}',
		originalInfoId: '12',
		changedInfo: '{"comments": "fafaf", "update_time": "2025-03-25 18:46:06"}',
		logicBackupType: 'update',
		uuid: 'b7f0fb97-c5ae-4e80-8a41-a0b2b4ee19e7',
		version: 1
	},
	{
		createBy: null,
		createTime: null,
		updateBy: null,
		updateTime: null,
		remark: null,
		selfBankCardType: null,
		otherBankCardType: null,
		id: 3926,
		tableName: 'lendmoney',
		backupTime: '2025-03-25 18:45:59',
		backupType: 'insert',
		backupUserTruename: 'maolei',
		backupUserId: 1,
		originalInfo: 'null',
		originalInfoId: null,
		changedInfo:
			'{"id": null, "type": null, "params": {}, "reason": "jtaij", "remark": null, "target": "无", "userId": 1, "addtime": "2025-03-25 18:45:59", "delFlag": 0, "comments": "erq", "createBy": null, "updateBy": null, "userName": "maolei", "futuresNO": "d46bb7a3-16a7-4509-851e-e158c720fc80", "checkState": null, "createTime": null, "selfBankNo": "321391239120-391", "targetType": null, "updateTime": null, "futuresDate": "2025-03-25 18:45:46", "moneyAmount": 3434.0, "selfBankName": "中国银行", "targetBankNo": "48798680", "targetBankName": "施工方", "selfAcountsName": "张明", "recoverMoneyList": null, "selfBankCardType": null, "otherBankCardType": null, "targetAcountsName": "发电公司", "futuresMarginCompany": null}',
		logicBackupType: 'insert',
		uuid: 'e7936beb-4afd-4021-9256-b29c7e00a6ba',
		version: 1
	}
];

// 1.对数据进行分组
function getRenderData() {
	return Object.entries(_.groupBy(compareData, item => item.uuid)).map(entries => {
		return _.groupBy(entries[1], item => item.tableName);
	});
}

const _1 = getRenderData();
console.dir(_1, { depth: null });

// 2.对新增 和 删除 的缺失信息进行处理
function getTable(prop) {
	for (let index = 0; index < this.renderData.length; index++) {
		const item = this.renderData[index];
		const _getData = (prop, type) => {
			const key = type === 1 ? 'originalInfo' : 'changedInfo';
			return item[prop]
				? _.cloneDeep(
						item[prop].map(item => {
							const _item = typeFilter(item);
							return JsonUtils.getJson(_item[key]);
						})
				  )
				: [];
		};
		const before = _getData(prop, 1);
		const after = _getData(prop, 2);
		console.log(before, after);
	}
}

const _2 = getTable(TableName.GOODS_ORDER);
console.dir(getRenderData(), { depth: null });
