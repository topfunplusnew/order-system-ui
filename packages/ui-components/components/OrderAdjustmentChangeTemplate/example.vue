<script>
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import OrderAdjustmentChangeTemplate from './index.vue';

/**
 * 订单调整单变动统计模板使用示例
 */
export default {
	name: 'OrderAdjustmentChangeTemplateExample',
	mixins: [common_dialog],
	data() {
		return {
			// 示例数据
			exampleData: [
				{
					recordId: '1',
					changeType: 'before',
					status: '已审核',
					orderDate: '2026-01-15',
					customerName: '山东冠州辰明玻璃科技公司',
					truckPlate: '鄂A12345',
					containerNo: 'ABCD1234567',
					shippingCompany: '中远海运',
					supplierName: '湖北三峡',
					warehouse: '刘彦波仓库',
					gradeName: '湖北三峡欧洲灰原片优等品',
					unit: '片',
					thickness: 7.2,
					length: 3660,
					width: 2250,
					factoryPieces: 520,
					piecesPerPack: 52,
					packCount: 10,
					factoryPrice: 20.97,
					includeTax: '是',
					miscFee: 100.0,
					factoryPayment: 10904.4,
					unloadPieces: 520,
					unloadPrice: 21.0,
					stockPrice: 20.97,
					originalFactoryPayment: 10904.4,
					originalFactoryPaymentTax: 12279.95,
					originalInventoryAmount: 8979.77,
					originalInventoryAmountTax: 10104.4,
					originalCustomerReceivable: 12000.0,
					originalCustomerReceivableTax: 13500.0,
					originalFreightAmount: 1200.0,
					originalFreightAmountTax: 1350.0,
					customerAmount: 12000.0,
					supplierAmount: 10904.4,
					inventoryAmount: 8979.77,
					freightAmount: 1200.0
				},
				{
					recordId: '1',
					changeType: 'after',
					status: '已审核',
					orderDate: '2026-01-15',
					customerName: '山东冠州辰明玻璃科技公司',
					truckPlate: '鄂A12345',
					containerNo: 'ABCD1234567',
					shippingCompany: '中远海运',
					supplierName: '湖北三峡',
					warehouse: '刘彦波仓库',
					gradeName: '湖北三峡欧洲灰原片优等品',
					unit: '片',
					thickness: 7.2,
					length: 3660,
					width: 2250,
					factoryPieces: 520,
					piecesPerPack: 52,
					packCount: 10,
					factoryPrice: 21.0,
					includeTax: '是',
					miscFee: 100.0,
					factoryPayment: 11000.0,
					unloadPieces: 520,
					unloadPrice: 21.5,
					stockPrice: 21.0,
					originalFactoryPayment: 11000.0,
					originalFactoryPaymentTax: 12375.0,
					originalInventoryAmount: 9000.0,
					originalInventoryAmountTax: 10125.0,
					originalCustomerReceivable: 12100.0,
					originalCustomerReceivableTax: 13612.5,
					originalFreightAmount: 1250.0,
					originalFreightAmountTax: 1406.25,
					customerAmount: 12100.0,
					supplierAmount: 11000.0,
					inventoryAmount: 9000.0,
					freightAmount: 1250.0
				},
				{
					recordId: '2',
					changeType: 'before',
					status: '待审核',
					orderDate: '2026-01-16',
					customerName: '北京某某贸易有限公司',
					truckPlate: '京B88888',
					containerNo: 'EFGH9876543',
					shippingCompany: '东方海外',
					supplierName: '河北沙河',
					warehouse: '王五仓库',
					gradeName: '河北沙河超白原片一等品',
					unit: '片',
					thickness: 8.0,
					length: 3300,
					width: 2440,
					factoryPieces: 400,
					piecesPerPack: 40,
					packCount: 10,
					factoryPrice: 25.5,
					includeTax: '否',
					miscFee: 150.0,
					factoryPayment: 10350.0,
					unloadPieces: 400,
					unloadPrice: 26.0,
					stockPrice: 25.5,
					originalFactoryPayment: 10350.0,
					originalFactoryPaymentTax: 11643.75,
					originalInventoryAmount: 8200.0,
					originalInventoryAmountTax: 9225.0,
					originalCustomerReceivable: 11000.0,
					originalCustomerReceivableTax: 12375.0,
					originalFreightAmount: 1000.0,
					originalFreightAmountTax: 1125.0,
					customerAmount: 11000.0,
					supplierAmount: 10350.0,
					inventoryAmount: 8200.0,
					freightAmount: 1000.0
				},
				{
					recordId: '2',
					changeType: 'after',
					status: '已审核',
					orderDate: '2026-01-16',
					customerName: '北京某某贸易有限公司',
					truckPlate: '京B88888',
					containerNo: 'EFGH9876543',
					shippingCompany: '东方海外',
					supplierName: '河北沙河',
					warehouse: '王五仓库',
					gradeName: '河北沙河超白原片一等品',
					unit: '片',
					thickness: 8.0,
					length: 3300,
					width: 2440,
					factoryPieces: 400,
					piecesPerPack: 40,
					packCount: 10,
					factoryPrice: 26.0,
					includeTax: '否',
					miscFee: 150.0,
					factoryPayment: 10550.0,
					unloadPieces: 400,
					unloadPrice: 26.5,
					stockPrice: 26.0,
					originalFactoryPayment: 10550.0,
					originalFactoryPaymentTax: 11868.75,
					originalInventoryAmount: 8400.0,
					originalInventoryAmountTax: 9450.0,
					originalCustomerReceivable: 11200.0,
					originalCustomerReceivableTax: 12600.0,
					originalFreightAmount: 1050.0,
					originalFreightAmountTax: 1181.25,
					customerAmount: 11200.0,
					supplierAmount: 10550.0,
					inventoryAmount: 8400.0,
					freightAmount: 1050.0
				}
			]
		};
	},
	methods: {
		/**
		 * 打开订单调整单变动详情弹窗
		 */
		openDialog() {
			this.openDialog(
				OrderAdjustmentChangeTemplate,
				'订单调整单变动详情',
				'1500px',
				{
					compareData: this.exampleData,
					moduleName: 'orderAdjustment'
				},
				false,
				false
			);
		},

		/**
		 * 模拟从后端获取数据
		 * @returns {Promise<Array>} 对比数据
		 */
		async fetchCompareData() {
			// 模拟 API 请求
			return new Promise(resolve => {
				setTimeout(() => {
					resolve(this.exampleData);
				}, 500);
			});
		},

		/**
		 * 打开弹窗并加载数据
		 */
		async openDialogWithData() {
			const compareData = await this.fetchCompareData();
			this.openDialog(
				OrderAdjustmentChangeTemplate,
				'订单调整单变动详情',
				'1500px',
				{
					compareData,
					moduleName: 'orderAdjustment'
				},
				false,
				false
			);
		}
	}
};
</script>

<template>
	<div class="example-container">
		<h2>订单调整单变动统计模板使用示例</h2>

		<el-card class="box-card">
			<div slot="header" class="clearfix">
				<span>示例操作</span>
			</div>

			<el-button type="primary" @click="openDialog">打开订单调整单变动详情弹窗</el-button>
			<el-button type="success" @click="openDialogWithData">打开弹窗并加载数据</el-button>
		</el-card>

		<el-card class="box-card" style="margin-top: 20px">
			<div slot="header" class="clearfix">
				<span>直接展示</span>
			</div>

			<order-adjustment-change-template :compare-data="exampleData" module-name="orderAdjustment" />
		</el-card>

		<el-card class="box-card" style="margin-top: 20px">
			<div slot="header" class="clearfix">
				<span>示例数据结构</span>
			</div>

			<pre><code>{{ JSON.stringify(exampleData, null, 2) }}</code></pre>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.example-container {
	padding: 20px;

	h2 {
		margin-bottom: 20px;
	}

	.box-card {
		margin-bottom: 20px;
	}

	pre {
		background: #f5f5f5;
		padding: 15px;
		border-radius: 4px;
		overflow-x: auto;

		code {
			font-family: 'Courier New', monospace;
			font-size: 12px;
		}
	}
}
</style>
