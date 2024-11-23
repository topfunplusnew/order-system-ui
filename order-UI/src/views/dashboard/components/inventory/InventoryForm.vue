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
      type: Boolean,
      default: false
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
      // 查询海运司机
      querySeaCars:'',
      // 海运和陆运
      isLand: false,
      isSea:false,
    }
  },
  computed: {},
  created() {
    this.resetInventoryInfo();
  },
  mounted() {

  },
  methods: {
    listFleet,
    listCars,
    listStoreHouse,
    handleProcess() {
      this.$refs.inventoryItem.handleProcess()
    },
    handleReject() {
      this.$refs.inventoryItem.handleReject()
    },
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
    // 填充司机信息的回调
    handleCommitBackCars(val) {
      Object.assign(this.inventoryInfo, {
        landDriverName: val.driver,
        landCarNo: val.carNo,
        landDriverTel: val.tel,
        landCarID: val.id
      })
    },
    handleUpdateQueryFleet(val) {
      this.queryFleet = val
    },
    handleCommitBackFleet(val) {
      this.inventoryInfo.fleet = val.fname
    },

    // 更新海运司机
    handleCommitBackSeaCar (value) {
      this.inventoryInfo.seaCarNo = value.carNo
      this.inventoryInfo.seaDriverName = value.driver
      this.inventoryInfo.seaDriverTel = value.tel
    },
    handleChangeSeaCar (value) {
      this.querySeaCars = value
    },
    resetInventoryInfo() {
      this.inventoryInfo = {
        storeDate: null,
        storeHouseName: null,
        landCarNo: null,
        landDriverTel: null,
        fleet: null,
        landCarID: null,
        seaDriverName: null,
        seaCarNo: null,
        seaDriverTel:null
      }
    }
  },

}
</script>

<template>
  <div>
    <el-form :inline="true" :model="orderInfo" label-width="80px">
      <el-card class="box-card" shadow="hover">
        <div slot="header" class="clearfix">
          <el-button type="text" style="color: #156fb2" icon="el-icon-notebook-2">
            库存基本信息
          </el-button>
        </div>
        <el-form-item label="日期" prop="orderDate">
          <el-date-picker
            v-model="inventoryInfo.storeDate"
            size="mini"
            type="datetime"
            placeholder="选择日期"
            value-format="yyyy-MM-dd HH:mm:ss"
            style="width: 120px"
          />
        </el-form-item>
        <el-form-item label="仓库" prop="customer">
          <el-row>
            <el-col :span="14">
              <el-input
                v-model="inventoryInfo.storeHouseName"
                type="text"
                size="mini"
                placeholder="请输入仓库名称"
              />
            </el-col>
            <el-col :span="4">
              <SearchOption
                :get-data="listStoreHouse"
                :query-name="queryStoreHouseName"
                query-label="库房名称"
                query-info="storeHouseName"
                :limit-info="{}"
                @update:queryName="handleUpdateQueryStoreHouseName"
                @commitBack="handleCommitBackStoreHouseName"
              >
                <template #table-columns>
                  <el-table-column label="仓库名称" align="center" prop="storeHouseName" />
                  <el-table-column label="地址" align="center" prop="address" />
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="运输方式">
          <el-checkbox v-model="isLand">
            陆运
          </el-checkbox>
          <el-checkbox v-model="isSea">
            海运
          </el-checkbox>
        </el-form-item>

        <!--      陆运-->
        <el-row v-if="isLand" style="margin:20px 0;">
          <el-form-item label="车牌">
            <el-row>
              <el-col :span="20">
                <el-input
                  v-model="inventoryInfo.landCarNo"
                  type="text"
                  size="mini"
                  placeholder="请输入陆运车牌"
                  style="width: 120px"
                />
              </el-col>
              <el-col :span="4">
                <!--搜索银行卡信息-->
                <SearchOption
                  :get-data="listCars"
                  :query-name="queryCars"
                  query-label="司机姓名"
                  query-info="driver"
                  :limit-info="{}"
                  @update:queryName="handleUpdateQueryCars"
                  @commitBack="handleCommitBackCars"
                >
                  <template #table-columns>
                    <el-table-column label="车牌号" align="center" prop="carNo" />
                    <el-table-column label="司机姓名" align="center" prop="driver" />
                    <el-table-column label="司机电话" align="center" prop="tel" />
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="司机">
            <el-input
              v-model="inventoryInfo.landDriverName"
              type="text"
              size="mini"
              placeholder="请输入陆运司机姓名"
              style="width: 130px"
            />
          </el-form-item>
          <el-form-item label="电话">
            <el-input
              v-model="inventoryInfo.landDriverTel"
              type="text"
              size="mini"
              placeholder="请输入陆运司机电话"
              style="width: 120px"
            />
          </el-form-item>
          <el-form-item label="车队">
            <el-row>
              <el-col :span="12">
                <el-input
                  v-model="inventoryInfo.fleet"
                  type="text"
                  size="mini"
                  placeholder="请输入车队"
                />
              </el-col>
              <el-col :span="4">
                <SearchOption
                  :get-data="listFleet"
                  :query-name="queryFleet"
                  query-label="车队名称"
                  query-info="fname"
                  :limit-info="{}"
                  @update:queryName="handleUpdateQueryFleet"
                  @commitBack="handleCommitBackFleet"
                >
                  <template #table-columns>
                    <el-table-column label="车队名称" align="center" prop="fname" />
                    <el-table-column label="车队经理" align="center" prop="fLeader" />
                    <el-table-column label="车队经理电话" align="center" prop="tel" />
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
        </el-row>
        <!--      海运-->
        <el-row v-if="isSea" style="margin:10px 0;">
          <!--          todo 车牌修改为柜号 且自己输入 不提供自动填充 -->
          <el-form-item label="柜号">
            <el-row>
              <el-col :span="20">
                <el-input
                  v-model="inventoryInfo.seaCarNo"
                  type="text"
                  size="mini"
                  placeholder="请输入柜号"
                  style="width: 120px"
                />
              </el-col>
              <el-col :span="4">
                <SearchOption
                  :limit-info="{carType:'海运'}"
                  :get-data="listCars"
                  query-label="车牌"
                  query-info="carNo"
                  :query-name="querySeaCars"
                  @commitBack="handleCommitBackSeaCar"
                  @update:queryName="handleChangeSeaCar"
                >
                  <template #table-columns>
                    <el-table-column label="车牌" align="center" prop="carNo" />
                    <el-table-column label="司机" align="center" prop="driver" />
                    <el-table-column label="司机电话" align="center" prop="tel" />
                    <el-table-column label="开户名" align="center" prop="acountsName" />
                    <el-table-column label="账号" align="center" prop="bankNo" />
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
          <!--          todo 原为海运司机 现改为海运公司-->
          <el-form-item label="海运公司">
            <el-input
              v-model="inventoryInfo.seaDriverName"
              type="text"
              size="mini"
              placeholder="请输入海运公司"
              style="width: 130px"
            />
          </el-form-item>
          <el-form-item label="电话">
            <el-input
              v-model="inventoryInfo.seaDriverTel"
              type="text"
              size="mini"
              placeholder="请输入电话"
              style="width: 120px"
            />
          </el-form-item>
        </el-row>
        <br>
      </el-card>
    </el-form>
    <br>
    <br>
    <!--    货物个体信息-->
    <el-card class="box-card" shadow="hover">
      <div slot="header" class="clearfix">
        <el-button type="text" style="color: #156fb2" icon="el-icon-notebook-2">
          货物信息
        </el-button>
      </div>
      <!--      传入库存信息 因为只有一个货物入库 所以只需要更新一个信息-->
      <InventoryItem ref="inventoryItem" :inventory-info="inventoryInfo" />
    </el-card>
  </div>
</template>

