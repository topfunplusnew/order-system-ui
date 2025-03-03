<template>
	<div>
		<INVENTORY :need-to-show-info="inventory" />
	</div>
</template>
<script>
import Vue from 'vue';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import { read, utils } from 'xlsx';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';

Vue.use(ElementUI);
export default {
	components: { INVENTORY },
	data() {
		return {
			fileList: [], // 上传文件列表
			tableHead: [], // 表头
			tableData: [], // 表数据
			inventory: {
				createBy: null,
				createTime: null,
				updateBy: null,
				updateTime: null,
				remark: null,
				selfBankCardType: null,
				otherBankCardType: null,
				id: 8,
				storeHouseid: 1,
				storeHouseName: '测试仓库',
				storeDate: '2025-02-13 18:54:29',
				landCarID: 1,
				landCarNo: '陆运车牌',
				landDriverTel: '11111111111',
				landDriverName: '测试陆运司机',
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				landBankNo: '测试陆运司机',
				seaBankNo: null,
				landBankName: '测试陆运司机开户行',
				seaBankName: null,
				addtime: '2025-02-13 18:56:17',
				userId: 1,
				delFlag: 0,
				showFlag: 0,
				goodsCompany: '本部',
				allLandFreight: 20093.4,
				allSeaFreight: 0.0,
				allTonnage: 223.26,
				allFreightPrice: 90.0,
				fleet: '梵蒂冈让他',
				receiveProof: null,
				checkUserId: null,
				checkState: null,
				inventoryDetailList: [
					{
						createBy: null,
						createTime: null,
						updateBy: null,
						updateTime: null,
						remark: null,
						selfBankCardType: null,
						otherBankCardType: null,
						storeHouseName: null,
						storeDate: null,
						id: 11,
						mainId: 8,
						stockNumber: 2000,
						supplier: '测试供应商',
						supplierId: 1,
						levelID: 5,
						levelName: '本溪玉晶一等品',
						countingUnit: '片',
						height: 5.0,
						length: 3660.0,
						width: 2440.0,
						pieces: 2000,
						piecesPerPack: 100,
						packs: 20,
						price: 20.0,
						isIncludeTaxFactory: 0,
						sundryCost: 10.0,
						paymentFactory: 357226.0,
						paymentUnload: 30.0,
						isIncludeTaxSale: 0,
						payments: '535824.000',
						erro: 0.0,
						tonnage: 223.26,
						landFreightPrice: 90.0,
						landFreight: 20093.4,
						seaFreight: null,
						freight: 20093.4,
						otherCost: 0.0,
						profit: 158504.6,
						profitNoTax: 158504.6,
						actualPieces: 2000,
						paymentsWithSundry: 0.0,
						additionalFees: 0.0,
						rebate: null,
						customerCommission: 0.0,
						comments: '0',
						exWareHoustId: null,
						delFlag: null,
						addtime: null,
						storeHouseid: null
					}
				],
				userName: 'maolei'
			}
		};
	},
	methods: {
		// 上传方法
		onChange(e) {
			// 获取上传的第一个文件
			const file = e.target.files[0];
			// fileReader读取文件
			const fileReader = new FileReader();

			// FileReader 接口的 load 事件在成功读取文件时触发。
			fileReader.onload = ev => {
				try {
					// data是文件读取的二进制数据
					const data = ev.target.result;
					// read是xlsx库提供的一个方法 返回一个workbook工作铺对象 里面包含sheets对象，sheet对象中包含表名，表数据等
					// export function read(data: any, opts?: ParsingOptions): WorkBook;
					const workbook = read(data, { type: 'binary' });

					// 参数数组
					const params = [];
					// 取对应表生成json表格内容  SheetNames 是所有的 Sheet item就是每一个Sheet
					workbook.SheetNames.forEach(item => {
						// 添加到params这个map中
						params.push({
							name: item,
							// 将workbook中的某个sheet转为js数组
							// sheet_to_json<T>(worksheet: WorkSheet, opts?: Sheet2JSONOpts): T[];
							dataList: utils.sheet_to_json(workbook.Sheets[item])
						});
						// 放入tableData中 el-table中tableData的数据结构为 [{},{},{}] 对象中每一个属性对应一个column 的prop
						this.tableData.push(utils.sheet_to_json(workbook.Sheets[item]));
					});
					// tableData是所有Sheet的数据 tableData[0]是第一个Sheet
					console.log('tableData:', this.tableData);
					// 该算法仅针对表头无合并的情况
					if (this.tableData.length > 0) {
						// 获取excel中第一个表格数据tableData[0][0]，并且将表头提取出来
						for (const key in this.tableData[1][0]) {
							this.tableHead.push(key);
						}
					}
					// todo 获取某一个sheet下的某一行数据的某一个属性
					console.log(this.tableData[1][0]['价税合计']);
					return params;
					// 重写数据
				} catch (e) {
					console.log('error:' + e);
					return false;
				}
			};
			fileReader.readAsBinaryString(file);
		}
	}
};
</script>
<style lang="scss" scoped>
.upload-demo {
	width: 100%;
}

.flex-display {
	margin: 50px 30px;
	width: 100%;
	display: flex;
	justify-content: flex-start;

	.left-box {
		margin: 20 30;
		height: 36px;
		line-height: 36px;
	}
}

.el-upload {
	margin-left: 40px;

	.el-btn {
		font-size: 16px;
	}

	.el-upload-tip {
		display: inline;
		font-size: 12px;
	}
}

.file-ipt {
	width: 200px;
	height: 36px;
	line-height: 36px;

	button {
		background-color: #409eff;
	}
}

input #file-upload-button {
	background-color: #409eff;
}
</style>
