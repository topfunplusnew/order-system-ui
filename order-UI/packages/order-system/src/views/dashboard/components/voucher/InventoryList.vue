<script>
import { delInventory, getInventory, listInventory } from '../../../../api/system/inventory';
import { addReason } from '../../../../api/system/user';
import { TableName } from '../../../../api/tool/enums';

export default {
	name: 'InventoryList',
	data() {
		return {
			// 搜索参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				storeHouseid: null,
				storeHouseName: null,
				storeDate: null,
				stockNumber: null,
				supplier: null,
				supplierId: null,
				levelID: null,
				levelName: null,
				countingUnit: null,
				height: null,
				length: null,
				width: null,
				pieces: null,
				piecesPerPack: null,
				packs: null,
				price: null,
				isIncludeTaxFactory: null,
				sundryCost: null,
				paymentFactory: null,
				paymentUnload: null,
				isIncludeTaxSale: null,
				payments: null,
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				erro: null,
				tonnage: null,
				landFreightPrice: null,
				landFreight: null,
				seaFreight: null,
				freight: null,
				otherCost: null,
				profit: null,
				profitNoTax: null,
				actualPieces: null,
				paymentsWithSundry: null,
				additionalFees: null,
				rebate: null,
				customerCommission: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null,
				showFlag: null
			},
			inventoryList: [],
			total: 0,
			loading: false
		};
	},
	created() {
		this.getList();
	},
	methods: {
		getList() {
			this.loading = true;
			listInventory(this.queryParams).then(response => {
				this.inventoryList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 选中的提交上级
		handleSelectionChange(selection) {
			this.$emit('update:selectedGoodsOrderList', selection);
		},
		// 搜索按钮的操作
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		handleUpdate(row) {
			// this.$prompt('请输入编辑原因', '提示', {
			// 	confirmButtonText: '确定',
			// 	cancelButtonText: '取消',
			// 	type: 'warning'
			// })
			// 	.then(({ value }) => {
			// 		addReason({
			// 			reason: value,
			// 			tableName: TableName.INVENTORY,
			// 			tid: row.id,
			// 			modifyTime: this.modifyTime
			// 		}).then(() => {
			// 			this.$message.success('提交成功');
			// 			this.reset();
			// 			const id = row.id || this.ids;
			// 			getInventory(id).then(response => {
			// 				this.form = response.data;
			// 				this.open = true;
			// 				this.title = '修改库存';
			// 			});
			// 		});
			// 	})
			// 	.catch(() => {
			// 		this.$message({
			// 			type: 'warning',
			// 			message: '请先输入编辑原因!'
			// 		});
			// 	});
			this.reset();
			const id = row.id || this.ids;
			getInventory(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改库存';
			});
		},
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除库存编号为"' + ids + '"的数据项？')
				.then(function () {
					return delInventory(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		}
	}
};
</script>

<template>
	<div>
		<div>
			<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
				<el-form-item label="级别名称" prop="levelName">
					<el-input v-model="queryParams.levelName" placeholder="请输入级别名称" clearable @keyup.enter.native="handleQuery" />
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				</el-form-item>
			</el-form>
			<slot name="option"></slot>
		</div>
		<div>
			<el-table
				v-horizontal-scroll="'always'"
				v-loading="loading"
				border
				:data="inventoryList"
				:cell-style="
					() => {
						return { padding: '2px' };
					}
				"
				size="mini"
				@selection-change="handleSelectionChange"
			>
				<el-table-column type="selection" width="55" fixed="left"></el-table-column>
				<el-table-column label="仓库名称" align="center" prop="storeHouseName" width="150" />
				<el-table-column label="入库日期" align="center" prop="storeDate" width="150" />
				<el-table-column label="入库量" align="center" prop="stockNumber" width="150" />
				<el-table-column label="供应商" align="center" prop="supplier" width="150" />
				<el-table-column label="级别编码" align="center" prop="levelID" width="150" />
				<el-table-column label="级别名称" align="center" prop="levelName" width="150" />
				<el-table-column label="计量单位" align="center" prop="countingUnit" width="150" />
				<el-table-column label="厚度" align="center" prop="height" width="150" />
				<el-table-column label="长度" align="center" prop="length" width="150" />
				<el-table-column label="宽度" align="center" prop="width" width="150" />
				<el-table-column label="出厂片数" align="center" prop="pieces" width="150" />
				<el-table-column label="每包片数" align="center" prop="piecesPerPack" width="150" />
				<el-table-column label="包数" align="center" prop="packs" width="150" />
				<el-table-column label="出厂单价" align="center" prop="price" width="150" />
				<el-table-column label="出厂是否含税" align="center" prop="isIncludeTaxFactory" width="150">
					<template slot-scope="scope">
						{{ scope.row.isIncludeTaxFactory === 0 ? '否' : '是' }}
					</template>
				</el-table-column>
				<el-table-column label="杂费" align="center" prop="sundryCost" width="150" />
				<el-table-column label="出厂货款" align="center" prop="paymentFactory" width="150" />
				<el-table-column label="存货价" align="center" prop="paymentUnload" width="150" />
				<el-table-column label="库存是否含税" align="center" prop="isIncludeTaxSale" width="150">
					<template slot-scope="scope">
						{{ scope.row.isIncludeTaxSale === 0 ? '否' : '是' }}
					</template>
				</el-table-column>
				<el-table-column label="库存金额" align="center" prop="payments" width="150" />
				<el-table-column label="陆运车牌" align="center" prop="landCarNo" width="150" />
				<el-table-column label="陆运司机电话" align="center" prop="landDriverTel" width="150" />
				<el-table-column label="陆地司机姓名" align="center" prop="landDriverName" width="150" />
				<el-table-column label="误差" align="center" prop="erro" width="150" />
				<el-table-column label="吨位" align="center" prop="tonnage" width="150" />
				<el-table-column label="陆运费单价" align="center" prop="landFreightPrice" width="150" />
				<el-table-column label="陆运费" align="center" prop="landFreight" width="150" />
				<el-table-column label="其他费用" align="center" prop="otherCost" width="150" />
				<el-table-column label="利润" align="center" prop="profit" width="150" />
				<el-table-column label="不含税利润" align="center" prop="profitNoTax" width="150" />
				<el-table-column label="库存量" align="center" prop="actualPieces" width="150" />
				<el-table-column label="返利金额" align="center" prop="rebate" width="150" />
				<el-table-column label="佣金" align="center" prop="customerCommission" width="150" />
				<el-table-column label="备注" align="center" prop="comments" width="150" />
			</el-table>
			<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
