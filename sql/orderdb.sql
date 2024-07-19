/*
 Navicat Premium Data Transfer

 Source Server         : 本地连接-MySql
 Source Server Type    : MySQL
 Source Server Version : 80012 (8.0.12)
 Source Host           : localhost:3306
 Source Schema         : orderdb

 Target Server Type    : MySQL
 Target Server Version : 80012 (8.0.12)
 File Encoding         : 65001

 Date: 18/07/2024 11:34:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for balanceaccounts
-- ----------------------------
DROP TABLE IF EXISTS `balanceaccounts`;
CREATE TABLE `balanceaccounts`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作时间',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '金额',
  `company` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司',
  `companyID` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '对方公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '余额账户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of balanceaccounts
-- ----------------------------

-- ----------------------------
-- Table structure for bankacceptance
-- ----------------------------
DROP TABLE IF EXISTS `bankacceptance`;
CREATE TABLE `bankacceptance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作日期',
  `billNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据号码',
  `issueDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出票日期',
  `dueDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '到期日期',
  `billAccount` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方承兑账户',
  `billDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据日期',
  `billType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类（收入、支出）',
  `reason` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '事由',
  `billAmount` float NULL DEFAULT 0 COMMENT '票据金额',
  `inDiscountPoints` float NULL DEFAULT 0 COMMENT '贴息点数',
  `inDiscountAmount` float NULL DEFAULT 0 COMMENT '贴息金额',
  `billCategory` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据种类（电子/纸质）',
  `origin` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源',
  `endorser` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '背书人',
  `endorsee` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '被背书人',
  `endorseReason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '背书事由（出卖/付货款）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '银行承兑' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bankacceptance
-- ----------------------------
INSERT INTO `bankacceptance` VALUES (1, '123', '123', '123', '123', '123', '123', NULL, '123', 123, 123, 123, '123', '123', '13', '123', '123', '123', '123', 1, NULL, NULL);

-- ----------------------------
-- Table structure for bankaccount
-- ----------------------------
DROP TABLE IF EXISTS `bankaccount`;
CREATE TABLE `bankaccount`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司名称',
  `companyId` int(11) NULL DEFAULT 0 COMMENT '对应公司ID',
  `bankName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `acountsName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户名称',
  `bankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `acountsType` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账户类型（己方公司，客户，供应商，司机，其它）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `amount` float NULL DEFAULT 0 COMMENT '当前资金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1648 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '银行账户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bankaccount
-- ----------------------------
INSERT INTO `bankaccount` VALUES (1647, '1231', 23123, '123', '3213123', '3', NULL, '3', 33);

-- ----------------------------
-- Table structure for bankaccountchange
-- ----------------------------
DROP TABLE IF EXISTS `bankaccountchange`;
CREATE TABLE `bankaccountchange`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `tableName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发生操作行为的表',
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发生操作行为的付款编号（UUID）',
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `changeType` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '变动类型（收入、支出）',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '金额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '银行账号变更' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bankaccountchange
-- ----------------------------

-- ----------------------------
-- Table structure for borrowedmoney
-- ----------------------------
DROP TABLE IF EXISTS `borrowedmoney`;
CREATE TABLE `borrowedmoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款编号（UUID）',
  `origin` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款来源',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '借入金额',
  `ratio` float NULL DEFAULT 0 COMMENT '贷款利率',
  `loanDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款发放日期',
  `loanDuring` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款年限（年）',
  `mortgageGuarantee` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '抵押担保',
  `acountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打入账户',
  `bankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打入账号',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '借入金钱' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrowedmoney
-- ----------------------------

-- ----------------------------
-- Table structure for businesstrip
-- ----------------------------
DROP TABLE IF EXISTS `businesstrip`;
CREATE TABLE `businesstrip`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `personnel` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差人员',
  `starttime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差时间',
  `startMilesPhoto` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出发里程拍照',
  `refuelPhoto` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油拍照',
  `endtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差结束时间',
  `endMilesPhoto` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结束里程拍照',
  `feesPhoto` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差费用拍照',
  `isReimburse` int(11) NULL DEFAULT 0 COMMENT '是否已报销（0未报销，1已报销）',
  `comments` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出差记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of businesstrip
-- ----------------------------

-- ----------------------------
-- Table structure for carapply
-- ----------------------------
DROP TABLE IF EXISTS `carapply`;
CREATE TABLE `carapply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applyDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请时间',
  `applyUser` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人',
  `department` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `carNo` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车牌',
  `isUseOilCard` int(11) NULL DEFAULT 0 COMMENT '是否携带油卡',
  `iolCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '油卡号',
  `peers` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '随同乘车人员',
  `startTime` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用车时间',
  `endTime` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还车时间',
  `ApplyPurpose` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用车事由',
  `startMile` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出车前里程',
  `startCarState` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出车前车况（外观是否损坏，车胎等）',
  `endMile` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回来后里程',
  `endCarState` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回来后车况（外观是否损坏，车胎等）',
  `miles` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用车里程数',
  `backStopPlace` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回程停靠位置',
  `violationsCount` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '行程中违法次数',
  `fine` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '违章罚款金额金额',
  `isMaintenance` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '行程中是否维修/保养',
  `maintenanceMoney` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保养金额',
  `refuelingFrequency` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '行程中使用加油卡加油次数',
  `refuelingMoney` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油金额',
  `oilCardSurplus` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡余额',
  `isOilTicket` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油小票记录是否交给公司管理车辆人员',
  `refuelingCash` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '现金加油金额',
  `dispatchPerson` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '派车人',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 85 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '汽车申请' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carapply
-- ----------------------------

-- ----------------------------
-- Table structure for cars
-- ----------------------------
DROP TABLE IF EXISTS `cars`;
CREATE TABLE `cars`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carNo` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车牌',
  `driver` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '司机',
  `tel` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '司机电话',
  `bankName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `acountsName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户名',
  `bankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `acountsType` int(11) NULL DEFAULT 0 COMMENT '账号类型（1收款，2付款）',
  `carType` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输类型(陆运，海运)',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '汽车信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cars
-- ----------------------------

-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司',
  `relationName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `relationTel` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `address` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `bankName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `acountsName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户名',
  `bankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `surplusMoney` float NOT NULL DEFAULT 0 COMMENT '余额',
  `companyType` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户类别（ 客户，供应商）',
  `delflag` int(11) NULL DEFAULT 1 COMMENT '删除标记',
  `salesman` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员',
  `leader` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '老板',
  `leaderTel` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `region` varchar(280) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区域（省+市县+乡镇）',
  `salesManager` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售经理',
  `province` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '市县',
  `county` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '乡镇',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '公司信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of company
-- ----------------------------

-- ----------------------------
-- Table structure for customervisit
-- ----------------------------
DROP TABLE IF EXISTS `customervisit`;
CREATE TABLE `customervisit`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `province` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '市县',
  `county` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '乡镇（街道）',
  `customer` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `leaderName` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `LeaderTel` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人电话',
  `equipment` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '厂房设备',
  `competitor` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '竞争对手',
  `localDealer` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '当地经销商',
  `monthlyConsumption` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '月用货量（车数）',
  `whiteGlassFactory` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '白玻用货习惯及厂家',
  `loweGlassConsumption` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'lowe玻璃用货厂家及用量',
  `colorGlassConsumption` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '色玻、过度色玻璃用货厂家及用量',
  `specialGlassConsumption` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '特色厚度、特殊尺寸、协议品用货厂家及用量',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `visitDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '走访日期',
  `checkState` int(11) NULL DEFAULT 0 COMMENT '审核标志',
  `checkUserID` int(11) NULL DEFAULT 0 COMMENT '审核人ID',
  `checkUserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '走访记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of customervisit
-- ----------------------------

-- ----------------------------
-- Table structure for exwarehouse
-- ----------------------------
DROP TABLE IF EXISTS `exwarehouse`;
CREATE TABLE `exwarehouse`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storeHouseid` int(11) NULL DEFAULT 0 COMMENT '仓库ID',
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `storeID` int(11) NULL DEFAULT 0 COMMENT '仓库存储的货物ID',
  `outDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出库日期',
  `outAmount` int(11) NULL DEFAULT 0 COMMENT '出库量（片数）',
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exwarehouse
-- ----------------------------

-- ----------------------------
-- Table structure for fixedassets
-- ----------------------------
DROP TABLE IF EXISTS `fixedassets`;
CREATE TABLE `fixedassets`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `buyDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购入日期',
  `assetNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资产编号',
  `assetName` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资产名称',
  ` specification` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格型号（车牌号）',
  `number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数量',
  `measurementUnit` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `amountIncludeTax` float NULL DEFAULT 0 COMMENT '含税金额',
  `amountNoTax` float NULL DEFAULT 0 COMMENT '不含税金额',
  `account` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '户名名称（公户/个人）',
  `department` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用部门',
  `scrapDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '固定资产清理时间',
  `saleAmount` float NULL DEFAULT 0 COMMENT '清理/变卖价值',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '固定资产信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fixedassets
-- ----------------------------

-- ----------------------------
-- Table structure for fleet
-- ----------------------------
DROP TABLE IF EXISTS `fleet`;
CREATE TABLE `fleet`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车队名称',
  `fLeader` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车队经理',
  `tel` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车队经理电话',
  `address` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `editTime` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编辑时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车队信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fleet
-- ----------------------------

-- ----------------------------
-- Table structure for futuresmargin
-- ----------------------------
DROP TABLE IF EXISTS `futuresmargin`;
CREATE TABLE `futuresmargin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `futuresNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保证金编号（UUID）',
  `futuresMarginCompany` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '期货保证金公司',
  `target` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对象(员工、外面公司在我公司借款)',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '保证金金额',
  `targetAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账户',
  `targetBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号',
  `targetBankName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方开户行',
  `selfAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方支付账户',
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方账号',
  `selfBankName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方开户行',
  `futuresDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付期货保证金时间',
  `reason` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '事由',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '期货保证金信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of futuresmargin
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (33, 'balanceaccounts', '余额账户', NULL, NULL, 'Balanceaccounts', 'crud', '', 'com.ruoyi.system', 'system', 'balanceaccounts', '余额账户', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (34, 'bankacceptance', '银行承兑', NULL, NULL, 'Bankacceptance', 'crud', '', 'com.ruoyi.system', 'system', 'bankacceptance', '银行承兑', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (35, 'bankaccount', '银行账户', NULL, NULL, 'Bankaccount', 'crud', '', 'com.ruoyi.system', 'system', 'bankaccount', '银行账户', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (36, 'bankaccountchange', '银行账号变更', NULL, NULL, 'Bankaccountchange', 'crud', '', 'com.ruoyi.system', 'system', 'bankaccountchange', '银行账号变更', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (37, 'borrowedmoney', '借入金钱', NULL, NULL, 'Borrowedmoney', 'crud', '', 'com.ruoyi.system', 'system', 'borrowedmoney', '借入金钱', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (38, 'businesstrip', '出差记录', NULL, NULL, 'Businesstrip', 'crud', '', 'com.ruoyi.system', 'system', 'businesstrip', '出差记录', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (39, 'carapply', '汽车申请', NULL, NULL, 'Carapply', 'crud', '', 'com.ruoyi.system', 'system', 'carapply', '汽车申请', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (40, 'cars', '汽车信息', NULL, NULL, 'Cars', 'crud', '', 'com.ruoyi.system', 'system', 'cars', '汽车信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (41, 'company', '公司信息', NULL, NULL, 'Company', 'crud', '', 'com.ruoyi.system', 'system', 'company', '公司信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (42, 'customervisit', '走访记录', NULL, NULL, 'Customervisit', 'crud', '', 'com.ruoyi.system', 'system', 'customervisit', '走访记录', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (43, 'exwarehouse', '出库信息', NULL, NULL, 'Exwarehouse', 'crud', '', 'com.ruoyi.system', 'system', 'exwarehouse', '出库信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (44, 'fixedassets', '固定资产信息', NULL, NULL, 'Fixedassets', 'crud', '', 'com.ruoyi.system', 'system', 'fixedassets', '固定资产信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (45, 'fleet', '车队信息', NULL, NULL, 'Fleet', 'crud', '', 'com.ruoyi.system', 'system', 'fleet', '车队信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (46, 'futuresmargin', '期货保证金信息', NULL, NULL, 'Futuresmargin', 'crud', '', 'com.ruoyi.system', 'system', 'futuresmargin', '期货保证金信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (47, 'goodsorder', '货物订单', NULL, NULL, 'Goodsorder', 'crud', '', 'com.ruoyi.system', 'system', 'goodsorder', '货物订单', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (48, 'inventory', '库存', NULL, NULL, 'Inventory', 'crud', '', 'com.ruoyi.system', 'system', 'inventory', '库存', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:51', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (49, 'lendmoney', '借贷', NULL, NULL, 'Lendmoney', 'crud', '', 'com.ruoyi.system', 'system', 'lendmoney', '借贷', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (50, 'liabilities', '负债信息', NULL, NULL, 'Liabilities', 'crud', '', 'com.ruoyi.system', 'system', 'liabilities', '负债信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (51, 'offsetting', '资金调整单信息', NULL, NULL, 'Offsetting', 'crud', '', 'com.ruoyi.system', 'system', 'offsetting', '资金调整单信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (52, 'oilcard', '加油卡信息', NULL, NULL, 'Oilcard', 'crud', '', 'com.ruoyi.system', 'system', 'oilcard', '加油卡信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (53, 'oilcardmain', '加油卡主卡登记信息', NULL, NULL, 'Oilcardmain', 'crud', '', 'com.ruoyi.system', 'system', 'oilcardmain', '加油卡主卡登记信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (54, 'orderdetail', '订单详情', NULL, NULL, 'Orderdetail', 'crud', '', 'com.ruoyi.system', 'system', 'orderdetail', '订单详情', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (55, 'orderfreight', '订单运费信息', NULL, NULL, 'Orderfreight', 'crud', '', 'com.ruoyi.system', 'system', 'orderfreight', '订单运费信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (56, 'orderinvoice', '订单发票信息', NULL, NULL, 'Orderinvoice', 'crud', '', 'com.ruoyi.system', 'system', 'orderinvoice', '订单发票信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (57, 'payment', '收付款信息', NULL, NULL, 'Payment', 'crud', '', 'com.ruoyi.system', 'system', 'payment', '收付款信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (58, 'productlevel', '产品级别信息', NULL, NULL, 'Productlevel', 'crud', '', 'com.ruoyi.system', 'system', 'productlevel', '产品级别信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (59, 'rebate', '返利信息', NULL, NULL, 'Rebate', 'crud', '', 'com.ruoyi.system', 'system', 'rebate', '返利信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (60, 'recoverfuturesmargin', '恢复期货保证金？', NULL, NULL, 'Recoverfuturesmargin', 'crud', '', 'com.ruoyi.system', 'system', 'recoverfuturesmargin', '恢复期货保证金？', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (61, 'repayment', '还款信息', NULL, NULL, 'Repayment', 'crud', '', 'com.ruoyi.system', 'system', 'repayment', '还款信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (62, 'socialinsurance', '社会保险信息', NULL, NULL, 'Socialinsurance', 'crud', '', 'com.ruoyi.system', 'system', 'socialinsurance', '社会保险信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (63, 'storehouse', '仓库信息', NULL, NULL, 'Storehouse', 'crud', '', 'com.ruoyi.system', 'system', 'storehouse', '仓库信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (64, 'tableeditmessage', '表信息', NULL, NULL, 'Tableeditmessage', 'crud', '', 'com.ruoyi.system', 'system', 'tableeditmessage', '信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-18 09:35:52', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1231 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (616, 33, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (617, 33, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (618, 33, 'moneyAmount', '金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (619, 33, 'company', '对方公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (620, 33, 'companyID', '对方公司ID', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (621, 33, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (622, 33, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (623, 33, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (624, 33, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (625, 33, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (626, 33, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (627, 34, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (628, 34, 'operateDate', '操作日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (629, 34, 'billNo', '票据号码', 'varchar(55)', 'String', 'billNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (630, 34, 'issueDate', '出票日期', 'varchar(50)', 'String', 'issueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (631, 34, 'dueDate', '到期日期', 'varchar(50)', 'String', 'dueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (632, 34, 'billAccount', '我方承兑账户', 'varchar(50)', 'String', 'billAccount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (633, 34, 'billDate', '票据日期', 'varchar(50)', 'String', 'billDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (634, 34, 'billType', '分类（收入、支出）', 'varchar(55)', 'String', 'billType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (635, 34, 'reason', '事由', 'varchar(155)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (636, 34, 'billAmount', '票据金额', 'float', 'Long', 'billAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (637, 34, 'inDiscountPoints', '贴息点数', 'float', 'Long', 'inDiscountPoints', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (638, 34, 'inDiscountAmount', '贴息金额', 'float', 'Long', 'inDiscountAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (639, 34, 'billCategory', '票据种类（电子/纸质）', 'varchar(55)', 'String', 'billCategory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (640, 34, 'origin', '来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (641, 34, 'endorser', '背书人', 'varchar(155)', 'String', 'endorser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (642, 34, 'endorsee', '被背书人', 'varchar(155)', 'String', 'endorsee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (643, 34, 'endorseReason', '背书事由（出卖/付货款）', 'varchar(255)', 'String', 'endorseReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (644, 34, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (645, 34, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (646, 34, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (647, 34, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (648, 34, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (649, 35, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (650, 35, 'companyName', '公司名称', 'varchar(50)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (651, 35, 'companyId', '对应公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (652, 35, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (653, 35, 'acountsName', '开户名称', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (654, 35, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (655, 35, 'acountsType', '账户类型（己方公司，客户，供应商，司机，其它）', 'varchar(50)', 'String', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (656, 35, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (657, 35, 'amount', '当前资金额', 'float', 'Long', 'amount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (658, 36, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (659, 36, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (660, 36, 'tableName', '发生操作行为的表', 'varchar(80)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (661, 36, 'payNO', '发生操作行为的付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (662, 36, 'operateDate', '日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (663, 36, 'changeType', '变动类型（收入、支出）', 'varchar(15)', 'String', 'changeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (664, 36, 'moneyAmount', '金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (665, 36, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (666, 36, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (667, 36, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (668, 36, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (669, 36, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (670, 37, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (671, 37, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (672, 37, 'origin', '贷款来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (673, 37, 'moneyAmount', '借入金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (674, 37, 'ratio', '贷款利率', 'float', 'Long', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (675, 37, 'loanDate', '贷款发放日期', 'varchar(50)', 'String', 'loanDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (676, 37, 'loanDuring', '贷款年限（年）', 'varchar(50)', 'String', 'loanDuring', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (677, 37, 'mortgageGuarantee', '抵押担保', 'varchar(200)', 'String', 'mortgageGuarantee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (678, 37, 'acountsName', '打入账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (679, 37, 'bankNo', '打入账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (680, 37, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (681, 37, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (682, 37, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (683, 37, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (684, 37, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (685, 38, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (686, 38, 'personnel', '出差人员', 'varchar(150)', 'String', 'personnel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (687, 38, 'starttime', '出差时间', 'varchar(50)', 'String', 'starttime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (688, 38, 'startMilesPhoto', '出发里程拍照', 'varchar(250)', 'String', 'startMilesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (689, 38, 'refuelPhoto', '加油拍照', 'varchar(250)', 'String', 'refuelPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (690, 38, 'endtime', '出差结束时间', 'varchar(50)', 'String', 'endtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (691, 38, 'endMilesPhoto', '结束里程拍照', 'varchar(250)', 'String', 'endMilesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (692, 38, 'feesPhoto', '出差费用拍照', 'varchar(250)', 'String', 'feesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (693, 38, 'isReimburse', '是否已报销（0未报销，1已报销）', 'int(11)', 'Long', 'isReimburse', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (694, 38, 'comments', '备注', 'varchar(550)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (695, 38, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (696, 38, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (697, 38, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (698, 38, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (699, 38, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (700, 39, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (701, 39, 'applyDate', '申请时间', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (702, 39, 'applyUser', '申请人', 'varchar(25)', 'String', 'applyUser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (703, 39, 'department', '部门', 'varchar(25)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (704, 39, 'carNo', '车牌', 'varchar(20)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (705, 39, 'isUseOilCard', '是否携带油卡', 'int(11)', 'Long', 'isUseOilCard', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (706, 39, 'iolCardNo', '油卡号', 'varchar(55)', 'String', 'iolCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (707, 39, 'peers', '随同乘车人员', 'varchar(155)', 'String', 'peers', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (708, 39, 'startTime', '用车时间', 'varchar(55)', 'String', 'startTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (709, 39, 'endTime', '还车时间', 'varchar(55)', 'String', 'endTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (710, 39, 'ApplyPurpose', '用车事由', 'varchar(255)', 'String', 'ApplyPurpose', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (711, 39, 'startMile', '出车前里程', 'varchar(55)', 'String', 'startMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (712, 39, 'startCarState', '出车前车况（外观是否损坏，车胎等）', 'varchar(155)', 'String', 'startCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (713, 39, 'endMile', '回来后里程', 'varchar(55)', 'String', 'endMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (714, 39, 'endCarState', '回来后车况（外观是否损坏，车胎等）', 'varchar(255)', 'String', 'endCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (715, 39, 'miles', '用车里程数', 'varchar(55)', 'String', 'miles', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (716, 39, 'backStopPlace', '回程停靠位置', 'varchar(155)', 'String', 'backStopPlace', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (717, 39, 'violationsCount', '行程中违法次数', 'varchar(15)', 'String', 'violationsCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (718, 39, 'fine', '违章罚款金额金额', 'varchar(25)', 'String', 'fine', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (719, 39, 'isMaintenance', '行程中是否维修/保养', 'varchar(5)', 'String', 'isMaintenance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (720, 39, 'maintenanceMoney', '保养金额', 'varchar(15)', 'String', 'maintenanceMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (721, 39, 'refuelingFrequency', '行程中使用加油卡加油次数', 'varchar(15)', 'String', 'refuelingFrequency', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (722, 39, 'refuelingMoney', '加油金额', 'varchar(25)', 'String', 'refuelingMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (723, 39, 'oilCardSurplus', '加油卡余额', 'varchar(25)', 'String', 'oilCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (724, 39, 'isOilTicket', '加油小票记录是否交给公司管理车辆人员', 'varchar(5)', 'String', 'isOilTicket', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (725, 39, 'refuelingCash', '现金加油金额', 'varchar(25)', 'String', 'refuelingCash', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (726, 39, 'dispatchPerson', '派车人', 'varchar(25)', 'String', 'dispatchPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (727, 39, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (728, 39, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (729, 39, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (730, 39, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 31, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (731, 39, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 32, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (732, 39, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (733, 39, 'path', '附件路径', 'varchar(255)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (734, 40, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (735, 40, 'carNo', '车牌', 'varchar(20)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (736, 40, 'driver', '司机', 'varchar(20)', 'String', 'driver', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (737, 40, 'tel', '司机电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (738, 40, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (739, 40, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (740, 40, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (741, 40, 'acountsType', '账号类型（1收款，2付款）', 'int(11)', 'Long', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (742, 40, 'carType', '运输类型(陆运，海运)', 'varchar(50)', 'String', 'carType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (743, 40, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (744, 40, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (745, 40, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (746, 40, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (747, 40, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (748, 41, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (749, 41, 'company', '公司', 'varchar(550)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (750, 41, 'relationName', '联系人', 'varchar(50)', 'String', 'relationName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (751, 41, 'relationTel', '联系人电话', 'varchar(30)', 'String', 'relationTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (752, 41, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (753, 41, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (754, 41, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (755, 41, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (756, 41, 'surplusMoney', '余额', 'float', 'Long', 'surplusMoney', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (757, 41, 'companyType', '客户类别（ 客户，供应商）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (758, 41, 'delflag', '删除标记', 'int(11)', 'Long', 'delflag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (759, 41, 'salesman', '业务员', 'varchar(55)', 'String', 'salesman', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (760, 41, 'leader', '老板', 'varchar(50)', 'String', 'leader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (761, 41, 'leaderTel', '联系人电话', 'varchar(30)', 'String', 'leaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (762, 41, 'region', '区域（省+市县+乡镇）', 'varchar(280)', 'String', 'region', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (763, 41, 'salesManager', '销售经理', 'varchar(55)', 'String', 'salesManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (764, 41, 'province', '省', 'varchar(55)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (765, 41, 'city', '市县', 'varchar(155)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (766, 41, 'county', '乡镇', 'varchar(155)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (767, 41, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (768, 41, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (769, 41, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (770, 41, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 23, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (771, 41, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 24, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (772, 42, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (773, 42, 'province', '省', 'varchar(50)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (774, 42, 'city', '市县', 'varchar(50)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (775, 42, 'county', '乡镇（街道）', 'varchar(100)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (776, 42, 'customer', '客户', 'varchar(550)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (777, 42, 'leaderName', '负责人', 'varchar(550)', 'String', 'leaderName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (778, 42, 'LeaderTel', '负责人电话', 'varchar(550)', 'String', 'LeaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (779, 42, 'equipment', '厂房设备', 'varchar(200)', 'String', 'equipment', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (780, 42, 'competitor', '竞争对手', 'varchar(200)', 'String', 'competitor', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (781, 42, 'localDealer', '当地经销商', 'varchar(200)', 'String', 'localDealer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (782, 42, 'monthlyConsumption', '月用货量（车数）', 'varchar(200)', 'String', 'monthlyConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (783, 42, 'whiteGlassFactory', '白玻用货习惯及厂家', 'varchar(200)', 'String', 'whiteGlassFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (784, 42, 'loweGlassConsumption', 'lowe玻璃用货厂家及用量', 'varchar(200)', 'String', 'loweGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (785, 42, 'colorGlassConsumption', '色玻、过度色玻璃用货厂家及用量', 'varchar(200)', 'String', 'colorGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (786, 42, 'specialGlassConsumption', '特色厚度、特殊尺寸、协议品用货厂家及用量', 'varchar(200)', 'String', 'specialGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (787, 42, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (788, 42, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (789, 42, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (790, 42, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (791, 42, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 20, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (792, 42, 'visitDate', '走访日期', 'varchar(50)', 'String', 'visitDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (793, 42, 'checkState', '审核标志', 'int(11)', 'Long', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (794, 42, 'checkUserID', '审核人ID', 'int(11)', 'Long', 'checkUserID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (795, 42, 'checkUserName', '审核人', 'varchar(50)', 'String', 'checkUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (796, 42, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (797, 43, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (798, 43, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (799, 43, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (800, 43, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (801, 43, 'outDate', '出库日期', 'varchar(50)', 'String', 'outDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (802, 43, 'outAmount', '出库量（片数）', 'int(11)', 'Long', 'outAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (803, 43, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (804, 43, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (805, 43, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (806, 44, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (807, 44, 'buyDate', '购入日期', 'varchar(50)', 'String', 'buyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (808, 44, 'assetNo', '资产编号', 'varchar(55)', 'String', 'assetNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (809, 44, 'assetName', '资产名称', 'varchar(155)', 'String', 'assetName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (810, 44, ' specification', '规格型号（车牌号）', 'varchar(100)', 'String', ' specification', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (811, 44, 'number', '数量', 'varchar(20)', 'String', 'number', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (812, 44, 'measurementUnit', '计量单位', 'varchar(55)', 'String', 'measurementUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (813, 44, 'amountIncludeTax', '含税金额', 'float', 'Long', 'amountIncludeTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (814, 44, 'amountNoTax', '不含税金额', 'float', 'Long', 'amountNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (815, 44, 'account', '户名名称（公户/个人）', 'varchar(55)', 'String', 'account', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (816, 44, 'department', '使用部门', 'varchar(55)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (817, 44, 'scrapDate', '固定资产清理时间', 'varchar(50)', 'String', 'scrapDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (818, 44, 'saleAmount', '清理/变卖价值', 'float', 'Long', 'saleAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (819, 44, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (820, 44, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (821, 44, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (822, 44, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (823, 44, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (824, 45, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (825, 45, 'fName', '车队名称', 'varchar(50)', 'String', 'fName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (826, 45, 'fLeader', '车队经理', 'varchar(50)', 'String', 'fLeader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (827, 45, 'tel', '车队经理电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (828, 45, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (829, 45, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (830, 45, 'editTime', '编辑时间', 'varchar(55)', 'String', 'editTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (831, 45, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (832, 46, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (833, 46, 'futuresNO', '保证金编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (834, 46, 'futuresMarginCompany', '期货保证金公司', 'varchar(80)', 'String', 'futuresMarginCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (835, 46, 'target', '对象(员工、外面公司在我公司借款)', 'varchar(50)', 'String', 'target', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (836, 46, 'moneyAmount', '保证金金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (837, 46, 'targetAcountsName', '对方账户', 'varchar(80)', 'String', 'targetAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (838, 46, 'targetBankNo', '对方账号', 'varchar(80)', 'String', 'targetBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (839, 46, 'targetBankName', '对方开户行', 'varchar(80)', 'String', 'targetBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (840, 46, 'selfAcountsName', '我方支付账户', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (841, 46, 'selfBankNo', '我方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (842, 46, 'selfBankName', '我方开户行', 'varchar(80)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (843, 46, 'futuresDate', '支付期货保证金时间', 'varchar(50)', 'String', 'futuresDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (844, 46, 'reason', '事由', 'varchar(200)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (845, 46, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (846, 46, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (847, 46, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (848, 46, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (849, 46, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (850, 47, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (851, 47, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (852, 47, 'orderDate', '日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (853, 47, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (854, 47, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (855, 47, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (856, 47, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (857, 47, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (858, 47, 'landDriverName', '陆地司机姓名', 'varchar(55)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (859, 47, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (860, 47, 'seaCarNo', '海运车牌', 'varchar(50)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (861, 47, 'seaDriverTel', '海运司机电话', 'varchar(50)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (862, 47, 'seaDriverName', '海运司机姓名', 'varchar(55)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (863, 47, 'checkUserId', '审核人编号', 'int(11)', 'Long', 'checkUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (864, 47, 'checkState', '审核状态（已审核、未审核）', 'varchar(20)', 'String', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (865, 47, 'invoiceState', '开票状态（未开票，部分开票，已开票）', 'varchar(20)', 'String', 'invoiceState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (866, 47, 'path', '附件路径', 'varchar(250)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (867, 47, 'PaymentState', '打款状态(已打款，未打款)', 'varchar(20)', 'String', 'PaymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (868, 47, 'landBankName', '陆运银行户名', 'varchar(50)', 'String', 'landBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (869, 47, 'landBankNo', '陆运银行账号', 'varchar(50)', 'String', 'landBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (870, 47, 'seaBankName', '海运银行户名', 'varchar(50)', 'String', 'seaBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (871, 47, 'seaBankNo', '海运银行账号', 'varchar(50)', 'String', 'seaBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (872, 47, 'receiveProof', '收到条附件路径', 'text', 'String', 'receiveProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 23, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (873, 47, 'saleManager', '销售经理', 'varchar(25)', 'String', 'saleManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (874, 47, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (875, 47, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (876, 47, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (877, 47, 'isAdjust', '是否调整单（是  否）', 'varchar(10)', 'String', 'isAdjust', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (878, 47, 'adjustOrderid', '原订单编号', 'int(11)', 'Long', 'adjustOrderid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (879, 47, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (880, 47, 'customerIsInvoice', '客户是否开票', 'int(11)', 'Long', 'customerIsInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (881, 47, 'isSupplierInvoice', '供应商是否开票', 'int(11)', 'Long', 'isSupplierInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (882, 47, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (883, 47, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (884, 47, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (885, 47, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (886, 47, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 37, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (887, 47, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 38, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (888, 48, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (889, 48, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (890, 48, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (891, 48, 'storeDate', '入库日期', 'varchar(50)', 'String', 'storeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (892, 48, 'stockNumber', '库存量（片数）', 'int(11)', 'Long', 'stockNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (893, 48, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (894, 48, 'supplierId', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (895, 48, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (896, 48, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (897, 48, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (898, 48, 'height', '厚度', 'float', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (899, 48, 'length', '长度', 'float', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (900, 48, 'width', '宽度', 'float', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (901, 48, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (902, 48, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (903, 48, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (904, 48, 'price', '出厂单价', 'float', 'Long', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (905, 48, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (906, 48, 'sundryCost', '杂费', 'float', 'Long', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (907, 48, 'paymentFactory', '出厂货款', 'float', 'Long', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (908, 48, 'paymentUnload', '卸货价', 'float', 'Long', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (909, 48, 'isIncludeTaxSale', '销售是否含税（0不含税，1含税）', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (910, 48, 'payments', '总货款', 'varchar(20)', 'String', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (911, 48, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (912, 48, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (913, 48, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (914, 48, 'landDriverName', '陆地司机姓名', 'varchar(255)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 27, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (915, 48, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (916, 48, 'seaCarNo', '海运车牌', 'varchar(550)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 29, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (917, 48, 'seaDriverTel', '海运司机电话', 'varchar(550)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 30, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (918, 48, 'seaDriverName', '海运司机姓名', 'varchar(255)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 31, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (919, 48, 'erro', '误差', 'float', 'Long', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (920, 48, 'tonnage', '吨位', 'float', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (921, 48, 'landFreightPrice', '陆运费单价', 'float', 'Long', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (922, 48, 'landFreight', '陆运费', 'float', 'Long', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (923, 48, 'seaFreight', '海运费', 'float', 'Long', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (924, 48, 'freight', '运费（海运费+陆运费）', 'float', 'Long', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (925, 48, 'otherCost', '其他费用', 'float', 'Long', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (926, 48, 'profit', '利润', 'float', 'Long', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (927, 48, 'profitNoTax', '不含税利润', 'float', 'Long', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (928, 48, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (929, 48, 'paymentsWithSundry', '总货款杂费', 'float', 'Long', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (930, 48, 'additionalFees', '加费', 'float', 'Long', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (931, 48, 'rebate', '返利金额', 'float', 'Long', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (932, 48, 'customerCommission', '客户佣金', 'float', 'Long', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (933, 48, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (934, 48, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (935, 48, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 48, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (936, 48, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 49, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (937, 48, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 50, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (938, 48, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 51, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (939, 48, 'showFlag', '订单仓库选择时是否显示（ 显示， 不显示）', 'int(11)', 'Long', 'showFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 52, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (940, 49, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (941, 49, 'payNO', '付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (942, 49, 'moneyAmount', '金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (943, 49, 'lendType', '借出类型（公司/个人）', 'varchar(55)', 'String', 'lendType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (944, 49, 'company', '公司/个人名称', 'varchar(55)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (945, 49, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (946, 49, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (947, 49, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (948, 49, 'otherBankID', '对方账号ID', 'varchar(150)', 'String', 'otherBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (949, 49, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (950, 49, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (951, 49, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (952, 49, 'selfBankID', '己方账号ID', 'varchar(150)', 'String', 'selfBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (953, 49, 'acountsName', '打入账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (954, 49, 'bankNo', '打入账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (955, 49, 'payTime', '打入时间', 'varchar(50)', 'String', 'payTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (956, 49, 'originReason', '缘由', 'int(11)', 'Long', 'originReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (957, 49, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (958, 49, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (959, 49, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (960, 49, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (961, 49, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (962, 50, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (963, 50, 'payNO', '付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (964, 50, 'moneyAmount', '金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (965, 50, 'payType', '付款类型', 'int(11)', 'Long', 'payType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (966, 50, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (967, 50, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (968, 50, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (969, 50, 'otherBankID', '对方账号ID', 'varchar(150)', 'String', 'otherBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (970, 50, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (971, 50, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (972, 50, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (973, 50, 'selfBankID', '己方账号ID', 'varchar(150)', 'String', 'selfBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (974, 50, 'payTime', '付款时间', 'varchar(55)', 'String', 'payTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (975, 50, 'payState', '付款类型（未付款、申请、已付款）', 'varchar(55)', 'String', 'payState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (976, 50, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (977, 50, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (978, 50, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (979, 50, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (980, 50, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (981, 51, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (982, 51, 'OffsetNO', '冲抵编号（UUID）', 'varchar(50)', 'String', 'OffsetNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (983, 51, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (984, 51, 'operateType', '冲抵类型（收入、支出）', 'varchar(50)', 'String', 'operateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (985, 51, 'moneyAmount', '金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (986, 51, 'company', '对方公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (987, 51, 'company_id', '对方公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (988, 51, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (989, 51, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (990, 51, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (991, 51, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (992, 51, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (993, 51, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (994, 51, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (995, 52, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (996, 52, 'oilCardNo', '加油卡卡号', 'varchar(155)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (997, 52, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (998, 52, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (999, 52, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1000, 52, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1001, 52, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1002, 52, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1003, 53, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1004, 53, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1005, 53, 'useDate', '使用加油卡时间', 'varchar(50)', 'String', 'useDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1006, 53, 'carNo', '使用加油卡车辆车牌号', 'varchar(55)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1007, 53, 'destination', '地点、事由', 'varchar(155)', 'String', 'destination', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1008, 53, 'startCardSurplus', '期初余额', 'varchar(55)', 'String', 'startCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1009, 53, 'toPlusCardMoney', '主卡转副卡充值金额', 'varchar(55)', 'String', 'toPlusCardMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1010, 53, 'refuelingNumber', '加油量（升）', 'varchar(255)', 'String', 'refuelingNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1011, 53, 'unitPrice', '单价', 'varchar(255)', 'String', 'unitPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1012, 53, 'refuelingMoney', '加油金额(元）', 'varchar(255)', 'String', 'refuelingMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1013, 53, 'rechargeMoney', '充值金额', 'varchar(255)', 'String', 'rechargeMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1014, 53, 'isTicket', '是否有小票', 'varchar(255)', 'String', 'isTicket', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1015, 53, 'endCardSurplus', '加油卡余额', 'varchar(255)', 'String', 'endCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1016, 53, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1017, 53, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1018, 53, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1019, 53, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1020, 53, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1021, 53, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1022, 54, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1023, 54, 'orderId', '订单详情ID', 'int(11)', 'Long', 'orderId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1024, 54, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1025, 54, 'orderDate', '订单日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1026, 54, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1027, 54, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1028, 54, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1029, 54, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1030, 54, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1031, 54, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1032, 54, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1033, 54, 'height', '厚度', 'float', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1034, 54, 'length', '长度', 'float', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1035, 54, 'width', '宽度', 'float', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1036, 54, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1037, 54, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1038, 54, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1039, 54, 'price', '出厂单价', 'float', 'Long', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1040, 54, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1041, 54, 'sundryCost', '杂费', 'float', 'Long', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1042, 54, 'paymentFactory', '出厂货款', 'float', 'Long', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1043, 54, 'paymentUnload', '卸货价', 'float', 'Long', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1044, 54, 'isIncludeTaxSale', '销售是否含税', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1045, 54, 'payments', '总货款', 'float', 'Long', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1046, 54, 'erro', '误差', 'float', 'Long', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1047, 54, 'tonnage', '吨位', 'float', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1048, 54, 'landFreightPrice', '陆运费单价', 'float', 'Long', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1049, 54, 'landFreight', '陆运费', 'float', 'Long', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1050, 54, 'seaFreight', '海运费', 'float', 'Long', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1051, 54, 'freight', '总运费', 'float', 'Long', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1052, 54, 'otherCost', '其他费用', 'float', 'Long', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1053, 54, 'profit', '利润', 'float', 'Long', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1054, 54, 'profitNoTax', '不含税利润', 'float', 'Long', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1055, 54, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1056, 54, 'paymentsWithSundry', '总货款杂费', 'float', 'Long', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1057, 54, 'additionalFees', '加费', 'float', 'Long', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1058, 54, 'storeHouseID', '仓库ID', 'int(11)', 'Long', 'storeHouseID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1059, 54, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 38, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1060, 54, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1061, 54, 'logisticsProfit', '物流利润', 'float', 'Long', 'logisticsProfit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1062, 54, 'customerCommission', '客户佣金', 'float', 'Long', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1063, 54, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1064, 54, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1065, 54, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1066, 54, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1067, 54, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1068, 54, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1069, 54, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 48, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1070, 54, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 49, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1071, 55, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1072, 55, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1073, 55, 'freightState', '运费类型（ 陆运、海运）', 'varchar(55)', 'String', 'freightState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1074, 55, 'moneyAmount', '金额', 'varchar(55)', 'String', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1075, 55, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1076, 55, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1077, 55, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1078, 55, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1079, 55, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1080, 55, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1081, 55, 'content', '备注', 'varchar(150)', 'String', 'content', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1082, 55, 'paymentState', '支付状态（ 已支付、 未支付、  申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1083, 55, 'driverName', '司机姓名', 'varchar(150)', 'String', 'driverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1084, 55, 'driverId', '司机ID', 'int(11)', 'Long', 'driverId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1085, 55, 'CarNo', '车牌号', 'varchar(20)', 'String', 'CarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1086, 55, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1087, 55, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1088, 55, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1089, 55, 'applyUserId', '申请人员ID', 'int(11)', 'Long', 'applyUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1090, 55, 'applyUserName', '申请人员姓名', 'varchar(50)', 'String', 'applyUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 20, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1091, 55, 'applyDate', '申请日期', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1092, 55, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1093, 55, 'payUserId', '付款人员ID', 'int(11)', 'Long', 'payUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1094, 55, 'payUserName', '付款人员姓名', 'varchar(50)', 'String', 'payUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1095, 55, 'payDate', '付款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1096, 55, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1097, 55, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1098, 55, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 28, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1099, 56, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1100, 56, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1101, 56, 'invoiceDate', '开票日期', 'varchar(55)', 'String', 'invoiceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1102, 56, 'invoiceType', '开票类型（购入、卖出）', 'float', 'Long', 'invoiceType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1103, 56, 'invoiceAmount', '应开票金额', 'float', 'Long', 'invoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1104, 56, 'companyType', '公司类别（客户、供应商）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1105, 56, 'companyName', '公司名称', 'varchar(120)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1106, 56, 'companyID', '公司名称', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1107, 56, 'invoiceCompanyName', '票据单位名称', 'varchar(120)', 'String', 'invoiceCompanyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1108, 56, 'actualInvoiceAmount', '实际开票金额', 'float', 'Long', 'actualInvoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1109, 56, 'ticketPoint', '票点', 'float', 'Long', 'ticketPoint', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1110, 56, 'ticketPointAmount', '票点金额（实际开票金额*票点）', 'float', 'Long', 'ticketPointAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1111, 56, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1112, 56, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1113, 56, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1114, 56, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1115, 56, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1116, 57, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1117, 57, 'payCategory', '收付款类型（收款，付款）', 'varchar(55)', 'String', 'payCategory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1118, 57, 'payNO', '付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1119, 57, 'fundsDate', '日期', 'varchar(50)', 'String', 'fundsDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1120, 57, 'payType', '支付类型', 'varchar(55)', 'String', 'payType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1121, 57, 'moneyAmount', '金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1122, 57, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1123, 57, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1124, 57, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1125, 57, 'selfBankID', '己方账号ID', 'varchar(150)', 'String', 'selfBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1126, 57, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1127, 57, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1128, 57, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1129, 57, 'paymentState', '支付状态（已支付、未支付、申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1130, 57, 'company', '对方公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1131, 57, 'company_id', '对方公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1132, 57, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1133, 57, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1134, 57, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1135, 57, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1136, 57, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1137, 57, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1138, 58, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1139, 58, 'levelNo', '级别编码', 'varchar(20)', 'String', 'levelNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1140, 58, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1141, 58, 'categoryNo', '分类编号', 'int(11)', 'Long', 'categoryNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1142, 58, 'categoryName', '分类名称', 'varchar(80)', 'String', 'categoryName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1143, 58, 'height', '厚度', 'float', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1144, 58, 'length', '长度', 'float', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1145, 58, 'width', '宽度', 'float', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1146, 58, 'tonnage', '吨位', 'float', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1147, 58, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1148, 58, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1149, 58, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1150, 58, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1151, 58, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1152, 59, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1153, 59, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1154, 59, 'rebateDate', '日期', 'varchar(50)', 'String', 'rebateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1155, 59, 'rebate', '金额', 'float', 'Long', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1156, 59, 'rebateType', '类型（返利、降价、售后质量赔偿）', 'varchar(80)', 'String', 'rebateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1157, 59, 'inAcountsName', '收款户名', 'varchar(80)', 'String', 'inAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1158, 59, 'inBankNo', '收款账号', 'varchar(80)', 'String', 'inBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1159, 59, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1160, 59, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1161, 59, 'outAcountsName', '付款户名', 'varchar(80)', 'String', 'outAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1162, 59, 'outBankNo', '付款款账号', 'varchar(80)', 'String', 'outBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1163, 59, 'rebateReason', '返利原因', 'varchar(55)', 'String', 'rebateReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1164, 59, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1165, 59, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1166, 59, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1167, 59, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1168, 59, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1169, 60, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1170, 60, 'futuresNO', '保证金编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1171, 60, 'recoverNO', '还款编号（UUID）', 'varchar(50)', 'String', 'recoverNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1172, 60, 'moneyAmount', '收回金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1173, 60, 'recoverDate', '收回日期', 'varchar(50)', 'String', 'recoverDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1174, 60, 'acountsName', '收回账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1175, 60, 'bankNo', '收回账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1176, 60, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1177, 60, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1178, 60, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1179, 60, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1180, 60, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1181, 61, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1182, 61, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1183, 61, 'payNO', '还款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1184, 61, 'moneyAmount', '还（本）金额', 'float', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1185, 61, 'ratio', '付息（金额）', 'float', 'Long', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1186, 61, 'payDate', '还款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1187, 61, 'acountsName', '还款账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1188, 61, 'bankNo', '还款账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1189, 61, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1190, 61, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1191, 61, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1192, 61, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1193, 61, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1194, 62, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1195, 62, 'basicSocialInsurance', '社保缴纳基数', 'float', 'Long', 'basicSocialInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1196, 62, 'basicHousingFund', '公积金基数', 'float', 'Long', 'basicHousingFund', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1197, 62, 'depName', '部门', 'varchar(50)', 'String', 'depName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1198, 62, 'employeeName', '姓名', 'varchar(15)', 'String', 'employeeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1199, 62, 'employeeID', '人员编号', 'varchar(15)', 'String', 'employeeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1200, 62, 'insuranceDate', '缴费时间', 'varchar(50)', 'String', 'insuranceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1201, 62, 'isRecruiting', '是否增员（是，否）', 'varchar(10)', 'String', 'isRecruiting', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1202, 62, 'isDepletion', '是否减员', 'varchar(10)', 'String', 'isDepletion', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1203, 62, 'healthySecuritySelf', '基本医疗保险-个人', 'float', 'Long', 'healthySecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1204, 62, 'healthySecurityCompany', '基本医疗保险-公司', 'float', 'Long', 'healthySecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1205, 62, 'injuryInsurance', '工伤保险', 'float', 'Long', 'injuryInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1206, 62, 'unemploymentSecuritySelf', '失业保险-个人', 'float', 'Long', 'unemploymentSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1207, 62, 'unemploymentSecurityCompany', '失业保险-公司', 'float', 'Long', 'unemploymentSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1208, 62, 'retirementSecuritySelf', '养老保险-个人', 'float', 'Long', 'retirementSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1209, 62, 'retirementSecurityCompany', '养老保险-公司', 'float', 'Long', 'retirementSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1210, 62, 'largeMedicalSecuritySelf', '大额医保-个人', 'float', 'Long', 'largeMedicalSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1211, 62, 'largeMedicalSecurityCompany', '大额医保-公司', 'float', 'Long', 'largeMedicalSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1212, 62, 'housingFundSelf', '公积金-个人', 'float', 'Long', 'housingFundSelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1213, 62, 'housingFundCompany', '公积金-公司', 'float', 'Long', 'housingFundCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1214, 62, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1215, 62, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1216, 62, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1217, 62, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1218, 62, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 25, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1219, 63, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1220, 63, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1221, 63, 'address', '地址', 'varchar(100)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1222, 63, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1223, 64, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1224, 64, 'tableName', '表名', 'varchar(50)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1225, 64, 'modifyTime', '修改时间', 'varchar(80)', 'String', 'modifyTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1226, 64, 'reason', '修改原因', 'varchar(280)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1227, 64, 'tid', '修改表对应信息的id', 'int(11)', 'Long', 'tid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1228, 64, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1229, 64, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-18 09:35:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (1230, 64, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-18 09:35:52', '', NULL);

-- ----------------------------
-- Table structure for goodsorder
-- ----------------------------
DROP TABLE IF EXISTS `goodsorder`;
CREATE TABLE `goodsorder`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `landCar_id` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCar_id` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
  `seaCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运车牌',
  `seaDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机电话',
  `seaDriverName` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机姓名',
  `checkUserId` int(11) NULL DEFAULT NULL COMMENT '审核人编号',
  `checkState` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核状态（已审核、未审核）',
  `invoiceState` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开票状态（未开票，部分开票，已开票）',
  `path` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件路径',
  `PaymentState` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打款状态(已打款，未打款)',
  `landBankName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运银行户名',
  `landBankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运银行账号',
  `seaBankName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运银行户名',
  `seaBankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运银行账号',
  `receiveProof` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '收到条附件路径',
  `saleManager` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售经理',
  `fleet` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车队',
  `isAdjusted` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否被调整单（ 是  否）',
  `adjustDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调整日期',
  `isAdjust` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否调整单（是  否）',
  `adjustOrderid` int(11) NULL DEFAULT 0 COMMENT '原订单编号',
  `isedit` int(11) NULL DEFAULT 1 COMMENT '是否可编辑',
  `customerIsInvoice` int(11) NULL DEFAULT 0 COMMENT '客户是否开票',
  `isSupplierInvoice` int(11) NULL DEFAULT 0 COMMENT '供应商是否开票',
  `cancelFlag` int(11) NULL DEFAULT 0 COMMENT '作废标记',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 23849 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '货物订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goodsorder
-- ----------------------------

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storeHouseid` int(11) NULL DEFAULT 0 COMMENT '仓库ID',
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `storeDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '入库日期',
  `stockNumber` int(11) NULL DEFAULT 0 COMMENT '库存量（片数）',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplierId` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `levelID` int(11) NULL DEFAULT NULL COMMENT '级别编码',
  `levelName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别名称',
  `countingUnit` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `height` float NULL DEFAULT 0 COMMENT '厚度',
  `length` float NULL DEFAULT 0 COMMENT '长度',
  `width` float NULL DEFAULT 0 COMMENT '宽度',
  `pieces` int(11) NULL DEFAULT NULL COMMENT '出厂片数',
  `piecesPerPack` int(11) NULL DEFAULT NULL COMMENT '每包片数',
  `packs` int(11) NULL DEFAULT NULL COMMENT '包数',
  `price` float NULL DEFAULT 0 COMMENT '出厂单价',
  `isIncludeTaxFactory` int(11) NULL DEFAULT NULL COMMENT '出厂是否含税',
  `sundryCost` float NULL DEFAULT 0 COMMENT '杂费',
  `paymentFactory` float NULL DEFAULT 0 COMMENT '出厂货款',
  `paymentUnload` float NULL DEFAULT 0 COMMENT '卸货价',
  `isIncludeTaxSale` int(11) NULL DEFAULT NULL COMMENT '销售是否含税（0不含税，1含税）',
  `payments` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '总货款',
  `landCar_id` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCar_id` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
  `seaCarNo` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运车牌',
  `seaDriverTel` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机电话',
  `seaDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机姓名',
  `erro` float NULL DEFAULT 0 COMMENT '误差',
  `tonnage` float NULL DEFAULT 0 COMMENT '吨位',
  `landFreightPrice` float NULL DEFAULT 0 COMMENT '陆运费单价',
  `landFreight` float NULL DEFAULT 0 COMMENT '陆运费',
  `seaFreight` float NULL DEFAULT 0 COMMENT '海运费',
  `freight` float NULL DEFAULT 0 COMMENT '运费（海运费+陆运费）',
  `otherCost` float NULL DEFAULT 0 COMMENT '其他费用',
  `profit` float NULL DEFAULT 0 COMMENT '利润',
  `profitNoTax` float NULL DEFAULT 0 COMMENT '不含税利润',
  `actualPieces` int(11) NULL DEFAULT NULL COMMENT '实际片数',
  `paymentsWithSundry` float NULL DEFAULT 0 COMMENT '总货款杂费',
  `additionalFees` float NULL DEFAULT 0 COMMENT '加费',
  `rebate` float NULL DEFAULT 0 COMMENT '返利金额',
  `customerCommission` float NULL DEFAULT 0 COMMENT '客户佣金',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  `showFlag` int(11) NULL DEFAULT 0 COMMENT '订单仓库选择时是否显示（ 显示， 不显示）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory
-- ----------------------------

-- ----------------------------
-- Table structure for lendmoney
-- ----------------------------
DROP TABLE IF EXISTS `lendmoney`;
CREATE TABLE `lendmoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款编号（UUID）',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '金额',
  `lendType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '借出类型（公司/个人）',
  `company` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司/个人名称',
  `otherAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方户名',
  `otherBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号',
  `otherBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方开户行',
  `otherBankID` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号ID',
  `selfAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方户名',
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `selfBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方开户行',
  `selfBankID` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号ID',
  `acountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打入账户',
  `bankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打入账号',
  `payTime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打入时间',
  `originReason` int(11) NULL DEFAULT NULL COMMENT '缘由',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '借贷' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lendmoney
-- ----------------------------

-- ----------------------------
-- Table structure for liabilities
-- ----------------------------
DROP TABLE IF EXISTS `liabilities`;
CREATE TABLE `liabilities`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款编号（UUID）',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '金额',
  `payType` int(11) NULL DEFAULT 0 COMMENT '付款类型',
  `otherAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方户名',
  `otherBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号',
  `otherBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方开户行',
  `otherBankID` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号ID',
  `selfAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方户名',
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `selfBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方开户行',
  `selfBankID` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号ID',
  `payTime` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款时间',
  `payState` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款类型（未付款、申请、已付款）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '负债信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of liabilities
-- ----------------------------

-- ----------------------------
-- Table structure for offsetting
-- ----------------------------
DROP TABLE IF EXISTS `offsetting`;
CREATE TABLE `offsetting`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `OffsetNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '冲抵编号（UUID）',
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作时间',
  `operateType` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '冲抵类型（收入、支出）',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '金额',
  `company` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '对方公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资金调整单信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of offsetting
-- ----------------------------

-- ----------------------------
-- Table structure for oilcard
-- ----------------------------
DROP TABLE IF EXISTS `oilcard`;
CREATE TABLE `oilcard`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oilCardNo` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡卡号',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加油卡信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oilcard
-- ----------------------------

-- ----------------------------
-- Table structure for oilcardmain
-- ----------------------------
DROP TABLE IF EXISTS `oilcardmain`;
CREATE TABLE `oilcardmain`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oilCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡卡号',
  `useDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用加油卡时间',
  `carNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用加油卡车辆车牌号',
  `destination` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地点、事由',
  `startCardSurplus` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '期初余额',
  `toPlusCardMoney` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主卡转副卡充值金额',
  `refuelingNumber` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油量（升）',
  `unitPrice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单价',
  `refuelingMoney` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油金额(元）',
  `rechargeMoney` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值金额',
  `isTicket` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否有小票',
  `endCardSurplus` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡余额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加油卡主卡登记信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oilcardmain
-- ----------------------------

-- ----------------------------
-- Table structure for orderdetail
-- ----------------------------
DROP TABLE IF EXISTS `orderdetail`;
CREATE TABLE `orderdetail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NULL DEFAULT NULL COMMENT '订单详情ID',
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单日期',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `levelID` int(11) NULL DEFAULT NULL COMMENT '级别编码',
  `levelName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别名称',
  `countingUnit` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `height` float NULL DEFAULT 0 COMMENT '厚度',
  `length` float NULL DEFAULT 0 COMMENT '长度',
  `width` float NULL DEFAULT 0 COMMENT '宽度',
  `pieces` int(11) NULL DEFAULT NULL COMMENT '出厂片数',
  `piecesPerPack` int(11) NULL DEFAULT NULL COMMENT '每包片数',
  `packs` int(11) NULL DEFAULT NULL COMMENT '包数',
  `price` float NULL DEFAULT NULL COMMENT '出厂单价',
  `isIncludeTaxFactory` int(11) NULL DEFAULT NULL COMMENT '出厂是否含税',
  `sundryCost` float NULL DEFAULT NULL COMMENT '杂费',
  `paymentFactory` float NULL DEFAULT NULL COMMENT '出厂货款',
  `paymentUnload` float NULL DEFAULT NULL COMMENT '卸货价',
  `isIncludeTaxSale` int(11) NULL DEFAULT NULL COMMENT '销售是否含税',
  `payments` float NULL DEFAULT NULL COMMENT '总货款',
  `erro` float NULL DEFAULT 0 COMMENT '误差',
  `tonnage` float NULL DEFAULT 0 COMMENT '吨位',
  `landFreightPrice` float NULL DEFAULT 0 COMMENT '陆运费单价',
  `landFreight` float NULL DEFAULT 0 COMMENT '陆运费',
  `seaFreight` float NULL DEFAULT 0 COMMENT '海运费',
  `freight` float NULL DEFAULT 0 COMMENT '总运费',
  `otherCost` float NULL DEFAULT NULL COMMENT '其他费用',
  `profit` float NULL DEFAULT NULL COMMENT '利润',
  `profitNoTax` float NULL DEFAULT NULL COMMENT '不含税利润',
  `actualPieces` int(11) NULL DEFAULT NULL COMMENT '实际片数',
  `paymentsWithSundry` float NULL DEFAULT 0 COMMENT '总货款杂费',
  `additionalFees` float NULL DEFAULT 0 COMMENT '加费',
  `storeHouseID` int(11) NULL DEFAULT 0 COMMENT '仓库ID',
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `storeID` int(11) NULL DEFAULT 0 COMMENT '仓库存储的货物ID',
  `logisticsProfit` float NULL DEFAULT 0 COMMENT '物流利润',
  `customerCommission` float NULL DEFAULT 0 COMMENT '客户佣金',
  `isAdjusted` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否被调整单（ 是  否）',
  `adjustDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调整日期',
  `cancelFlag` int(11) NULL DEFAULT 0 COMMENT '作废标记',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderdetail
-- ----------------------------

-- ----------------------------
-- Table structure for orderfreight
-- ----------------------------
DROP TABLE IF EXISTS `orderfreight`;
CREATE TABLE `orderfreight`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `freightState` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运费类型（ 陆运、海运）',
  `moneyAmount` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '金额',
  `selfAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方户名',
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `selfBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方开户行',
  `otherAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方户名',
  `otherBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号',
  `otherBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方开户行',
  `content` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `paymentState` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付状态（ 已支付、 未支付、  申请中）',
  `driverName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '司机姓名',
  `driverId` int(11) NULL DEFAULT NULL COMMENT '司机ID',
  `CarNo` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车牌号',
  `fleet` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车队',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `applyUserId` int(11) NULL DEFAULT NULL COMMENT '申请人员ID',
  `applyUserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人员姓名',
  `applyDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请日期',
  `isedit` int(11) NULL DEFAULT 1 COMMENT '是否可编辑',
  `payUserId` int(11) NULL DEFAULT NULL COMMENT '付款人员ID',
  `payUserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款人员姓名',
  `payDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款日期',
  `cancelFlag` int(11) NULL DEFAULT 0 COMMENT '作废标记',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单运费信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderfreight
-- ----------------------------

-- ----------------------------
-- Table structure for orderinvoice
-- ----------------------------
DROP TABLE IF EXISTS `orderinvoice`;
CREATE TABLE `orderinvoice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `invoiceDate` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开票日期',
  `invoiceType` float NULL DEFAULT 0 COMMENT '开票类型（购入、卖出）',
  `invoiceAmount` float NULL DEFAULT 0 COMMENT '应开票金额',
  `companyType` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司类别（客户、供应商）',
  `companyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司名称',
  `companyID` int(11) NULL DEFAULT NULL COMMENT '公司名称',
  `invoiceCompanyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据单位名称',
  `actualInvoiceAmount` float NULL DEFAULT 0 COMMENT '实际开票金额',
  `ticketPoint` float NULL DEFAULT 0 COMMENT '票点',
  `ticketPointAmount` float NULL DEFAULT 0 COMMENT '票点金额（实际开票金额*票点）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1459 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单发票信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderinvoice
-- ----------------------------

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payCategory` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收付款类型（收款，付款）',
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款编号（UUID）',
  `fundsDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `payType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付类型',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '金额',
  `selfAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方户名',
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `selfBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方开户行',
  `selfBankID` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号ID',
  `otherAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方户名',
  `otherBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号',
  `otherBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方开户行',
  `paymentState` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付状态（已支付、未支付、申请中）',
  `company` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '对方公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '收付款信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment
-- ----------------------------

-- ----------------------------
-- Table structure for productlevel
-- ----------------------------
DROP TABLE IF EXISTS `productlevel`;
CREATE TABLE `productlevel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `levelNo` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别编码',
  `levelName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别名称',
  `categoryNo` int(11) NULL DEFAULT 0 COMMENT '分类编号',
  `categoryName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `height` float NULL DEFAULT 0 COMMENT '厚度',
  `length` float NULL DEFAULT 0 COMMENT '长度',
  `width` float NULL DEFAULT 0 COMMENT '宽度',
  `tonnage` float NULL DEFAULT 0 COMMENT '吨位',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品级别信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productlevel
-- ----------------------------

-- ----------------------------
-- Table structure for rebate
-- ----------------------------
DROP TABLE IF EXISTS `rebate`;
CREATE TABLE `rebate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `rebateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `rebate` float NULL DEFAULT 0 COMMENT '金额',
  `rebateType` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型（返利、降价、售后质量赔偿）',
  `inAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收款户名',
  `inBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收款账号',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `outAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款户名',
  `outBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款款账号',
  `rebateReason` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '返利原因',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '返利信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rebate
-- ----------------------------

-- ----------------------------
-- Table structure for recoverfuturesmargin
-- ----------------------------
DROP TABLE IF EXISTS `recoverfuturesmargin`;
CREATE TABLE `recoverfuturesmargin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `futuresNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保证金编号（UUID）',
  `recoverNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款编号（UUID）',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '收回金额',
  `recoverDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收回日期',
  `acountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收回账户',
  `bankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收回账号',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '恢复期货保证金？' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recoverfuturesmargin
-- ----------------------------

-- ----------------------------
-- Table structure for repayment
-- ----------------------------
DROP TABLE IF EXISTS `repayment`;
CREATE TABLE `repayment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款编号（UUID）',
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款编号（UUID）',
  `moneyAmount` float NULL DEFAULT 0 COMMENT '还（本）金额',
  `ratio` float NULL DEFAULT 0 COMMENT '付息（金额）',
  `payDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款日期',
  `acountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款账户',
  `bankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款账号',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '还款信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of repayment
-- ----------------------------

-- ----------------------------
-- Table structure for socialinsurance
-- ----------------------------
DROP TABLE IF EXISTS `socialinsurance`;
CREATE TABLE `socialinsurance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `basicSocialInsurance` float NULL DEFAULT 0 COMMENT '社保缴纳基数',
  `basicHousingFund` float NULL DEFAULT 0 COMMENT '公积金基数',
  `depName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `employeeName` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `employeeID` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '人员编号',
  `insuranceDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缴费时间',
  `isRecruiting` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否增员（是，否）',
  `isDepletion` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否减员',
  `healthySecuritySelf` float NULL DEFAULT 0 COMMENT '基本医疗保险-个人',
  `healthySecurityCompany` float NULL DEFAULT 0 COMMENT '基本医疗保险-公司',
  `injuryInsurance` float NULL DEFAULT 0 COMMENT '工伤保险',
  `unemploymentSecuritySelf` float NULL DEFAULT 0 COMMENT '失业保险-个人',
  `unemploymentSecurityCompany` float NULL DEFAULT 0 COMMENT '失业保险-公司',
  `retirementSecuritySelf` float NULL DEFAULT 0 COMMENT '养老保险-个人',
  `retirementSecurityCompany` float NULL DEFAULT 0 COMMENT '养老保险-公司',
  `largeMedicalSecuritySelf` float NULL DEFAULT 0 COMMENT '大额医保-个人',
  `largeMedicalSecurityCompany` float NULL DEFAULT 0 COMMENT '大额医保-公司',
  `housingFundSelf` float NULL DEFAULT 0 COMMENT '公积金-个人',
  `housingFundCompany` float NULL DEFAULT 0 COMMENT '公积金-公司',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '社会保险信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of socialinsurance
-- ----------------------------

-- ----------------------------
-- Table structure for storehouse
-- ----------------------------
DROP TABLE IF EXISTS `storehouse`;
CREATE TABLE `storehouse`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of storehouse
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-07-18 08:59:27', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-07-18 08:59:27', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-07-18 08:59:27', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-07-18 08:59:27', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-07-18 08:59:27', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-07-18 08:59:27', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', 'DZU科技', 0, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `CONCURRENT` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-07-18 08:59:27', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`STATUS` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-18 09:06:35');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-18 09:06:42');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-18 09:08:10');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-18 10:42:02');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-18 10:42:12');
INSERT INTO `sys_logininfor` VALUES (105, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-18 10:49:36');
INSERT INTO `sys_logininfor` VALUES (106, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-18 10:49:58');
INSERT INTO `sys_logininfor` VALUES (107, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-18 10:51:08');
INSERT INTO `sys_logininfor` VALUES (108, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-18 10:51:52');
INSERT INTO `sys_logininfor` VALUES (109, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-18 10:52:13');
INSERT INTO `sys_logininfor` VALUES (110, NULL, '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '退出成功', '2024-07-18 10:52:25');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `QUERY` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2198 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-07-18 08:59:27', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-07-18 08:59:27', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-07-18 08:59:27', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, 'DZU官网', 0, 4, 'http://dzu.vip', NULL, '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-07-18 08:59:27', '', NULL, 'DZU官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-07-18 08:59:27', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-07-18 08:59:27', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-07-18 08:59:27', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-07-18 08:59:27', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-07-18 08:59:27', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-07-18 08:59:27', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-07-18 08:59:27', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-07-18 08:59:27', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-07-18 08:59:27', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-07-18 08:59:27', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-07-18 08:59:27', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-07-18 08:59:27', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-07-18 08:59:27', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-07-18 08:59:27', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-07-18 08:59:27', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-07-18 08:59:27', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-07-18 08:59:27', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-07-18 08:59:27', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-07-18 08:59:27', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-07-18 08:59:27', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '社会保险信息', 3, 1, 'socialinsurance', 'system/socialinsurance/index', NULL, 1, 0, 'C', '0', '0', 'system:socialinsurance:list', '#', 'admin', '2024-07-18 09:38:42', '', NULL, '社会保险信息菜单');
INSERT INTO `sys_menu` VALUES (2001, '社会保险信息查询', 2000, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:query', '#', 'admin', '2024-07-18 09:38:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2002, '社会保险信息新增', 2000, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:add', '#', 'admin', '2024-07-18 09:38:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '社会保险信息修改', 2000, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:edit', '#', 'admin', '2024-07-18 09:38:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '社会保险信息删除', 2000, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:remove', '#', 'admin', '2024-07-18 09:38:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '社会保险信息导出', 2000, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:export', '#', 'admin', '2024-07-18 09:38:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '余额账户', 3, 1, 'balanceaccounts', 'system/balanceaccounts/index', NULL, 1, 0, 'C', '0', '0', 'system:balanceaccounts:list', '#', 'admin', '2024-07-18 09:39:12', '', NULL, '余额账户菜单');
INSERT INTO `sys_menu` VALUES (2007, '余额账户查询', 2006, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:query', '#', 'admin', '2024-07-18 09:39:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '余额账户新增', 2006, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:add', '#', 'admin', '2024-07-18 09:39:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '余额账户修改', 2006, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:edit', '#', 'admin', '2024-07-18 09:39:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '余额账户删除', 2006, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:remove', '#', 'admin', '2024-07-18 09:39:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '余额账户导出', 2006, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:export', '#', 'admin', '2024-07-18 09:39:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '银行承兑', 3, 1, 'bankacceptance', 'system/bankacceptance/index', NULL, 1, 0, 'C', '0', '0', 'system:bankacceptance:list', '#', 'admin', '2024-07-18 09:39:15', '', NULL, '银行承兑菜单');
INSERT INTO `sys_menu` VALUES (2013, '银行承兑查询', 2012, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:query', '#', 'admin', '2024-07-18 09:39:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '银行承兑新增', 2012, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:add', '#', 'admin', '2024-07-18 09:39:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '银行承兑修改', 2012, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:edit', '#', 'admin', '2024-07-18 09:39:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '银行承兑删除', 2012, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:remove', '#', 'admin', '2024-07-18 09:39:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '银行承兑导出', 2012, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:export', '#', 'admin', '2024-07-18 09:39:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '银行账号变更', 3, 1, 'bankaccountchange', 'system/bankaccountchange/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccountchange:list', '#', 'admin', '2024-07-18 09:39:19', '', NULL, '银行账号变更菜单');
INSERT INTO `sys_menu` VALUES (2019, '银行账号变更查询', 2018, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:query', '#', 'admin', '2024-07-18 09:39:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '银行账号变更新增', 2018, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:add', '#', 'admin', '2024-07-18 09:39:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '银行账号变更修改', 2018, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:edit', '#', 'admin', '2024-07-18 09:39:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '银行账号变更删除', 2018, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:remove', '#', 'admin', '2024-07-18 09:39:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '银行账号变更导出', 2018, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:export', '#', 'admin', '2024-07-18 09:39:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '银行账户', 3, 1, 'bankaccount', 'system/bankaccount/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccount:list', '#', 'admin', '2024-07-18 09:39:23', '', NULL, '银行账户菜单');
INSERT INTO `sys_menu` VALUES (2025, '银行账户查询', 2024, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:query', '#', 'admin', '2024-07-18 09:39:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '银行账户新增', 2024, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:add', '#', 'admin', '2024-07-18 09:39:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '银行账户修改', 2024, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:edit', '#', 'admin', '2024-07-18 09:39:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '银行账户删除', 2024, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:remove', '#', 'admin', '2024-07-18 09:39:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '银行账户导出', 2024, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:export', '#', 'admin', '2024-07-18 09:39:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '借入金钱', 3, 1, 'borrowedmoney', 'system/borrowedmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:borrowedmoney:list', '#', 'admin', '2024-07-18 09:39:27', '', NULL, '借入金钱菜单');
INSERT INTO `sys_menu` VALUES (2031, '借入金钱查询', 2030, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:query', '#', 'admin', '2024-07-18 09:39:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '借入金钱新增', 2030, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:add', '#', 'admin', '2024-07-18 09:39:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '借入金钱修改', 2030, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:edit', '#', 'admin', '2024-07-18 09:39:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '借入金钱删除', 2030, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:remove', '#', 'admin', '2024-07-18 09:39:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '借入金钱导出', 2030, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:export', '#', 'admin', '2024-07-18 09:39:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '出差记录', 3, 1, 'businesstrip', 'system/businesstrip/index', NULL, 1, 0, 'C', '0', '0', 'system:businesstrip:list', '#', 'admin', '2024-07-18 09:39:34', '', NULL, '出差记录菜单');
INSERT INTO `sys_menu` VALUES (2037, '出差记录查询', 2036, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:query', '#', 'admin', '2024-07-18 09:39:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '出差记录新增', 2036, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:add', '#', 'admin', '2024-07-18 09:39:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '出差记录修改', 2036, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:edit', '#', 'admin', '2024-07-18 09:39:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '出差记录删除', 2036, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:remove', '#', 'admin', '2024-07-18 09:39:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '出差记录导出', 2036, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:export', '#', 'admin', '2024-07-18 09:39:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '汽车申请', 3, 1, 'carapply', 'system/carapply/index', NULL, 1, 0, 'C', '0', '0', 'system:carapply:list', '#', 'admin', '2024-07-18 09:39:37', '', NULL, '汽车申请菜单');
INSERT INTO `sys_menu` VALUES (2043, '汽车申请查询', 2042, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:query', '#', 'admin', '2024-07-18 09:39:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '汽车申请新增', 2042, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:add', '#', 'admin', '2024-07-18 09:39:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '汽车申请修改', 2042, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:edit', '#', 'admin', '2024-07-18 09:39:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '汽车申请删除', 2042, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:remove', '#', 'admin', '2024-07-18 09:39:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '汽车申请导出', 2042, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:export', '#', 'admin', '2024-07-18 09:39:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '汽车信息', 3, 1, 'cars', 'system/cars/index', NULL, 1, 0, 'C', '0', '0', 'system:cars:list', '#', 'admin', '2024-07-18 09:39:40', '', NULL, '汽车信息菜单');
INSERT INTO `sys_menu` VALUES (2049, '汽车信息查询', 2048, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:query', '#', 'admin', '2024-07-18 09:39:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '汽车信息新增', 2048, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:add', '#', 'admin', '2024-07-18 09:39:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '汽车信息修改', 2048, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:edit', '#', 'admin', '2024-07-18 09:39:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '汽车信息删除', 2048, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:remove', '#', 'admin', '2024-07-18 09:39:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '汽车信息导出', 2048, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:export', '#', 'admin', '2024-07-18 09:39:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '公司信息', 3, 1, 'company', 'system/company/index', NULL, 1, 0, 'C', '0', '0', 'system:company:list', '#', 'admin', '2024-07-18 09:39:42', '', NULL, '公司信息菜单');
INSERT INTO `sys_menu` VALUES (2055, '公司信息查询', 2054, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:query', '#', 'admin', '2024-07-18 09:39:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '公司信息新增', 2054, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:add', '#', 'admin', '2024-07-18 09:39:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '公司信息修改', 2054, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:edit', '#', 'admin', '2024-07-18 09:39:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '公司信息删除', 2054, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:remove', '#', 'admin', '2024-07-18 09:39:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '公司信息导出', 2054, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:export', '#', 'admin', '2024-07-18 09:39:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '走访记录', 3, 1, 'customervisit', 'system/customervisit/index', NULL, 1, 0, 'C', '0', '0', 'system:customervisit:list', '#', 'admin', '2024-07-18 09:39:45', '', NULL, '走访记录菜单');
INSERT INTO `sys_menu` VALUES (2061, '走访记录查询', 2060, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:query', '#', 'admin', '2024-07-18 09:39:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '走访记录新增', 2060, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:add', '#', 'admin', '2024-07-18 09:39:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '走访记录修改', 2060, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:edit', '#', 'admin', '2024-07-18 09:39:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '走访记录删除', 2060, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:remove', '#', 'admin', '2024-07-18 09:39:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '走访记录导出', 2060, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:export', '#', 'admin', '2024-07-18 09:39:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2066, '出库信息', 3, 1, 'exwarehouse', 'system/exwarehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:exwarehouse:list', '#', 'admin', '2024-07-18 09:39:47', '', NULL, '出库信息菜单');
INSERT INTO `sys_menu` VALUES (2067, '出库信息查询', 2066, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:query', '#', 'admin', '2024-07-18 09:39:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '出库信息新增', 2066, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:add', '#', 'admin', '2024-07-18 09:39:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '出库信息修改', 2066, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:edit', '#', 'admin', '2024-07-18 09:39:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '出库信息删除', 2066, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:remove', '#', 'admin', '2024-07-18 09:39:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '出库信息导出', 2066, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:export', '#', 'admin', '2024-07-18 09:39:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '固定资产信息', 3, 1, 'fixedassets', 'system/fixedassets/index', NULL, 1, 0, 'C', '0', '0', 'system:fixedassets:list', '#', 'admin', '2024-07-18 09:39:49', '', NULL, '固定资产信息菜单');
INSERT INTO `sys_menu` VALUES (2073, '固定资产信息查询', 2072, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:query', '#', 'admin', '2024-07-18 09:39:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2074, '固定资产信息新增', 2072, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:add', '#', 'admin', '2024-07-18 09:39:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2075, '固定资产信息修改', 2072, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:edit', '#', 'admin', '2024-07-18 09:39:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2076, '固定资产信息删除', 2072, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:remove', '#', 'admin', '2024-07-18 09:39:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2077, '固定资产信息导出', 2072, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:export', '#', 'admin', '2024-07-18 09:39:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2078, '车队信息', 3, 1, 'fleet', 'system/fleet/index', NULL, 1, 0, 'C', '0', '0', 'system:fleet:list', '#', 'admin', '2024-07-18 09:39:53', '', NULL, '车队信息菜单');
INSERT INTO `sys_menu` VALUES (2079, '车队信息查询', 2078, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:query', '#', 'admin', '2024-07-18 09:39:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2080, '车队信息新增', 2078, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:add', '#', 'admin', '2024-07-18 09:39:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2081, '车队信息修改', 2078, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:edit', '#', 'admin', '2024-07-18 09:39:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2082, '车队信息删除', 2078, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:remove', '#', 'admin', '2024-07-18 09:39:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2083, '车队信息导出', 2078, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:export', '#', 'admin', '2024-07-18 09:39:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2084, '期货保证金信息', 3, 1, 'futuresmargin', 'system/futuresmargin/index', NULL, 1, 0, 'C', '0', '0', 'system:futuresmargin:list', '#', 'admin', '2024-07-18 09:39:55', '', NULL, '期货保证金信息菜单');
INSERT INTO `sys_menu` VALUES (2085, '期货保证金信息查询', 2084, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:futuresmargin:query', '#', 'admin', '2024-07-18 09:39:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2086, '期货保证金信息新增', 2084, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:futuresmargin:add', '#', 'admin', '2024-07-18 09:39:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2087, '期货保证金信息修改', 2084, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:futuresmargin:edit', '#', 'admin', '2024-07-18 09:39:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2088, '期货保证金信息删除', 2084, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:futuresmargin:remove', '#', 'admin', '2024-07-18 09:39:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2089, '期货保证金信息导出', 2084, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:futuresmargin:export', '#', 'admin', '2024-07-18 09:39:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2090, '货物订单', 3, 1, 'goodsorder', 'system/goodsorder/index', NULL, 1, 0, 'C', '0', '0', 'system:goodsorder:list', '#', 'admin', '2024-07-18 09:39:58', '', NULL, '货物订单菜单');
INSERT INTO `sys_menu` VALUES (2091, '货物订单查询', 2090, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:query', '#', 'admin', '2024-07-18 09:39:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2092, '货物订单新增', 2090, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:add', '#', 'admin', '2024-07-18 09:39:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2093, '货物订单修改', 2090, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:edit', '#', 'admin', '2024-07-18 09:39:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2094, '货物订单删除', 2090, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:remove', '#', 'admin', '2024-07-18 09:39:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2095, '货物订单导出', 2090, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:export', '#', 'admin', '2024-07-18 09:39:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2096, '库存', 3, 1, 'inventory', 'system/inventory/index', NULL, 1, 0, 'C', '0', '0', 'system:inventory:list', '#', 'admin', '2024-07-18 09:40:01', '', NULL, '库存菜单');
INSERT INTO `sys_menu` VALUES (2097, '库存查询', 2096, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:query', '#', 'admin', '2024-07-18 09:40:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2098, '库存新增', 2096, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:add', '#', 'admin', '2024-07-18 09:40:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2099, '库存修改', 2096, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:edit', '#', 'admin', '2024-07-18 09:40:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2100, '库存删除', 2096, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:remove', '#', 'admin', '2024-07-18 09:40:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2101, '库存导出', 2096, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:export', '#', 'admin', '2024-07-18 09:40:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2102, '借贷', 3, 1, 'lendmoney', 'system/lendmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:lendmoney:list', '#', 'admin', '2024-07-18 09:40:04', '', NULL, '借贷菜单');
INSERT INTO `sys_menu` VALUES (2103, '借贷查询', 2102, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:query', '#', 'admin', '2024-07-18 09:40:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2104, '借贷新增', 2102, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:add', '#', 'admin', '2024-07-18 09:40:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2105, '借贷修改', 2102, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:edit', '#', 'admin', '2024-07-18 09:40:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2106, '借贷删除', 2102, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:remove', '#', 'admin', '2024-07-18 09:40:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2107, '借贷导出', 2102, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:export', '#', 'admin', '2024-07-18 09:40:04', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2108, '负债信息', 3, 1, 'liabilities', 'system/liabilities/index', NULL, 1, 0, 'C', '0', '0', 'system:liabilities:list', '#', 'admin', '2024-07-18 09:40:07', '', NULL, '负债信息菜单');
INSERT INTO `sys_menu` VALUES (2109, '负债信息查询', 2108, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:liabilities:query', '#', 'admin', '2024-07-18 09:40:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '负债信息新增', 2108, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:liabilities:add', '#', 'admin', '2024-07-18 09:40:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '负债信息修改', 2108, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:liabilities:edit', '#', 'admin', '2024-07-18 09:40:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '负债信息删除', 2108, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:liabilities:remove', '#', 'admin', '2024-07-18 09:40:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '负债信息导出', 2108, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:liabilities:export', '#', 'admin', '2024-07-18 09:40:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '资金调整单信息', 3, 1, 'offsetting', 'system/offsetting/index', NULL, 1, 0, 'C', '0', '0', 'system:offsetting:list', '#', 'admin', '2024-07-18 09:40:10', '', NULL, '资金调整单信息菜单');
INSERT INTO `sys_menu` VALUES (2115, '资金调整单信息查询', 2114, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:query', '#', 'admin', '2024-07-18 09:40:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2116, '资金调整单信息新增', 2114, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:add', '#', 'admin', '2024-07-18 09:40:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2117, '资金调整单信息修改', 2114, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:edit', '#', 'admin', '2024-07-18 09:40:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2118, '资金调整单信息删除', 2114, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:remove', '#', 'admin', '2024-07-18 09:40:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2119, '资金调整单信息导出', 2114, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:export', '#', 'admin', '2024-07-18 09:40:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '加油卡主卡登记信息', 3, 1, 'oilcardmain', 'system/oilcardmain/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcardmain:list', '#', 'admin', '2024-07-18 09:40:12', '', NULL, '加油卡主卡登记信息菜单');
INSERT INTO `sys_menu` VALUES (2121, '加油卡主卡登记信息查询', 2120, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:query', '#', 'admin', '2024-07-18 09:40:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '加油卡主卡登记信息新增', 2120, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:add', '#', 'admin', '2024-07-18 09:40:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2123, '加油卡主卡登记信息修改', 2120, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:edit', '#', 'admin', '2024-07-18 09:40:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2124, '加油卡主卡登记信息删除', 2120, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:remove', '#', 'admin', '2024-07-18 09:40:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2125, '加油卡主卡登记信息导出', 2120, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:export', '#', 'admin', '2024-07-18 09:40:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2126, '加油卡信息', 3, 1, 'oilcard', 'system/oilcard/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcard:list', '#', 'admin', '2024-07-18 09:40:15', '', NULL, '加油卡信息菜单');
INSERT INTO `sys_menu` VALUES (2127, '加油卡信息查询', 2126, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:query', '#', 'admin', '2024-07-18 09:40:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2128, '加油卡信息新增', 2126, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:add', '#', 'admin', '2024-07-18 09:40:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2129, '加油卡信息修改', 2126, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:edit', '#', 'admin', '2024-07-18 09:40:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, '加油卡信息删除', 2126, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:remove', '#', 'admin', '2024-07-18 09:40:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, '加油卡信息导出', 2126, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:export', '#', 'admin', '2024-07-18 09:40:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, '订单详情', 3, 1, 'orderdetail', 'system/orderdetail/index', NULL, 1, 0, 'C', '0', '0', 'system:orderdetail:list', '#', 'admin', '2024-07-18 09:40:18', '', NULL, '订单详情菜单');
INSERT INTO `sys_menu` VALUES (2133, '订单详情查询', 2132, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:query', '#', 'admin', '2024-07-18 09:40:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2134, '订单详情新增', 2132, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:add', '#', 'admin', '2024-07-18 09:40:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2135, '订单详情修改', 2132, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:edit', '#', 'admin', '2024-07-18 09:40:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2136, '订单详情删除', 2132, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:remove', '#', 'admin', '2024-07-18 09:40:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2137, '订单详情导出', 2132, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:export', '#', 'admin', '2024-07-18 09:40:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2138, '订单运费信息', 3, 1, 'orderfreight', 'system/orderfreight/index', NULL, 1, 0, 'C', '0', '0', 'system:orderfreight:list', '#', 'admin', '2024-07-18 09:40:20', '', NULL, '订单运费信息菜单');
INSERT INTO `sys_menu` VALUES (2139, '订单运费信息查询', 2138, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:query', '#', 'admin', '2024-07-18 09:40:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2140, '订单运费信息新增', 2138, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:add', '#', 'admin', '2024-07-18 09:40:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2141, '订单运费信息修改', 2138, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:edit', '#', 'admin', '2024-07-18 09:40:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2142, '订单运费信息删除', 2138, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:remove', '#', 'admin', '2024-07-18 09:40:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2143, '订单运费信息导出', 2138, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:export', '#', 'admin', '2024-07-18 09:40:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2144, '订单发票信息', 3, 1, 'orderinvoice', 'system/orderinvoice/index', NULL, 1, 0, 'C', '0', '0', 'system:orderinvoice:list', '#', 'admin', '2024-07-18 09:40:22', '', NULL, '订单发票信息菜单');
INSERT INTO `sys_menu` VALUES (2145, '订单发票信息查询', 2144, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:query', '#', 'admin', '2024-07-18 09:40:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2146, '订单发票信息新增', 2144, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:add', '#', 'admin', '2024-07-18 09:40:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2147, '订单发票信息修改', 2144, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:edit', '#', 'admin', '2024-07-18 09:40:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2148, '订单发票信息删除', 2144, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:remove', '#', 'admin', '2024-07-18 09:40:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2149, '订单发票信息导出', 2144, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:export', '#', 'admin', '2024-07-18 09:40:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2150, '收付款信息', 3, 1, 'payment', 'system/payment/index', NULL, 1, 0, 'C', '0', '0', 'system:payment:list', '#', 'admin', '2024-07-18 09:40:31', '', NULL, '收付款信息菜单');
INSERT INTO `sys_menu` VALUES (2151, '收付款信息查询', 2150, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:query', '#', 'admin', '2024-07-18 09:40:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2152, '收付款信息新增', 2150, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:add', '#', 'admin', '2024-07-18 09:40:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2153, '收付款信息修改', 2150, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:edit', '#', 'admin', '2024-07-18 09:40:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2154, '收付款信息删除', 2150, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:remove', '#', 'admin', '2024-07-18 09:40:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2155, '收付款信息导出', 2150, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:export', '#', 'admin', '2024-07-18 09:40:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2156, '产品级别信息', 3, 1, 'productlevel', 'system/productlevel/index', NULL, 1, 0, 'C', '0', '0', 'system:productlevel:list', '#', 'admin', '2024-07-18 09:40:33', '', NULL, '产品级别信息菜单');
INSERT INTO `sys_menu` VALUES (2157, '产品级别信息查询', 2156, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:query', '#', 'admin', '2024-07-18 09:40:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2158, '产品级别信息新增', 2156, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:add', '#', 'admin', '2024-07-18 09:40:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2159, '产品级别信息修改', 2156, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:edit', '#', 'admin', '2024-07-18 09:40:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2160, '产品级别信息删除', 2156, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:remove', '#', 'admin', '2024-07-18 09:40:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2161, '产品级别信息导出', 2156, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:export', '#', 'admin', '2024-07-18 09:40:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2162, '返利信息', 3, 1, 'rebate', 'system/rebate/index', NULL, 1, 0, 'C', '0', '0', 'system:rebate:list', '#', 'admin', '2024-07-18 09:40:36', '', NULL, '返利信息菜单');
INSERT INTO `sys_menu` VALUES (2163, '返利信息查询', 2162, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:query', '#', 'admin', '2024-07-18 09:40:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2164, '返利信息新增', 2162, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:add', '#', 'admin', '2024-07-18 09:40:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2165, '返利信息修改', 2162, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:edit', '#', 'admin', '2024-07-18 09:40:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2166, '返利信息删除', 2162, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:remove', '#', 'admin', '2024-07-18 09:40:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2167, '返利信息导出', 2162, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:export', '#', 'admin', '2024-07-18 09:40:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2168, '恢复期货保证金？', 3, 1, 'recoverfuturesmargin', 'system/recoverfuturesmargin/index', NULL, 1, 0, 'C', '0', '0', 'system:recoverfuturesmargin:list', '#', 'admin', '2024-07-18 09:40:38', '', NULL, '恢复期货保证金？菜单');
INSERT INTO `sys_menu` VALUES (2169, '恢复期货保证金？查询', 2168, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recoverfuturesmargin:query', '#', 'admin', '2024-07-18 09:40:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2170, '恢复期货保证金？新增', 2168, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recoverfuturesmargin:add', '#', 'admin', '2024-07-18 09:40:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2171, '恢复期货保证金？修改', 2168, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recoverfuturesmargin:edit', '#', 'admin', '2024-07-18 09:40:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2172, '恢复期货保证金？删除', 2168, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recoverfuturesmargin:remove', '#', 'admin', '2024-07-18 09:40:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2173, '恢复期货保证金？导出', 2168, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recoverfuturesmargin:export', '#', 'admin', '2024-07-18 09:40:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2174, '还款信息', 3, 1, 'repayment', 'system/repayment/index', NULL, 1, 0, 'C', '0', '0', 'system:repayment:list', '#', 'admin', '2024-07-18 09:40:41', '', NULL, '还款信息菜单');
INSERT INTO `sys_menu` VALUES (2175, '还款信息查询', 2174, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:query', '#', 'admin', '2024-07-18 09:40:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2176, '还款信息新增', 2174, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:add', '#', 'admin', '2024-07-18 09:40:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2177, '还款信息修改', 2174, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:edit', '#', 'admin', '2024-07-18 09:40:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2178, '还款信息删除', 2174, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:remove', '#', 'admin', '2024-07-18 09:40:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2179, '还款信息导出', 2174, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:export', '#', 'admin', '2024-07-18 09:40:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2180, '社会保险信息', 3, 1, 'socialinsurance', 'system/socialinsurance/index', NULL, 1, 0, 'C', '0', '0', 'system:socialinsurance:list', '#', 'admin', '2024-07-18 09:40:44', '', NULL, '社会保险信息菜单');
INSERT INTO `sys_menu` VALUES (2181, '社会保险信息查询', 2180, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:query', '#', 'admin', '2024-07-18 09:40:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2182, '社会保险信息新增', 2180, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:add', '#', 'admin', '2024-07-18 09:40:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2183, '社会保险信息修改', 2180, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:edit', '#', 'admin', '2024-07-18 09:40:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2184, '社会保险信息删除', 2180, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:remove', '#', 'admin', '2024-07-18 09:40:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2185, '社会保险信息导出', 2180, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:export', '#', 'admin', '2024-07-18 09:40:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2186, '仓库信息', 3, 1, 'storehouse', 'system/storehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:storehouse:list', '#', 'admin', '2024-07-18 09:40:47', '', NULL, '仓库信息菜单');
INSERT INTO `sys_menu` VALUES (2187, '仓库信息查询', 2186, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:query', '#', 'admin', '2024-07-18 09:40:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2188, '仓库信息新增', 2186, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:add', '#', 'admin', '2024-07-18 09:40:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2189, '仓库信息修改', 2186, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:edit', '#', 'admin', '2024-07-18 09:40:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2190, '仓库信息删除', 2186, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:remove', '#', 'admin', '2024-07-18 09:40:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2191, '仓库信息导出', 2186, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:export', '#', 'admin', '2024-07-18 09:40:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2192, '信息', 3, 1, 'tableeditmessage', 'system/tableeditmessage/index', NULL, 1, 0, 'C', '0', '0', 'system:tableeditmessage:list', '#', 'admin', '2024-07-18 09:40:49', '', NULL, '信息菜单');
INSERT INTO `sys_menu` VALUES (2193, '信息查询', 2192, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:query', '#', 'admin', '2024-07-18 09:40:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2194, '信息新增', 2192, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:add', '#', 'admin', '2024-07-18 09:40:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2195, '信息修改', 2192, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:edit', '#', 'admin', '2024-07-18 09:40:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2196, '信息删除', 2192, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:remove', '#', 'admin', '2024-07-18 09:40:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2197, '信息导出', 2192, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:export', '#', 'admin', '2024-07-18 09:40:49', '', NULL, '');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `STATUS` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`STATUS` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"socialinsurance,businesstrip,futuresmargin,orderdetail,carapply,goodsorder,orderfreight,storehouse,cars,inventory,orderinvoice,tableeditmessage,balanceaccounts,company,lendmoney,payment,bankacceptance,customervisit,liabilities,productlevel,bankaccount,exwarehouse,offsetting,rebate,bankaccountchange,fixedassets,oilcard,recoverfuturesmargin,borrowedmoney,fleet,oilcardmain,repayment\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:14:37', 1958);
INSERT INTO `sys_oper_log` VALUES (101, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"socialinsurance,businesstrip,futuresmargin,orderdetail,carapply,goodsorder,orderfreight,storehouse,cars,inventory,orderinvoice,tableeditmessage,balanceaccounts,company,lendmoney,payment,bankacceptance,customervisit,liabilities,productlevel,bankaccount,exwarehouse,offsetting,rebate,bankaccountchange,fixedassets,oilcard,recoverfuturesmargin,borrowedmoney,fleet,oilcardmain,repayment\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:18:39', 1408);
INSERT INTO `sys_oper_log` VALUES (102, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:35:23', 72);
INSERT INTO `sys_oper_log` VALUES (103, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"tableeditmessage,storehouse,socialinsurance,repayment,recoverfuturesmargin,rebate,productlevel,payment,orderinvoice,orderfreight,orderdetail,oilcardmain,oilcard,offsetting,liabilities,borrowedmoney,lendmoney,inventory,goodsorder,futuresmargin,fleet,fixedassets,exwarehouse,customervisit,company,cars,carapply,businesstrip,bankaccountchange,bankacceptance,bankaccount,balanceaccounts\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:35:52', 1644);
INSERT INTO `sys_oper_log` VALUES (104, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,futuresmargin,goodsorder,inventory,lendmoney,liabilities,offsetting,oilcard,oilcardmain,orderdetail,orderfreight,orderinvoice,payment,productlevel,rebate,recoverfuturesmargin,repayment,socialinsurance,storehouse,tableeditmessage\"}', NULL, 0, NULL, '2024-07-18 09:36:15', 1606);
INSERT INTO `sys_oper_log` VALUES (105, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,futuresmargin,goodsorder,inventory,lendmoney,liabilities,offsetting,oilcard,oilcardmain,orderdetail,orderfreight,orderinvoice,payment,productlevel,rebate,recoverfuturesmargin,repayment,socialinsurance,storehouse,tableeditmessage\"}', NULL, 0, NULL, '2024-07-18 09:36:28', 1280);
INSERT INTO `sys_oper_log` VALUES (106, '银行承兑', 1, 'com.ruoyi.system.controller.BankacceptanceController.add()', 'POST', 1, 'admin', '研发部门', '/system/bankacceptance', '127.0.0.1', '内网IP', '{\"addtime\":\"123\",\"billAccount\":\"123\",\"billAmount\":123,\"billCategory\":\"123\",\"billDate\":\"123\",\"billNo\":\"123\",\"comments\":\"123\",\"dueDate\":\"123\",\"endorseReason\":\"123\",\"endorsee\":\"123\",\"endorser\":\"13\",\"id\":1,\"inDiscountAmount\":123,\"inDiscountPoints\":123,\"issueDate\":\"123\",\"operateDate\":\"123\",\"origin\":\"123\",\"params\":{},\"reason\":\"123\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:48:33', 34);
INSERT INTO `sys_oper_log` VALUES (107, '银行账户', 1, 'com.ruoyi.system.controller.BankaccountController.add()', 'POST', 1, 'admin', '研发部门', '/system/bankaccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"3\",\"amount\":33,\"bankName\":\"123\",\"bankNo\":\"3\",\"comments\":\"3\",\"companyId\":23123,\"companyName\":\"1231\",\"id\":1647,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:48:49', 61);
INSERT INTO `sys_oper_log` VALUES (108, '银行账户', 2, 'com.ruoyi.system.controller.BankaccountController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/bankaccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"3213123\",\"amount\":33,\"bankName\":\"123\",\"bankNo\":\"3\",\"comments\":\"3\",\"companyId\":23123,\"companyName\":\"1231\",\"id\":1647,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:48:54', 24);
INSERT INTO `sys_oper_log` VALUES (109, '信息', 1, 'com.ruoyi.system.controller.TableeditmessageController.add()', 'POST', 1, 'admin', '研发部门', '/system/tableeditmessage', '127.0.0.1', '内网IP', '{\"addtime\":\"31231\",\"id\":1,\"modifyTime\":\"213\",\"params\":{},\"reason\":\"231\",\"tableName\":\"1231\",\"tid\":23,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-18 09:49:07', 11);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2024-07-18 08:59:27', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2024-07-18 08:59:27', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2024-07-18 08:59:27', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `PASSWORD` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `STATUS` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `trueName` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `postName` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位',
  `state` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '就职状态（在职、离职）',
  `startDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '入职时间',
  `iDCard` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '身份证号码',
  `birthday` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '出生日期',
  `nation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '民族',
  `politicalStatus` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '政治面貌',
  `maritalStatus` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '婚姻状况',
  `domicileAddress` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '户籍地址',
  `residentialAddress` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '居住地址',
  `relationPerson` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '紧急联系人',
  `relationPersonTel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '紧急联系人电话',
  `relationship` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关系',
  `education` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '学历',
  `gradualUniversity` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '毕业院校',
  `profession` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '专业',
  `gradualDate` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '毕业时间',
  `bankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '开户银行',
  `bankNo` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '银行账号',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', 'ml', '00', '231412613412@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-07-18 10:52:14', 'admin', '2024-06-17 15:05:44', '', '2024-07-18 10:52:13', '管理员', '12', '12', '1', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12', '12');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

-- ----------------------------
-- Table structure for tableeditmessage
-- ----------------------------
DROP TABLE IF EXISTS `tableeditmessage`;
CREATE TABLE `tableeditmessage`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tableName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表名',
  `modifyTime` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改时间',
  `reason` varchar(280) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改原因',
  `tid` int(11) NULL DEFAULT 0 COMMENT '修改表对应信息的id',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '表信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tableeditmessage
-- ----------------------------
INSERT INTO `tableeditmessage` VALUES (1, '1231', '213', '231', 23, '31231', 1, NULL);

SET FOREIGN_KEY_CHECKS = 1;
