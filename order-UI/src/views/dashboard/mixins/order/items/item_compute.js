import { fix } from '../../../../../api/tool/format';

/**
 * 订单的计算公式 分为四种情况
 * @type {{data: (function(): {}), computed: {profit10(): *|string, profit00(): *|string, profit11(): *|string, profit01(): *|string, tonnage00(): *|string, paymentFactory10(): *|string, tonnage11(): *|string, tonnage01(): *|string, paymentFactory01(): *|string, payments01(): *|string, paymentFactory00(): *|string, tonnage10(): *|string, paymentFactory11(): *|string, payments10(): *|string, payments00(): *|string, payments11(): *|string, landFreight10(): *|string, profitNoTax00(): *|string, profitNoTax11(): *|string, profitNoTax01(): *|string, profitNoTax10(): *|string, landFreight00(): *|string, landFreight11(): *|string, landFreight01(): *|string}, methods: {}}}
 */
export var mixin_item_compute = {
	data: function () {
		return {};
	},
	computed: {
		// 公式计算相关的计算属性
		// 是否含税 厂家否 客户否
		paymentFactory00() {
			return fix(
				((this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces) /
					1000000) *
					this.orderItemInfo.price +
					Number(this.orderItemInfo.sundryCost)
			);
		},
		payments00() {
			return fix(
				((this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.actualPieces) /
					1000000) *
					this.orderItemInfo.paymentUnload +
					Number(this.orderItemInfo.paymentsWithSundry)
			);
		},
		// todo  长度宽度高度过低 会计算吨位为0
		tonnage00() {
			return fix(
				((Number(this.orderItemInfo.height) - Number(this.orderItemInfo.erro)) *
					this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces) /
					1000000 /
					20 /
					20
			);
		},
		landFreight00() {
			return fix(
				Number(this.orderItemInfo.tonnage) *
					Number(this.orderItemInfo.landFreightPrice) +
					Number(this.orderItemInfo.additionalFees)
			);
		},
		profit00() {
			return fix(
				this.orderItemInfo.payments -
					this.orderItemInfo.paymentFactory -
					this.orderItemInfo.landFreight -
					this.orderItemInfo.seaFreight
			);
		},
		profitNoTax00() {
			return fix(
				this.orderItemInfo.payments -
					this.orderItemInfo.paymentFactory -
					this.orderItemInfo.landFreight -
					this.orderItemInfo.seaFreight -
					this.orderItemInfo.otherCost
			);
		},
		// 是否含税10
		paymentFactory10() {
			return fix(
				(this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces *
					this.orderItemInfo.price) /
					1000000 +
					Number(this.orderItemInfo.sundryCost)
			);
		},
		payments10() {
			return fix(
				(this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.actualPieces *
					this.orderItemInfo.paymentUnload) /
					1000000 +
					Number(this.orderItemInfo.paymentsWithSundry)
			);
		},
		tonnage10() {
			return fix(
				((this.orderItemInfo.height - this.orderItemInfo.erro) *
					this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces) /
					1000000 /
					20 /
					20
			);
		},
		landFreight10() {
			return fix(
				this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice +
					Number(this.orderItemInfo.additionalFees)
			);
		},
		profit10() {
			return fix(
				this.orderItemInfo.payments -
					this.orderItemInfo.paymentFactory -
					this.orderItemInfo.landFreight -
					this.orderItemInfo.seaFreight
			);
		},
		// todo
		profitNoTax10() {
			return fix(
				this.orderItemInfo.payments -
					this.orderItemInfo.paymentFactory / 1.075 -
					this.orderItemInfo.landFreight -
					this.orderItemInfo.seaFreight -
					this.orderItemInfo.otherCost
			);
		},
		// 是否含税01
		paymentFactory01() {
			return fix(
				((this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces) /
					1000000) *
					this.orderItemInfo.price +
					Number(this.orderItemInfo.sundryCost)
			);
		},
		payments01() {
			return fix(
				(this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.actualPieces *
					this.orderItemInfo.paymentUnload) /
					1000000 +
					Number(this.orderItemInfo.paymentsWithSundry)
			);
		},
		tonnage01() {
			return fix(
				((this.orderItemInfo.height - this.orderItemInfo.erro) *
					this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces) /
					1000000 /
					20 /
					20
			);
		},
		landFreight01() {
			return fix(
				Number(
					this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice
				) + Number(this.orderItemInfo.additionalFees)
			);
		},
		profit01() {
			return fix(
				this.orderItemInfo.payments -
					this.orderItemInfo.paymentFactory -
					this.orderItemInfo.landFreight -
					this.orderItemInfo.seaFreight
			);
		},
		// 否 是 运费
		profitNoTax01() {
			return fix(
				this.orderItemInfo.payments / 1.075 -
					this.orderItemInfo.paymentFactory -
					this.orderItemInfo.landFreight -
					this.orderItemInfo.seaFreight -
					this.orderItemInfo.otherCost
			);
		},
		// 是否含税11
		paymentFactory11() {
			return fix(
				(this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces *
					this.orderItemInfo.price) /
					1000000 +
					Number(this.orderItemInfo.sundryCost)
			);
		},
		payments11() {
			return fix(
				(this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.actualPieces *
					this.orderItemInfo.paymentUnload) /
					1000000 +
					Number(this.orderItemInfo.paymentsWithSundry)
			);
		},
		tonnage11() {
			return fix(
				((this.orderItemInfo.height - this.orderItemInfo.erro) *
					this.orderItemInfo.length *
					this.orderItemInfo.width *
					this.orderItemInfo.pieces) /
					1000000 /
					20 /
					20
			);
		},
		landFreight11() {
			return fix(
				this.orderItemInfo.tonnage * this.orderItemInfo.landFreightPrice +
					Number(this.orderItemInfo.additionalFees)
			);
		},
		profit11() {
			return fix(
				this.orderItemInfo.payments -
					this.orderItemInfo.paymentFactory -
					this.orderItemInfo.landFreight -
					this.orderItemInfo.seaFreight
			);
		},
		profitNoTax11() {
			return fix(
				this.orderItemInfo.payments -
					this.orderItemInfo.paymentFactory -
					this.orderItemInfo.landFreight * 1.075 -
					this.orderItemInfo.seaFreight -
					((this.orderItemInfo.height *
						this.orderItemInfo.length *
						this.orderItemInfo.width *
						this.orderItemInfo.pieces) /
						1000000 /
						20) *
						0.5 -
					this.orderItemInfo.otherCost
			);
		}
	},
	watch: {},
	methods: {}
};
