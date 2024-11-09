<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="车牌" prop="carNo">
        <el-input
          v-model="queryParams.carNo"
          placeholder="请输入车牌"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>

      <el-form-item label="用车时间" prop="startTime">
        <el-date-picker
          v-model="queryParams.startTime"
          type="date"
          placeholder="选择用车时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="还车时间" prop="endTime">
        <el-date-picker
          v-model="queryParams.endTime"
          type="date"
          placeholder="选择还车时间" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>

      <el-form-item label="派车人" prop="dispatchPerson">
        <el-input
          v-model="queryParams.dispatchPerson"
          placeholder="请输入派车人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="danger" size="mini" @click="handleAdd">添加车辆派出信息</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-printer"
              size="mini"
              @click="printHTML"
            >
            </el-button>
          </el-col>
        </template>
        <!--        导出-->
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:carapply:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="carApplyList" @selection-change="handleSelectionChange" id="printBox"
              v-horizontal-scroll="'always'" size="mini" :cell-style="()=>{return {padding:'2px'}}">
      <el-table-column label="申请时间" align="center" prop="applyDate"
                       v-if="columns[0].visible" show-overflow-tooltip/>
      <el-table-column label="申请人" align="center" prop="applyUser"
                       v-if="columns[1].visible" show-overflow-tooltip/>
      <el-table-column label="部门" align="center" prop="department"
                       v-if="columns[2].visible" show-overflow-tooltip/>
      <el-table-column label="车牌" align="center" prop="carNo"
                       v-if="columns[3].visible" show-overflow-tooltip/>
      <el-table-column label="是否携带油卡" align="center" prop="isUseOilCard"
                       v-if="columns[4].visible" show-overflow-tooltip/>
      <el-table-column label="随同乘车人员" align="center" prop="peers"
                       v-if="columns[5].visible" show-overflow-tooltip/>
      <el-table-column label="用车时间" align="center" prop="startTime"
                       v-if="columns[6].visible" show-overflow-tooltip/>
      <el-table-column label="还车时间" align="center" prop="endTime"
                       v-if="columns[7].visible" show-overflow-tooltip/>
      <el-table-column label="用车事由" align="center" prop="applyPurpose"
                       v-if="columns[8].visible" show-overflow-tooltip/>
      <el-table-column label="出车前里程" align="center" prop="startMile"
                       v-if="columns[9].visible" show-overflow-tooltip/>
      <el-table-column label="出车前车况" align="center" prop="startCarState"
                       v-if="columns[10].visible" show-overflow-tooltip/>
      <el-table-column label="回来后里程" align="center" prop="endMile"
                       v-if="columns[11].visible" show-overflow-tooltip/>
      <el-table-column label="回来后车况" align="center" prop="endCarState"
                       v-if="columns[12].visible" show-overflow-tooltip/>
      <el-table-column label="用车里程数" align="center" prop="miles"
                       v-if="columns[13].visible" show-overflow-tooltip/>
      <el-table-column label="回程停靠位置" align="center" prop="backStopPlace"
                       v-if="columns[14].visible" show-overflow-tooltip/>
      <el-table-column label="行程中违法次数" align="center" prop="violationsCount"
                       v-if="columns[15].visible" show-overflow-tooltip/>
      <el-table-column label="违章罚款金额" align="center" prop="fine"
                       v-if="columns[16].visible" show-overflow-tooltip/>
      <el-table-column label="行程中是否维修/保养" align="center" prop="isMaintenance"
                       v-if="columns[17].visible" show-overflow-tooltip/>
      <el-table-column label="保养金额" align="center" prop="maintenanceMoney"
                       v-if="columns[18].visible" show-overflow-tooltip/>
      <el-table-column label="行程中使用加油卡加油次数" align="center" prop="refuelingFrequency"
                       v-if="columns[19].visible" show-overflow-tooltip/>
      <el-table-column label="派车人" align="center" prop="dispatchPerson"
                       v-if="columns[20].visible" show-overflow-tooltip/>
      <el-table-column label="备注" align="center" prop="comments"
                       v-if="columns[21].visible" show-overflow-tooltip/>
      <el-table-column label="附件路径" align="center" prop="path" v-if="columns[22].visible">
        <template slot-scope="scope">
          <CheckFiles :path="scope.row.path"
                      @needToUpdate="(value)=>handleUpdateFilePath(value,scope.row,'path',getCarApply(),updateCarApply())"/>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="100px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:carapply:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:carapply:remove']"
          >删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改车辆使用申请对话框 -->
    <el-dialog :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1100px"
               append-to-body>
      <div>
        <el-form ref="form" :model="form" :rules="rules" label-width="160px">
          <el-row>
            <el-col :span="8">
              <el-form-item label="申请时间" prop="applyDate">
                <el-date-picker
                  v-model="form.applyDate"
                  type="date"
                  placeholder="选择申请时间"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="申请人" prop="applyUser">
                <el-input v-model="form.applyUser" placeholder="请输入申请人"/>
              </el-form-item>
              <el-form-item label="部门" prop="department">
                <treeselect v-model="form.department" :options="deptOptions" :normalizer="normalizer"
                            placeholder="请选择部门"/>
              </el-form-item>
              <el-form-item label="车牌" prop="carNo">
                <el-row>
                  <el-col :span="20">
                    <el-input v-model="form.carNo" placeholder="请输入车牌"/>
                  </el-col>
                  <el-col :span="4">
                    <SearchOption :limit-info="{dictType:'order_cars'}"
                                  :get-data="listData" query-label="车牌搜索"
                                  :query-name="queryCars"
                                  query-info="dictLabel"
                                  @update:queryName="updateQueryCars"
                                  @commitBack="handleCommitBackCars">
                      <template #table-columns>
                        <el-table-column label="车牌" prop="dictLabel"/>
                      </template>
                    </SearchOption>
                  </el-col>
                </el-row>
              </el-form-item>
              <el-form-item label="是否携带油卡" prop="isUseOilCard">
                <el-row>
                  <el-radio v-model="form.isUseOilCard" label="1" @change="openOilCardOpen">是
                  </el-radio>
                  <el-radio v-model="form.isUseOilCard" label="0">否</el-radio>
                </el-row>
                <el-button v-if="form.isUseOilCard === '1'" type="warning" size="mini"
                           @click="oilCardConsumeVisible=true">重新填写油卡信息
                </el-button>
              </el-form-item>
              <el-form-item label="随同乘车人员" prop="peers">
                <el-input v-model="form.peers" placeholder="请输入随同乘车人员"/>
              </el-form-item>
              <el-form-item label="用车时间" prop="startTime">
                <el-date-picker
                  v-model="form.startTime"
                  type="date"
                  placeholder="选择用车时间"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="还车时间" prop="endTime">
                <el-date-picker
                  v-model="form.endTime"
                  type="date"
                  placeholder="选择还车时间"
                  value-format="yyyy-MM-dd">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="用车事由" prop="applyPurpose">
                <el-input v-model="form.applyPurpose" placeholder="请输入用车事由"/>
              </el-form-item>
              <el-form-item label="出车前里程" prop="startMile">
                <el-input v-model="form.startMile" placeholder="请输入出车前里程"/>
              </el-form-item>
              <el-form-item label="出车前车况" prop="startCarState">
                <el-input v-model="form.startCarState" placeholder="请输入出车前车况"/>
              </el-form-item>
              <el-form-item label="回来后里程" prop="endMile">
                <el-input v-model="form.endMile" placeholder="请输入回来后里程"/>
              </el-form-item>
              <el-form-item label="回来后车况" prop="endCarState">
                <el-input v-model="form.endCarState" placeholder="请输入回来后车况"/>
              </el-form-item>
              <el-form-item label="用车里程数" prop="miles">
                <el-input v-model="form.miles" placeholder="请输入用车里程数"/>
              </el-form-item>
              <el-form-item label="回程停靠位置" prop="backStopPlace">
                <el-input v-model="form.backStopPlace" placeholder="请输入回程停靠位置"/>
              </el-form-item>
              <el-form-item label="行程中违法次数" prop="violationsCount">
                <el-input v-model="form.violationsCount" placeholder="请输入行程中违法次数"/>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="违章罚款金额金额" prop="fine">
                <el-input v-model="form.fine" placeholder="请输入违章罚款金额金额"/>
              </el-form-item>
              <el-form-item label="行程中是否维修/保养" prop="isMaintenance">
                <el-radio v-model="form.isMaintenance" label="是">是</el-radio>
                <el-radio v-model="form.isMaintenance" label="否">否</el-radio>
              </el-form-item>
              <el-form-item label="保养金额" prop="maintenanceMoney" v-if="form.isMaintenance === '是'">
                <el-input v-model="form.maintenanceMoney" placeholder="请输入保养金额"/>
              </el-form-item>
              <el-form-item label="行程中使用加油卡加油次数" prop="refuelingFrequency">
                <el-input v-model="form.refuelingFrequency" placeholder="请输入行程中使用加油卡加油次数"/>
              </el-form-item>
              <el-form-item label="派车人" prop="dispatchPerson">
                <el-input v-model="form.dispatchPerson" placeholder="请输入派车人"/>
              </el-form-item>
              <el-form-item label="备注" prop="comments">
                <el-input v-model="form.comments" placeholder="请输入备注"/>
              </el-form-item>
              <el-form-item label="附件路径" prop="path">
                <file-upload @input="handleFileUploadCarApply"/>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    油卡消费记录的弹窗-->
    <el-dialog :close-on-click-modal="false" :show-close="false" title="油卡消费记录"
               :visible.sync="oilCardConsumeVisible" width="75%" append-to-body>
      <el-form ref="form" :model="oilCardConsumeInfo" label-width="160px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="加油卡卡号" prop="oilCardNo">
              <el-row>
                <el-col :span="20">
                  <el-input v-model="oilCardConsumeInfo.oilCardNo" placeholder="请输入加油卡卡号"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :get-data="listOilCard" @commitBack="handleCommitBackOilCard" query-info="oilCardNo"
                                :query-name="queryOilCard" query-label="油卡账号查询"
                                @update:queryName="handleCommitBackQueryOilCard" :limit-info="{oilType:'主卡'}">
                    <template #table-columns>
                      <el-table-column label="加油卡卡号" align="center" prop="oilCardNo"/>
                      <el-table-column label="当前金额" align="center" prop="moneyAmount"/>
                    </template>
                  </SearchOption>
                </el-col>
              </el-row>
            </el-form-item>
            <el-form-item label="使用加油卡时间" prop="useDate">
              <el-date-picker
                v-model="oilCardConsumeInfo.useDate"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="使用加油卡车辆车牌号" prop="carNo">
              <el-row>
                <el-col :span="20">
                  <el-input v-model="oilCardConsumeInfo.carNo" placeholder="请输入使用加油卡车辆车牌号"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :get-data="listData" @commitBack="handleCommitCarNumber" query-info="dictLabel"
                                :query-name="queryCarNumber" query-label="车牌号查询"
                                @update:queryName="handleCommitBackQueryCarNumber"
                                :limit-info="{dictType: 'order_cars'}">
                    <template #table-columns>
                      <el-table-column label="车牌号" align="center" prop="dictLabel"/>
                    </template>
                  </SearchOption>
                </el-col>
              </el-row>
            </el-form-item>
            <el-form-item label="期初余额" prop="startCardSurplus">
              <el-input v-model="oilCardConsumeInfo.startCardSurplus" placeholder="请输入期初余额"/>
            </el-form-item>
            <!--            途中是否自己充钱 如果自己充了 那么下面的保存填写后要加上这个充值金额，如果没充，默认是0-->
            <el-form-item label="途中是否充值">
              <el-radio v-model="isRecharge" label="1">是</el-radio>
              <el-radio v-model="isRecharge" label="2">否</el-radio>
            </el-form-item>
            <el-form-item label="充值金额" prop="rechargeMoney" v-if="isRecharge === '1'">
              <el-input v-model="oilCardConsumeInfo.rechargeMoney"
                        placeholder="请输入充值金额,此金额为过程中使用现金充值金额"/>
            </el-form-item>
            <el-form-item label="加油量" prop="refuelingNumber">
              <el-input v-model="oilCardConsumeInfo.refuelingNumber" placeholder="请输入加油量"/>
            </el-form-item>
            <el-form-item label="单价" prop="unitPrice">
              <el-input v-model="oilCardConsumeInfo.unitPrice" placeholder="请输入单价"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-row>
              <el-form-item label="加油金额(元）" prop="refuelingMoney">
                <el-input v-model="oilCardConsumeInfo.refuelingMoney" placeholder="请输入加油金额(元）"/>
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item label="加油小票附件" prop="attachmentOiladd">
                <el-row>
                  <el-col :span="20">
                    <el-input v-model="oilCardConsumeInfo.attachmentOiladd" placeholder="加油小票附件路径" disabled/>
                  </el-col>
                  <el-col :span="4"
                          v-if="oilCardConsumeInfo.attachmentOiladd !== null && oilCardConsumeInfo.attachmentOiladd !== ''">
                    <el-button size="mini" @click="checkPath(oilCardConsumeInfo.attachmentOiladd)">查看附件
                    </el-button>
                  </el-col>
                </el-row>
                <el-row justify="center">
                  <el-col :span="20">
                    <el-upload
                      class="upload-demo"
                      drag
                      :action="uploadFileUrl"
                      :headers="headers"
                      :limit="1"
                      multiple :on-success="handleFileSuccess">
                      <i class="el-icon-upload"></i>
                      <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                    </el-upload>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item label="备注" prop="comments">
                <el-input v-model="oilCardConsumeInfo.comments" placeholder="请输入备注"/>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitOilCard">保存填写</el-button>
        <el-button type="primary" @click="clearOilCard">清除填写</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
import {listCarApply, delCarApply, addCarApply,} from "@/api/system/carApply";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {mixin_businesstrip_car_apply} from "../../dashboard/mixins/bussiness/businesstrip_car_apply";
import {listData} from "../../../api/system/dict/data";
import SearchOption from "../../../components/SearchOption.vue";
import {listOilCard} from "../../../api/system/oilCard";
import Treeselect from "@riophae/vue-treeselect";
import {listDept} from "@/api/system/dept";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";
import CheckFiles from "../../../components/CheckFiles.vue";
import {getCarApply, updateCarApply} from "../../../api/system/carApply";
import {mixin_checkfile} from "../../dashboard/mixins/checkfiles/mixin_checkfile";

export default {
  name: "CarApply",
  components: {CheckFiles, Treeselect, SearchOption},
  mixins: [mixin_printHTML, mixin_businesstrip_car_apply, mixin_checkfile],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 车辆使用申请表格数据
      carApplyList: [],
      deptOptions: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        bTripId: null,
        applyDate: null,
        applyUser: null,
        department: null,
        carNo: null,
        isUseOilCard: null,
        peers: null,
        startTime: null,
        endTime: null,
        ApplyPurpose: null,
        startMile: null,
        startCarState: null,
        endMile: null,
        endCarState: null,
        miles: null,
        backStopPlace: null,
        violationsCount: null,
        fine: null,
        isMaintenance: null,
        maintenanceMoney: null,
        refuelingFrequency: null,
        dispatchPerson: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null,
        path: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `申请时间`, visible: true},
        {key: 1, label: `申请人`, visible: true},
        {key: 2, label: `部门`, visible: true},
        {key: 3, label: `车牌`, visible: true},
        {key: 4, label: `是否携带油卡`, visible: true},
        {key: 5, label: `随同乘车人员`, visible: true},
        {key: 6, label: `用车时间`, visible: true},
        {key: 7, label: `还车时间`, visible: true},
        {key: 8, label: `用车事由`, visible: true},
        {key: 9, label: `出车前里程`, visible: true},
        {key: 10, label: `出车前车况`, visible: true},
        {key: 11, label: `回来后历程`, visible: true},
        {key: 12, label: `回来后车况`, visible: true},
        {key: 13, label: `用车里程数`, visible: true},
        {key: 14, label: `回程停靠位置`, visible: true},
        {key: 15, label: `行程中违法次数`, visible: true},
        {key: 16, label: `违章罚款金额`, visible: true},
        {key: 17, label: `行程中是否维修/保养`, visible: true},
        {key: 18, label: `保养金额`, visible: true},
        {key: 19, label: `行程中使用加油卡加油次数`, visible: true},
        {key: 20, label: `派车人`, visible: true},
        {key: 21, label: `备注`, visible: true},
        {key: 22, label: `附件路径`, visible: true},

      ],
    };
  },
  created() {
    this.getList();
    listDept().then(response => {
      this.deptOptions = this.handleTree(response.data, "deptId");
    });
    if (localStorage.getItem('carapply-columns') === 'null'
      || !localStorage.getItem('carapply-columns')) {
      //设置localStorage
      localStorage.setItem("carapply-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('carapply-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("carapply-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    updateCarApply() {
      return updateCarApply
    },
    getCarApply() {
      return getCarApply
    },
    listOilCard,
    listData,
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children;
      }
      return {
        id: node.deptName,
        label: node.deptName,
        children: node.children
      };
    },
    /** 查询车辆使用申请列表 */
    getList() {
      this.loading = true;
      listCarApply(this.queryParams).then(response => {
        this.carApplyList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        bTripId: null,
        applyDate: null,
        applyUser: null,
        department: null,
        carNo: null,
        isUseOilCard: '0',
        peers: null,
        startTime: null,
        endTime: null,
        applyPurpose: null,
        startMile: null,
        startCarState: null,
        endMile: null,
        endCarState: null,
        miles: null,
        backStopPlace: null,
        violationsCount: null,
        fine: null,
        isMaintenance: '否',
        maintenanceMoney: null,
        refuelingFrequency: null,
        dispatchPerson: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null,
        path: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加车辆使用申请";
      this.form.applyUser = this.trueName
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getCarApply(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改车辆使用申请";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateCarApply(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addCarApply(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除车辆使用申请编号为"' + ids + '"的数据项？').then(function () {
        return delCarApply(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/carApply/export', {
        ...this.queryParams
      }, `carApply_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
