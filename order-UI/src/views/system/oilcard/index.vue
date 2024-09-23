<!-- 加油卡管理，要分开管理 分为加油卡主卡和加油卡副卡-->
<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="加油卡卡号" prop="oilCardNo">
        <el-input
          v-model="queryParams.oilCardNo"
          placeholder="请输入加油卡卡号"
          clearable
          @keyup.enter.native="handleQuery"
        />
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
    <el-row>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane lazy label="加油卡主卡管理" name="first">
          <el-table size="mini" border v-loading="loading" :data="mainOilCardList"
                    @selection-change="handleSelectionChange" id="printBox"
                    v-horizontal-scroll="'always'">
            <el-table-column label="加油卡卡号" align="center" prop="oilCardNo" v-if="columns[0].visible"/>
            <el-table-column label="当前金额" align="center" prop="moneyAmount" v-if="columns[1].visible"/>
            <el-table-column label="备注" align="center" prop="comments" v-if="columns[2].visible"/>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
              <template slot-scope="scope">
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
            v-show="MainTotal>0"
            :total="MainTotal"
            :page.sync="queryParams.pageNum"
            :limit.sync="queryParams.pageSize"
            @pagination="getList()"
          />
          <br/>
          <!--          加个换行,不然分页下部分缺失-->
        </el-tab-pane>
        <el-tab-pane lazy label="加油卡副卡管理" name="second">
          <el-table border v-loading="loading" :data="subCardList"
                    @selection-change="handleSelectionChange" id="printBox"
                    v-horizontal-scroll="'always'">
            <el-table-column label="加油卡卡号" align="center" prop="oilCardNo" v-if="columns[0].visible"/>
            <el-table-column label="当前金额" align="center" prop="moneyAmount" v-if="columns[1].visible"/>
            <el-table-column label="备注" align="center" prop="comments" v-if="columns[2].visible"/>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
              <template slot-scope="scope">
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
            v-show="SubTotal>0"
            :total="SubTotal"
            :page.sync="queryParams.pageNum"
            :limit.sync="queryParams.pageSize"
            @pagination="getList"
          />
          <br/>
          <!--          加个换行,不然分页下部分缺失-->
        </el-tab-pane>
      </el-tabs>


    </el-row>


    <!-- 添加或修改加油卡信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="加油卡卡号" prop="oilCardNo">
          <el-input v-model="form.oilCardNo" placeholder="请输入加油卡卡号"/>
        </el-form-item>
        <el-form-item label="加油卡类别" prop="oilType">
          <el-radio v-model="form.oilType" label="主卡">主卡</el-radio>
          <el-radio v-model="form.oilType" label="副卡">副卡</el-radio>
        </el-form-item>
        <el-form-item label="加油卡金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入使用加油卡金额"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入使用备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    加油卡充值弹窗-->
    <el-dialog title="加油卡充值" :visible.sync="moneyDialogVisible" width="500px" append-to-body>
      <el-form :model="moneyInfo" :rules="rules" label-width="120px">
        <el-form-item label="加油卡卡号" prop="oilCardNo">
          <el-row>
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
        <el-form-item label="请选择充值方式" prop="rechargeType">
          <el-select v-model="moneyInfo.rechargeType" placeholder="请选择充值方式">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="请输入充值金额" prop="rechargeMoney">
          <el-input v-model="moneyInfo.rechargeMoney" placeholder="请输入充值金额"/>
        </el-form-item>
        <el-form-item label="姓名" prop="rechargeName">
          <el-input disabled v-model="moneyInfo.rechargeName" placeholder="请输入姓名"/>
        </el-form-item>
        <el-form-item v-if="moneyInfo.rechargeType==='银行卡'" label="银行开户名" prop="acountsName">
          <el-col :span="10">
            <el-input v-model="moneyInfo.acountsName" placeholder="请输入银行开户名"/>
          </el-col>
          <el-col :span="4">
            <SearchOption :limit-info="{acountsType:'己方公司'}" :get-data="listBankAccount"
                          @commitBack="handleCommitBackBankAcount"
                          @update:queryName="handleUpdateQueryBankAcount" :query-name="queryBankAcount"
                          query-label="户名查找" query-info="acountsName">
              <template #table-columns>
                <el-table-column label="账户类型" align="center" prop="acountsType"/>
                <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                <el-table-column label="开户行" align="center" prop="bankName"/>
                <el-table-column label="公司名称" align="center" prop="companyName"/>
              </template>
            </SearchOption>
          </el-col>
        </el-form-item>
        <el-form-item v-if="moneyInfo.rechargeType==='银行卡'" label="银行账号" prop="bankNo">
          <el-input v-model="moneyInfo.bankNo" placeholder="请输入银行账号"/>
        </el-form-item>
        <el-form-item label="附件" prop="bankName">
          <file-upload @input="handleUpload"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitMoney">确 定</el-button>
        <el-button @click="moneyDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listOilCard, getOilCard, delOilCard, addOilCard, updateOilCard} from "@/api/system/oilCard";
import SearchOption from "@/components/SearchOption.vue";
import {excludeParams} from "@/api/tool/exclude";
import {listBankAccount} from "@/api/system/bankAccount";
import {addOilRecharge} from "@/api/system/oilRecharge";
import {mapGetters} from "vuex";
import {parseTime} from "@/utils/ruoyi";

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
      MainTotal: 0,
      SubTotal: 0,
      // 加油卡信息表格数据
      mainOilCardList: [],
      subCardList: [],
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
      form: {
        rechargeName: ''
      },
      // 表单校验
      rules: {
        oilCardNo: [
          {required: true, message: "加油卡卡号不能为空", trigger: "blur"}
        ],
        oilType: [
          {required: true, message: "加油卡类别不能为空", trigger: "blur"}
        ],
        moneyAmount: [
          {required: true, message: "加油金额不能为空", trigger: "blur"}
        ]
      },
      columns: [
        {key: 0, label: `加油卡卡号`, visible: true},
        {key: 1, label: `当前金额`, visible: true},
        {key: 2, label: `备注`, visible: true},
      ],

      //加油卡充值界面的弹窗
      moneyDialogVisible: false,
      //加油卡信息
      moneyInfo: {
        oilCardNo: '',
        rechargeType: '',
        rechargeMoney: '',
        rechargeDate: parseTime(new Date()),
        rechargeName: "",
        acountsName: "",
        bankNo: "",
        attachment: '',
        comments: ''
      },
      activeName: 'first',
      options: [{
        value: '现金',
        label: '现金'
      }, {
        value: '银行卡',
        label: '银行卡'
      }],
      queryBankAcount: ''
    };
  },
  computed: {
    change: {
      set(val) {
        this.isMain = !this.isMain
      },
      get() {
        return this.isMain
      }
    },
    ...mapGetters(['trueName'])
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
    },
    isMain(val) {
      console.log(val)
    }
  },
  methods: {
    listBankAccount,
    listOilCard,
    handleCommitBackBankAcount(val) {
      this.moneyInfo.acountsName = val.acountsName;
      this.moneyInfo.bankNo = val.bankNo;
    },
    handleUpdateQueryBankAcount(val) {
      this.queryBankAcount = val
    },
    handleUpload(val) {
      this.moneyInfo.attachment = val;
    },
    handleClick(tab, event) {
      console.log(tab.name, event);
      if (tab.name === 'first') {
      } else {
      }
    },
    //加油卡充值
    handleMoney() {
      this.moneyDialogVisible = true;
      this.moneyInfo.rechargeName = this.trueName;
    },
    //确认银行卡充值
    submitMoney() {
      //添加
      addOilRecharge(this.moneyInfo).then(res => {
        this.$message.success('充值成功')
      })
      this.moneyDialogVisible = false
    },
    handleCommitBack(val) {
      console.log(val)
      //自动填充加油卡信息
      this.moneyInfo.oilCardNo = val.oilCardNo
    },
    /** 查询加油卡信息列表 */
    getList() {
      this.loading = true;
      // 先获取主卡信息
      this.queryParams.oilType = '主卡';
      listOilCard(this.queryParams).then(response => {
        this.mainOilCardList = response.rows;
        this.MainTotal = response.total;
        this.loading = false;
      });
      // 再获取副卡信息
      this.queryParams.oilType = '副卡';
      listOilCard(this.queryParams).then(response => {
        this.subCardList = response.rows;
        this.SubTotal = response.total;
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
            this.form = excludeParams(this.form, this.$exclude)
            updateOilCard(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form = excludeParams(this.form, this.$exclude)
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
