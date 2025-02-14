<!--凭证生成组件-->
<template>
	<div id="chargeContainer" class="charge-container">
		<div class="charge">
			<!--      上面三个基本信息-->
			<div class="charge-header">
				<div class="item">
					<div style="width: 80px">日期</div>
					<div>
						<el-date-picker
							v-model="voucher.vDate"
							style="width: 200px"
							type="datetime"
						></el-date-picker>
					</div>
				</div>
				<div v-if="computedToMakeList.length !== 0" class="item">
					<div style="width: 80px">凭证编号</div>
					<div>
						<el-input
							v-model="computedToMakeList[0].voucherNo"
							type="text"
							style="width: 200px"
						></el-input>
					</div>
				</div>
				<div class="item">
					<div style="width: 80px">制单人</div>
					<div>
						<el-input
							v-model="voucher.makeUser"
							type="text"
							style="width: 200px"
						></el-input>
					</div>
				</div>
			</div>
			<table class="charge-table" border="2">
				<!-- 表头-->
				<tr>
					<td width="6%" style="font-weight: bold">序号</td>
					<td :width="'22%'" style="font-weight: bold">摘要</td>
					<td :width="'22%'" style="font-weight: bold">科目名称</td>
					<td :width="'22%'" style="font-weight: bold">辅助项</td>
					<!--  右侧金额-->
					<td width="50%">
						<table style="height: 50px">
							<tr style="border-bottom: 1px solid #bab9b9">
								<td
									width="50%"
									style="
										border-right: 1px solid #bab9b9;
										font-weight: bold;
									"
								>
									借方
								</td>
								<td width="50%" style="font-weight: bold">
									贷方
								</td>
							</tr>
						</table>
					</td>
				</tr>

				<!-- 销项列表-->
				<!-- eslint-disable-next-line -->
				<tr v-for="(item, index) in computedToMakeList">
					<!--          序号-->
					<td>
						{{ index + 1 }}
					</td>
					<!--          摘要-->
					<td>
						<div class="main-subject">
							<el-input
								v-model="item.quote"
								type="text"
							></el-input>
						</div>
					</td>
					<!--          科目-->
					<td>
						<div class="main-subject">
							<el-row>
								<el-col :span="20">
									<el-input
										v-model="item.voucherType"
										type="text"
									></el-input>
								</el-col>
								<el-col :span="4">
									<!-- value是函数默认参数 箭头函数的默认参数是Update默认自带的value 传递给另一个函数执行-->
									<SubjectOption
										@update:type="
											value =>
												handleUpdateType(value, index)
										"
									/>
								</el-col>
							</el-row>
						</div>
					</td>
					<!--          辅助项-->
					<td>
						<div class="main-subject">
							<el-input
								v-model="item.comments"
								type="text"
							></el-input>
						</div>
					</td>

					<!--          右侧金额表格-->
					<td>
						<table>
							<tr>
								<td
									width="50%"
									style="border-right: 1px solid #bab9b9"
								>
									<el-input
										v-model="item.lender"
										type="text"
									></el-input>
								</td>
								<td width="50%">
									<el-input
										v-model="item.borrower"
										type="text"
									></el-input>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td
						:colspan="3"
						style="
							text-align: left;
							padding-left: 10px;
							height: 50px;
						"
					>
						合计：
					</td>
					<td
						style="
							text-align: left;
							padding-left: 10px;
							height: 50px;
						"
					>
						大写合计:{{
							numToChineseUppercase(totalBorrower + totalLender)
						}}
					</td>
					<td>
						<table>
							<tr>
								<!--                借方合计-->
								<td
									width="50%"
									style="border-right: 1px solid #bab9b9"
								>
									{{ totalLender }}
								</td>
								<!--                贷方合计-->
								<td width="50%">
									{{ totalBorrower }}
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td :colspan="5" style="height: 51px">
						<el-button type="success" @click="handleAddVoucher">
							+
						</el-button>
					</td>
				</tr>
			</table>
			<div style="text-align: right">
				<el-button type="primary" @click="submitVouchersList"
					>保存</el-button
				>
				<el-button @click="reset">重置</el-button>
			</div>
		</div>
	</div>
</template>

<script>
import SubjectOption from '../../../../components/SubjectOption.vue';
import { mapGetters } from 'vuex';
import { fix, numToChineseUppercase } from '../../../../api/tool/format';
import { addVoucherBatch } from '../../../../api/system/voucher';

export default {
	name: 'CrendentMake',
	components: { SubjectOption },
	props: {
		needToMakeList: {
			type: Array,
			default() {
				return [];
			}
		}
	},
	data() {
		return {
			voucher: {
				voucherNo: '1001',
				vDate: new Date(),
				makeUser: ''
			},
			list: [{}],
			voucherType: ''
		};
	},
	computed: {
		// 凭证列表
		computedToMakeList: {
			get() {
				return this.needToMakeList;
			},
			set(val) {
				this.$emit('update:needToMakeList', val);
			}
		},
		totalLender() {
			return fix(
				this.needToMakeList.reduce(
					(sum, item) => sum + Number(item.lender || 0),
					0
				)
			);
		},
		totalBorrower() {
			return fix(
				this.needToMakeList.reduce(
					(sum, item) => sum + Number(item.borrower || 0),
					0
				)
			);
		},
		...mapGetters(['trueName'])
	},
	mounted() {
		this.voucher.makeUser = this.trueName;
	},
	updated() {},
	methods: {
		fix,
		numToChineseUppercase,
		// 单条添加凭证
		handleAddVoucher() {
			const obj = {
				voucherType: '',
				borrower: '',
				lender: '',
				quote: '',
				comments: '',
				...this.voucher
			};
			this.computedToMakeList.push(obj);
		},
		// 拿到科目类型
		handleUpdateType(value, index) {
			this.computedToMakeList[index].voucherType = value;
		},
		// 保存凭证 (批量保存)
		submitVouchersList() {
			addVoucherBatch(this.computedToMakeList).then(res => {
				if (res.code === 200) {
					this.$message.success('凭证保存成功');
					location.reload();
				} else {
					this.$message.error(res.msg);
				}
			});
		},
		reset() {
			location.reload();
		}
	}
};
</script>

<style scoped>
table {
	width: 100%;
	border-spacing: 0;
	border-collapse: collapse;
	padding: 0;
	margin: 0;
}

table td {
	text-align: center;
	table-layout: fixed;
	padding: 0px;
	position: relative;
}

.main-subject {
	position: relative;
	height: 60px;
	line-height: 60px;
	text-align: left;
}

.charge-container {
	font-size: 14px;
	color: #444;
	font-weight: 400;
	background-color: white;
}

.charge {
	width: 1200px;
	margin: auto;
}

.charge-header {
	display: flex;
	flex-direction: row;
	margin-bottom: 10px;
}

.item {
	width: 300px;
	display: flex;
	flex-direction: row;
	justify-content: center;
	align-items: center;
}

.tip-box-table tr {
	height: 25px;
}

.el-icon-info {
	font-size: 18px;
	margin-left: 30px;
	cursor: pointer;
}

.el-icon-info:hover + .tip-box {
	display: inline-block;
}

.suggest-list .item-list {
	max-height: 375px;
	overflow: auto;
	list-style: none;
	margin: 0px;
	padding: 0px;
}

.item-list li {
	display: flex;
	padding: 0 10px;
	height: 28px;
	line-height: 28px;
	cursor: pointer;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}

.item-list li:hover {
	background: #ecebeb;
}

.item-list li.hover {
	background: #ecebeb;
}

.charge-table,
.tip-box-table {
	border: 1px solid #bab9b9;
}

.charge-table,
.debtor-tbale,
.lender-tbale > tr {
	height: 60px;
}

.charge-table > tr:first-child {
	height: 50px;
}

.td-auxiliary-dis {
	background-color: #f7f7f7;
}

.auxiliary-accounting {
	height: 60px;
	overflow: auto;
	padding: 15px 0 0 30px;
}

.auxiliary-accounting:before {
	content: '+';
	font-size: 30px;
	color: #4a90e2;
	cursor: pointer;
	padding: 0 11px;
	position: absolute;
	top: 0;
	left: 0;
	line-height: 60px;
}

.auxiliary-single {
	display: flex;
	float: left;
	height: 28px;
	line-height: 28px;
	margin-right: 5px;
	cursor: pointer;
	background: #eee;
	padding: 0 8px;
	border-radius: 2px;
}

.auxiliary-single span {
	max-width: 90px;
	overflow: hidden;
	height: 28px;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.auxiliary-single i {
	color: red;
	margin: 8px 0 8px 7px;
	font-size: 10px;
	visibility: hidden;
}

.auxiliary-single:hover i {
	visibility: inherit;
}

.charge-table-icon {
	cursor: pointer;
	display: inline-block;
}

.debtor-lender-table tr td {
	width: 9%;
	border-right: 1px solid #bab9b9;
}

.debtor-lender-table tr td:nth-child(3) {
	border-right-color: rgba(74, 144, 226, 0.5);
}

.debtor-lender-table tr td:nth-child(6) {
	border-right-color: rgba(74, 144, 226, 0.5);
}

.debtor-lender-table tr td:nth-child(9) {
	border-right-color: rgba(226, 106, 74, 0.5);
}

.debtor-lender-table tr td:last-child {
	border-right: none;
}

.tr-negative {
	color: red;
}

.charge-table input,
select {
	width: 100%;
	height: 60px;
}

.charge-table textarea {
	width: 100%;
	height: 60px;
	padding: 9px 14px 9px 10px;
	overflow: auto;
	resize: none;
	border: none;
	border-radius: 0px;
	margin: 0;
	color: #444;
	box-sizing: border-box;
}
</style>
