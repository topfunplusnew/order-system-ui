// 冲抵款类型 这里的Other后期可以添加更多的冲抵款类型
import { TableName } from '../../../api/tool/enums';

/**
 * 冲抵款类型
 * @type {{CASH_RECORD: string, INVOICE_OTHER: string, TRANSFER: string}}
 * @description 冲抵款类型
 * @reference cash_record:referenceTableName
 */
export var CASH_TYPE = {
	CASH_RECORD: TableName.CASH_RECORD,
	INVOICE_OTHER: TableName.INVOICE_OTHER,
	TRANSFER: 'transfer'
};
