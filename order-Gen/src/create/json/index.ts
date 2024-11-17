import * as XLSX from 'xlsx'

// 根据json对象生成sheet
export function createSheet(data: Object[]) {
    return XLSX.utils.json_to_sheet(data)
}
