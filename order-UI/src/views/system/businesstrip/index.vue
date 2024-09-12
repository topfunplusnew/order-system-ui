<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="出差时间" prop="starttime">
        <el-date-picker
          v-model="queryParams.starttime"
          type="date"
          placeholder="选择日期" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="返回时间" prop="endtime">
        <el-date-picker
          v-model="queryParams.endtime"
          type="date"
          placeholder="选择日期" value-format="yyyy-MM-dd">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
      </el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:businesstrip:add']"
        >新增出差信息
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
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
        <!--        导出-->
        <template v-slot:export>
          <el-col :span="1.5">
            <el-button
              plain
              icon="el-icon-folder-opened"
              size="mini"
              @click="handleExport"
              v-hasPermi="['system:businesstrip:export']"
            >
            </el-button>
          </el-col>
        </template>
      </right-toolbar>
    </el-row>

    <el-table size="mini" border v-horizontal-scroll="'always'" v-loading="loading" :data="BusinessTripList"
              @selection-change="handleSelectionChange">
      <!--      <el-table-column label="报销人ID" align="center" prop="employeeID"/>-->
      <el-table-column label="报销人" align="center" prop="employee" v-if="columns[0].visible"/>
      <el-table-column label="共同出差人员" align="center" prop="personnel" v-if="columns[1].visible"/>
      <el-table-column label="部门" align="center" prop="deptName"/>
      <el-table-column label="出差时间" align="center" prop="starttime" v-if="columns[2].visible"/>
      <el-table-column label="出差结束时间" align="center" prop="endtime" v-if="columns[3].visible"/>
      <el-table-column label="附件" align="center" prop="attachmentPath" v-if="columns[4].visible">
        <template #default="scope">
          <img v-if="isPic(scope.row.attachmentPath)" :src="scope.row.attachmentPath" alt=""
               style="width: 100%;height: 100%">
          <span v-else-if="scope.row.attachmentPath === '' || scope.row.attachmentPath === null">无附件</span>
          <span v-else>
            文件不支持预览，请手动下载:
          <a style="color: red"
             :href="scope.row.attachmentPath">{{ scope.row.attachmentPath }}</a>
          </span>
        </template>
      </el-table-column>
      <el-table-column label="是否已报销" align="center" prop="isReimburse" v-if="columns[5].visible">
        <template slot-scope="scope">
          {{ scope.row.isReimburse === 0 ? '否' : '是' }}
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="comments" v-if="columns[6].visible"/>
      <el-table-column label="操作" align="center" class-name="small-padding " width="260px" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            @click="applyForPayment(scope.row)"
          >发起付款申请
          </el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:businesstrip:edit']"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:businesstrip:remove']"
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

    <!-- 添加或修改出差对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <!--      头部流程信息-->
      <el-row>
        <div>
          <el-steps :active="active" finish-status="success">
            <el-step title="基本信息登记">
            </el-step>
            <el-step title="报销信息">
            </el-step>
          </el-steps>
        </div>
      </el-row>
      <!--      提示信息-->
      <br/>
      <el-row>
        <el-alert
          title="各填写信息相互独立！"
          type="info">
        </el-alert>
      </el-row>
      <br/>
      <el-row justify="center">
        <el-col :span="24">
          <el-row v-if="active === 0">
            <el-col :span="24">
              <el-row>
                <el-form ref="form" :model="form" :rules="rules" label-width="80px">
                  <el-col :span="12">
                    <el-form-item label="报销人" prop="employee">
                      <el-input v-model="form.employee" disabled placeholder="请输入报销人"/>
                    </el-form-item>
                    <el-form-item label="部门" prop="deptName">
                      <el-input v-model="form.deptName" placeholder="请输入部门"/>
                    </el-form-item>
                    <el-form-item label="共同出差人员" prop="personnel">
                      <el-input v-model="form.personnel" placeholder="请输入共同出差人员"/>
                    </el-form-item>
                    <el-form-item label="出差时间" prop="starttime">
                      <el-date-picker
                        v-model="form.starttime"
                        type="date"
                        placeholder="选择出差时间"
                        value-format="yyyy-MM-dd">
                      </el-date-picker>
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="出差结束时间" prop="endtime">
                      <el-date-picker
                        v-model="form.endtime"
                        type="date"
                        placeholder="选择出差结束时间"
                        value-format="yyyy-MM-dd">
                      </el-date-picker>
                    </el-form-item>
                    <el-form-item label="附件地址" prop="attachmentPath">
                      <!--          <el-input v-model="form.attachmentPath" placeholder="请输入附件地址"/>-->
                      <file-upload @input="handleFileUpload"/>
                      <img v-if="isImg" :src="form.attachmentPath" alt="" style="width: 300px;height: 200px">
                    </el-form-item>
                    <el-form-item label="备注" prop="comments">
                      <el-input v-model="form.comments" type="textarea" placeholder="请输入内容"/>
                    </el-form-item>
                  </el-col>
                </el-form>
              </el-row>
            </el-col>
          </el-row>
          <el-row v-if="active === 1">
            <el-row>
              <el-col :span="5">
                <span style="font-weight: bolder">
                  是否使用车辆
                </span>
              </el-col>
              <el-col :span="5">
                <el-radio v-model="useCar" label="是">是</el-radio>
                <el-radio v-model="useCar" label="否">否</el-radio>
              </el-col>
              <el-button size="mini" type="warning" @click="handleWriteCarsInfo" v-if="useCar ==='是'">填写车辆使用信息
              </el-button>
            </el-row>
            <hr/>
            <el-row :gutter="10" class="mb8">
              <el-col :span="5">
                <span style="font-weight: bolder">填写报销项</span>
              </el-col>
              <el-col :span="1.5">
                <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddTripReimbursement">添加
                </el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteTripReimbursement">
                  删除
                </el-button>
              </el-col>
            </el-row>
            <el-table :data="tripReimbursementList" :row-class-name="rowTripReimbursementIndex"
                      @selection-change="handleTripReimbursementSelectionChange" ref="tripReimbursement">
              <el-table-column type="selection" width="50" align="center"/>
              <el-table-column label="序号" align="center" prop="index" width="50"/>
              <el-table-column label="报销项" prop="item" width="150">
                <template slot-scope="scope">
                  <el-input v-model="scope.row.item" placeholder="请输入报销项" :disabled="scope.row.isDisabled"/>
                </template>
              </el-table-column>
              <el-table-column label="费用" prop="itemCost">
                <template slot-scope="scope">
                  <el-input v-model="scope.row.itemCost" placeholder="请输入费用" :disabled="scope.row.isDisabled"/>
                </template>
              </el-table-column>
            </el-table>
          </el-row>
          <!--          完成提交的页面-->
          <el-row v-if="active === 2">
            <el-result icon="success" title="申请提交成功">
              <template slot="extra">
                <el-button type="primary" size="medium" @click="closeAll">关闭</el-button>
              </template>
            </el-result>
          </el-row>
        </el-col>
      </el-row>
      <div slot="footer" class="dialog-footer" v-if="active !== 2">
        <el-button type="warning" @click="before" v-if="active !== 0">上一步</el-button>
        <el-button type="warning" @click="next" v-if="active !== 1">下一步</el-button>
        <el-button type="success" @click="nextAndSubmit" v-if="active === 1">完成提交</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>


    <!--    车辆使用申请-->
    <el-dialog title="车辆使用申请" :visible.sync="carApplyVisible" fullscreen append-to-body width="80%">
      <el-form ref="carApplyForm" :model="carApplyForm" :rules="rules" label-width="150px">
        <!--        自动填充以下字段-->
        <!--          <el-form-item label="申请人" prop="applyUser">-->
        <!--            <el-input v-model="carApplyForm.applyUser" placeholder="请输入申请人"/>-->
        <!--          </el-form-item>-->
        <!--          <el-form-item label="部门" prop="department">-->
        <!--            <el-input v-model="carApplyForm.department" placeholder="请输入部门"/>-->
        <!--          </el-form-item>-->
        <el-col :span="8">
          <el-form-item label="申请时间" prop="applyDate">
            <el-date-picker
              v-model="carApplyForm.applyDate"
              type="date"
              placeholder="选择申请时间"
              value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="申请人" prop="applyUser">
            <el-input v-model="carApplyForm.applyUser" disabled/>
          </el-form-item>
          <el-form-item label="部门" prop="department">
            <el-input v-model="carApplyForm.department" disabled/>
          </el-form-item>
          <!--          车辆信息搜索-->
          <el-form-item label="车牌" prop="carNo">
            <el-row>
              <el-col :span="20">
                <el-input v-model="carApplyForm.carNo" placeholder="请输入车牌"/>
              </el-col>
              <el-col :span="4">
                <SearchOption :limit-info="{dictType:'order_cars'}"
                              :get-data="listData" query-label="车牌搜索"
                              :query-name="queryCars"
                              query-info="dictLabel"
                              @update:queryName="updateQueryCars"
                              @commitBack="handleCommitBackCars">
                  <template #table-columns>
                    <el-table-column label="车牌" prop="dictLabel"/>
                  </template>
                </SearchOption>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="是否携带油卡" prop="isUseOilCard">
            <el-row>
              <el-radio v-model="carApplyForm.isUseOilCard" label="1" @change="test">是
              </el-radio>
              <el-radio v-model="carApplyForm.isUseOilCard" label="0">否</el-radio>
            </el-row>
            <el-button v-if="carApplyForm.isUseOilCard === '1'" type="warning" size="mini"
                       @click="oilCardConsumeVisible=true">重新填写油卡信息
            </el-button>
          </el-form-item>
          <el-form-item label="行程中使用加油卡加油次数" prop="refuelingFrequency"
                        v-if="carApplyForm.isUseOilCard==='1'">
            <el-input v-model="carApplyForm.refuelingFrequency" placeholder="请输入行程中使用加油卡加油次数"/>
          </el-form-item>
          <el-form-item label="用车事由" prop="ApplyPurpose">
            <el-input v-model="carApplyForm.ApplyPurpose" placeholder="请输入用车事由"/>
          </el-form-item>
          <el-form-item label="用车时间" prop="startTime">
            <el-date-picker
              v-model="carApplyForm.startTime"
              type="date"
              placeholder="选择用车时间"
              value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="还车时间" prop="endTime">
            <el-date-picker
              v-model="carApplyForm.endTime"
              type="date"
              placeholder="选择还车时间"
              value-format="yyyy-MM-dd">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="用车里程数" prop="miles">
            <el-input v-model="carApplyForm.miles" placeholder="请输入用车里程数"/>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="回来后里程" prop="endMile">
            <el-input v-model="carApplyForm.endMile" placeholder="请输入回来后里程"/>
          </el-form-item>
          <el-form-item label="出车前里程" prop="startMile">
            <el-input v-model="carApplyForm.startMile" placeholder="请输入出车前里程"/>
          </el-form-item>
          <el-form-item label="出车前车况" prop="startCarState">
            <el-input v-model="carApplyForm.startCarState" placeholder="请输入出车前车况"/>
          </el-form-item>
          <el-form-item label="回来后车况" prop="endCarState">
            <el-input v-model="carApplyForm.endCarState" placeholder="请输入回来后车况"/>
          </el-form-item>
          <el-form-item label="回程停靠位置" prop="backStopPlace">
            <el-input v-model="carApplyForm.backStopPlace" placeholder="请输入回程停靠位置"/>
          </el-form-item>
          <el-form-item label="行程中违法次数" prop="violationsCount">
            <el-input v-model="carApplyForm.violationsCount" placeholder="请输入行程中违法次数"/>
          </el-form-item>
          <el-form-item label="违章罚款金额金额" prop="fine">
            <el-input v-model="carApplyForm.fine" placeholder="请输入违章罚款金额金额"/>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="行程中是否维修/保养" prop="isMaintenance">
            <el-radio v-model="carApplyForm.isMaintenance" label="是">是</el-radio>
            <el-radio v-model="carApplyForm.isMaintenance" label="否">否</el-radio>
          </el-form-item>
          <el-form-item label="保养金额" prop="maintenanceMoney" v-if="carApplyForm.isMaintenance === '是'">
            <el-input v-model="carApplyForm.maintenanceMoney" placeholder="请输入保养金额"/>
          </el-form-item>
          <el-form-item label="派车人" prop="dispatchPerson">
            <el-input v-model="carApplyForm.dispatchPerson" placeholder="请输入派车人"/>
          </el-form-item>
          <el-form-item label="随同乘车人员" prop="peers">
            <el-input v-model="carApplyForm.peers" placeholder="请输入随同乘车人员"/>
          </el-form-item>
          <el-form-item label="备注" prop="comments">
            <el-input v-model="carApplyForm.comments" placeholder="请输入备注"/>
          </el-form-item>
          <el-form-item label="附件" prop="path">
            <file-upload @input="handleFileUploadCarApply"/>
          </el-form-item>
        </el-col>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <!--        车辆信息填写完成后，先保存 后续使用-->
        <el-button type="primary" @click="submitCarApply">保存填写</el-button>
        <el-button type="danger" @click="clearCarApply">清除填写</el-button>
        <el-button @click="carApplyVisible = false">取 消</el-button>
      </div>
    </el-dialog>


    <!--    付款申请弹窗-->
    <el-dialog
      title="提示"
      :visible.sync="applyForPaymentDialogVisible"
      width="60%">
      <ApplyPayment :table-name="TableName.BUSINESS_TRIP" @changeOpen="changePaymentApplyInfoVisible"
                    :t-i-d="tID" :need-info="{}"/>
    </el-dialog>


    <!--    新增油卡消费记录-->
    <el-dialog title="油卡消费记录" :visible.sync="oilCardConsumeVisible" width="75%" append-to-body>
      <el-form ref="form" :model="oilCardConsumeInfo" label-width="160px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="加油卡卡号" prop="oilCardNo">
              <el-row>
                <el-col :span="20">
                  <el-input v-model="oilCardConsumeInfo.oilCardNo" placeholder="请输入加油卡卡号"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :get-data="listOilCard" @commitBack="handleCommitBackOilCard" query-info="oilCardNo"
                                :query-name="queryOilCard" query-label="油卡账号查询"
                                @update:queryName="handleCommitBackQueryOilCard" :limit-info="{oilType:'主卡'}">
                    <template #table-columns>
                      <el-table-column label="加油卡卡号" align="center" prop="oilCardNo"/>
                      <el-table-column label="当前金额" align="center" prop="moneyAmount"/>
                    </template>
                  </SearchOption>
                </el-col>
              </el-row>
            </el-form-item>
            <el-form-item label="使用加油卡时间" prop="useDate">
              <el-date-picker
                v-model="oilCardConsumeInfo.useDate"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="使用加油卡车辆车牌号" prop="carNo">
              <el-row>
                <el-col :span="20">
                  <el-input v-model="oilCardConsumeInfo.carNo" placeholder="请输入使用加油卡车辆车牌号"/>
                </el-col>
                <el-col :span="4">
                  <SearchOption :get-data="listData" @commitBack="handleCommitCarNumber" query-info="dictLabel"
                                :query-name="queryCarNumber" query-label="车牌号查询"
                                @update:queryName="handleCommitBackQueryCarNumber"
                                :limit-info="{dictType: 'order_cars'}">
                    <template #table-columns>
                      <el-table-column label="车牌号" align="center" prop="dictLabel"/>
                    </template>
                  </SearchOption>
                </el-col>
              </el-row>
            </el-form-item>
            <el-form-item label="期初余额" prop="startCardSurplus">
              <el-input v-model="oilCardConsumeInfo.startCardSurplus" placeholder="请输入期初余额"/>
            </el-form-item>
            <!--            途中是否自己充钱 如果自己充了 那么下面的保存填写后要加上这个充值金额，如果没充，默认是0-->
            <el-form-item label="途中是否充值">
              <el-radio v-model="isRecharge" label="1">是</el-radio>
              <el-radio v-model="isRecharge" label="2">否</el-radio>
            </el-form-item>
            <el-form-item label="充值金额" prop="rechargeMoney" v-if="isRecharge === '1'">
              <el-input v-model="oilCardConsumeInfo.rechargeMoney"
                        placeholder="请输入充值金额,此金额为过程中使用现金充值金额"/>
            </el-form-item>
            <el-form-item label="加油量" prop="refuelingNumber">
              <el-input v-model="oilCardConsumeInfo.refuelingNumber" placeholder="请输入加油量"/>
            </el-form-item>
            <el-form-item label="单价" prop="unitPrice">
              <el-input v-model="oilCardConsumeInfo.unitPrice" placeholder="请输入单价"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-row>
              <el-form-item label="加油金额(元）" prop="refuelingMoney">
                <el-input v-model="oilCardConsumeInfo.refuelingMoney" placeholder="请输入加油金额(元）"/>
              </el-form-item>
            </el-row>
            <!--            <el-row>-->
            <!--              <el-form-item label="充值金额(元）" prop="rechargeMoney">-->
            <!--                <el-input v-model="oilCardConsumeInfo.rechargeMoney" placeholder="请输入充值金额(元）"/>-->
            <!--              </el-form-item>-->
            <!--            </el-row>-->
            <!--            <el-row>-->
            <!--              <el-form-item label="加油卡余额" prop="endCardSurplus">-->
            <!--                <el-input v-model="oilCardConsumeInfo.endCardSurplus" placeholder="请输入加油卡余额"/>-->
            <!--              </el-form-item>-->
            <!--            </el-row>-->
            <el-row>
              <el-form-item label="加油小票附件" prop="attachmentOiladd">
                <el-row>
                  <el-col :span="20">
                    <el-input v-model="oilCardConsumeInfo.attachmentOiladd" placeholder="加油小票附件路径" disabled/>
                  </el-col>
                  <el-col :span="4"
                          v-if="oilCardConsumeInfo.attachmentOiladd !== null && oilCardConsumeInfo.attachmentOiladd !== ''">
                    <el-button size="mini" @click="checkPath(oilCardConsumeInfo.attachmentOiladd)">查看附件
                    </el-button>
                  </el-col>
                </el-row>
                <el-row justify="center">
                  <el-col :span="20">
                    <el-upload
                      class="upload-demo"
                      drag
                      :action="uploadFileUrl"
                      :headers="headers"
                      :limit="1"
                      multiple :on-success="handleFileSuccess">
                      <i class="el-icon-upload"></i>
                      <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                    </el-upload>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item label="备注" prop="comments">
                <el-input v-model="oilCardConsumeInfo.comments" placeholder="请输入备注"/>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitOilCard">保存填写</el-button>
        <el-button type="primary" @click="clearOilCard">清除填写</el-button>
      </div>
    </el-dialog>


    <!--    油卡充值的页面-->
    <el-dialog
      title="提示"
      :visible.sync="oilCardDialogVisible"
      width="30%">
      <el-form :model="moneyInfo" :rules="rules" label-width="120px">
        <el-form-item label="加油卡卡号" prop="oilCardNo">
          <el-row>
            <el-col :span="10">
              <el-input v-model="moneyInfo.oilCardNo" placeholder="请输入加油卡卡号"/>
            </el-col>
            <el-col :span="3">
              <SearchOption :get-data="listOilCard" title="选择加油卡" icon="el-icon-search"
                            :limit-info="{oilType:'主卡'}" @commitBack="handleCommitBack">
                <template #table-columns>
                  <el-table-column prop="oilCardNo" label="加油卡卡号"/>
                  <el-table-column prop="moneyAmount" label="加油卡余额"/>
                </template>
              </SearchOption>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="请选择充值方式" prop="rechargeType">
          <el-select v-model="moneyInfo.rechargeType" placeholder="请选择充值方式">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="请输入充值金额" prop="rechargeMoney">
          <el-input v-model="moneyInfo.rechargeMoney" placeholder="请输入充值金额"/>
        </el-form-item>
        <el-form-item label="姓名" prop="rechargeName">
          <el-input disabled v-model="moneyInfo.rechargeName" placeholder="请输入姓名"/>
        </el-form-item>
        <el-form-item v-if="moneyInfo.rechargeType==='银行卡'" label="银行开户名" prop="acountsName">
          <el-col :span="10">
            <el-input v-model="moneyInfo.acountsName" placeholder="请输入银行开户名"/>
          </el-col>
          <el-col :span="4">
            <SearchOption :limit-info="{acountsType:'己方公司'}" :get-data="listBankAccount"
                          @commitBack="handleCommitBackBankAcount"
                          @update:queryName="handleUpdateQueryBankAcount" :query-name="queryBankAcount"
                          query-label="户名查找" query-info="acountsName">
              <template #table-columns>
                <el-table-column label="账户类型" align="center" prop="acountsType"/>
                <el-table-column label="开户名称(户名)" align="center" prop="acountsName"/>
                <el-table-column label="账号(银行账号)" align="center" prop="bankNo"/>
                <el-table-column label="开户行" align="center" prop="bankName"/>
                <el-table-column label="公司名称" align="center" prop="companyName"/>
              </template>
            </SearchOption>
          </el-col>
        </el-form-item>
        <el-form-item v-if="moneyInfo.rechargeType==='银行卡'" label="银行账号" prop="bankNo">
          <el-input v-model="moneyInfo.bankNo" placeholder="请输入银行账号"/>
        </el-form-item>
        <el-form-item label="附件" prop="bankName">
          <file-upload @input="handleUpload"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitMoney">确 定</el-button>
        <el-button @click="oilCardDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  addBusinessTrip,
  delBusinessTrip,
  getBusinessTrip,
  listBusinessTrip,
  updateBusinessTrip
} from "@/api/system/BusinessTrip";
import {mixin_printHTML} from "@/views/dashboard/mixins/print";
import {findFileExtension, getUuid} from "@/utils/trash/utils";
import {mixin_upload} from "@/views/dashboard/mixins/upload";
import SearchOption from "@/components/SearchOption.vue";
import {listData} from "@/api/system/dict/data";
import {mapGetters} from "vuex";
import {addCarApply, getCarApply, listCarApply, updateCarApply} from "@/api/system/carApply";
import PaymentApply from "@/views/system/paymentApply/index.vue";
import ApplyPayment from "@/components/ApplyPayment.vue";
import {TableName} from "@/api/tool/enums";
import {checkOilCard, listOilCard} from "@/api/system/oilCard";
import {getToken} from "@/utils/auth";
import {excludeParams} from "@/api/tool/exclude";
import {updateGoodsOrder} from "@/api/system/goodsOrder";
import {listBankAccount} from "@/api/system/bankAccount";
import {addOilRecharge} from "@/api/system/oilRecharge";
import {parseTime} from "@/utils/ruoyi";
import {addOilCardConsume} from "@/api/system/OilCardConsume";

export default {
  name: "BusinessTrip",
  components: {ApplyPayment, PaymentApply, SearchOption},
  mixins: [mixin_printHTML, mixin_upload],
  data() {
    return {
      loading: true,
      ids: [],
      checkedTripReimbursement: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      BusinessTripList: [],
      tripReimbursementList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        employeeID: null,
        employee: null,
        personnel: null,
        starttime: null,
        endtime: null,
        attachmentPath: null,
        isReimburse: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        delFlag: null
      },
      form: {
        employee: ''
      },
      rules: {},
      columns: [
        {key: 0, label: `报销人`, visible: true},
        {key: 1, label: `共同出差人员`, visible: true},
        {key: 2, label: `出差时间`, visible: true},
        {key: 3, label: `出差结束时间`, visible: true},
        {key: 4, label: `附件地址`, visible: true},
        {key: 5, label: `是否已报销`, visible: true},
        {key: 6, label: `备注`, visible: true},
      ],
      active: 0,
      //是否使用车辆 默认为否
      useCar: '否',
      carApplyForm: {
        carNo: '',
        isMaintenance: '',
        isReimburse: '',
      },
      carApplyVisible: false,
      //车辆查询
      queryCars: '',
      //发起付款申请的
      applyForPaymentDialogVisible: false,
      tID: '',
      isRecharge: '',
      oilCardConsumeInfo: {
        oilCardNo: '',
        carNo: '',
        //附件路径
        attachmentOiladd: '',
        //充值金额 默认为0
        rechargeMoney: '0'
      },
      oilCardConsumeVisible: false,
      queryOilCard: '',
      queryCarNumber: '',

      // 文件上传
      baseUrl: process.env.VUE_APP_BASE_API,
      uploadFileUrl: process.env.VUE_APP_BASE_API + "/common/upload", // 上传文件服务器地址
      headers: {
        Authorization: "Bearer " + getToken(),
      },

      //油卡充值
      oilCardDialogVisible: false,
      moneyInfo: {
        oilCardNo: '',
        rechargeType: '',
        rechargeMoney: '',
        rechargeDate: parseTime(new Date()),
        rechargeName: "",
        acountsName: "",
        bankNo: "",
        attachment: '',
        comments: ''
      },
      options: [{
        value: '现金',
        label: '现金'
      }, {
        value: '银行卡',
        label: '银行卡'
      }],
      queryBankAcount: '',


      // 互斥变量UUID
      UUID: ''
    };
  },
  created() {
    this.getList();
    if (localStorage.getItem('BusinessTrip-columns') === 'null'
      || !localStorage.getItem('BusinessTrip-columns')) {
      //设置localStorage
      localStorage.setItem("BusinessTrip-columns", JSON.stringify(this.columns))
    } else {
      this.columns = JSON.parse(localStorage.getItem('BusinessTrip-columns'));
    }
  },
  //展示与隐藏
  watch: {
    columns: {
      handler: (newVal) => {
        localStorage.setItem("BusinessTrip-columns", JSON.stringify(newVal))
      },
      deep: true,
    },
    //监听是否携带了油卡 如果携带，那么要打开填写加油卡消费记录的弹窗
    'carApplyForm.isUseOilCard': {
      handler: (newVal) => {
        console.log(newVal)
      }
    }
  },
  computed: {
    TableName() {
      return TableName
    },
    ...mapGetters(['trueName'])
  },
  methods: {
    listBankAccount,
    listOilCard,
    listData,
    isPic(url) {
      console.log(url)
      return this.$imgs.includes(findFileExtension(url))
    },
    before() {
      if (this.active-- <= 0) this.active = 0;
    },
    next() {
      if (this.active++ > 2) {
        this.active = 0;
      }
      // id 不为空则为修改
      if (this.form.id !== null && this.form.id !== '' && this.form.id !== undefined) {
        this.form = excludeParams(this.form, this.$exclude)
        updateBusinessTrip({...this.form, UUID: this.UUID}).then(res => {
          if (res.code === 500) {
            this.$message.error(res.msg)
            this.active = 0;
          } else {
            this.$message.success('修改出差基本信息成功')
            //保存到会话中
            sessionStorage.setItem('BusinessTrip-form', JSON.stringify(this.form))
          }
        }).catch(err => {
          this.active = 0
        })
      } else {
        this.form = excludeParams(this.form, this.$exclude)
        addBusinessTrip({...this.form, UUID: this.UUID}).then(res => {
          if (res.code === 500) {
            this.$message.error(res.msg)
            this.active = 0;
          } else {
            this.$message.success('添加出差基本信息成功')
            //保存到会话中
            sessionStorage.setItem('BusinessTrip-form', JSON.stringify(res.data))
          }
        }).catch(err => {
          this.active = 0
        })
      }
    },
    //提交车辆使用申请 保存使用车辆信息
    submitCarApply() {
      sessionStorage.setItem('carApplyForm', JSON.stringify(this.carApplyForm))
      this.$message.success('车辆信息保存成功~')
      //清除状态
      // this.carApplyForm = this.$refreshParams(this.carApplyForm)
      this.carApplyVisible = false
    },
    //清除缓存
    clearCarApply() {
      sessionStorage.removeItem('carApplyForm')
      this.carApplyForm = this.$refreshParams(this.carApplyForm)
      this.carApplyVisible = false
    },
    //车辆使用申请的附件
    handleFileUploadCarApply(url) {
      this.carApplyForm.path = url
    },
    closeAll() {
      this.active = 0;
      this.open = false
    },
    updateQueryCars(val) {
      this.queryCars = val;
    },
    handleCommitBackCars(val) {
      this.carApplyForm.carNo = val.dictLabel
    },
    //打开车辆申请信息填写
    handleWriteCarsInfo() {
      const json = sessionStorage.getItem('carApplyForm')
      //如果没有存储对象
      if (JSON.parse(json) === null) {
        this.carApplyVisible = true;
      } else {
        const keys = Object.keys(JSON.parse(json))
        for (let property of keys) {
          //是否包含该属性 包含则给 不包含给空
          this.$set(this.carApplyForm, property, keys.includes(property) ? JSON.parse(json)[property] : '')
        }
        this.carApplyVisible = true;
      }
    },
    //完成提交
    nextAndSubmit() {
      // 修改 修改的时候
      if (this.form.id !== null && this.form.id !== '' && this.form.id !== undefined) {
        //保存报销信息
        this.form.tripReimbursementList = this.tripReimbursementList;
        updateBusinessTrip(excludeParams(this.form, this.$exclude)).then(res => {
          this.$message.success('修改成功')
          //添加车辆信息
          updateCarApply(excludeParams(this.carApplyForm, this.$exclude)).then(res => {
            this.$message.success('车辆信息修改成功')
            this.active++;
            // 清除状态
            sessionStorage.removeItem('carApplyForm')
            sessionStorage.removeItem('BusinessTrip-form')
            this.carApplyForm = {}
            this.oilCardConsumeInfo = {}
            this.form = {}
            this.getList()
          })
        })
        // 添加
      } else {
        // 如果不使用车辆
        if (this.useCar !== '是') {
          //先提交申请信息 回调函数中添加车辆使用信息
          addBusinessTrip(this.form).then(res => {
            this.$message.success('提交成功,本次无车辆使用信息')
            this.active++;
            // 清除状态
            this.carApplyForm = {}
            this.oilCardConsumeInfo = {}
            this.form = {}
            this.getList()
          })
          // 如果使用车辆
        } else {
          //保存报销信息
          this.form.tripReimbursementList = this.tripReimbursementList;
          //form 是出差申请基本信息 carApplyInfo是车辆使用信息
          let carApplyInfo = JSON.parse(sessionStorage.getItem('carApplyForm'))
          //填充某些字段
          carApplyInfo.applyUser = this.form.employee;
          carApplyInfo.department = this.form.deptName;
          //先提交申请信息 回调函数中添加车辆使用信息
          addBusinessTrip(this.form).then(res => {
            carApplyInfo.bTripId = res.data.id;
            this.$message.success('提交成功')
            //添加车辆信息
            setTimeout(() => {
              addCarApply(carApplyInfo).then(res => {
                this.$message.success('车辆信息提交成功')
                this.active++;
                // 清除状态
                this.carApplyForm = {}
                this.oilCardConsumeInfo = {}
                this.form = {}
                this.getList()
              })
            }, 30)
          })
        }
      }
    },

    //发起付款申请
    applyForPayment(row) {
      // 出差费用包含 报销项 车辆使用申请的保养金额 加油金额 初期金额
      getBusinessTrip(row.id).then(res => {
        console.log('出差信息', res)
      })
      this.tID = row.id;
      this.applyForPaymentDialogVisible = true
    },
    test(e) {
      this.oilCardConsumeVisible = true
    },
    changePaymentApplyInfoVisible(val) {
      this.applyForPaymentDialogVisible = val;
      this.getList()
    },
    // 添加油卡消费信息
    submitOilCard() {
      this.carApplyForm.isUseOilCard = '1';
      // 要检查油卡的余额是否够用 如果够用就保存数据 如果不够用 那么就要提示是否充值  如果充值 就要弹出充值页面
      checkOilCard({
        oilCardNo: this.oilCardConsumeInfo.oilCardNo,
        consumeAmount: this.oilCardConsumeInfo.refuelingMoney
      }).then(res => {
        // 如果余额不足 要进行充值
        if (res.data.error === '油卡余额不足') {
          this.$confirm('油卡余额不足,是否充值?', '提示', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this.oilCardDialogVisible = true
            this.moneyInfo.rechargeName = this.trueName;
          })
          // 如果油卡信息不存在
        } else if (res.data.error === '油卡不存在') {
          this.$message.error('油卡不存在')
        } else {
          // 先从session拿出出差信息 判断是否存在
          const businessTripInfo = JSON.parse(sessionStorage.getItem('BusinessTrip-form'))
          if (businessTripInfo === undefined || businessTripInfo === {} || businessTripInfo === null) {
            this.$message.error('出差信息为空!请先添加出差信息')
          }
          // 纠正money
          this.oilCardConsumeInfo.rechargeMoney = this.isRecharge === '2' ? '0' : this.oilCardConsumeInfo.rechargeMoney

          // 添加油卡消费信息
          addOilCardConsume({
            ...this.oilCardConsumeInfo,
            bTripId: businessTripInfo.id,
          }).then(res => {
            this.$message.success('保存成功~')

            // 回写充值账户信息到报销项中
            this.tripReimbursementList.push({
              index: this.tripReimbursementList.length + 1,
              item: '加油卡现金充值金额',
              itemCost: this.oilCardConsumeInfo.rechargeMoney,
              isDisabled: true // 不可更改
            })

            // 关闭油卡消费添加弹窗
            this.oilCardConsumeVisible = false
          })
        }
      })
    },
    clearOilCard() {
      this.oilCardConsumeVisible = false;
      this.oilCardConsumeInfo = {}
      this.carApplyForm.isUseOilCard = '0';
      this.$message.success('已清除')
    },
    handleCommitBackOilCard(val) {
      this.oilCardConsumeInfo.oilCardNo = val.oilCardNo;
    },
    handleCommitBackQueryOilCard(val) {
      this.queryOilCard = val
    },

    // 公司车辆
    handleCommitCarNumber(val) {
      this.oilCardConsumeInfo.carNo = val.dictLabel
    },
    handleCommitBackQueryCarNumber(val) {
      this.queryCarNumber = val;
    },

    // 文件上传
    handleFileSuccess(response, file, fileList) {
      console.log(response)
      if (response.code === 200) {
        this.oilCardConsumeInfo.attachmentOiladd = response.url
        console.log(this.oilCardConsumeInfo.attachmentOiladd)
        this.$message.success('上传成功')
      } else {
        this.$message.error('上传失败')
      }
      fileList.pop();
    },
    // 查看附件
    checkPath(path) {
      window.open(path)
    },

    // 油卡充值
    handleCommitBackBankAcount(val) {
      this.moneyInfo.acountsName = val.acountsName;
      this.moneyInfo.bankNo = val.bankNo;
    },
    handleUpdateQueryBankAcount(val) {
      this.queryBankAcount = val
    },
    handleUpload(val) {
      this.moneyInfo.attachment = val;
    },
    handleClick(tab, event) {
      console.log(tab.name, event);
      if (tab.name === 'first') {
      } else {
      }
    },
    //确认银行卡充值
    submitMoney() {
      //添加
      addOilRecharge(this.moneyInfo).then(res => {
        this.$message.success('充值成功')
      })
      this.oilCardDialogVisible = false
    },
    handleCommitBack(val) {
      console.log(val)
      //自动填充加油卡信息
      this.moneyInfo.oilCardNo = val.oilCardNo
    },
    /** 查询出差列表 */
    getList() {
      this.loading = true;
      listBusinessTrip(this.queryParams).then(response => {
        this.BusinessTripList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },

    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
      // 清除session中保存的出差信息
      window.sessionStorage.removeItem('BusinessTrip-form')
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        employeeID: null,
        employee: null,
        personnel: null,
        starttime: null,
        endtime: null,
        attachmentPath: null,
        isReimburse: null,
        comments: null,
        addtime: null,
        userId: null,
        UserName: null,
        updateTime: null,
        delFlag: null
      };
      this.tripReimbursementList = [];
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
      //这里重置了form
      this.reset();
      // 清除状态
      sessionStorage.removeItem('carApplyForm')
      sessionStorage.removeItem('BusinessTrip-form')
      this.carApplyForm = {}
      this.oilCardConsumeInfo = {}
      this.form = {}

      //自动填充填写人
      this.form.employee = this.trueName;
      this.open = true;
      this.title = "添加出差";
      // 生成一个UUID 保存在Vue实例上，单次填写生成的UUID是唯一的
      this.UUID = getUuid()
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      // 清除状态
      sessionStorage.removeItem('carApplyForm')
      sessionStorage.removeItem('BusinessTrip-form')
      this.carApplyForm = {}
      this.oilCardConsumeInfo = {}
      this.form = {}

      const id = row.id || this.ids
      // 拿到该行id对应的出差信息
      getBusinessTrip(id).then(response => {
        this.form = response.data;
        // 需要判断一下是否有车辆使用信息 保存状态
        listCarApply({bTripId: response.data.id}).then(res => {
          // 如果有车辆使用信息
          if (res.rows.length !== 0) {
            this.useCar = '是'
            setTimeout(() => {
              this.$message.success('该出差信息车辆信息填写成功')
              this.carApplyForm = res.rows[0];
            }, 50)
          }
          // 如果没有车辆使用信息
          else {
            this.$message.warning('该出差信息无车辆使用信息')
            //自动填充填写人和部门
            this.carApplyForm.applyUser = this.trueName;
            this.carApplyForm.department = this.form.deptName;
          }
        })
        // 报销项信息保存状态
        this.tripReimbursementList = response.data.tripReimbursementList;
        this.open = true;
        this.title = "修改出差";
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除出差编号为"' + ids + '"的数据项？').then(function () {
        return delBusinessTrip(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 出差报销序号 */
    rowTripReimbursementIndex({row, rowIndex}) {
      row.index = rowIndex + 1;
    },
    /** 出差报销添加按钮操作 */
    handleAddTripReimbursement() {
      let obj = {};
      obj.item = "";
      obj.itemCost = "";
      obj.comments = "";
      obj.addtime = "";
      obj.userId = "";
      obj.UserName = "";
      obj.delFlag = "";
      this.tripReimbursementList.push(obj);
    },
    /** 出差报销删除按钮操作 */
    handleDeleteTripReimbursement() {
      if (this.checkedTripReimbursement.length == 0) {
        this.$modal.msgError("请先选择要删除的出差报销数据");
      } else {
        const tripReimbursementList = this.tripReimbursementList;
        const checkedTripReimbursement = this.checkedTripReimbursement;
        this.tripReimbursementList = tripReimbursementList.filter(function (item) {
          return checkedTripReimbursement.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handleTripReimbursementSelectionChange(selection) {
      this.checkedTripReimbursement = selection.map(item => item.index)
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/BusinessTrip/export', {
        ...this.queryParams
      }, `BusinessTrip_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
