<!--封装的通用搜索组件-->
<!--使用方式-->
<!--1.必传属性:-->
<!--getData: 获取数据的函数;-->
<!--limitInfo:限制条件，限制获取函数，例如查询客户类型为供应商信息-->
<!--2.选传属性:-->
<!--title:弹出框的标题-->
<!--icon:该组件的图标 默认为搜索-->
<!--queryInfo: 搜索框要查询的字段,-->
<!--queryName: 搜索框中输入的值 需要和$emit配合使用,-->
<!--queryLabel: 搜索框前面的文字提示-->
<!--3.插槽:-->
<!--table-columns: 表格的列配置-->
<!--4.回调函数-->
<!--@update:queryName:修改父组件传入的queryName的值 放置输入框无法输入值保证响应式-->
<!--@commitBack(val):点击确认后的回调，val中是需要自动填充的对象-->

<script>
export default {
  name: "SearchOption",
  props: {
    //弹出框的标题
    title: '',
    //图标信息
    icon: {
      type: String,
      default: 'el-icon-search'
    },
    disable: false,
    //获取数据的函数
    getData: {
      type: Function,
      required: true,
    },
    //约束条件 必须传入 这个字段为查找data的筛选属性，如果不需要传{}空对象
    limitInfo: {
      type: Object,
      required: true
    },
    //查询条件
    queryInfo: '',
    queryName: '',
    //查询标签
    queryLabel: ''
  },
  data() {
    return {
      //显示总行数
      total: 0,
      pageNum: 0,
      pageSize: 10,
      dialogVisible: false,
      //数据集 通过父组件传入函数来获取
      tableData: [],
      //加载效果
      loading: false,
      queryParams: {}
    }
  },
  created() {
  },
  computed: {
    query: {
      set(val) {
        this.$emit('update:queryName', val)
      },
      get() {
        return this.queryName
      }
    }
  },
  methods: {
    getList() {
      this.getData({...this.limitInfo, pageNum: this.pageNum, pageSize: this.pageSize}).then(res => {
        this.total = res.total;
        this.tableData = res.rows;
        this.loading = false;
      })
    },
    //点击弹窗
    handleCallBack() {
      this.dialogVisible = true
      this.loading = true;
      //获取数据 渲染表格
      this.getList()
    },
    //点击确认
    commitSomeThing(row) {
      this.$emit('commitBack', row)
      this.dialogVisible = false
    },
    //条件查询
    handleSearchInfo() {
      this.getData({
        ...this.limitInfo
      }).then(res => {
        this.total = res.total;
        this.tableData = res.rows;
        this.loading = false;
      })
    }
  },
  watch: {
    queryInfo: {
      handler(val) {
      }
    },
    query: {
      handler(val) {
        var queryParams = Object.create({}); //创建一个代理对象
        //传入的queryInfo是需要查询的字段名 queryName绑定的是需要查找的变量
        Object.defineProperty(queryParams, this.queryInfo, {
          value: this.query,
          enumerable: true
        })
        //Object.assign只能赋值可枚举属性
        Object.assign(this.limitInfo, queryParams)
      }
    },
    //监听数据
    tableData: {
      handler(val) {
      },
      deep: true,
      immediate: true
    }
  }
}
</script>

<template>
  <div>
    <!--    按钮-->
    <el-button size="mini" :icon="icon" @click="handleCallBack" type="primary"></el-button>
    <!--    弹窗-->
    <el-dialog
        :title="title"
        :visible.sync="dialogVisible"
        width="65%" append-to-body>
      <!--      弹出的表格内容-->
      <el-row>
        <div>
          <el-row :gutter="5">
            <el-col :span="4">
              <span style="font-weight: bolder">{{ queryLabel }}</span>
            </el-col>
            <el-col :span="10">
              <el-input type="text" placeholder="请输入" size="mini" v-model="query"></el-input>
            </el-col>
            <el-col :span="3">
              <el-button type="primary" @click="handleSearchInfo" size="mini">搜索</el-button>
            </el-col>
          </el-row>
        </div>
        <el-table :data="tableData" v-loading="loading" size="mini">
          <!--   这里给表格的数据行-->
          <slot name="table-columns"></slot>
          <!--          点击确认的地方-->
          <el-table-column
              fixed="right"
              label="操作"
              width="100">
            <template slot-scope="scope">
              <el-button @click="commitSomeThing(scope.row)" type="danger" size="small" :disabled="disable">确认
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination
            v-show="total>0"
            :total="total"
            :page.sync="pageNum"
            :limit.sync="pageSize"
            @pagination="getList"
        />
      </el-row>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">

</style>
