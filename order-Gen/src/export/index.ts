// 导出
import * as XLSX from 'xlsx'
import {WorkBook, WorkSheet} from "xlsx";

/**
 * 导出excel
 * @param workbook excel 表对象
 * @param workSheet excel sheet对象
 * @param fileName 文件名
 * @param sheetName sheet名
 */
export function exportToExcel(workbook: WorkBook, workSheet: WorkSheet, fileName: string, sheetName: string) {
    try {
        XLSX.utils.book_append_sheet(workbook, workSheet, sheetName);
        const timestamp = Date.now()
        XLSX.writeFile(workbook, fileName + timestamp + '.xlsx')
    } catch (err) {
        console.log(err)
    }
}