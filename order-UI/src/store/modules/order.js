// 订单模块
const state = {
    orderItemList: [],
}

const mutations = {
    // 设置货物列表
    setOrderItemList(state, data) {
        state.orderItemList = data
        console.log('setOrderItemList', state.orderItemList)
    },
    // 添加货物到货物列表中
    addsOrderItem(state, data) {
        state.orderItemList.push(data)
    },
    // 移除货物
    removeOrderItem(state, index) {
        state.orderItemList.splice(index, 1)
    },
    // 修改货物的状态
    changeOrderItemStatus(state, payload) {
        console.log(payload)
        // 获取传入的状态
        const {orderIndex, ...orderInfo} = payload
        state.orderItemList = state.orderItemList.map(item => {
            if (item.orderIndex === orderIndex) {
                console.log('===item:', item)
                return {...orderInfo};
            }
            console.log('!==item:', item)
            return item;
        });
        console.log('orderItemList:', state.orderItemList);
    },
    // 清除索引为index的索引的所有状态
    // clearOrderItemStatus(state, index) {
    //   // 清除索引为index的元素
    //   state.orderItemList = state.orderItemList.map(item => {
    //     console.log(item, 'index=>', item.orderIndex)
    //     if (item.orderIndex === index) {
    //       return {
    //         ...{
    //           orderDate: null,
    //           supplier: null,
    //           supplierID: null,
    //           customer: null,
    //           customerID: null,
    //           levelID: null,
    //           levelName: null,
    //           countingUnit: '片',
    //           height: null,
    //           length: null,
    //           width: null,
    //           pieces: null,
    //           piecesPerPack: 0,
    //           packs: 0,
    //           price: 0,
    //           isIncludeTaxFactory: '0',
    //           sundryCost: 0,
    //           paymentFactory: 0,
    //           paymentUnload: 0,
    //           isIncludeTaxSale: '0',
    //           payments: 0,
    //           erro: 0,
    //           tonnage: 0,
    //           landFreightPrice: 0,
    //           landFreight: 0,
    //           seaFreight: 0,
    //           freight: 0,
    //           otherCost: 0,
    //           profit: 0,
    //           profitNoTax: 0,
    //           actualPieces: 0,
    //           paymentsWithSundry: 0,
    //           additionalFees: 0,
    //           storeHouseID: null,
    //           storeHouseName: null,
    //           storeID: null,
    //           logisticsProfit: 0,
    //           customerCommission: null,
    //           isAdjusted: null,
    //           adjustDate: null,
    //           comments: null,
    //           addtime: null,
    //           userId: null,
    //           exWarehouseDate: null,
    //           outPieces: 0
    //         }
    //       };
    //     }
    //     return item;
    //   });
    //   console.log(state.orderItemList)
    // },
    // 清除货物列表中所有元素
    clearOrderItemList(state) {
        state.orderItemList = []
    }
}

const actions = {
    // 设置订单货物信息
    setOrderItemListAsync({commit}, data) {
        commit('setOrderItemList', data)
    },
}

export default {
    namespaced: true,
    state,
    mutations,
    actions
}
