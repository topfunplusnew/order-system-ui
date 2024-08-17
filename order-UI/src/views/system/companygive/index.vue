<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="供应商名称" prop="companyName">
        <el-input
          v-model="queryParams.companyName"
          placeholder="请输入供应商名称"
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
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:company:add']"
        >新增供应商信息
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-search"
          size="mini"
          @click="handleSearch"
        >账号搜索
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
            </el-button>
          </el-col>
        </template>
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:company:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table border v-loading="loading" :data="companyList" @selection-change="handleSelectionChange" id="printBox"
              height="300px" v-horizontal-scroll="'always'">
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="供应商" align="center" prop="companyName" v-if="columns[0].visible"/>
      <el-table-column label="地址" align="center" prop="address" v-if="columns[1].visible"/>
      <el-table-column label="联系人" align="center" prop="relationName" v-if="columns[2].visible"/>
      <el-table-column label="银行卡账号" align="center" prop="bankNo" v-if="columns[3].visible"/>
      <el-table-column label="老板电话" align="center" prop="leaderTel" v-if="columns[3].visible"/>
      <el-table-column label="开户名" align="center" prop="acountsName" v-if="columns[4].visible"/>
      <el-table-column label="开户行" align="center" prop="bankName" v-if="columns[5].visible"/>
      <el-table-column label="电话" align="center" prop="relationTel" v-if="columns[6].visible"/>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[7].visible"/>
      <!--      <el-table-column label="乡镇" align="center" prop="county"/>-->
      <!--      <el-table-column label="余额" align="center" prop="surplusMoney"/>-->
      <!--      <el-table-column label="业务员" align="center" prop="salesman"/>-->
      <!--      <el-table-column label="区域" align="center" prop="region" v-if="columns[6].visible"/>-->
      <!--      <el-table-column label="销售经理" align="center" prop="salesManager" v-if="columns[7].visible"/>-->
      <!--      <el-table-column label="省" align="center" prop="province"/>-->
      <!--      <el-table-column label="市县" align="center" prop="city"/>-->
      <!--      <el-table-column label="添加时间" align="center" prop="addtime"/>-->
      <!--      <el-table-column label="操作人员ID" align="center" prop="userId"/>-->
      <!--      <el-table-column label="操作人员姓名" align="center" prop="UserName"/>-->
      <!--      <el-table-column label="删除标记" align="center" prop="delFlag"/>-->
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180">
        <template slot-scope="scope">
          <el-button
            size="mini"
            @click="jumpBankNo(scope.row)"
          >银行卡号
          </el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:company:edit']"
          >编辑
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:company:remove']"
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

    <!-- 添加或修改供应商、供应商信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="供应商名称" prop="relationName">
          <el-input v-model="form.companyName" placeholder="请输入供应商名称"/>
        </el-form-item>
        <!--        <el-form-item label="公司名称" prop="companyName">-->
        <!--          <el-input v-model="form.companyName" type="textarea" placeholder="请输入内容"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="供应商电话" prop="relationTel">
          <el-input v-model="form.relationTel" placeholder="请输入联系人电话"/>
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入地址"/>
        </el-form-item>
        <el-form-item label="联系人" prop="address">
          <el-input v-model="form.relationName" placeholder="请输入联系人"/>
        </el-form-item>
        <!--        <el-form-item label="开户行" prop="bankName">-->
        <!--          <el-input v-model="form.bankName" placeholder="请输入开户行"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="开户名" prop="acountsName">-->
        <!--          <el-input v-model="form.acountsName" placeholder="请输入开户名"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="账号" prop="bankNo">-->
        <!--          <el-input v-model="form.bankNo" placeholder="请输入账号"/>-->
        <!--        </el-form-item>-->
        <!--        <el-form-item label="余额" prop="surplusMoney">-->
        <!--          <el-input v-model="form.surplusMoney" placeholder="请输入余额"/>-->
        <!--        </el-form-item>-->
        <el-form-item label="业务员" prop="salesman">
          <el-input v-model="form.salesman" placeholder="请输入业务员"/>
        </el-form-item>
        <el-form-item label="老板姓名" prop="leader">
          <el-input v-model="form.leader" placeholder="请输入老板姓名"/>
        </el-form-item>
        <el-form-item label="老板电话" prop="leaderTel">
          <el-input v-model="form.leaderTel" placeholder="请输入联系人电话"/>
        </el-form-item>
        <el-form-item label="省" prop="province">
          <el-input v-model="form.province" placeholder="请输入省"/>
        </el-form-item>
        <el-form-item label="市县" prop="city">
          <el-input v-model="form.city" placeholder="请输入市县"/>
        </el-form-item>
        <el-form-item label="乡镇" prop="county">
          <el-input v-model="form.county" placeholder="请输入乡镇"/>
        </el-form-item>
        <el-form-item label="备注" prop="comments">
          <el-input v-model="form.comments" placeholder="请输入备注"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!--    银行卡-->
    <el-dialog title="银行卡号" :visible.sync="dialogFormVisible">
      <el-form :model="currentInfo">
        <el-row :gutter="4">
          <el-col :span="4">
            {{ currentInfo.companyName }}
          </el-col>
          <el-col :span="8">
            <el-form-item label="账号" :label-width="formLabelWidth">
              <el-input v-model="currentInfo.bankNo" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="户名" :label-width="formLabelWidth">
              <el-input v-model="currentInfo.acountsName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="3">
            <el-button type="primary" @click="handleCommitCompanyGive">提交</el-button>
          </el-col>
        </el-row>
      </el-form>

      <hr/>
      <el-row>
        <span style="font-weight: bolder">已绑定银行卡列表</span>
      </el-row>
      <el-row>
        <el-table v-loading="loading" :data="singleInfo" @selection-change="handleSelectionChange">
          <!--          添加银行卡信息-->
          <!--          <template #append>-->
          <!--            <div style="text-align: center">-->
          <!--              <el-button type="primary" @click="handleAddBankInfo">添加银行卡信息</el-button>-->
          <!--            </div>-->
          <!--          </template>-->
          <el-table-column label="序号" align="center" prop="id"/>
          <!--          <el-table-column label="供应商名称" align="center" prop="relationName"/>-->
          <el-table-column label="户名" align="center" prop="acountsName"/>
          <el-table-column label="银行卡号" align="center" prop="bankNo"/>
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right" width="180">
            <template slot-scope="scope">
              <el-button
                size="mini"
                @click="handleUpdateBankPop(scope.row)"
                v-hasPermi="['system:company:edit']"
              ><i class="el-icon-edit"></i>
              </el-button>
              <el-button
                size="mini"
                @click="handleDelete(scope.row)"
                v-hasPermi="['system:company:remove']"
              ><i class="el-icon-delete"></i>
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-row>


      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
      </div>
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />


      <el-dialog title="操作银行卡" :visible.sync="dialogBankInfoVisible" append-to-body>
        <el-form :model="queryBankInfo">
          <el-row :gutter="4">
            <el-col :span="8">
              <el-form-item label="账号类型" :label-width="formLabelWidth">
                <el-select v-model="queryBankInfo.acountsType" placeholder="请选择">
                  <el-option
                    v-for="item in acountsTypeList"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="账户名" :label-width="formLabelWidth">
                <el-input v-model="queryBankInfo.acountsName" autocomplete="off"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="3">
              <el-button type="primary" @click="handleSearchBankInfo">搜索</el-button>
            </el-col>
          </el-row>
        </el-form>
        <el-row>
          <el-table v-loading="loading" :data="bankInfo">
            <el-table-column label="银行卡号" align="center" prop="bankNo"/>
            <el-table-column label="账户类型" align="center" prop="acountsType"/>
            <el-table-column label="账户名" align="center" prop="acountsName"/>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right"
                             width="180">
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  @click="addThisBankInfo(scope.row)"
                >添加该银行卡
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-row>
        <div slot="footer" class="dialog-footer">
          <el-button @click="dialogBankInfoVisible = false">取 消</el-button>
          <el-button type="primary" @click="dialogBankInfoVisible = false">确 定</el-button>
        </div>
        <pagination
          v-show="total>0"
          :total="total"
          :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize"
          @pagination="getList"
        />
      </el-dialog>

    </el-dialog>


    <!--    账号搜索-->
    <el-dialog title="账号搜索" :visible.sync="dialogFormSearchVisible">
      <el-form :model="queryParams">
        <el-row :gutter="4">
          <el-col :span="8">
            <el-form-item label="供应商名称" :label-width="formLabelWidth">
              <el-input v-model="queryParams.relationName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="银行账号" :label-width="formLabelWidth">
              <el-input v-model="queryParams.bankNo" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="户名" :label-width="formLabelWidth">
              <el-input v-model="queryParams.acountsName" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
          <el-col>
            <el-button type="primary" @click="handleSearchCompanyGive" style="margin-left: 50px">提交</el-button>
          </el-col>
        </el-row>
      </el-form>
      <el-table v-loading="loading" :data="companyList" @selection-change="handleSelectionChange">
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="left" width="180">
          <template slot-scope="scope">
            <el-button
              type="danger"
              size="mini"
              @click="dialogFormSearchVisible = false"
            >确认
            </el-button>
          </template>
        </el-table-column>
        <el-table-column label="供应商名称" align="center" prop="relationName"/>
        <el-table-column label="银行卡号" align="center" prop="bankNo"/>
        <el-table-column label="户名" align="center" prop="acountsName"/>
      </el-table>
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
import {listCompany, getCompany, delCompany, addCompany, updateCompany} from "@/api/system/company";
import {listBankAccount} from "@/api/system/bankAccount";

export default {
  name: "Company",
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
      // 供应商、供应商信息表格数据
      companyList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        companyName: null,
        relationName: null,
        relationTel: null,
        address: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        surplusMoney: null,
        companyType: '供应商',
        salesman: null,
        leader: null,
        leaderTel: null,
        region: null,
        salesManager: null,
        province: null,
        city: null,
        county: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        surplusMoney: [
          {required: true, message: "余额不能为空", trigger: "blur"}
        ],
      },
      columns: [
        {key: 0, label: `供应商`, visible: true},
        {key: 1, label: `地址`, visible: true},
        {key: 2, label: `联系人`, visible: true},
        {key: 3, label: `银行卡账号`, visible: true},
        {key: 4, label: `开户名`, visible: true},
        {key: 5, label: `开户行`, visible: true},
        {key: 6, label: `电话`, visible: true},
        {key: 7, label: `备注`, visible: true},
      ],
      dialogFormSearchVisible: false,
      dialogFormVisible: false,
      formLabelWidth: '120px',
      //点击弹窗出来的搜索信息
      currentInfo: {
        companyType: '供应商',
        relationName: '',
        bankNo: '',
        bankName: '',
        acountsName: ''
      },
      //指定用户的信息银行卡相关信息
      singleInfo: [],

      bankInfo: [],
      dialogBankInfoVisible: false,
      queryBankInfo: {
        acountsType: '',
        acountsName: ''
      },

      //账户类型
      acountsTypeList: [{
        value: '己方公司',
        label: '己方公司'
      }, {
        value: '客户',
        label: '客户'
      }, {
        value: '供应商',
        label: '供应商'
      }, {
        value: '司机',
        label: '司机'
      }, {
        value: '其他',
        label: '其他'
      }]
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('companygive-columns') === 'null'
      || !localStorage.getItem('companygive-columns')) {
      //设置localStorage
      localStorage.setItem("companygive-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('companygive-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("companygive-columns", JSON.stringify(newVal))
      },
      deep: true,
    }
  },
  methods: {
    //银行卡搜索按钮
    handleSearchCompanyGive() {
      this.getList();
    },
    //账号搜索
    handleSearch() {
      this.dialogFormSearchVisible = true;
    },
    //点击银行卡后弹窗
    jumpBankNo(row) {
      this.currentInfo.relationName = row.relationName
      this.currentInfo.id = row.id
      this.currentInfo.relationTel = row.relationTel
      this.currentInfo.address = row.address;
      this.currentInfo.surplusMoney = row.surplusMoney
      this.currentInfo.salesman = row.salesman
      this.currentInfo.leader = row.leader
      this.currentInfo.leaderTel = row.leaderTel
      this.currentInfo.region = row.region
      this.currentInfo.salesManager = row.salesManager
      this.currentInfo.province = row.province
      this.currentInfo.city = row.city
      this.currentInfo.county = row.county
      this.currentInfo.comments = row.comments
      this.currentInfo.companyName = row.companyName
      this.dialogFormVisible = true
      //查询某供应商信息 账户名称应该是公司名称
      listBankAccount({companyId: row.id, acountsType: '供应商'}).then(res => {
        this.singleInfo = res.rows
      })
    },
    //添加银行卡信息
    handleAddBankInfo() {
      this.dialogBankInfoVisible = true;
      //查询所有银行卡信息
      listBankAccount().then(res => {
        this.bankInfo = res.rows;
      })
    },

    //查询银行卡
    handleSearchBankInfo() {
      listBankAccount({acountsType: this.queryBankInfo.acountsType, acountsName: this.queryBankInfo.acountsName})
        .then(res => {
          this.bankInfo = res.rows;
        })
    },
    addThisBankInfo(row) {
      console.log(row)
      this.dialogBankInfoVisible = false;
      this.dialogFormVisible = false;
      //添加银行卡信息

      //如果账户名不一样不允许添加银行卡
      if (this.currentInfo.companyName !== row.acountsName) {
        this.$message.error("不允许添加非己银行卡!");
      } else {
        this.currentInfo.bankNo = row.bankNo;
        this.currentInfo.bankName = row.bankName;
        this.currentInfo.acountsName = row.acountsName
        // 应该是调用修改客户信息的修改银行卡信息
        updateCompany(this.currentInfo).then(res => {
          this.$message.success("添加成功")
        })
      }
    },
    //弹出的银行卡信息点击提交
    handleCommitCompanyGive() {
      this.loading = true;
      updateCompany(this.currentInfo).then(res => {
        this.$modal.msgSuccess("修改成功");
        this.loading = false
      }).catch(err => {
        this.$modal.msgError("修改失败!" + err.msg);
      })
      listCompany({
        relationName: this.currentInfo.relationName,
        relationTel: this.currentInfo.relationTel
      }).then(res => {
        this.singleInfo = res.rows
      })
    },
    //打开的银行卡弹窗点击编辑
    handleUpdateBankPop(row) {
      this.currentInfo.bankNo = row.bankNo;
      this.currentInfo.acountsName = row.acountsName;
    },
    printHTML() {
      this.$print({
        printable: 'printBox',
        type: 'html',
        targetStyles: ['*'], // 打印内容使用所有HTML样式，没有设置这个属性/值，设置分页打印没有效果
      })
    },
    /** 查询供应商、供应商信息列表 */
    getList() {
      this.loading = true;
      listCompany(this.queryParams).then(response => {
        this.companyList = response.rows;
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
        companyName: null,
        relationName: null,
        relationTel: null,
        address: null,
        bankName: null,
        acountsName: null,
        bankNo: null,
        surplusMoney: null,
        companyType: '供应商',
        salesman: null,
        leader: null,
        leaderTel: null,
        region: null,
        salesManager: null,
        province: null,
        city: null,
        county: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
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
      this.title = "添加供应商信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getCompany(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改供应商信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            updateCompany(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            this.form.delFlag = null;
            this.form.addtime = null;
            this.form.updateTime = null;
            this.form.userId = null;
            addCompany(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除供应商编号为"' + ids + '"的数据项？').then(function () {
        return delCompany(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/company/export', {
        ...this.queryParams
      }, `company_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
