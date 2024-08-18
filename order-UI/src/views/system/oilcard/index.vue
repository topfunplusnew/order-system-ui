<!--todo 加油卡管理，要分开管理 分为加油卡主卡和加油卡副卡-->
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

    <el-table border v-loading="loading" :data="oilCardList" @selection-change="handleSelectionChange" id="printBox"
              v-horizontal-scroll="'always'">
      <el-table-column label="加油卡卡号" align="center" prop="oilCardNo" v-if="columns[0].visible"/>
      <el-table-column label="加油卡类别" align="center" prop="oilType" v-if="columns[1].visible"/>
      <el-table-column label="当前金额" align="center" prop="moneyAmount" v-if="columns[2].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[3].visible"/>
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
        <el-form-item label="加油卡类别" prop="oilType">
          <el-radio v-model="form.oilType" label="主卡">主卡</el-radio>
          <el-radio v-model="form.oilType" label="副卡">副卡</el-radio>
        </el-form-item>
        <el-form-item label="加油卡金额" prop="moneyAmount">
          <el-input v-model="form.moneyAmount" placeholder="请输入使用加油卡时间"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入使用加油卡时间"/>
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
        {key: 1, label: `加油卡类别`, visible: true},
        {key: 2, label: `当前金额`, visible: true},
        {key: 3, label: `备注`, visible: true},
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
    /*listOilCard,*/
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
