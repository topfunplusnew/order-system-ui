<!--封装的通用搜索组件-->
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
    //获取数据的函数
    getData: {
      type: Function,
      required: true
    },
    //约束条件
    limitInfo: {
      type: Object
    }
  },
  data() {
    return {
      dialogVisible: false,
      //数据集 通过父组件传入函数来获取
      tableData: [],
      //加载效果
      loading: false
    }
  },
  created() {
  },
  methods: {
    //点击弹窗
    handleCallBack() {
      this.dialogVisible = true
      this.loading = true;
      //获取数据 渲染表格
      this.getData(this.limitInfo).then(res => {
        this.tableData = res.rows;
        this.loading = false;
      })
    },
    //点击确认
    commitSomeThing(row) {
      this.$emit('commitBack', row)
      this.dialogVisible = false
    }
  }
}
</script>

<template>
  <div>
    <!--    按钮-->
    <el-button :icon="icon" @click="handleCallBack" type="primary"></el-button>
    <!--    弹窗-->
    <el-dialog
      :title="title"
      :visible.sync="dialogVisible"
      width="30%" append-to-body>
      <!--      弹出的表格内容-->
      <el-row>
        <el-table :data="tableData" v-loading="loading">
          <!--   这里给表格的数据行-->
          <slot name="table-columns"></slot>
          <!--          点击确认的地方-->
          <el-table-column
            fixed="right"
            label="操作"
            width="100">
            <template slot-scope="scope">
              <el-button @click="commitSomeThing(scope.row)" type="danger" size="small">确认</el-button>
            </template>
          </el-table-column>
        </el-table>
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
