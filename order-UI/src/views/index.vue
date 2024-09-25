<template>
  <div>
    <el-row style="margin: 35px 0">
      <el-col :xs="24" :sm="12" :md="11" :lg="11" :offset="xs ? 0 : 1">
        <el-row>
          <el-col :span="6">
            <span style="font-weight: bold; font-size: 24px; color: #156fb2">
              今日发货列表
            </span>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="beginTime"
              type="date"
              size="mini"
              value-format="yyyy-MM-dd"
              placeholder="开始日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="endTime"
              type="date"
              size="mini"
              value-format="yyyy-MM-dd"
              placeholder="结束日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="2">
            <el-button type="primary" size="mini">搜索</el-button>
          </el-col>
        </el-row>
      </el-col>
      <el-col :xs="24" :sm="12" :md="12" :lg="12">
        <el-row>
          <el-col :span="6">
            <span style="font-weight: bold; font-size: 24px; color: #156fb2">
              利润
            </span>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="beginTime"
              type="date"
              size="mini"
              value-format="yyyy-MM-dd"
              placeholder="开始日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="endTime"
              type="date"
              size="mini"
              value-format="yyyy-MM-dd"
              placeholder="结束日期"
            ></el-date-picker>
          </el-col>
          <el-col :span="2">
            <el-button type="primary" size="mini">搜索</el-button>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row :gutter="50">
      <el-col :xs="24" :sm="12" :md="11" :lg="11" :offset="xs ? 0 : 1">
        <el-table
          :data="tableData"
          height="250"
          border
          style="width: 100%"
          :header-cell-style="{ background: '#f0f0f0', color: '#333' }"
        >
          <el-table-column
            prop="date"
            label="日期"
            width="180"
          ></el-table-column>
          <el-table-column
            prop="name"
            label="姓名"
            width="180"
          ></el-table-column>
          <el-table-column
            prop="address"
            label="地址"
          ></el-table-column>
        </el-table>
      </el-col>
      <el-col :xs="24" :sm="12" :md="12" :lg="12">
        <el-table
          height="130"
          :empty-text="' '"
        >
          <el-table-column
            prop="date"
            label="￥0"
            align="center"
          >
            <el-table-column
              prop="date"
              label="利润总额"
            >
              <el-table-column
                prop="date"
                label="费用合计"
              ></el-table-column>
            </el-table-column>
            <el-table-column
              label="￥0"
            >
              <el-table-column
                label="￥0"
              ></el-table-column>
            </el-table-column>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "Index",
  data() {
    return {
      beginTime: '',
      endTime: '',
      tableData: [
        {
          date: '2016-05-03',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-02',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-04',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-01',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-08',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-06',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-07',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }]
    };
  },
  computed: {
    xs() {
      return this.$store.state.viewport === 'xs';
    }
  },
  methods: {}
};
</script>

<style scoped lang="scss">
@import "~element-ui/lib/theme-chalk/index.css";

.button-search {
  line-height: 60px;
}

.el-row {
  margin-bottom: 20px;
}

.el-col {
  border-radius: 4px;
}

.el-date-editor.el-input, .el-date-editor.el-input__inner {
  width: 120px;
}

.el-button--mini {
  padding: 6px 12px;
}

.el-table th {
  font-weight: bold;
}

.el-table td, .el-table th {
  padding: 8px;
}

.el-table .cell {
  font-size: 14px;
}

.el-table thead {
  font-weight: bold;
}

// Media Queries for responsiveness
@media (max-width: 768px) {
  .el-row {
    margin: 20px 0;
  }

  .el-col {
    margin-bottom: 10px;
  }

  .el-date-editor.el-input, .el-date-editor.el-input__inner {
    width: 100%;
  }

  .el-button--mini {
    width: 100%;
    margin-top: 10px;
  }

  .el-table {
    overflow-x: auto;
  }
}
</style>
