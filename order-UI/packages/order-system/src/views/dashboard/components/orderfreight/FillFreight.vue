<script>
import InfoDialog from '../../../../components/InfoDialog.vue';
import SearchOption from '../../../../components/SearchOption.vue';
import { listBankAccount } from '../../../../api/system/bankAccount';
import { addOrderFreight } from '../../../../api/system/orderFreight';
import { excludeParams } from '../../../../api/tool/exclude';
import { listFleet } from '../../../../api/system/fleet';
import { listData } from '../../../../api/system/dict/data';
import { listGoodsOrder } from '../../../../api/system/goodsOrder';
import { isNull } from '../../../../main';
import { TableName } from '@/api/tool/enums';

export default {
	name: 'FillFreight',
	components: { SearchOption, InfoDialog },
	props: {},
	data() {
		return {
			visible: false,
			form: {},
			rules: {
				moneyAmount: [{ required: true, message: '请输入金额', trigger: 'blur' }],
				otherAcountsName: [
					{
						required: true,
						message: '请输入对方户名',
						trigger: 'blur'
					}
				],
				otherBankNo: [
					{
						required: true,
						message: '请输入对方账号',
						trigger: 'blur'
					}
				],

				applyDate: [
					{
						required: true,
						message: '请选择申请日期',
						trigger: 'blur'
					}
				],
				payDate: [
					{
						required: true,
						message: '请选择付款日期',
						trigger: 'blur'
					}
				]
			},

			// 搜索字段
			queryCompany: '',
			queryFleet: '',
			queryCars: '',
			queryOrder: ''
		};
	},
	methods: {
		isNull,
		listGoodsOrder,
		listData,
		listFleet,
		listBankAccount,
		// 修正运费 因为有差值需要填补
		handleFill() {
			this.reset();
			this.visible = true;
		},
		// 订单的填充
		updateQueryOrder(val) {
			this.queryOrder = val;
		},
		// 订单的填充 主要是 填充车牌 司机 车队
		// 陆运 填充 val.landCarNo 陆运车牌 val.landDriverName 司机姓名 fleet 车队
		// 海运 填充 val.seaCarNo 海运车牌 seaDriverName 海运公司 fleet 为 无
		// 这里要让用户选择填充海运费还是陆运费
		handleCommitBackOrder(val) {
			// 判断是否包含陆运或海运
			const hasLandFreight = !!val.landFreight;
			const hasSeaFreight = !!val.seaFreight;

			// 填充进本信息 ordersNo source
			this.form.ordersNo = val.id;
			this.form.source = TableName.GOODS_ORDER;

			// 付款人员姓名
			if (hasLandFreight || hasSeaFreight) {
				// 如果同时包含陆运和海运，提示用户选择
				if (hasLandFreight && hasSeaFreight) {
					this.$confirm({
						title: '填充运输信息',
						content: '此订单同时包含陆运和海运，请选择填充',
						okText: '海运',
						cancelText: '陆运',
						type: 'warning',
						centered: true,
						zIndex: 2600,
						onOk: () => {
							this.handleFillSeaInfo(val);
						},
						onCancel: () => {
							this.handleFillLandInfo(val);
						}
					});
				} else {
					// 如果只包含陆运或海运，直接填充相应的运输费用
					this.handleFillTransportInfo(val, hasLandFreight ? 'land' : 'sea');
				}
			} else {
				this.$message.error('此订单没有运输信息，请自行填写');
			}
		},
		// 填充运费的函数
		handleFillTransportInfo(val, transportType) {
			if (transportType === 'land') {
				this.handleFillLandInfo(val);
			} else if (transportType === 'sea') {
				this.handleFillSeaInfo(val);
			}
		},
		handleFillLandInfo(val) {
			// 填充银行卡信息 todo 这里的银行卡户名 填写的是司机的名称 后续是否需要修改?
			this.form.otherAcountsName = val.landDriverName;
			this.form.otherBankNo = val.landBankNo;
			this.form.otherBankName = val.landBankName;

			// 填充司机信息
			this.form.driverName = val.landDriverName;
			this.form.carNo = val.landCarNo;
			this.form.fleet = val.fleet;

			// 填充主键
			this.form.driverId = val.landCarID;

			// 填充运输类型
			this.form.freightType = '陆运';
		},
		// 填充海运费
		handleFillSeaInfo(val) {
			// 填充银行卡信息 todo 这里的银行卡户名 填写的是司机的名称 后续是否需要修改?
			this.form.otherAcountsName = val.seaDriverName;
			this.form.otherBankNo = val.seaBankNo;
			this.form.otherBankName = val.seaBankName;

			// 填充司机信息
			this.form.driverName = val.seaDriverName;
			this.form.carNo = val.seaCarNo;
			this.form.fleet = '无';

			// 填充主键
			this.form.driverId = val.seaCarID;

			// 填充运输类型
			this.form.freightType = '海运';
		},
		// 己方公司点击确定的回调
		handleCommitBack(val) {
			this.form.otherBankNo = val.bankNo;
			this.form.otherBankName = val.bankName;
			this.form.companyName = val.companyName;
			this.form.companyId = val.id;
			this.form.otherAcountsName = val.acountsName;
			this.form.companyType = val.companyType;
		},
		handleCommitBackCars(val) {
			this.form.carNo = val.dictLabel;
		},
		updateQueryCars(val) {
			this.queryCars = val;
		},
		// update
		handleUpdateQueryName(val) {
			this.queryCompany = val;
		},
		handleCommitBackFleet(val) {
			this.form.fleet = val.fname;
		},
		updateQueryFleet(val) {
			this.queryFleet = val;
		},
		// 提交表单信息
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					this.form = excludeParams(this.form, this.$exclude);
					// 运费修正需要使用字段isOrderFreightFix
					this.form.extraInfo = { isOrderFreightFix: true };
					addOrderFreight(this.form).then(() => {
						this.$modal.msgSuccess('新增成功');
						this.visible = false;
						this.getList();
					});
				}
			});
		},
		cancel() {
			this.visible = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				ordersNo: null,
				freightType: null,
				moneyAmount: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				content: null,
				paymentState: null,
				driverName: null,
				driverId: null,
				CarNo: null,
				fleet: null,
				applyUserId: null,
				applyUserName: null,
				applyDate: null,
				isedit: null,
				payUserId: null,
				payUserName: null,
				payDate: null,
				cancelFlag: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			};
			this.resetForm('form');
		}
	}
};
</script>

<template>
	<div>
		<el-col :span="1.5">
			<el-button type="success" size="mini" @click="handleFill">运费修正</el-button>
		</el-col>

		<!--     修正弹窗-->
		<InfoDialog :visible.sync="visible" title="运费修正" :width="'750px'" @close="visible = false">
			<template #info>
				<el-form ref="form" :model="form" :rules="rules" label-width="100px">
					<!--           选择订单 主要是为了根据ordersNo 查询对应的司机和车队以及车牌信息 然后自动填充-->
					<el-form-item label="订单信息">
						<el-row>
							<el-col :span="8">
								<span style="color: #1c84c6">选择订单自动填充相关信息</span>
							</el-col>
							<el-col :span="4">
								<SearchOption
									title="订单信息"
									:limit-info="{}"
									:get-data="listGoodsOrder"
									query-label="ID搜索"
									:query-name="queryOrder"
									query-info="ordersNo"
									@update:queryName="updateQueryOrder"
									@commitBack="handleCommitBackOrder"
								>
									<template #table-columns>
										<el-table-column show-overflow-tooltip label="ID" align="center" prop="id" fixed="left" />
										<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" fixed="left" />
										<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" fixed="left" />
										<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" fixed="left" />
										<el-table-column show-overflow-tooltip label="是否调整过" align="center" prop="isAdjusted" />
										<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
										<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
										<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
										<el-table-column show-overflow-tooltip label="柜号" align="center" prop="seaCarNo">
											<template #default="scope">
												{{ isNull(scope.row.seaCarNo) }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel">
											<template #default="scope">
												{{ isNull(scope.row.seaDriverTel) }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
											<template #default="scope">
												{{ isNull(scope.row.seaDriverTel) }}
											</template>
										</el-table-column>
										<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
										<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
										<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120" />
										<el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState" width="120px" />
										<el-table-column show-overflow-tooltip label="打款状态" align="center" prop="paymentState" width="120px" />
										<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="金额" prop="moneyAmount">
						<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
					</el-form-item>
					<el-form-item label="对方户名" prop="otherAcountsName">
						<el-row>
							<el-col :span="10">
								<el-input disabled v-model="form.otherAcountsName" placeholder="请选择订单填充" />
							</el-col>
							<!-- <el-col :span="3">
                <SearchOption
                  :get-data="listBankAccount"
                  icon="el-icon-search"
                  :limit-info="{}"
                  query-label="户名查找"
                  query-info="acountsName"
                  :query-name="queryCompany"
                  @commitBack="handleCommitBack"
                  @update:queryName="handleUpdateQueryName"
                >
                  <template #table-columns>
                    <el-table-column
                      label="公司名称"
                      align="center"
                      prop="companyName"
                    />
                    <el-table-column
                      label="公司类型"
                      align="center"
                      prop="companyType"
                    />
                    <el-table-column
                      label="开户行"
                      align="center"
                      prop="bankName"
                    />
                    <el-table-column
                      label="开户名"
                      align="center"
                      prop="acountsName"
                    />
                    <el-table-column
                      label="账号"
                      align="center"
                      prop="bankNo"
                    />
                  </template>
                </SearchOption>
              </el-col> -->
						</el-row>
					</el-form-item>
					<el-form-item label="对方账号" prop="otherBankNo">
						<el-input disabled v-model="form.otherBankNo" placeholder="请选择订单填充" />
					</el-form-item>
					<el-form-item label="对方开户行" prop="otherBankName">
						<el-input disabled v-model="form.otherBankName" placeholder="请选择订单填充" />
					</el-form-item>
					<!--          下面这些可以通过选择订单 然后自动补齐-->
					<el-form-item label="司机姓名" prop="driverName">
						<el-input disabled v-model="form.driverName" placeholder="请选择订单填充" />
					</el-form-item>
					<el-form-item label="车牌号/柜号" prop="carNo">
						<el-row>
							<el-col :span="20">
								<el-input disabled v-model="form.carNo" placeholder="请选择订单填充" />
							</el-col>
							<!-- <el-col :span="4">
                <SearchOption
                  :limit-info="{ dictType: 'order_cars' }"
                  :get-data="listData"
                  query-label="车牌搜索"
                  :query-name="queryCars"
                  query-info="dictLabel"
                  @update:queryName="updateQueryCars"
                  @commitBack="handleCommitBackCars"
                >
                  <template #table-columns>
                    <el-table-column label="车牌" prop="dictLabel" />
                  </template>
                </SearchOption>
              </el-col> -->
						</el-row>
					</el-form-item>
					<el-form-item label="车队" prop="fleet">
						<el-col :span="20">
							<el-input disabled v-model="form.fleet" placeholder="请选择订单填充" />
						</el-col>
						<!-- <el-col :span="4">
              <SearchOption
                :limit-info="{}"
                :get-data="listFleet"
                query-label="车队名称搜索"
                :query-name="queryFleet"
                query-info="fname"
                @update:queryName="updateQueryFleet"
                @commitBack="handleCommitBackFleet"
              >
                <template #table-columns>
                  <el-table-column label="车队名称" prop="fname" />
                </template>
              </SearchOption>
            </el-col> -->
					</el-form-item>
					<el-form-item label="申请日期" prop="applyDate">
						<el-date-picker v-model="form.applyDate" type="datetime" placeholder="请选择申请日期" value-format="yyyy-MM-dd HH:mm:ss" />
					</el-form-item>
					<el-form-item label="付款日期" prop="payDate">
						<el-date-picker v-model="form.payDate" type="datetime" placeholder="请选择付款日期" value-format="yyyy-MM-dd HH:mm:ss" />
					</el-form-item>
					<el-form-item label="备注" prop="comments">
						<el-input v-model="form.comments" placeholder="请输入备注" />
					</el-form-item>
				</el-form>
				<div slot="footer" class="dialog-footer" style="text-align: center">
					<el-button type="primary" @click="submitForm">确 定</el-button>
					<el-button @click="cancel">取 消</el-button>
				</div>
			</template>
		</InfoDialog>
	</div>
</template>

<style scoped lang="scss"></style>
