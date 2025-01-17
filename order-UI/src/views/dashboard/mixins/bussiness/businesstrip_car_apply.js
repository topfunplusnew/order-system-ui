import { getToken } from '../../../../utils/auth';
import { mapGetters } from 'vuex';

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
		updateQueryCars(val) {
			this.queryCars = val;
		},
		handleCommitBackCars(val) {
			this.form.carNo = val.dictLabel;
		},
		handleCommitBackOilCard(val, row) {
			row.oilCardNo = val.oilCardNo;
		},
		handleCommitBackQueryOilCard(val) {
			this.queryOilCard = val;
		},
		// 公司车辆
		handleCommitCarNumber(val, row) {
			row.carNo = val.dictLabel;
		},
		handleCommitBackQueryCarNumber(val) {
			this.queryCarNumber = val;
		},
		checkPath(path) {
			window.open(path);
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
