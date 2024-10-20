<script>
import SearchOption from "@/components/SearchOption.vue";
import {listStoreHouse} from "@/api/system/StoreHouse";
import {listCars} from "@/api/system/cars";
import {listFleet} from "@/api/system/fleet";
import InventoryItem from "./InventoryItem.vue";

export default {
  name: "InventoryForm",
  components: {SearchOption, InventoryItem},
  props: {
    //是否为二次出库
    isSecond: {
      type: Boolean
    }
  },
  data() {
    return {
      inventoryInfo: {},
      //查询库房信息
      queryStoreHouseName: '',
      //查询司机信息
      queryCars: '',
      //查询车队信息
      queryFleet: '',
    }
  },
  computed: {},
  methods: {
    listFleet,
    listCars,
    listStoreHouse,
    //一堆的更新查找和确认 Query是更新查找值 Commit是更新当前库存对象的属性
    handleUpdateQueryStoreHouseName(val) {
      this.queryStoreHouseName = val
    },
    handleCommitBackStoreHouseName(val) {
      Object.assign(this.inventoryInfo, {
        storeHouseName: val.storeHouseName,
        storeHouseid: val.id
      })
    },
    handleUpdateQueryCars(val) {
      this.queryCars = val
    },
    handleCommitBackCars(val) {
      Object.assign(this.inventoryInfo, {
        landDriverName: val.driver,
        landCarNo: val.carNo,
        landDriverTel: val.tel
      })
    },
    handleUpdateQueryFleet(val) {
      this.queryFleet = val
    },
    handleCommitBackFleet(val) {
      this.inventoryInfo.fleet = val.fName
    },
    // 关闭弹窗
    closeInventoryInfo() {
      this.$emit('close')
    },
    resetInventoryInfo() {
      this.inventoryInfo = {
        storeDate: '',
        storeHouseName: '',
        landCarNo: '',
        landDriverTel: '',
        fleet: '',
      }
    }
  },
  created() {
    this.resetInventoryInfo();
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
          <el-col :span="20">
            <el-date-picker
              v-model="inventoryInfo.storeDate"
              type="date"
              placeholder="选择日期" style="width: 70%"
              value-format="yyyy-MM-dd">
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
            <el-input type="text" v-model="inventoryInfo.storeHouseName"
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
            <el-input type="text" v-model="inventoryInfo.landCarNo"
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
            <el-input type="text" v-model="inventoryInfo.landDriverTel"
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
            <el-input type="text" v-model="inventoryInfo.fleet"
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
      <InventoryItem :inventoryInfo="inventoryInfo" @close="closeInventoryInfo"/>
    </el-row>
  </div>
</template>

<style scoped lang="scss">
* {
  box-sizing: border-box;
}


</style>
