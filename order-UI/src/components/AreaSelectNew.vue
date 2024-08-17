<script>
export default {
  name: "AreaSelectNew",
  data() {
    return {
      //省市县
      provinceList: [],
      cityList: [],
      districtList: [],
      province: '',
      city: '',
      district: '',
    }
  },
  created() {
    fetch('/area.json')
      .then(res => res.json())
      .then(res => {
        this.provinceList = res;
        console.log(res)
      })
  },
  watch: {
    province(val) {
      this.provinceList.forEach(item => {
        if (item.name === val) {
          this.cityList = item.areaList;
        }
      })
    },
    city(val) {
      this.cityList.forEach(item => {
        if (item.name === val) {
          this.districtList = item.areaList;
        }
      })
    }
  },
  methods: {
    //省改变了 要赋值市
    changeProvince(e) {
      this.province = e;
    },
    changeCity(e) {
      this.city = e;
    },
    changeDis(e) {
      this.district = e;
    }
  }
}
</script>

<template>
  <div>
    <el-select v-model="province" placeholder="请选择省" @change="changeProvince">
      <el-option
        v-for="item in provinceList"
        :key="item.code"
        :label="item.name"
        :value="item.name">
      </el-option>
    </el-select>
    <el-select v-model="city" placeholder="请选择市" @change="changeCity">
      <el-option
        v-for="item in cityList"
        :key="item.code"
        :label="item.name"
        :value="item.name">
      </el-option>
    </el-select>
    <el-select v-model="district" placeholder="请选择县" @change="changeDis">
      <el-option
        v-for="item in districtList"
        :key="item.code"
        :label="item.name"
        :value="item.name">
      </el-option>
    </el-select>
  </div>
</template>

<style scoped lang="scss">

</style>
