<!--凭证生成组件-->
<template>
  <div class="charge-container" id="chargeContainer">
    <div class="charge">
      <!--      上面三个基本信息-->
      <div class="charge-header">
        <div>
          日期
          <el-date-picker type="date" style="width: 145px;" v-model="voucher.date"></el-date-picker>
        </div>
        <div>
          凭证编号
          <el-input type="text" style="width: 80px;" v-model="voucher.no"></el-input>
        </div>
        <div>
          制单人
          <el-input type="text" style="width: 80px;" v-model="voucher.maker"></el-input>
        </div>
      </div>
      <table class="charge-table" border="1">
        <!-- 表头-->
        <tr>
          <td width="6%">序号</td>
          <td :width="'22%'">摘要</td>
          <td :width="'22%'">科目名称</td>
          <td :width="'22%'">辅助项</td>
          <!--  右侧金额-->
          <td width="50%">
            <table style="height: 50px;">
              <tr style="border-bottom: 1px solid #bab9b9;">
                <td width="50%" style="border-right: 1px solid #bab9b9;">借方</td>
                <td width="50%">贷方</td>
              </tr>
            </table>
          </td>
        </tr>

        <!-- 销项列表-->
        <tr v-for="(item,index) in needToMakeList">
          <!--          序号-->
          <td>
            {{ index }}
          </td>
          <!--          摘要-->
          <td>
            <div class="main-subject">
              <el-input type="text"></el-input>
            </div>
          </td>
          <!--          科目-->
          <td>
            <div class="main-subject">
              <el-row>
                <el-col :span="20">
                  <el-input type="text" v-model="type"></el-input>
                </el-col>
                <el-col :span="4">
                  <SubjectOption @update:type="handleUpdateType"/>
                </el-col>
              </el-row>
            </div>
          </td>
          <!--          辅助项-->
          <td>
            <div class="main-subject">
              <el-input type="text"></el-input>
            </div>
          </td>

          <!--          右侧金额表格-->
          <td>
            <table>
              <tr>
                <td width="50%" style="border-right: 1px solid #bab9b9;">
                  <el-input type="text"></el-input>
                </td>
                <td width="50%">
                  <el-input type="text"></el-input>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td :colspan="3" style="text-align: left;padding-left: 10px;height:50px">合计：</td>
          <td style="text-align: left;padding-left: 10px;height:50px">大写合计:</td>
          <td>
            <table>
              <tr>
                <td width="50%" style="border-right: 1px solid #bab9b9;">
                  5000
                </td>
                <td width="50%">
                  6000
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <div style="height: 50px;line-height: 50px;">制单人：</div>
      <div style="text-align: right;">
        <el-button>暂存</el-button>
        <el-button type="primary">保存</el-button>
      </div>
    </div>
  </div>
</template>

<script>

import SubjectOption from "./SubjectOption.vue";

export default {
  name: "CrendentMake",
  components: {SubjectOption},
  props: {
    needToMakeList: {
      type: Array,
      default() {
        return []
      }
    }
  },
  data() {
    return {
      voucher: {
        no: '1001', date: new Date(), maker: '', bill: 0
      },
      list: [{}],
      type: ''
    }
  },
  mounted() {
  },
  updated() {

  },
  methods: {
    // 拿到科目类型
    handleUpdateType(value) {
      this.type = value
    }
  }
}
</script>

<style scoped>
table {
  width: 100%;
  border-spacing: 0;
  border-collapse: collapse;
  padding: 0;
  margin: 0;
}

table td {
  text-align: center;
  table-layout: fixed;
  padding: 0px;
  position: relative;
}

.main-subject {
  position: relative;
  height: 60px;
  line-height: 60px;
  text-align: left;
}

.charge-container {
  font-size: 14px;
  color: #444;
  font-weight: 400;
  background-color: white;
}

.charge {
  width: 1124px;
  margin: auto;
}

.charge-header {
  margin-bottom: 10px;
}

.charge-header > div {
  display: inline-block;
  margin-right: 15px;
}

.tip-box {
  width: 330px;
  padding: 10px;
  position: absolute;
  top: 27px;
  right: -15px;
  z-index: 1005;
  background-color: #fff;
  box-shadow: 0 0 6px rgba(170, 170, 170, .73);
  display: none;
}

.tip-box-table tr {
  height: 25px;
}

.el-icon-info {
  font-size: 18px;
  margin-left: 30px;
  cursor: pointer;
}

.el-icon-info:hover + .tip-box {
  display: inline-block;
}

.el-icon-more {
  position: absolute;
  top: 22px;
  right: 10px;
  z-index: 2;
  color: #666;
  cursor: pointer;
  font-size: 16px;
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0px;
  float: left;
  padding: 5px 0;
  margin: 2px 0 0;
  text-align: left;
  list-style: none;
  background-color: #fff;
  background-clip: padding-box;
}

.suggest-list {
  width: 100%;
  height: auto;
  z-index: 1015;
  min-width: inherit;
  display: block;
  overflow: hidden;
  border: none;
  box-shadow: 0 1px 6px rgba(0, 0, 0, .2);
}

.suggest-list .item-list {
  max-height: 375px;
  overflow: auto;
  list-style: none;
  margin: 0px;
  padding: 0px;
}

.item-list li {
  display: flex;
  padding: 0 10px;
  height: 28px;
  line-height: 28px;
  cursor: pointer;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.item-list li:hover {
  background: #ecebeb;
}

.item-list li.hover {
  background: #ecebeb;
}

.charge-table, .tip-box-table {
  border: 1px solid #bab9b9;
}

.charge-table, .debtor-tbale, .lender-tbale > tr {
  height: 60px;
}

.charge-table > tr:first-child {
  height: 50px;
}

.td-auxiliary-dis {
  background-color: #f7f7f7;
}

.auxiliary-accounting {
  height: 60px;
  overflow: auto;
  padding: 15px 0 0 30px;
}

.auxiliary-accounting:before {
  content: "+";
  font-size: 30px;
  color: #4a90e2;
  cursor: pointer;
  padding: 0 11px;
  position: absolute;
  top: 0;
  left: 0;
  line-height: 60px;
}

.auxiliary-single {
  display: flex;
  float: left;
  height: 28px;
  line-height: 28px;
  margin-right: 5px;
  cursor: pointer;
  background: #eee;
  padding: 0 8px;
  border-radius: 2px;
}

.auxiliary-single span {
  max-width: 90px;
  overflow: hidden;
  height: 28px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.auxiliary-single i {
  color: red;
  margin: 8px 0 8px 7px;
  font-size: 10px;
  visibility: hidden;
}

.auxiliary-single:hover i {
  visibility: inherit;
}

.charge-table-icon {
  cursor: pointer;
  display: inline-block;
}

.debtor-lender-table tr td {
  width: 9%;
  border-right: 1px solid #bab9b9;
}

.debtor-lender-table tr td:nth-child(3) {
  border-right-color: rgba(74, 144, 226, .5);
}

.debtor-lender-table tr td:nth-child(6) {
  border-right-color: rgba(74, 144, 226, .5);
}

.debtor-lender-table tr td:nth-child(9) {
  border-right-color: rgba(226, 106, 74, .5);
}

.debtor-lender-table tr td:last-child {
  border-right: none;
}

.tr-negative {
  color: red;
}

.charge-table input, select {
  width: 100%;
  height: 60px;
}

.charge-table textarea {
  width: 100%;
  height: 60px;
  padding: 9px 14px 9px 10px;
  overflow: auto;
  resize: none;
  border: none;
  border-radius: 0px;
  margin: 0;
  color: #444;
  box-sizing: border-box;
}
</style>
