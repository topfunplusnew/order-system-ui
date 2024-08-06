<script>
import {listCompany} from "@/api/system/company";
import {listCars} from "@/api/system/cars";
import {listFleet} from "@/api/system/fleet";

export default {
  name: "OrderForm",
  props: {
    //订单信息
    orderInfo: {}
  },
  data() {
    return {
      isLand: false,
      isSea: false,
      //客户信息弹窗
      customerInfoDialogVisible: false,
      //陆运车牌信息弹窗
      landInfoDialogVisible: false,
      //车队信息弹窗
      fleetInfoDialogVisible: false,
      //海运车牌信息弹窗
      seaInfoDialogVisible: false,
      //客户信息
      companyInfo: [],
      //陆运车牌信息
      landInfo: [],
      //车队信息
      fleetInfo: [],
      //海运车牌信息
      seaInfo: [],


      //客户信息弹窗的搜索客户名
      customerName: '',
      fleetName: '',
    }
  },
  methods: {
    //客户供应商信息
    searchCustomerInfo() {
      this.customerInfoDialogVisible = true
      if (this.customerName !== '') {
        listCompany({relationName: this.customerName}).then(res => {
          this.companyInfo = res.rows;
        })
      } else {
        //发送请求 获取客户供应商信息
        listCompany().then(res => {
          this.companyInfo = res.rows;
        })
      }
    },
    //陆运车牌信息
    searchLandInfo() {
      this.landInfoDialogVisible = true
      //搜索车队信息
      listCars().then(res => {
        this.landInfo = res.rows;
      })
    },
    //车队信息
    searchFleetInfo() {
      this.fleetInfoDialogVisible = true
      if (this.fleetName !== '') {
        listFleet({fName: this.fleetName}).then(res => {
          this.fleetInfo = res.rows;
        })
      } else {
        //发送请求 获取客户供应商信息
        listFleet().then(res => {
          this.fleetInfo = res.rows;
        })
      }
    },
    //todo 海运车牌信息
    searchSeaInfo() {
      this.seaInfoDialogVisible = true
      //查询海运车牌信息

    },
    handleClick(row) {
      console.log(row);
    },


    //客户信息中的搜索确认
    commitCustomerInfo(row) {
      //填充客户和销售经理信息
      this.orderInfo.customer = row.relationName;
      this.orderInfo.saleManager = row.salesManager;
      this.customerInfoDialogVisible = false
    },
    //查询车牌信息的确认
    commitCarsInfo(row) {
      this.orderInfo.landCarNo = row.carNo;
      this.orderInfo.landDriverName = row.driver;
      this.orderInfo.landDriverTel = row.tel;
      this.landInfoDialogVisible = false;
    },
    //车队信息的确认
    commitFleetInfo(row) {
      this.orderInfo.fleet = row.fName;
      this.fleetInfoDialogVisible = false;
    },
    //海运信息的确认
    commitSeaInfo(row) {

    }
  },
  created() {

  },
  mounted() {

  }
}
</script>

<template>
  <div>
    <!--    订单上面-->
    <div class="order-header">
      <div class="header-item">
        <span style="font-weight: bolder">日期:</span>
        <el-date-picker
          v-model="orderInfo.orderDate"
          type="date"
          placeholder="选择日期" style="width: 70%">
        </el-date-picker>
      </div>
      <div class="header-item">
        <span style="font-weight: bolder">客户:</span>
        <el-input type="text" v-model="orderInfo.customer" style="width: 50%" placeholder="请输入客户名称"></el-input>
        <!--        查询客户列表-->
        <el-button type="primary" size="mini" icon="el-icon-search" @click="searchCustomerInfo"></el-button>
      </div>
      <div class="header-item">
        <span style="font-weight: bolder">销售经理:</span>
        <el-input type="text" v-model="orderInfo.saleManager" style="width: 60%"
                  placeholder="请输入销售经理名称"></el-input>
      </div>
      <!--      多选框-->
      <div class="header-item">
        <span style="font-weight: bolder;">交通运输方式: </span>
        <el-checkbox v-model="isLand">陆运</el-checkbox>
        <el-checkbox v-model="isSea">海运</el-checkbox>
      </div>


      <!--      陆运-->
      <div style="margin:20px 0;" v-if="isLand">
        <div style="font-weight: bolder;margin-bottom: 10px">陆运信息</div>
        <div style="display: flex;">
          <div>
            <span class="text-bold">陆运车牌</span>
            <el-input type="text" v-model="orderInfo.landCarNo" style="width: 50%"
                      placeholder="请输入陆运车牌"></el-input>
            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchLandInfo"></el-button>
          </div>
          <div>
            <span class="text-bold">陆运司机姓名</span>
            <el-input type="text" v-model="orderInfo.landDriverName" style="width: 60%"
                      placeholder="请输入陆运司机姓名"></el-input>
          </div>
          <div>
            <span class="text-bold">陆运司机电话</span>
            <el-input type="text" v-model="orderInfo.landDriverTel" style="width: 60%"
                      placeholder="请输入陆运司机电话"></el-input>
          </div>
          <div>
            <span class="text-bold">车队</span>
            <el-input type="text" v-model="orderInfo.fleet" style="width: 50%" placeholder="请输入车队"></el-input>
            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchFleetInfo"></el-button>
          </div>
        </div>
      </div>

      <!--      海运-->
      <div style="margin:10px 0;" v-if="isSea">
        <div style="font-weight: bolder;margin-bottom: 10px">海运信息</div>
        <div style="display: flex;">
          <div>
            <span class="text-bold">海运车牌</span>
            <el-input type="text" v-model="orderInfo.seaCarNo" style="width: 50%" placeholder="请输入车牌"></el-input>
            <!--            <el-button type="primary" size="mini" icon="el-icon-search" @click="searchSeaInfo"></el-button>-->
          </div>
          <div>
            <span class="text-bold">海运司机姓名</span>
            <el-input type="text" v-model="orderInfo.seaDriverName" style="width: 60%"
                      placeholder="请输入司机姓名"></el-input>
          </div>
          <div>
            <span class="text-bold">海运司机电话</span>
            <el-input type="text" v-model="orderInfo.seaDriverTel" style="width: 60%"
                      placeholder="请输入司机电话"></el-input>
          </div>
        </div>
      </div>

    </div>

    <!--    订单主体-->
    <div class="order font-size-12">
      <div class="order-item">
        <span class="text-bold">供应商/仓库</span>
        <hr/>
        <el-input placeholder="请输入供应商/仓库"></el-input>
        <el-button size="mini" type="primary" icon="el-icon-user" circle>
        </el-button>
        <el-button size="mini" icon="el-icon-s-home" circle>
        </el-button>
      </div>
      <div class="order-item">
        <span class="text-bold">产品级别</span>
        <hr/>
        <el-input type="text" placeholder="请输入产品级别"></el-input>
        <el-button type="primary" size="mini" icon="el-icon-search" circle></el-button>
      </div>
      <div class="order-item">
        <span class="text-bold">计量单位</span>
        <hr/>
        <el-radio v-model="orderInfo.countingUnit" label="片数">片数</el-radio>
        <el-radio v-model="orderInfo.countingUnit" label="其他">其他</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">厚度</span>
        <hr/>
        <el-input type="text" placeholder="请输入厚度"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">长度</span>
        <hr/>
        <el-input type="text" placeholder="请输入长度"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">宽度</span>
        <hr/>
        <el-input type="text" placeholder="请输入宽度"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">每包片数</span>
        <hr/>
        <el-input type="text" placeholder="请输入每包片数"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">包数</span>
        <hr/>
        <el-input type="text" placeholder="请输入包数"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂片数</span>
        <hr/>
        <el-input type="text" placeholder="请输入出厂片数"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂单价</span>
        <hr/>
        <el-input type="text" placeholder="请输入出厂单价"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">是否含税</span>
        <hr/>
        <el-radio v-model="orderInfo.countingUnit" label="是">是</el-radio>
        <el-radio v-model="orderInfo.countingUnit" label="否">否</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">杂费</span>
        <hr/>
        <el-input type="text" placeholder="请输入杂费"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">出厂货款</span>
        <hr/>
        <el-input type="text" placeholder="请输入出厂贷款"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">卸货片数</span>
        <hr/>
        <el-input type="text" placeholder="请输入卸货片数"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">卸货价</span>
        <hr/>
        <el-input type="text" placeholder="请输入卸货价"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">是否含税</span>
        <hr/>
        <el-radio v-model="orderInfo.countingUnit" label="是">是</el-radio>
        <el-radio v-model="orderInfo.countingUnit" label="否">否</el-radio>
      </div>
      <div class="order-item">
        <span class="text-bold">杂费</span>
        <hr/>
        <el-input type="text" placeholder="请输入杂费"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">总货款</span>
        <hr/>
        <el-input type="text" placeholder="请输入总货款"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">误差</span>
        <hr/>
        <el-input type="text" placeholder="请输入误差"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">吨位</span>
        <hr/>
        <el-input type="text" placeholder="请输入吨位"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">运费单价</span>
        <hr/>
        <el-input type="text" placeholder="请输入运费单价"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">加费</span>
        <hr/>
        <el-input type="text" placeholder="加费"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">运费</span>
        <hr/>
        <el-input type="text" placeholder="运费"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">其他费用</span>
        <hr/>
        <el-input type="text" placeholder="其他费用"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">利润</span>
        <hr/>
        <el-input type="text" placeholder="利润"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">不含税利润</span>
        <hr/>
        <el-input type="text" placeholder="不含税利润"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">备注</span>
        <hr/>
        <el-input type="text" placeholder="备注"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">返利金额</span>
        <hr/>
        <el-input type="text" placeholder="返利金额"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">降价金额</span>
        <hr/>
        <el-input type="text" placeholder="降价金额"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">物流利润</span>
        <hr/>
        <el-input type="text" placeholder="物流利润"></el-input>
      </div>
      <div class="order-item">
        <span class="text-bold">客户佣金</span>
        <hr/>
        <el-input type="text" placeholder="客户佣金"></el-input>
      </div>
      <div class="option">
        <el-button type="primary">提交</el-button>
        <el-button>重置</el-button>
      </div>
    </div>

    <!--    客户信息弹窗-->
    <el-dialog
      title="客户信息"
      :visible.sync="customerInfoDialogVisible"
      width="35%" append-to-body>
      <el-row :gutter="5">
        <el-col :span="4">
          <span style="font-weight: bolder;line-height: 40px">客户名称</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="customerName" placeholder="请输入客户名称"></el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" @click="searchCustomerInfo">搜索</el-button>
        </el-col>
      </el-row>

      <el-table
        :data="companyInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitCustomerInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="relationName"
          label="客户">
        </el-table-column>
        <el-table-column
          prop="leader"
          label="老板姓名">
        </el-table-column>
        <el-table-column
          prop="leaderTel"
          label="老板联系方式">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="customerInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="customerInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    陆运车牌信息弹窗-->
    <el-dialog
      title="车牌信息"
      :visible.sync="landInfoDialogVisible"
      width="35%" append-to-body>
      <el-table
        :data="landInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitCarsInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="carNo"
          label="车牌">
        </el-table-column>
        <el-table-column
          prop="driver"
          label="司机姓名">
        </el-table-column>
        <el-table-column
          prop="tel"
          label="司机电话">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="landInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="landInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    车队信息弹窗-->
    <el-dialog
      title="客户信息"
      :visible.sync="fleetInfoDialogVisible"
      width="35%" append-to-body>
      <!--      车队搜索框-->
      <el-row :gutter="5">
        <el-col :span="4">
          <span style="font-weight: bolder;line-height: 40px">车队</span>
        </el-col>
        <el-col :span="8">
          <el-input v-model="fleetName" placeholder="请输入车队名称"></el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" @click="searchFleetInfo">搜索</el-button>
        </el-col>
      </el-row>

      <!--      车队信息列表-->
      <el-table
        :data="fleetInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitFleetInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="fName"
          label="车队名称">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="fleetInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="fleetInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>


    <!--    海运车牌信息弹窗-->
    <el-dialog
      title="客户信息"
      :visible.sync="seaInfoDialogVisible"
      width="35%" append-to-body>
      <el-table
        :data="seaInfo"
        border>
        <!--        操作-->
        <el-table-column
          fixed="left"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="commitSeaInfo(scope.row)" type="danger" size="small">确认</el-button>
          </template>
        </el-table-column>
        <el-table-column
          fixed
          prop="relationName"
          label="客户">
        </el-table-column>
        <el-table-column
          prop="leader"
          label="老板姓名">
        </el-table-column>
        <el-table-column
          prop="leaderTel"
          label="老板联系方式">
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
    <el-button @click="seaInfoDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="seaInfoDialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
* {
  box-sizing: border-box;
}

/*订单头部搜索信息*/
.order-header {
  display: flex;
  align-items: center;
  width: 100%;
  flex-wrap: wrap;
}

.header-item {
  width: 30%;
  margin-top: 10px;
}

/*订单信息*/
.order {
  overflow-x: scroll;
  display: flex;
  width: 100%;
  justify-content: flex-start;
  align-items: center;
  margin: 12px auto;
}

.order-item {
  height: 120px;
  flex: 0 0 70px;
  flex-direction: column;
  flex-wrap: nowrap;
  border: 1px solid #dddddd;
  background-color: #f9f9f9;

  span {
    font-weight: bolder;
  }
}

.option {
  line-height: 100px;
  width: 60%;
  height: 120px;
  flex: 0 0 200px;
}

.font-size-12 {
  font-size: 12px;
}

.width-50px {
  width: 50px;
}
</style>
