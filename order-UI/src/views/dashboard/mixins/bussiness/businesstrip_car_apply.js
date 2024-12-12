import { getToken } from '../../../../utils/auth';
import { getBusinessTrip } from '../../../../api/system/BusinessTrip';
import { addOilCardConsume } from '../../../../api/system/OilCardConsume';
import { checkOilCard } from '../../../../api/system/oilCard';
import { mapGetters } from 'vuex';
import OilCardRecharge from '@/views/dashboard/components/common/OilCardRecharge.vue';

export var mixin_businesstrip_car_apply = {
	data: function () {
		return {
			oilCardConsumeVisible: false,
			queryCars: '',
			queryCarNumber: '',
			oilCardConsumeInfo: {
				oilCardNo: '',
				carNo: '',
				// 附件路径
				attachmentOiladd: '',
				// 充值金额 默认为0
				rechargeMoney: '0'
			},
			queryOilCard: '',
			// 文件上传
			baseUrl: process.env.VUE_APP_BASE_API,
			uploadFileUrl: process.env.VUE_APP_BASE_API + '/common/upload', // 上传文件服务器地址
			headers: {
				Authorization: 'Bearer ' + getToken()
			},
			isRecharge: ''
		};
	},
	computed: {
		...mapGetters(['trueName'])
	},
	methods: {
		handleFileUploadCarApply(url) {
			this.form.path = url;
		},
		// 打开油卡消费记录的弹窗
		openOilCardOpen() {
			this.resetOilCardConsumeInfo();
			this.oilCardConsumeVisible = true;
		},
		updateQueryCars(val) {
			this.queryCars = val;
		},
		handleCommitBackCars(val) {
			this.form.carNo = val.dictLabel;
		},
		handleCommitBackOilCard(val) {
			this.oilCardConsumeInfo.oilCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCard(val) {
			this.queryOilCard = val;
		},
		// 公司车辆
		handleCommitCarNumber(val) {
			this.oilCardConsumeInfo.carNo = val.dictLabel;
		},
		handleCommitBackQueryCarNumber(val) {
			this.queryCarNumber = val;
		},
		// 文件上传
		handleFileSuccess(response, file, fileList) {
			if (response.code === 200) {
				this.oilCardConsumeInfo.attachmentOiladd = response.url;
				console.log(this.oilCardConsumeInfo.attachmentOiladd);
				this.$message.success('上传成功');
			} else {
				this.$message.error('上传失败');
			}
			fileList.pop();
		},
		// 查看附件
		checkPath(path) {
			window.open(path);
		},
		// 添加油卡消费信息
		submitOilCard() {
			// 是否携带了油卡
			this.form.isUseOilCard = '1';
			// 要检查油卡的余额是否够用 如果够用就保存数据 如果不够用 那么就要提示是否充值  如果充值 就要弹出充值页面
			checkOilCard({
				oilCardNo: this.oilCardConsumeInfo.oilCardNo,
				consumeAmount: this.oilCardConsumeInfo.refuelingMoney
			}).then(res => {
				// 如果余额不足 要进行充值
				if (res.data.error === '油卡余额不足') {
					this.$confirm('油卡余额不足,是否充值?', '提示', {
						confirmButtonText: '是',
						cancelButtonText: '否',
						type: 'warning'
					}).then(() => {
						// 打开油卡充值的弹窗
						this.openDialog(
							OilCardRecharge,
							'加油卡充值(需审核通过)',
							'800px',
							{
								OilCardFillInfo: this.oilCardConsumeInfo
							}
						);
					});
					// 如果油卡信息不存在
				} else if (res.data.error === '油卡不存在') {
					this.$message.error('油卡不存在');
					// 如果存在并且余额充足
				} else {
					// 纠正money
					this.oilCardConsumeInfo.rechargeMoney =
						this.isRecharge === '2'
							? '0'
							: this.oilCardConsumeInfo.rechargeMoney;
					// todo 这里先保存一下油卡的消费信息 后面添加车辆申请的时候 把这个信息同时保存在车辆申请的子对象中
					// todo youtrack 出差管理 -> 出差登记和车辆申请闭环了
					// 关闭油卡消费添加弹窗
					this.oilCardConsumeVisible = false;
				}
			});
		},
		clearOilCard() {
			this.oilCardConsumeVisible = false;
			this.oilCardConsumeInfo = {};
			this.form.isUseOilCard = '0';
			this.$message.success('已清除');
		},
		resetOilCardConsumeInfo() {
			this.oilCardConsumeInfo = {
				oilCardNo: '', // 加油卡卡号
				useDate: '', // 使用加油卡时间
				carNo: '', // 车辆车牌号
				startCardSurplus: '', // 期初余额
				rechargeMoney: '', // 充值金额
				refuelingNumber: '', // 加油量
				unitPrice: '', // 单价
				refuelingMoney: '', // 加油金额
				attachmentOiladd: '', // 加油小票附件路径
				comments: '' // 备注
			};
		}
	}
};
