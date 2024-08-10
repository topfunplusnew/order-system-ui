<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="加油卡卡号" prop="oilCardNo">
        <el-input
          v-model="queryParams.oilCardNo"
          placeholder="请输入加油卡卡号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <!--      <el-form-item label="使用加油卡时间" prop="useDate">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.useDate"-->
      <!--          placeholder="请输入使用加油卡时间"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="使用加油卡车辆车牌号" prop="carNo">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.carNo"-->
      <!--          placeholder="请输入使用加油卡车辆车牌号"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="地点、事由" prop="destination">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.destination"-->
      <!--          placeholder="请输入地点、事由"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="充值金额(元）" prop="rechargeMoney">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.rechargeMoney"-->
      <!--          placeholder="请输入充值金额(元）"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="期初余额" prop="startCardSurplus">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.startCardSurplus"-->
      <!--          placeholder="请输入期初余额"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="主卡转副卡充值金额" prop="toPlusCardMoney">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.toPlusCardMoney"-->
      <!--          placeholder="请输入主卡转副卡充值金额"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="加油量" prop="refuelingNumber">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.refuelingNumber"-->
      <!--          placeholder="请输入加油量"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="单价" prop="unitPrice">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.unitPrice"-->
      <!--          placeholder="请输入单价"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="加油金额(元）" prop="refuelingMoney">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.refuelingMoney"-->
      <!--          placeholder="请输入加油金额(元）"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="是否有小票" prop="isTicket">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.isTicket"-->
      <!--          placeholder="请输入是否有小票"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="加油卡余额" prop="endCardSurplus">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.endCardSurplus"-->
      <!--          placeholder="请输入加油卡余额"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <!--      <el-form-item label="备注" prop="comments">-->
      <!--        <el-input-->
      <!--          v-model="queryParams.comments"-->
      <!--          placeholder="请输入备注"-->
      <!--          clearable-->
      <!--          @keyup.enter.native="handleQuery"-->
      <!--        />-->
      <!--      </el-form-item>-->
      <el-form-item label="使用加油卡时间">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:oilcard:add']"
        >新增加油卡信息
        </el-button>
      </el-col>
      <!--      加油卡充值功能-->
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleMoney"
        >加油卡充值
        </el-button>
      </el-col>
      <!--      <el-col :span="1.5">-->
      <!--        <el-button
                type="success"
                plain
                icon="el-icon-edit"
                size="mini"
                @click="handleUpdate"
                :disabled="single"
                v-hasPermi="['system:oilcard:edit']"
              >修改
              </el-button>-->
      <!--记录为空时可以点按钮-->
      <!--      </el-col>-->
      <!--      <el-col :span="1.5">-->
      <!--        <el-button
                type="danger"
                plain
                icon="el-icon-delete"
                size="mini"
                :disabled="multiple"
                @click="handleDelete"
                v-hasPermi="['system:oilcard:remove']"
              >删除
              </el-button>-->
      <!--记录为空时可以点按钮-->
      <!--      </el-col>-->
      <!--      <el-col :span="1.5">-->
      <!--        <el-button
                type="warning"
                plain
                icon="el-icon-download"
                size="mini"
                @click="handleExport"
                v-hasPermi="['system:oilcard:export']"
              >导出
              </el-button>-->
      <!--      </el-col>-->
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns">
        <template v-slot:print>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-printer"
              size="mini"
              @click="printHTML"
            >
              <!--              v-hasPermi="['system:oilcard:export']"-->
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
              v-hasPermi="['system:oilcard:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="oilCardList" @selection-change="handleSelectionChange" id="printBox"
              v-horizontal-scroll="'always'">
      <!--      <el-table-column type="selection" width="55" align="center">-->
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="加油卡卡号" align="center" prop="oilCardNo" v-if="columns[0].visible"/>
      <el-table-column label="使用加油卡时间" align="center" prop="useDate" v-if="columns[1].visible"/>
      <el-table-column label="使用加油卡车辆车牌号" align="center" prop="carNo" v-if="columns[2].visible"/>
      <el-table-column label="地点、事由" align="center" prop="destination" v-if="columns[3].visible"/>
      <el-table-column label="充值金额(元）" align="center" prop="rechargeMoney" v-if="columns[4].visible"/>
      <el-table-column label="期初余额" align="center" prop="startCardSurplus" v-if="columns[5].visible"/>
      <el-table-column label="主卡转副卡充值金额" align="center" prop="toPlusCardMoney" v-if="columns[6].visible"/>
      <el-table-column label="加油量" align="center" prop="refuelingNumber" v-if="columns[7].visible"/>
      <el-table-column label="单价" align="center" prop="unitPrice" v-if="columns[8].visible"/>
      <el-table-column label="加油金额(元）" align="center" prop="refuelingMoney" v-if="columns[9].visible"/>
      <el-table-column label="是否有小票" align="center" prop="isTicket" v-if="columns[10].visible"/>
      <el-table-column label="加油卡余额" align="center" prop="endCardSurplus" v-if="columns[11].visible"/>
      <el-table-column label="加油卡类别" align="center" prop="oilType" v-if="columns[12].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[13].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
        <template slot-scope="scope">
          <!--          <el-button
                      size="mini"
                      type="text"
                      icon="el-icon-edit"
                      @click="handleUpdate(scope.row)"
                      v-hasPermi="['system:oilcard:edit']"
                    >修改
                    </el-button>
                    <el-button
                      size="mini"
                      type="text"
                      icon="el-icon-delete"
                      @click="handleDelete(scope.row)"
                      v-hasPermi="['system:oilcard:remove']"
                    >删除
                    </el-button>-->
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:oilcard:edit']"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:oilcard:remove']"
          >删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <!--分页-->
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改加油卡信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>

      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="加油卡卡号" prop="oilCardNo">
          <el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号"/>
        </el-form-item>
        <el-form-item label="使用加油卡时间" prop="useDate">
          <el-input v-model="form.useDate" placeholder="请输入使用加油卡时间"/>
        </el-form-item>
        <el-form-item label="使用加油卡车辆车牌号" prop="carNo">
          <el-input v-model="form.carNo" placeholder="请输入使用加油卡车辆车牌号"/>
        </el-form-item>
        <el-form-item label="地点、事由" prop="destination">
          <el-input v-model="form.destination" placeholder="请输入地点、事由"/>
        </el-form-item>
        <el-form-item label="充值金额(元）" prop="rechargeMoney">
          <el-input v-model="form.rechargeMoney" placeholder="请输入充值金额(元）"/>
        </el-form-item>
        <el-form-item label="期初余额" prop="startCardSurplus">
          <el-input v-model="form.startCardSurplus" placeholder="请输入期初余额"/>
        </el-form-item>
        <el-form-item label="主卡转副卡充值金额" prop="toPlusCardMoney">
          <el-input v-model="form.toPlusCardMoney" placeholder="请输入主卡转副卡充值金额"/>
        </el-form-item>
        <el-form-item label="加油量" prop="refuelingNumber">
          <el-input v-model="form.refuelingNumber" placeholder="请输入加油量"/>
        </el-form-item>
        <el-form-item label="单价" prop="unitPrice">
          <el-input v-model="form.unitPrice" placeholder="请输入单价"/>
        </el-form-item>
        <el-form-item label="加油金额(元）" prop="refuelingMoney">
          <el-input v-model="form.refuelingMoney" placeholder="请输入加油金额(元）"/>
        </el-form-item>
        <el-form-item label="是否有小票" prop="isTicket">
          <el-input v-model="form.isTicket" placeholder="请输入是否有小票"/>
        </el-form-item>
        <el-form-item label="加油卡余额" prop="endCardSurplus">
          <el-input v-model="form.endCardSurplus" placeholder="请输入加油卡余额"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注 "/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-dialog>

    <!--    加油卡充值弹窗-->
    <el-dialog title="加油卡充值" :visible.sync="moneyDialogVisible" width="500px" append-to-body>
      <el-form :model="moneyInfo" :rules="rules" label-width="80px">
        <el-form-item label="加油卡卡号" prop="oilCardNo">
          <el-row>
            <!--        todo    要选择充值类型 圈存功能-->
            <el-col :span="10">
              <el-input v-model="moneyInfo.oilCardNo" placeholder="请输入加油卡卡号"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listOilCard" title="选择加油卡" icon="el-icon-search"
                            :limit-info="{oilType:'主卡'}" @commitBack="handleCommitBack">
                <template #table-columns>
                  <el-table-column prop="oilCardNo" label="加油卡卡号"/>
                  <el-table-column prop="moneyAmount" label="加油卡余额"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitMoney">确 定</el-button>
        <el-button @click="moneyDialogVisible = false">取 消</el-button>
      </div>
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-dialog>
  </div>
</template>

<script>
import {listOilCard, getOilCard, delOilCard, addOilCard, updateOilCard} from "@/api/system/oilCard";
import SearchOption from "@/components/SearchOption.vue";

export default {
  name: "OilCard",
  components: {SearchOption},
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
      // 加油卡信息表格数据
      oilCardList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        oilCardNo: null,
        useDate: null,
        carNo: null,
        destination: null,
        rechargeMoney: null,
        startCardSurplus: null,
        toPlusCardMoney: null,
        refuelingNumber: null,
        unitPrice: null,
        refuelingMoney: null,
        isTicket: null,
        endCarState: null,
        oilType: null,
        moneyAmount: null,
        comments: null,
        submittime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {},
      columns: [
        {key: 0, label: `加油卡卡号`, visible: true},
        {key: 1, label: `使用加油卡时间`, visible: true},
        {key: 2, label: `使用加油卡车辆车牌号`, visible: true},
        {key: 3, label: `地点、事由`, visible: true},
        {key: 4, label: `充值金额(元)`, visible: true},
        {key: 5, label: `期初余额`, visible: true},
        {key: 6, label: `主卡转副卡充值金额`, visible: true},
        {key: 7, label: `加油量`, visible: true},
        {key: 8, label: `单价`, visible: true},
        {key: 9, label: `加油金额(元)`, visible: true},
        {key: 10, label: `是否有小票`, visible: true},
        {key: 11, label: `加油卡余额`, visible: true},
        {key: 12, label: `加油卡类别`, visible: true},
        {key: 13, label: `备注`, visible: true},
      ],

      //加油卡充值界面的弹窗
      moneyDialogVisible: false,
      //加油卡信息
      moneyInfo: {}
    };
  },

  created() {
    this.getList();
    if (localStorage.getItem('oilcard-columns') === 'null'
      || !localStorage.getItem('oilcard-columns')) {
      //设置localStorage
      localStorage.setItem("oilcard-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('oilcard-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("oilcard-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    listOilCard,
    //加油卡充值
    handleMoney() {
      this.moneyDialogVisible = true
    },
    //确认银行卡充值
    submitMoney() {
      this.moneyDialogVisible = false
    },
    handleCommitBack(val) {
      console.log(val)
      //自动填充加油卡信息
      //todo
    },
    /** 查询加油卡信息列表 */
    getList() {
      this.loading = true;
      listOilCard(this.queryParams).then(response => {
        this.oilCardList = response.rows;
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
        oilCardNo: null,
        useDate: null,
        carNo: null,
        destination: null,
        rechargeMoney: null,
        startCardSurplus: null,
        toPlusCardMoney: null,
        refuelingNumber: null,
        unitPrice: null,
        refuelingMoney: null,
        isTicket: null,
        endCarState: null,
        oilType: null,
        moneyAmount: null,
        comments: null,
        submittime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
      };
      this.resetForm("form");
    },
    // 打印按钮操作
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
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
      this.title = "添加加油卡信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getOilCard(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改加油卡信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateOilCard(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOilCard(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除加油卡信息编号为"' + ids + '"的数据项？').then(function () {
        return delOilCard(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/oilCard/export', {
        ...this.queryParams
      }, `oilCard_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
