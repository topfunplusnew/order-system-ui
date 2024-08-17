<script>

import SearchOption from "@/components/SearchOption.vue";
import {listCars} from "@/api/system/cars";
import SwitchBarItem from "@/components/SwitchBarItem.vue";
import ChatForm from "@/components/ChatForm.vue";
import AreaSelect from "@/components/AreaSelect.vue";

export default {
  components: {AreaSelect, ChatForm, SwitchBarItem, SearchOption},
  data() {
    return {
      //tableData每一个对象代表的是图表的每一个行
      tableData: [{
        date: '2016-05-03',
        name: '王小虎',
        province: '上海',
        city: '普陀区',
        address: '上海市普陀区金沙江路 1518 弄',
        zip: 200333
      }, {
        date: '2016-05-02',
        name: '王小虎',
        province: '上海',
        city: '普陀区',
        address: '上海市普陀区金沙江路 1518 弄',
        zip: 200333
      }, {
        date: '2016-05-04',
        name: '王小虎',
        province: '上海',
        city: '普陀区',
        address: '上海市普陀区金沙江路 1518 弄',
        zip: 200333
      }, {
        date: '2016-05-01',
        name: '王小虎',
        province: '上海',
        city: '普陀区',
        address: '上海市普陀区金沙江路 1518 弄',
        zip: 200333
      }, {
        date: '2016-05-08',
        name: '王小虎',
        province: '上海',
        city: '普陀区',
        address: '上海市普陀区金沙江路 1518 弄',
        zip: 200333
      }, {
        date: '2016-05-06',
        name: '王小虎',
        province: '上海',
        city: '普陀区',
        address: '上海市普陀区金沙江路 1518 弄',
        zip: 200333
      }, {
        date: '2016-05-07',
        name: '王小虎',
        province: '上海',
        city: '普陀区',
        address: '上海市普陀区金沙江路 1518 弄',
        zip: 200333
      }],

      modelValue: false,
      size: '',


      selected: [],
      options: [{
        value: '选项1',
        label: '黄金糕'
      }, {
        value: '选项2',
        label: '双皮奶'
      }, {
        value: '选项3',
        label: '蚵仔煎'
      }, {
        value: '选项4',
        label: '龙须面'
      }, {
        value: '选项5',
        label: '北京烤鸭'
      }],
      value: '',

      //省市县
      provinceList: [],
      cityList: [],
      districtList: [],
      //
      province: '',
      city: '',
      district: '',
    }

  }
  ,
  watch: {
    province(val) {
      console.log('省', val.name)
    }
  }
  ,
  created() {
    fetch('/area.json')
      .then(res => res.json())
      .then(res => {
        this.provinceList = res;
        console.log(res)
      })
  }
  ,
  methods: {
    //省改变了 要赋值市
    changeProvince(e) {
      console.log('e', e)
    }
  }
}
</script>

<template>
  <div>
    <h1 style="font-weight: bolder;color: red">!测试请添加el-row!</h1>
    <div>
      <AreaSelect/>
    </div>
    <div>
      <el-select v-model="province" placeholder="请选择省" @change="changeProvince">
        <el-option
          v-for="item in provinceList"
          :key="item.code"
          :label="item.name"
          :value="item.name">
        </el-option>
      </el-select>
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>
