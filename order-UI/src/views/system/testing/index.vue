<script>

import SearchOption from "@/components/SearchOption.vue";
import {listCars} from "@/api/system/cars";
import SwitchBarItem from "@/components/SwitchBarItem.vue";

export default {
  components: {SwitchBarItem, SearchOption},
  data() {
    return {
      //tableData每一个对象代表的是图表的每一个行
      tableData: [{
        id: '12987122',
        name: '王兄胡',
        amount1: '234',
        amount2: '3.2',
        amount3: 10,
      }, {
        id: '12987123',
        name: '王小虎',
        amount1: '165',
        amount2: '4.43',
        amount3: 12
      }, {
        id: '12987124',
        name: '王小虎',
        amount1: '324',
        amount2: '1.9',
        amount3: 9
      }, {
        id: '12987125',
        name: '王小虎',
        amount1: '621',
        amount2: '2.2',
        amount3: 17
      }, {
        id: '12987126',
        name: '王小虎',
        amount1: '539',
        amount2: '4.1',
        amount3: 15
      }],

      modelValue: false
    };
  },
  methods: {

    listCars,
    //统计方法
    getSummaries(param) {
      console.log(param)
      //columns是列数据 data是行数据
      const {columns, data} = param;
      //sums就是存放的每一个列的总数和
      const sums = [];

      //计算
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '总价';
          return;
        }
        const values = data.map(item => {
          return Number(item[column.property])
        });
        console.log(values)
        if (!values.every(value => isNaN(value))) {
          sums[index] = values.reduce((prev, curr) => {
            const value = Number(curr);
            if (!isNaN(value)) {
              return prev + curr;
            } else {
              return prev;
            }
          }, 0);
          sums[index] += ' 元';
        } else {
          sums[index] = 'N/A';
        }
      });

      return sums;
    },


    //确认的函数 可以用于给表单自动填充
    handleCommitBack(val) {
      console.log(val)
    },
    handleUpdate(val) {
      console.log(val)
    }
  },
  created() {

  }
};
</script>

<template>
  <div>
    <h1 style="font-weight: bolder;color: red">!测试请添加el-row!</h1>
    <el-row>
      <h1>表格组件测试</h1>
      <el-table
        :data="tableData"
        border
        show-summary
        style="width: 100%">
        <el-table-column
          prop="id"
          label="ID"
          width="180">
        </el-table-column>
        <el-table-column
          prop="name"
          label="姓名">
        </el-table-column>
        <el-table-column
          prop="amount1"
          sortable
          label="数值 1">
        </el-table-column>
        <el-table-column
          prop="amount2"
          sortable
          label="数值 2">
        </el-table-column>
        <el-table-column
          prop="amount3"
          sortable
          label="数值 3">
        </el-table-column>
      </el-table>

      <el-table
        :data="tableData"
        border
        height="250"
        :summary-method="getSummaries"
        show-summary
        style="width: 100%; margin-top: 20px">
        <!--        列信息-->
        <el-table-column
          prop="id"
          label="ID"
          width="180">
        </el-table-column>
        <el-table-column
          prop="name"
          label="姓名">
        </el-table-column>
        <el-table-column
          prop="amount1"
          label="数值 1（元）">
        </el-table-column>
        <el-table-column
          prop="amount2"
          label="数值 2（元）">
        </el-table-column>
        <el-table-column
          prop="amount3"
          label="数值 3（元）">
        </el-table-column>
      </el-table>
    </el-row>
    <el-row>
      <h2>测试封装组件</h2>

      <!--      封装组件用例-->
      <!--      需要的参数 icon:图标  title:弹窗标题 get-data:列表获取数据源函数  handleCommitBack:用于修改表单的函数 -->
      <!--      slot: 表格的列数据 -->
      <SearchOption icon="el-icon-platform-eleme" title="车辆信息" :get-data="listCars" @commitBack="handleCommitBack">
        <template v-slot:table-columns>
          <el-table-column
            prop="acountsName"
            label="户名"
            width="150">
          </el-table-column>
          <el-table-column
            prop="acountsType"
            label="账户类型"
            width="150">
          </el-table-column>
        </template>
      </SearchOption>
    </el-row>
    <el-row>
      <SwitchBarItem :model-value="modelValue" @update:modelValue="handleUpdate"/>
    </el-row>
  </div>
</template>

<style scoped lang="scss">

</style>
