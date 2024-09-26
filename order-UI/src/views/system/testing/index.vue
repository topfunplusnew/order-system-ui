<script>

import SearchOption from "@/components/SearchOption.vue";
import SwitchBarItem from "@/components/SwitchBarItem.vue";
import ChatForm from "@/components/ChatForm.vue";
import AreaSelect from "@/components/AreaSelect.vue";
import EditReason from "@/components/EditReason.vue";
import {TableName} from "@/api/tool/enums";
import ShowLabel from "@/components/ShowLabel.vue";

// jsondiffpatch
import {create} from 'jsondiffpatch'
import {format} from "jsondiffpatch/lib/formatters/html";
import 'jsondiffpatch/lib/formatters/styles/html.css'

export default {
  computed: {
    TableName() {
      return TableName
    },
    // 映射对象 要求传入一个属性，从this.mapper中获取映射属性，并且赋值到原有属性位置
    mapProp() {

    }
  },
  components: {ShowLabel, EditReason, AreaSelect, ChatForm, SwitchBarItem, SearchOption},
  data() {
    return {
      diffPatcher: null,
      // 映射对象
      mapper: {
        'name': '姓名',
        'age': '年龄',
        'address': '地址',
        'address.city': '城市',
        'address.street': '街道'
      },
      testObj1: {
        name: '张三',
        age: 18,
        address: {
          city: '北京',
          street: '黄埔'
        }
      },
      testObj2: {
        name: '李四',
        age: 25,
        address: {
          city: '天津',
          street: '狗不理'
        }
      }
    }
  },
  created() {
  },
  mounted() {
    const order1 = {
      [this.mapper.name]: '张三',
      [this.mapper.age]: 18,
      [this.mapper.address]: {
        [this.mapper["address.city"]]: '北京',
        [this.mapper["address.street"]]: '黄埔'
      },
    }
    const order2 = {
      [this.mapper.name]: '王五',
      [this.mapper.age]: 28,
      [this.mapper.address]: {
        [this.mapper["address.city"]]: '山东',
        [this.mapper["address.street"]]: '菏泽'
      },
    }
    this.diffPatcher = create()
    const diff = this.diffPatcher.diff(order1, order2)
    console.log(diff)
    document.getElementById('compare').innerHTML = format(diff, order2);
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
      <el-row>
        <EditReason :table-name="TableName.PAYMENT" :tid="1"/>
      </el-row>
    </div>
    <el-row>
      <ShowLabel/>
    </el-row>
    <el-row>
      <div id="compare" style="width: 500px;height: 500px;border:1px solid red">

      </div>
    </el-row>
  </div>
</template>

<style scoped lang="scss">

</style>
