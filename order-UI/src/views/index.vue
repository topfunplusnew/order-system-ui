<template>
  <div>
    <el-row style="margin:35px 0">
      <el-col :span="11" :offset="1">
        <el-row>
          <el-col :span="6">
            <span style="font-weight: bolder;font-size: 20px;color: #156fb2">
          今日发货列表
        </span>
          </el-col>
          <el-col :span="6">
            <span>
          <el-date-picker
            v-model="beginTime"
            type="date"
            size="mini"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            style="width: 120px;">
        </el-date-picker>
       </span>
          </el-col>
          <el-col :span="6">
            <span>
          <el-date-picker
            v-model="endTime"
            type="date"
            size="mini"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            style="width: 120px;">
        </el-date-picker>
        </span>
          </el-col>
          <el-col :span="2">
            <el-button type="primary" size="mini">搜索</el-button>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row>
          <el-col :span="6">
            <span style="font-weight: bolder;font-size: 20px;color: #156fb2">
          利润
        </span>
          </el-col>
          <el-col :span="6">
            <span>
          <el-date-picker
            v-model="beginTime"
            type="date"
            size="mini"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            style="width: 120px;">
        </el-date-picker>
       </span>
          </el-col>
          <el-col :span="6">
            <span>
          <el-date-picker
            v-model="endTime"
            type="date"
            size="mini"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            style="width: 120px;">
        </el-date-picker>
        </span>
          </el-col>
          <el-col :span="2">
            <el-button type="primary" size="mini">搜索</el-button>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row :gutter="30">
      <el-col :span="11" :offset="1">
        <el-table
          :data="tableData"
          height="250"
          border
          style="width: 100%">
          <el-table-column
            prop="date"
            label="日期"
            width="180">
          </el-table-column>
          <el-table-column
            prop="name"
            label="姓名"
            width="180">
          </el-table-column>
          <el-table-column
            prop="address"
            label="地址">
          </el-table-column>
        </el-table>
      </el-col>
      <el-col :span="12">
        <el-descriptions title="用户信息">
          <el-descriptions-item label="用户名">kooriookami</el-descriptions-item>
          <el-descriptions-item label="手机号">18100000000</el-descriptions-item>
          <el-descriptions-item label="居住地">苏州市</el-descriptions-item>
          <el-descriptions-item label="备注">
            <el-tag size="small">学校</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="联系地址">江苏省苏州市吴中区吴中大道 1188 号</el-descriptions-item>
        </el-descriptions>
      </el-col>
    </el-row>
    <!--    <el-row style="margin-top: 200px">-->
    <!--      <el-col :span="12" :offset="8">-->
    <!--        <LoadingWarning/>-->
    <!--      </el-col>-->
    <!--    </el-row>-->
  </div>
</template>

<script>
import LoadingWarning from "@/components/LoadingWarning.vue";

export default {
  name: "Index",
  components: {LoadingWarning},
  data() {
    return {
      beginTime: '',
      endTime: '',
      tableData: [{
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
  methods: {}
};
</script>

<style scoped lang="scss">

.button-search {
  line-height: 60px;
}
</style>

