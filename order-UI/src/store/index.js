import Vue from 'vue'
import Vuex from 'vuex'
import app from './modules/app'
import dict from './modules/dict'
import user from './modules/user'
import tagsView from './modules/tagsView'
import permission from './modules/permission'
import settings from './modules/settings'
import getters from './getters'
import money from "@/store/modules/money";
import order from "@/store/modules/order";
import balanceaccounts from "@/store/modules/balanceaccounts";
import fixedassets from "@/store/modules/fixedassets";
import apply from "@/store/modules/apply";
import inventory from "@/store/modules/inventory";
import paymentApply from "@/store/modules/paymentApply";
import trash from "@/store/modules/trash";
import excel from "@/store/modules/excel";


Vue.use(Vuex)

const store = new Vuex.Store({
  modules: {
    app,
    dict,
    user,
    tagsView,
    permission,
    settings,
    //借款信息
    money,
    order,
    //平账信息
    balanceaccounts,
    fixedassets,
    apply,
    inventory,
    paymentApply,
    //垃圾桶
    trash,
    // excel
    excel
  },
  getters
})

export default store
