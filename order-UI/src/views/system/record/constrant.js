// 冲抵款类型 这里的Other后期可以添加更多的冲抵款类型
import {TableName} from "../../../api/tool/enums";

export var CASH_TYPE = {
  OFF_SETTING: TableName.OFFSETTING,
  INVOICE_OTHER: TableName.INVOICE_OTHER,
  TRANSFER: 'transfer'
}
