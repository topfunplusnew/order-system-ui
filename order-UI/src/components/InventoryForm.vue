<script>
import InventoryItem from "@/components/InventoryItem.vue";
import SearchOption from "@/components/SearchOption.vue";
import {listStoreHouse} from "@/api/system/StoreHouse";
import {listCars} from "@/api/system/cars";
import {listFleet} from "@/api/system/fleet";
import Vue from "vue";

export default {
  name: "InventoryForm",
  components: {SearchOption, InventoryItem},
  props: {
    //库存信息
    inventoryInfo: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      isLand: false,
      isSea: false,
      //查询库房信息
      queryStoreHouseName: '',
      //查询司机信息
      queryCars: '',
      //查询车队信息
      queryFleet: '',

      //货物信息
      goodsInfo: {}
    }
  },
  computed: {
    //这个字段是用来该改变当前的库存信息
    currentInventoryInfo: {
      get() {
        return this.inventoryInfo
      },
      set(value) {
        this.$emit('changeInventoryInfo', value)
      }
    }
  },
  //订单也可以这么优化
  watch: {
    currentInventoryInfo: {
      handler(val) {
        console.log('更新库存信息', val)
      },
      deep: true
    },
    goodsInfo: {
      handler(val) {
        console.log('监听货物', val)
      }
    }
  },
  methods: {
    listFleet,
    listCars,
    listStoreHouse,

    //一堆的更新查找和确认 Query是更新查找值 Commit是更新当前库存对象的属性
    handleUpdateQueryStoreHouseName(val) {
      this.queryStoreHouseName = val
    },
    handleCommitBackStoreHouseName(val) {
      this.currentInventoryInfo = {...this.currentInventoryInfo, storeHouseName: val.storeHouseName}
    },
    handleUpdateQueryCars(val) {
      this.queryCars = val
    },
    handleCommitBackCars(val) {
      this.currentInventoryInfo = {...this.currentInventoryInfo, driver: val.driver, carNo: val.carNo, tel: val.tel}
    },
    handleUpdateQueryFleet(val) {
      this.queryFleet = val
    },
    handleCommitBackFleet(val) {
      this.currentInventoryInfo = {...this.currentInventoryInfo, fleet: val.fName}
    },

    //修改货物信息
    handleChangeGoodsInfo(val) {
      for (let property in val) {
        Vue.set(this.goodsInfo, `${property}`, val[property])
      }
      this.$store.dispatch('inventory/setInventoryInfoAll', this.currentInventoryInfo)
      this.$store.dispatch('inventory/setInventoryInfoAll', this.goodsInfo)
    }
  },
  created() {

  },
  mounted() {

  },

}
</script>

<template>
  <div>
    <el-row>
      <el-col :span="6">
        <el-row>
          <el-col :span="4">
            <span style="font-weight: bolder">日期:</span>
          </el-col>
          <el-col :span="12">
            <el-date-picker
              v-model="currentInventoryInfo.storeDate"
              type="date"
              placeholder="选择日期" style="width: 70%"
              value-format="timestamp">
            </el-date-picker>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row>
          <el-col :span="4">
            <span style="font-weight: bolder">仓库:</span>
          </el-col>
          <el-col :span="12">
            <el-input type="text" v-model="currentInventoryInfo.storeHouseName"
                      placeholder="请输入仓库名称"></el-input>
          </el-col>
          <el-col :span="2">
            <SearchOption :get-data="listStoreHouse" :query-name="queryStoreHouseName" query-label="库房名称"
                          query-info="storeHouseName" @update:queryName="handleUpdateQueryStoreHouseName"
                          @commitBack="handleCommitBackStoreHouseName" :limit-info="{}">
              <template #table-columns>
                <el-table-column label="仓库名称" align="center" prop="storeHouseName"/>
                <el-table-column label="地址" align="center" prop="address"/>
              </template>
            </SearchOption>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row>
          <el-col :span="4">
            <span style="font-weight: bolder">车牌:</span>
          </el-col>
          <el-col :span="12">
            <el-input type="text" v-model="currentInventoryInfo.carNo"
                      placeholder="请输入车牌"></el-input>
          </el-col>
          <el-col :span="2">
            <SearchOption :get-data="listCars" :query-name="queryCars" query-label="司机姓名"
                          query-info="driver" @update:queryName="handleUpdateQueryCars"
                          @commitBack="handleCommitBackCars" :limit-info="{}">
              <template #table-columns>
                <el-table-column label="车牌号" align="center" prop="carNo"/>
                <el-table-column label="司机姓名" align="center" prop="driver"/>
                <el-table-column label="司机电话" align="center" prop="tel"/>
              </template>
            </SearchOption>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row>
          <el-col :span="4">
            <span style="font-weight: bolder">司机电话:</span>
          </el-col>
          <el-col :span="12">
            <el-input type="text" v-model="currentInventoryInfo.tel"
                      placeholder="请输入司机电话"></el-input>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="6">
        <el-row>
          <el-col :span="4">
            <span style="font-weight: bolder">车队:</span>
          </el-col>
          <el-col :span="12">
            <el-input type="text" v-model="currentInventoryInfo.fleet"
                      placeholder="请输入车队"></el-input>
          </el-col>
          <el-col :span="2">
            <SearchOption :get-data="listFleet" :query-name="queryFleet" query-label="车队名称"
                          query-info="fName" @update:queryName="handleUpdateQueryFleet"
                          @commitBack="handleCommitBackFleet" :limit-info="{}">
              <template #table-columns>
                <el-table-column label="车队名称" align="center" prop="fName"/>
                <el-table-column label="车队经理" align="center" prop="fLeader"/>
                <el-table-column label="车队经理电话" align="center" prop="tel"/>
              </template>
            </SearchOption>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <!--    货物个体信息-->
    <el-row>
      <p style="font-weight: bolder">货物信息</p>
      <!--      传入库存信息 因为只有一个货物入库 所以只需要更新一个信息-->
      <InventoryItem :order-item-info="goodsInfo" @changeOrderItemInfo="handleChangeGoodsInfo"/>
    </el-row>
  </div>
</template>

<style scoped lang="scss">
* {
  box-sizing: border-box;
}


</style>
