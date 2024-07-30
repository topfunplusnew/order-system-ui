/*
 Navicat Premium Data Transfer

 Source Server         : 订单系统
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44-log)
 Source Host           : 47.121.126.94:3306
 Source Schema         : order

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44-log)
 File Encoding         : 65001

 Date: 30/07/2024 22:03:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for BalanceAccounts
-- ----------------------------
DROP TABLE IF EXISTS `BalanceAccounts`;
CREATE TABLE `BalanceAccounts`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作时间',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `companyName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司',
  `companyID` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '对方公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平账信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of BalanceAccounts
-- ----------------------------

-- ----------------------------
-- Table structure for BusinessTrip
-- ----------------------------
DROP TABLE IF EXISTS `BusinessTrip`;
CREATE TABLE `BusinessTrip`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeID` int(11) NULL DEFAULT 0 COMMENT '报销人ID',
  `employee` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报销人',
  `personnel` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '共同出差人员',
  `starttime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差时间',
  `endtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差结束时间',
  `attachmentPath` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件地址',
  `isReimburse` int(11) NULL DEFAULT 0 COMMENT '是否已报销（0未报销，1已报销）',
  `comments` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出差' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of BusinessTrip
-- ----------------------------

-- ----------------------------
-- Table structure for CustomerVisit
-- ----------------------------
DROP TABLE IF EXISTS `CustomerVisit`;
CREATE TABLE `CustomerVisit`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '走访记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of CustomerVisit
-- ----------------------------
INSERT INTO `CustomerVisit` VALUES (1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 16:44:25 CST 2024', 1, NULL, NULL, NULL, 0, 0, NULL, 1);
INSERT INTO `CustomerVisit` VALUES (2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 16:44:48 CST 2024', 1, NULL, NULL, NULL, 0, 0, NULL, 1);
INSERT INTO `CustomerVisit` VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 16:44:59 CST 2024', 1, NULL, NULL, NULL, 0, 0, NULL, 1);
INSERT INTO `CustomerVisit` VALUES (4, '山东', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 17:16:08 CST 2024', 1, NULL, NULL, NULL, 0, 0, NULL, 1);
INSERT INTO `CustomerVisit` VALUES (5, '浙江', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 17:16:21 CST 2024', 1, NULL, NULL, NULL, 0, 0, NULL, 1);
INSERT INTO `CustomerVisit` VALUES (6, '江西', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 17:16:30 CST 2024', 1, NULL, NULL, NULL, 0, 0, NULL, 1);
INSERT INTO `CustomerVisit` VALUES (7, '山东', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 20:03:05 CST 2024', 1, NULL, '2024-07-30 20:03:19', NULL, 0, 0, NULL, 1);

-- ----------------------------
-- Table structure for Offsetting
-- ----------------------------
DROP TABLE IF EXISTS `Offsetting`;
CREATE TABLE `Offsetting`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `OffsetNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '冲抵编号（UUID）',
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作时间',
  `operateType` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '冲抵类型（收入、支出）',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `companyName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司',
  `companyId` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '对冲账信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Offsetting
-- ----------------------------

-- ----------------------------
-- Table structure for OilCardConsume
-- ----------------------------
DROP TABLE IF EXISTS `OilCardConsume`;
CREATE TABLE `OilCardConsume`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bTripId` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差编号UUID',
  `oilCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡卡号',
  `useDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用加油卡时间',
  `carNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用加油卡车辆车牌号',
  `startCardSurplus` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '期初余额',
  `refuelingNumber` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油量（升）',
  `unitPrice` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单价',
  `refuelingMoney` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油金额(元）',
  `rechargeMoney` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值金额(元）',
  `endCardSurplus` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡余额',
  `attachmentOiladd` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油小票附件',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加油卡消费信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of OilCardConsume
-- ----------------------------

-- ----------------------------
-- Table structure for Rebate
-- ----------------------------
DROP TABLE IF EXISTS `Rebate`;
CREATE TABLE `Rebate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `rebateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `rebate` double NULL DEFAULT 0 COMMENT '金额',
  `rebateType` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型（返利、降价、售后质量赔偿）',
  `inAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收款户名',
  `inBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收款账号',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplierID` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `outAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款户名',
  `outBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款款账号',
  `rebateReason` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '返利原因',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '返利回扣' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Rebate
-- ----------------------------

-- ----------------------------
-- Table structure for StoreHouse
-- ----------------------------
DROP TABLE IF EXISTS `StoreHouse`;
CREATE TABLE `StoreHouse`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库房' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of StoreHouse
-- ----------------------------
INSERT INTO `StoreHouse` VALUES (1, '1', '12', 1);
INSERT INTO `StoreHouse` VALUES (2, '1', '12', 1);
INSERT INTO `StoreHouse` VALUES (3, '1', '113', 1);
INSERT INTO `StoreHouse` VALUES (4, NULL, NULL, 1);
INSERT INTO `StoreHouse` VALUES (5, NULL, NULL, 0);

-- ----------------------------
-- Table structure for bankAcceptance
-- ----------------------------
DROP TABLE IF EXISTS `bankAcceptance`;
CREATE TABLE `bankAcceptance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作日期',
  `billNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据号码',
  `issueDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出票日期',
  `dueDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '到期日期',
  `billAccount` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方承兑账户',
  `billDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据日期',
  `billType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类（收入、支出）',
  `reason` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '事由',
  `billAmount` double NULL DEFAULT 0 COMMENT '票据金额',
  `inDiscountPoints` double NULL DEFAULT 0 COMMENT '贴息点数',
  `inDiscountAmount` double NULL DEFAULT 0 COMMENT '贴息金额',
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
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商业票据、银行承兑' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bankAcceptance
-- ----------------------------

-- ----------------------------
-- Table structure for bankAccount
-- ----------------------------
DROP TABLE IF EXISTS `bankAccount`;
CREATE TABLE `bankAccount`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司名称',
  `companyId` int(11) NULL DEFAULT 0 COMMENT '对应公司ID',
  `bankName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `acountsName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户名称',
  `bankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `acountsType` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账户类型（己方公司，客户，供应商，司机，其它）',
  `amount` double NULL DEFAULT 0 COMMENT '当前资金额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '银行账号' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bankAccount
-- ----------------------------
INSERT INTO `bankAccount` VALUES (1, '山东省某科技有限公司', 999, '中国工商银行济南分行', '山东省某科技有限公司', '6222001234567890', '己方公司', 1000020, '公司主要银行账户', 1);
INSERT INTO `bankAccount` VALUES (2, '山东省某科技有限公司', 999, '中国工商银行济南分行', '山东省某科技有限公司', '6222001234567890', '己方公司', 100000, '公司主要银行账户', 1);
INSERT INTO `bankAccount` VALUES (9, '张司机', 1, '中国农业银行济南分行123', '张司机', '7228481234567891', '己方公司', 0, NULL, 1);
INSERT INTO `bankAccount` VALUES (10, '李司机2', 1, '中国农业银行济南分行', '李司机', '6228481234567860', '司机', 0, NULL, 0);
INSERT INTO `bankAccount` VALUES (11, '毛司机', 0, '中国农业银行济南分行', '毛账户名', '6228481234567860', '司机', 0, NULL, 0);
INSERT INTO `bankAccount` VALUES (12, '毛司机', 1, '中国农业银行济南分行', '毛账户名', '6228481234567860', '司机', 0, NULL, 0);
INSERT INTO `bankAccount` VALUES (13, '山东省某科技有限公司', 999, '中国工商银行济南分行', '山东省某科技有限公司', '6222001234567890', NULL, 100000, '公司主要银行账户', 0);
INSERT INTO `bankAccount` VALUES (14, '山东省某科技有限公司', 999, '中国工商银行济南分行', '山东省某科技有限公司', '6222001234567890', '己方公司', 100000, '公司主要银行账户', 0);
INSERT INTO `bankAccount` VALUES (15, '山东省某科技有限公司', 999, '中国工商银行济南分行', '山东省某科技有限公司', '6222001234567890', '己方公司', 100000, '公司主要银行账户', 0);
INSERT INTO `bankAccount` VALUES (16, '山东省某科技有限公司', 999, '中国工商银行济南分行', '山东省某科技有限公司', '6222001234567890', '己方公司', 100000, '公司主要银行账户', 0);
INSERT INTO `bankAccount` VALUES (17, NULL, 0, '中国银行', '张先生', '1226555855985548', '己方公司', 0, NULL, 0);

-- ----------------------------
-- Table structure for bankAccountChange
-- ----------------------------
DROP TABLE IF EXISTS `bankAccountChange`;
CREATE TABLE `bankAccountChange`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `tableName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发生操作行为的表',
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发生操作行为的付款编号（UUID）',
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `changeType` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '变动类型（收入、支出）',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '银行账号变动流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bankAccountChange
-- ----------------------------

-- ----------------------------
-- Table structure for borrowedMoney
-- ----------------------------
DROP TABLE IF EXISTS `borrowedMoney`;
CREATE TABLE `borrowedMoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款编号（UUID）',
  `origin` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款来源',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '借入金额',
  `ratio` double NULL DEFAULT 0 COMMENT '贷款利率',
  `loanDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款发放日期',
  `loanDuring` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款年限（年）',
  `mortgageGuarantee` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '抵押担保',
  `acountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打入账户',
  `bankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打入账号',
  `isEnd` int(11) NULL DEFAULT 0 COMMENT '已还款标记',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从外部借款信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrowedMoney
-- ----------------------------

-- ----------------------------
-- Table structure for carApply
-- ----------------------------
DROP TABLE IF EXISTS `carApply`;
CREATE TABLE `carApply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bTripId` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差编号UUID',
  `applyDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请时间',
  `applyUser` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人',
  `department` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `carNo` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车牌',
  `isUseOilCard` int(11) NULL DEFAULT 0 COMMENT '是否携带油卡',
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
  `dispatchPerson` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '派车人',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车辆使用申请' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carApply
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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '外部车辆信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cars
-- ----------------------------
INSERT INTO `cars` VALUES (1, '鲁A济南车~', '毛司机', '19512345678', '中国农业银行济南分行', '毛账户名', '6228481234567860', 1, '海运', 'Mon Jul 29 15:32:30 CST 2024', 1, NULL, '2024-07-29 15:48:56', 1);
INSERT INTO `cars` VALUES (2, '鲁A济南车~', '毛司机', '19512345678', '中国农业银行济南分行', '毛账户名', '6228481234567860', 1, '陆运', 'Mon Jul 29 15:47:36 CST 2024', 1, NULL, NULL, 1);
INSERT INTO `cars` VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'Tue Jul 30 17:22:36 CST 2024', 1, NULL, NULL, 1);
INSERT INTO `cars` VALUES (4, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'Tue Jul 30 17:23:46 CST 2024', 1, NULL, NULL, 1);
INSERT INTO `cars` VALUES (5, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'Tue Jul 30 20:05:22 CST 2024', 1, NULL, NULL, 1);

-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS `company`;
CREATE TABLE `company`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司名称',
  `relationName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `relationTel` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人电话',
  `address` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `bankName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `acountsName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户名',
  `bankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `surplusMoney` double NOT NULL DEFAULT 0 COMMENT '余额',
  `companyType` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户类别（ 客户，供应商）',
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
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户、供应商信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of company
-- ----------------------------
INSERT INTO `company` VALUES (1, '山东省某科技有限公司', '张三', '13812345678', '山东省济南市高新区某街道100号', '中国工商银行济南分行', '山东省某科技有限公司', '6222001234567890', 50000, '客户', '李四', '王五', '13987654321', '山东省济南市高新区', '赵六', '山东省', '济南市', '高新区', '优质客户', 'Mon Jul 29 13:45:17 CST 2024', 1, NULL, '2024-07-30 21:04:44', 1);
INSERT INTO `company` VALUES (2, '山东省某有限公司', '王五', '13812345678', '山东省德州市高新区某街道100号', '', '泰安有限公司', '5622001234567120', 50000, '客户', '李四', '王五', '13987654321', '山东省济南市高新区', '赵六', '山东省', '济南市', '高新区', '优质客户', 'Mon Jul 29 20:03:32 CST 2024', 1, NULL, '2024-07-30 21:19:32', 0);
INSERT INTO `company` VALUES (3, '山东省某有限公司', '王五', '13812345678', '山东省德州市高新区某街道100号', '中国工商银行德州分行', '山东省某科技有限公司', '6222001234567890', 50000, '客户', '李四', '王五', '13987654321', 'nullnullnull', '赵六', '山东省', '济南市', '高新区', '优质客户', 'Mon Jul 29 20:03:38 CST 2024', 1, NULL, NULL, 0);
INSERT INTO `company` VALUES (4, '山东省某有限公司', '王6', '13812345678', '山东省德州市高新区某街道100号', '', '江西省有限公司', '6222001234567890', 50000, '供应商', '李四', '王五', '13987654321', '山东省济南市高新区', '赵六', '山东省', '济南市', '高新区', '优质客户', 'Tue Jul 30 11:07:46 CST 2024', 1, NULL, '2024-07-30 21:22:01', 0);
INSERT INTO `company` VALUES (5, '1', '1', '1', '1', '1', '1', '1', 1, '客户', '1', '1', '1', 'nullnullnull', NULL, NULL, NULL, NULL, NULL, 'Tue Jul 30 11:11:42 GMT+08:00 2024', 1, NULL, NULL, 1);
INSERT INTO `company` VALUES (6, '山东省某有限公司', '王7', '13812345678', '山东省德州市高新区某街道2000号', '中国工商银行德州分行', '山东省有限公司', '63220012345671540', 50000, '供应商', '李四', '王五', '13987654321', '山东省济南市高新区', '赵六', '山东省', '济南市', '高新区', '优质客户', 'Tue Jul 30 11:50:35 CST 2024', 1, NULL, '2024-07-30 11:52:03', 0);
INSERT INTO `company` VALUES (7, '山东省某有限公司', '粒6', '13812345678', '山东省德州市高新区某街道2000号', '中国工商银行济南分行', '山东省公司', '62220012345671540', 50000, '供应商', '李四', '王五', '13987654321', '山东省济南市高新区', '赵六', '山东省', '济南市', '高新区', '优质客户', 'Tue Jul 30 11:50:52 CST 2024', 1, NULL, NULL, 0);
INSERT INTO `company` VALUES (8, '山东石油公司', '张客户', '15588459866', '德州代悦', NULL, NULL, NULL, 0, '客户', '李老板', '李老板', '15588459866', '山东太大无', '李老板', '山东', '太大', '无', '无', 'Tue Jul 30 13:57:01 CST 2024', 1, NULL, NULL, 0);
INSERT INTO `company` VALUES (9, '山东公司', NULL, '15588459958', '德州', NULL, NULL, NULL, 0, '供应商', NULL, NULL, NULL, '德州德州德州', NULL, '德州', '德州', '德州', '无', 'Tue Jul 30 14:02:56 CST 2024', 1, NULL, NULL, 0);

-- ----------------------------
-- Table structure for exWarehouse
-- ----------------------------
DROP TABLE IF EXISTS `exWarehouse`;
CREATE TABLE `exWarehouse`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `storeHouseid` int(11) NULL DEFAULT 0 COMMENT '仓库ID',
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `storeID` int(11) NULL DEFAULT 0 COMMENT '仓库存储的货物ID',
  `outDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出库日期',
  `outAmount` int(11) NULL DEFAULT 0 COMMENT '出库量（片数）',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exWarehouse
-- ----------------------------

-- ----------------------------
-- Table structure for fixedAssets
-- ----------------------------
DROP TABLE IF EXISTS `fixedAssets`;
CREATE TABLE `fixedAssets`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `buyDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购入日期',
  `assetNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资产编号',
  `assetName` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资产名称',
  ` specification` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格型号（车牌号）',
  `number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数量',
  `measurementUnit ` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `amountIncludeTax` double NULL DEFAULT 0 COMMENT '含税金额',
  `amountNoTax` double NULL DEFAULT 0 COMMENT '不含税金额',
  `account` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '户名名称（公户/个人）',
  `department` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '使用部门',
  `scrapDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '固定资产清理时间',
  `saleAmount` double NULL DEFAULT 0 COMMENT '清理/变卖价值',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '固定资产' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fixedAssets
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车队' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fleet
-- ----------------------------
INSERT INTO `fleet` VALUES (1, '1', '12', '123323', '221', 'Tue Jul 30 16:37:09 CST 2024', '1', 1);
INSERT INTO `fleet` VALUES (2, NULL, NULL, NULL, NULL, 'Tue Jul 30 17:24:09 CST 2024', NULL, 1);
INSERT INTO `fleet` VALUES (3, 'QpoVFg#w*SW#Yvv[i&', 'yx*vdiv21^)p^&', '18638478643', '&S2@gg*FVj', 'Tue Jul 30 21:31:35 CST 2024', NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (1, 'BusinessTrip', '出差', NULL, NULL, 'BusinessTrip', 'crud', '', 'org.dzu.system', 'system', 'BusinessTrip', '出差', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:30:13', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (2, 'carApply', '车辆使用申请', NULL, NULL, 'CarApply', 'crud', '', 'org.dzu.system', 'system', 'carApply', '车辆使用申请', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:30:15', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (3, 'BalanceAccounts', '平账信息', NULL, NULL, 'BalanceAccounts', 'crud', '', 'org.dzu.system', 'system', 'BalanceAccounts', '平账信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:30:47', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (4, 'CustomerVisit', '走访记录', NULL, NULL, 'CustomerVisit', 'crud', '', 'org.dzu.system', 'system', 'CustomerVisit', '走访记录', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:30:49', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (5, 'Offsetting', '对冲账信息', NULL, NULL, 'Offsetting', 'crud', '', 'org.dzu.system', 'system', 'Offsetting', '对冲账信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:30:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (6, 'OilCardConsume', '加油卡消费信息', NULL, NULL, 'OilCardConsume', 'crud', '', 'org.dzu.system', 'system', 'OilCardConsume', '加油卡消费信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:30:55', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (7, 'Rebate', '返利回扣', NULL, NULL, 'Rebate', 'crud', '', 'org.dzu.system', 'system', 'Rebate', '返利回扣', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:30:57', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (8, 'StoreHouse', '库房', NULL, NULL, 'StoreHouse', 'crud', '', 'org.dzu.system', 'system', 'StoreHouse', '库房', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:00', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (9, 'bankAcceptance', '商业票据、银行承兑', NULL, NULL, 'BankAcceptance', 'crud', '', 'org.dzu.system', 'system', 'bankAcceptance', '商业票据、银行承兑', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:01', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (10, 'bankAccount', '银行账号', NULL, NULL, 'BankAccount', 'crud', '', 'org.dzu.system', 'system', 'bankAccount', '银行账号', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:04', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (11, 'bankAccountChange', '银行账号变动流水', NULL, NULL, 'BankAccountChange', 'crud', '', 'org.dzu.system', 'system', 'bankAccountChange', '银行账号变动流水', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:06', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (12, 'borrowedMoney', '从外部借款信息', NULL, NULL, 'BorrowedMoney', 'crud', '', 'org.dzu.system', 'system', 'borrowedMoney', '从外部借款信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:08', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (13, 'cars', '外部车辆信息', NULL, NULL, 'Cars', 'crud', '', 'org.dzu.system', 'system', 'cars', '外部车辆信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (14, 'company', '客户、供应商信息', NULL, NULL, 'Company', 'crud', '', 'org.dzu.system', 'system', 'company', '客户、供应商信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:12', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (15, 'exWarehouse', '出库', NULL, NULL, 'ExWarehouse', 'crud', '', 'org.dzu.system', 'system', 'exWarehouse', '出库', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:16', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (16, 'fixedAssets', '固定资产', NULL, NULL, 'FixedAssets', 'crud', '', 'org.dzu.system', 'system', 'fixedAssets', '固定资产', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (17, 'fleet', '车队', NULL, NULL, 'Fleet', 'crud', '', 'org.dzu.system', 'system', 'fleet', '车队', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:20', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (18, 'goodsOrder', '订单表', NULL, NULL, 'GoodsOrder', 'crud', '', 'org.dzu.system', 'system', 'goodsOrder', '订单', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:22', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (19, 'goodsOrder_back', '订单表备份', NULL, NULL, 'GoodsorderBack', 'crud', '', 'org.dzu.system', 'system', 'back', '订单备份', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:27', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (20, 'inventory', '库存', NULL, NULL, 'Inventory', 'crud', '', 'org.dzu.system', 'system', 'inventory', '库存', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:32', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (21, 'inventory_back', '库存备份', NULL, NULL, 'InventoryBack', 'crud', '', 'org.dzu.system', 'system', 'back', '库存备份', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:40', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (22, 'invoiceIn', '发票购入信息', NULL, NULL, 'InvoiceIn', 'crud', '', 'org.dzu.system', 'system', 'invoiceIn', '发票购入信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:47', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (23, 'invoiceOther', '商家直接给客户开发票', NULL, NULL, 'InvoiceOther', 'crud', '', 'org.dzu.system', 'system', 'invoiceOther', '商家直接给客户开发票', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:50', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (24, 'invoiceOut', '发票卖出信息', NULL, NULL, 'InvoiceOut', 'crud', '', 'org.dzu.system', 'system', 'invoiceOut', '发票卖出信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:52', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (25, 'lendMoney', '向外部借出款信息', NULL, NULL, 'LendMoney', 'crud', '', 'org.dzu.system', 'system', 'lendMoney', '向外部借出款信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:55', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (26, 'oilCard', '加油卡信息', NULL, NULL, 'OilCard', 'crud', '', 'org.dzu.system', 'system', 'oilCard', '加油卡信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:58', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (27, 'oilCardFundTransfer', '加油卡圈存', NULL, NULL, 'OilCardFundTransfer', 'crud', '', 'org.dzu.system', 'system', 'oilCardFundTransfer', '加油卡圈存', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:31:59', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (28, 'oilRecharge', '加油卡充值信息', NULL, NULL, 'OilRecharge', 'crud', '', 'org.dzu.system', 'system', 'oilRecharge', '加油卡充值信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:01', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (29, 'orderDetail', '订单详情', NULL, NULL, 'OrderDetail', 'crud', '', 'org.dzu.system', 'system', 'orderDetail', '订单详情', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:04', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (30, 'orderDetail_back', '订单详情备份', NULL, NULL, 'OrderdetailBack', 'crud', '', 'org.dzu.system', 'system', 'back', '订单详情备份', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (31, 'orderFreight', '订单运费', NULL, NULL, 'OrderFreight', 'crud', '', 'org.dzu.system', 'system', 'orderFreight', '订单运费', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (32, 'payment', '付款信息', NULL, NULL, 'Payment', 'crud', '', 'org.dzu.system', 'system', 'payment', '付款信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:21', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (33, 'productLevel', '产品级别', NULL, NULL, 'ProductLevel', 'crud', '', 'org.dzu.system', 'system', 'productLevel', '产品级别', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:25', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (34, 'receiveMoney', '收款信息', NULL, NULL, 'ReceiveMoney', 'crud', '', 'org.dzu.system', 'system', 'receiveMoney', '收款信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:27', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (35, 'recoverMoney', '借出款收回信息', NULL, NULL, 'RecoverMoney', 'crud', '', 'org.dzu.system', 'system', 'recoverMoney', '借出款收回信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:30', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (36, 'repayment', '贷款还款信息', NULL, NULL, 'Repayment', 'crud', '', 'org.dzu.system', 'system', 'repayment', '贷款还款信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:32', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (37, 'socialInsurance', '社保基金', NULL, NULL, 'SocialInsurance', 'crud', '', 'org.dzu.system', 'system', 'socialInsurance', '社保基金', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:34', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (38, 'tableEditMessage', '表编辑原因', NULL, NULL, 'TableEditMessage', 'crud', '', 'org.dzu.system', 'system', 'tableEditMessage', '编辑原因', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:38', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (39, 'tripReimbursement', '出差报销', NULL, NULL, 'TripReimbursement', 'crud', '', 'org.dzu.system', 'system', 'tripReimbursement', '出差报销', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:40', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (40, 'virtualBankAccountChange', '虚拟银行账号', NULL, NULL, 'VirtualBankAccountChange', 'crud', '', 'org.dzu.system', 'system', 'virtualBankAccountChange', '虚拟银行账号', 'ml', '0', '/', NULL, 'admin', '2024-07-29 12:32:41', '', NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 840 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1, 1, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:30:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (2, 1, 'employeeID', '报销人ID', 'int(11)', 'Long', 'employeeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:30:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (3, 1, 'employee', '报销人', 'varchar(150)', 'String', 'employee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:30:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (4, 1, 'personnel', '共同出差人员', 'varchar(150)', 'String', 'personnel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:30:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (5, 1, 'starttime', '出差时间', 'varchar(50)', 'String', 'starttime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (6, 1, 'endtime', '出差结束时间', 'varchar(50)', 'String', 'endtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (7, 1, 'attachmentPath', '附件地址', 'varchar(250)', 'String', 'attachmentPath', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (8, 1, 'isReimburse', '是否已报销（0未报销，1已报销）', 'int(11)', 'Long', 'isReimburse', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (9, 1, 'comments', '备注', 'varchar(550)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 9, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (10, 1, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (11, 1, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (12, 1, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:30:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (13, 1, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 12:30:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (14, 1, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:30:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (15, 2, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:30:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (16, 2, 'bTripId', '出差编号UUID', 'varchar(50)', 'String', 'bTripId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:30:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (17, 2, 'applyDate', '申请时间', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:30:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (18, 2, 'applyUser', '申请人', 'varchar(25)', 'String', 'applyUser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (19, 2, 'department', '部门', 'varchar(25)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (20, 2, 'carNo', '车牌', 'varchar(200)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (21, 2, 'isUseOilCard', '是否携带油卡', 'int(11)', 'Long', 'isUseOilCard', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (22, 2, 'peers', '随同乘车人员', 'varchar(155)', 'String', 'peers', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (23, 2, 'startTime', '用车时间', 'varchar(55)', 'String', 'startTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (24, 2, 'endTime', '还车时间', 'varchar(55)', 'String', 'endTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (25, 2, 'ApplyPurpose', '用车事由', 'varchar(255)', 'String', 'ApplyPurpose', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:30:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (26, 2, 'startMile', '出车前里程', 'varchar(55)', 'String', 'startMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:30:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (27, 2, 'startCarState', '出车前车况（外观是否损坏，车胎等）', 'varchar(155)', 'String', 'startCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:30:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (28, 2, 'endMile', '回来后里程', 'varchar(55)', 'String', 'endMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:30:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (29, 2, 'endCarState', '回来后车况（外观是否损坏，车胎等）', 'varchar(255)', 'String', 'endCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:30:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (30, 2, 'miles', '用车里程数', 'varchar(55)', 'String', 'miles', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:30:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (31, 2, 'backStopPlace', '回程停靠位置', 'varchar(155)', 'String', 'backStopPlace', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:30:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (32, 2, 'violationsCount', '行程中违法次数', 'varchar(15)', 'String', 'violationsCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:30:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (33, 2, 'fine', '违章罚款金额金额', 'varchar(25)', 'String', 'fine', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (34, 2, 'isMaintenance', '行程中是否维修/保养', 'varchar(5)', 'String', 'isMaintenance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (35, 2, 'maintenanceMoney', '保养金额', 'varchar(15)', 'String', 'maintenanceMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (36, 2, 'refuelingFrequency', '行程中使用加油卡加油次数', 'varchar(15)', 'String', 'refuelingFrequency', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (37, 2, 'dispatchPerson', '派车人', 'varchar(25)', 'String', 'dispatchPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (38, 2, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (39, 2, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (40, 2, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:30:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (41, 2, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 27, 'admin', '2024-07-29 12:30:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (42, 2, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 28, 'admin', '2024-07-29 12:30:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (43, 2, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 12:30:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (44, 2, 'path', '附件路径', 'varchar(255)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 12:30:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (45, 3, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:30:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (46, 3, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:30:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (47, 3, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:30:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (48, 3, 'companyName', '对方公司', 'varchar(150)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 12:30:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (49, 3, 'companyID', '对方公司ID', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:30:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (50, 3, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-29 12:30:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (51, 3, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:30:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (52, 3, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:30:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (53, 3, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:30:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (54, 3, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:30:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (55, 3, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2024-07-29 12:30:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (56, 3, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:30:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (57, 4, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:30:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (58, 4, 'province', '省', 'varchar(50)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:30:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (59, 4, 'city', '市县', 'varchar(50)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:30:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (60, 4, 'county', '乡镇（街道）', 'varchar(100)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:30:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (61, 4, 'customer', '客户', 'varchar(550)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2024-07-29 12:30:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (62, 4, 'leaderName', '负责人', 'varchar(550)', 'String', 'leaderName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 6, 'admin', '2024-07-29 12:30:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (63, 4, 'LeaderTel', '负责人电话', 'varchar(550)', 'String', 'LeaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 7, 'admin', '2024-07-29 12:30:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (64, 4, 'equipment', '厂房设备', 'varchar(200)', 'String', 'equipment', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:30:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (65, 4, 'competitor', '竞争对手', 'varchar(200)', 'String', 'competitor', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:30:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (66, 4, 'localDealer', '当地经销商', 'varchar(200)', 'String', 'localDealer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (67, 4, 'monthlyConsumption', '月用货量（车数）', 'varchar(200)', 'String', 'monthlyConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (68, 4, 'whiteGlassFactory', '白玻用货习惯及厂家', 'varchar(200)', 'String', 'whiteGlassFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (69, 4, 'loweGlassConsumption', 'lowe玻璃用货厂家及用量', 'varchar(200)', 'String', 'loweGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (70, 4, 'colorGlassConsumption', '色玻、过度色玻璃用货厂家及用量', 'varchar(200)', 'String', 'colorGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (71, 4, 'specialGlassConsumption', '特色厚度、特殊尺寸、协议品用货厂家及用量', 'varchar(200)', 'String', 'specialGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (72, 4, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (73, 4, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:30:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (74, 4, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:30:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (75, 4, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-29 12:30:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (76, 4, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 20, 'admin', '2024-07-29 12:30:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (77, 4, 'visitDate', '走访日期', 'varchar(50)', 'String', 'visitDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:30:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (78, 4, 'checkState', '审核标志', 'int(11)', 'Long', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:30:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (79, 4, 'checkUserID', '审核人ID', 'int(11)', 'Long', 'checkUserID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:30:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (80, 4, 'checkUserName', '审核人', 'varchar(50)', 'String', 'checkUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-29 12:30:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (81, 4, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:30:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (82, 5, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:30:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (83, 5, 'OffsetNO', '冲抵编号（UUID）', 'varchar(50)', 'String', 'OffsetNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:30:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (84, 5, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:30:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (85, 5, 'operateType', '冲抵类型（收入、支出）', 'varchar(50)', 'String', 'operateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-29 12:30:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (86, 5, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:30:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (87, 5, 'companyName', '公司', 'varchar(150)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:30:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (88, 5, 'companyId', '公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:30:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (89, 5, 'companyType', '公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-29 12:30:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (90, 5, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:30:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (91, 5, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:30:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (92, 5, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:30:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (93, 5, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:30:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (94, 5, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 12:30:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (95, 5, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:30:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (96, 6, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:30:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (97, 6, 'bTripId', '出差编号UUID', 'varchar(50)', 'String', 'bTripId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:30:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (98, 6, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:30:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (99, 6, 'useDate', '使用加油卡时间', 'varchar(50)', 'String', 'useDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:30:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (100, 6, 'carNo', '使用加油卡车辆车牌号', 'varchar(55)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (101, 6, 'startCardSurplus', '期初余额', 'varchar(55)', 'String', 'startCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (102, 6, 'refuelingNumber', '加油量（升）', 'varchar(255)', 'String', 'refuelingNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (103, 6, 'unitPrice', '单价', 'varchar(255)', 'String', 'unitPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (104, 6, 'refuelingMoney', '加油金额(元）', 'varchar(255)', 'String', 'refuelingMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (105, 6, 'rechargeMoney', '充值金额(元）', 'varchar(255)', 'String', 'rechargeMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (106, 6, 'endCardSurplus', '加油卡余额', 'varchar(255)', 'String', 'endCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (107, 6, 'attachmentOiladd', '加油小票附件', 'varchar(300)', 'String', 'attachmentOiladd', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:30:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (108, 6, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:30:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (109, 6, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:30:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (110, 6, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:30:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (111, 6, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-29 12:30:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (112, 6, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-29 12:30:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (113, 6, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:30:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (114, 7, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:30:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (115, 7, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:30:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (116, 7, 'rebateDate', '日期', 'varchar(50)', 'String', 'rebateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:30:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (117, 7, 'rebate', '金额', 'double', 'Double', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:30:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (118, 7, 'rebateType', '类型（返利、降价、售后质量赔偿）', 'varchar(80)', 'String', 'rebateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-29 12:30:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (119, 7, 'inAcountsName', '收款户名', 'varchar(80)', 'String', 'inAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:30:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (120, 7, 'inBankNo', '收款账号', 'varchar(80)', 'String', 'inBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:30:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (121, 7, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:30:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (122, 7, 'supplierID', '供应商ID', 'int(11)', 'Long', 'supplierID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:30:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (123, 7, 'outAcountsName', '付款户名', 'varchar(80)', 'String', 'outAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:30:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (124, 7, 'outBankNo', '付款款账号', 'varchar(80)', 'String', 'outBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:30:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (125, 7, 'rebateReason', '返利原因', 'varchar(55)', 'String', 'rebateReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:30:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (126, 7, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:30:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (127, 7, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:30:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (128, 7, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (129, 7, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-29 12:31:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (130, 7, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-29 12:31:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (131, 7, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:31:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (132, 8, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (133, 8, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 12:31:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (134, 8, 'address', '地址', 'varchar(100)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (135, 8, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (136, 9, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (137, 9, 'operateDate', '操作日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (138, 9, 'billNo', '票据号码', 'varchar(55)', 'String', 'billNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (139, 9, 'issueDate', '出票日期', 'varchar(50)', 'String', 'issueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (140, 9, 'dueDate', '到期日期', 'varchar(50)', 'String', 'dueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (141, 9, 'billAccount', '我方承兑账户', 'varchar(50)', 'String', 'billAccount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (142, 9, 'billDate', '票据日期', 'varchar(50)', 'String', 'billDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (143, 9, 'billType', '分类（收入、支出）', 'varchar(55)', 'String', 'billType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-29 12:31:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (144, 9, 'reason', '事由', 'varchar(155)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (145, 9, 'billAmount', '票据金额', 'double', 'Double', 'billAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (146, 9, 'inDiscountPoints', '贴息点数', 'double', 'Double', 'inDiscountPoints', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (147, 9, 'inDiscountAmount', '贴息金额', 'double', 'Double', 'inDiscountAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (148, 9, 'billCategory', '票据种类（电子/纸质）', 'varchar(55)', 'String', 'billCategory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (149, 9, 'origin', '来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (150, 9, 'endorser', '背书人', 'varchar(155)', 'String', 'endorser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (151, 9, 'endorsee', '被背书人', 'varchar(155)', 'String', 'endorsee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (152, 9, 'endorseReason', '背书事由（出卖/付货款）', 'varchar(255)', 'String', 'endorseReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (153, 9, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (154, 9, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:31:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (155, 9, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:31:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (156, 9, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-29 12:31:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (157, 9, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-29 12:31:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (158, 9, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:31:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (159, 10, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (160, 10, 'companyName', '公司名称', 'varchar(50)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 12:31:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (161, 10, 'companyId', '对应公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (162, 10, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 12:31:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (163, 10, 'acountsName', '开户名称', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 12:31:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (164, 10, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (165, 10, 'acountsType', '账户类型（己方公司，客户，供应商，司机，其它）', 'varchar(50)', 'String', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 7, 'admin', '2024-07-29 12:31:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (166, 10, 'amount', '当前资金额', 'double', 'Double', 'amount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (167, 10, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (168, 10, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (169, 11, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (170, 11, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (171, 11, 'tableName', '发生操作行为的表', 'varchar(80)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 12:31:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (172, 11, 'payNO', '发生操作行为的付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (173, 11, 'operateDate', '日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (174, 11, 'changeType', '变动类型（收入、支出）', 'varchar(15)', 'String', 'changeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-29 12:31:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (175, 11, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (176, 11, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (177, 11, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (178, 11, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (179, 11, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 12:31:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (180, 11, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-29 12:31:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (181, 12, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (182, 12, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (183, 12, 'origin', '贷款来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (184, 12, 'moneyAmount', '借入金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (185, 12, 'ratio', '贷款利率', 'double', 'Double', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (186, 12, 'loanDate', '贷款发放日期', 'varchar(50)', 'String', 'loanDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (187, 12, 'loanDuring', '贷款年限（年）', 'varchar(50)', 'String', 'loanDuring', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (188, 12, 'mortgageGuarantee', '抵押担保', 'varchar(200)', 'String', 'mortgageGuarantee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (189, 12, 'acountsName', '打入账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (190, 12, 'bankNo', '打入账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (191, 12, 'isEnd', '已还款标记', 'int(11)', 'Long', 'isEnd', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (192, 12, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (193, 12, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (194, 12, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (195, 12, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 15, 'admin', '2024-07-29 12:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (196, 12, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2024-07-29 12:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (197, 12, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (198, 13, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (199, 13, 'carNo', '车牌', 'varchar(20)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (200, 13, 'driver', '司机', 'varchar(20)', 'String', 'driver', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (201, 13, 'tel', '司机电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (202, 13, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (203, 13, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (204, 13, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (205, 13, 'acountsType', '账号类型（1收款，2付款）', 'int(11)', 'Long', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (206, 13, 'carType', '运输类型(陆运，海运)', 'varchar(50)', 'String', 'carType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 9, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (207, 13, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (208, 13, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (209, 13, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:31:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (210, 13, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 12:31:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (211, 13, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (212, 14, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (213, 14, 'companyName', '公司名称', 'varchar(550)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 2, 'admin', '2024-07-29 12:31:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (214, 14, 'relationName', '联系人', 'varchar(50)', 'String', 'relationName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 12:31:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (215, 14, 'relationTel', '联系人电话', 'varchar(30)', 'String', 'relationTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (216, 14, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (217, 14, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:31:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (218, 14, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 12:31:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (219, 14, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (220, 14, 'surplusMoney', '余额', 'double', 'Double', 'surplusMoney', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (221, 14, 'companyType', '客户类别（ 客户，供应商）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 10, 'admin', '2024-07-29 12:31:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (222, 14, 'salesman', '业务员', 'varchar(55)', 'String', 'salesman', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (223, 14, 'leader', '老板', 'varchar(50)', 'String', 'leader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (224, 14, 'leaderTel', '联系人电话', 'varchar(30)', 'String', 'leaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (225, 14, 'region', '区域（省+市县+乡镇）', 'varchar(280)', 'String', 'region', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (226, 14, 'salesManager', '销售经理', 'varchar(55)', 'String', 'salesManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (227, 14, 'province', '省', 'varchar(55)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (228, 14, 'city', '市县', 'varchar(155)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (229, 14, 'county', '乡镇', 'varchar(155)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (230, 14, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (231, 14, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (232, 14, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (233, 14, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (234, 14, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 23, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (235, 14, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:31:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (236, 15, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (237, 15, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (238, 15, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (239, 15, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 12:31:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (240, 15, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (241, 15, 'outDate', '出库日期', 'varchar(50)', 'String', 'outDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (242, 15, 'outAmount', '出库量（片数）', 'int(11)', 'Long', 'outAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (243, 15, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (244, 15, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2024-07-29 12:31:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (245, 15, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (246, 15, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (247, 15, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:31:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (248, 16, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (249, 16, 'buyDate', '购入日期', 'varchar(50)', 'String', 'buyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (250, 16, 'assetNo', '资产编号', 'varchar(55)', 'String', 'assetNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (251, 16, 'assetName', '资产名称', 'varchar(155)', 'String', 'assetName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 12:31:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (252, 16, ' specification', '规格型号（车牌号）', 'varchar(100)', 'String', ' specification', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (253, 16, 'number', '数量', 'varchar(20)', 'String', 'number', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (254, 16, 'measurementUnit ', '计量单位', 'varchar(55)', 'String', 'measurementUnit ', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (255, 16, 'amountIncludeTax', '含税金额', 'double', 'Double', 'amountIncludeTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (256, 16, 'amountNoTax', '不含税金额', 'double', 'Double', 'amountNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (257, 16, 'account', '户名名称（公户/个人）', 'varchar(55)', 'String', 'account', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (258, 16, 'department', '使用部门', 'varchar(55)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (259, 16, 'scrapDate', '固定资产清理时间', 'varchar(50)', 'String', 'scrapDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (260, 16, 'saleAmount', '清理/变卖价值', 'double', 'Double', 'saleAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (261, 16, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (262, 16, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (263, 16, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (264, 16, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-29 12:31:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (265, 16, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-29 12:31:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (266, 16, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:31:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (267, 17, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (268, 17, 'fName', '车队名称', 'varchar(50)', 'String', 'fName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 12:31:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (269, 17, 'fLeader', '车队经理', 'varchar(50)', 'String', 'fLeader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (270, 17, 'tel', '车队经理电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (271, 17, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (272, 17, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (273, 17, 'editTime', '编辑时间', 'varchar(55)', 'String', 'editTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (274, 17, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (275, 18, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (276, 18, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (277, 18, 'orderDate', '日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (278, 18, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (279, 18, 'customerID', '客户ID', 'int(11)', 'Long', 'customerID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (280, 18, 'landCarID', '陆运车辆ID', 'int(11)', 'Long', 'landCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (281, 18, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (282, 18, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (283, 18, 'landDriverName', '陆地司机姓名', 'varchar(55)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (284, 18, 'seaCarID', '海运车辆ID', 'int(11)', 'Long', 'seaCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (285, 18, 'seaCarNo', '海运车牌', 'varchar(50)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (286, 18, 'seaDriverTel', '海运司机电话', 'varchar(50)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (287, 18, 'seaDriverName', '海运司机姓名', 'varchar(55)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (288, 18, 'checkUserId', '审核人编号', 'int(11)', 'Long', 'checkUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (289, 18, 'checkState', '审核状态（已审核、未审核）', 'varchar(20)', 'String', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (290, 18, 'invoiceState', '开票状态（未开票，部分开票，已开票）', 'varchar(20)', 'String', 'invoiceState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (291, 18, 'path', '附件路径', 'varchar(250)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (292, 18, 'PaymentState', '打款状态(申请中，已打款，未打款)', 'varchar(20)', 'String', 'PaymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:31:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (293, 18, 'landBankName', '陆运银行户名', 'varchar(50)', 'String', 'landBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-29 12:31:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (294, 18, 'landBankNo', '陆运银行账号', 'varchar(50)', 'String', 'landBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:31:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (295, 18, 'seaBankName', '海运银行户名', 'varchar(50)', 'String', 'seaBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-29 12:31:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (296, 18, 'seaBankNo', '海运银行账号', 'varchar(50)', 'String', 'seaBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:31:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (297, 18, 'receiveProof', '收到条附件路径', 'text', 'String', 'receiveProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 23, 'admin', '2024-07-29 12:31:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (298, 18, 'saleManager', '销售经理', 'varchar(25)', 'String', 'saleManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:31:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (299, 18, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:31:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (300, 18, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:31:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (301, 18, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 12:31:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (302, 18, 'isAdjust', '是否调整单（是  否）', 'varchar(10)', 'String', 'isAdjust', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 12:31:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (303, 18, 'adjustOrderid', '原订单编号', 'int(11)', 'Long', 'adjustOrderid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (304, 18, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (305, 18, 'customerIsInvoice', '客户是否开票', 'int(11)', 'Long', 'customerIsInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (306, 18, 'isSupplierInvoice', '供应商是否开票', 'int(11)', 'Long', 'isSupplierInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (307, 18, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (308, 18, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (309, 18, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (310, 18, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 12:31:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (311, 18, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 37, 'admin', '2024-07-29 12:31:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (312, 18, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 38, 'admin', '2024-07-29 12:31:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (313, 19, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (314, 19, 'goodsOrderID', '原订单ID', 'int(11)', 'Long', 'goodsOrderID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (315, 19, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (316, 19, 'orderDate', '日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (317, 19, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (318, 19, 'customerID', '客户ID', 'int(11)', 'Long', 'customerID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (319, 19, 'landCarID', '陆运车辆ID', 'int(11)', 'Long', 'landCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (320, 19, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (321, 19, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (322, 19, 'landDriverName', '陆地司机姓名', 'varchar(55)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (323, 19, 'seaCarID', '海运车辆ID', 'int(11)', 'Long', 'seaCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (324, 19, 'seaCarNo', '海运车牌', 'varchar(50)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (325, 19, 'seaDriverTel', '海运司机电话', 'varchar(50)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (326, 19, 'seaDriverName', '海运司机姓名', 'varchar(55)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-29 12:31:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (327, 19, 'checkUserId', '审核人编号', 'int(11)', 'Long', 'checkUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (328, 19, 'checkState', '审核状态（已审核、未审核）', 'varchar(20)', 'String', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (329, 19, 'invoiceState', '开票状态（未开票，部分开票，已开票）', 'varchar(20)', 'String', 'invoiceState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (330, 19, 'path', '附件路径', 'varchar(250)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:31:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (331, 19, 'PaymentState', '打款状态(已打款，未打款)', 'varchar(20)', 'String', 'PaymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (332, 19, 'landBankName', '陆运银行户名', 'varchar(50)', 'String', 'landBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 20, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (333, 19, 'landBankNo', '陆运银行账号', 'varchar(50)', 'String', 'landBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (334, 19, 'seaBankName', '海运银行户名', 'varchar(50)', 'String', 'seaBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (335, 19, 'seaBankNo', '海运银行账号', 'varchar(50)', 'String', 'seaBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (336, 19, 'receiveProof', '收到条附件路径', 'text', 'String', 'receiveProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 24, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (337, 19, 'saleManager', '销售经理', 'varchar(25)', 'String', 'saleManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (338, 19, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:31:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (339, 19, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 12:31:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (340, 19, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 12:31:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (341, 19, 'isAdjust', '是否调整单（是  否）', 'varchar(10)', 'String', 'isAdjust', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 12:31:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (342, 19, 'adjustOrderid', '原订单编号', 'int(11)', 'Long', 'adjustOrderid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 12:31:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (343, 19, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 12:31:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (344, 19, 'customerIsInvoice', '客户是否开票', 'int(11)', 'Long', 'customerIsInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 12:31:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (345, 19, 'isSupplierInvoice', '供应商是否开票', 'int(11)', 'Long', 'isSupplierInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 12:31:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (346, 19, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 12:31:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (347, 19, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 12:31:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (348, 19, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 12:31:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (349, 19, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 12:31:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (350, 19, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 38, 'admin', '2024-07-29 12:31:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (351, 19, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 39, 'admin', '2024-07-29 12:31:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (352, 20, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (353, 20, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (354, 20, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 12:31:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (355, 20, 'storeDate', '入库日期', 'varchar(50)', 'String', 'storeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (356, 20, 'stockNumber', '库存量（片数）', 'int(11)', 'Long', 'stockNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (357, 20, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (358, 20, 'supplierId', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (359, 20, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (360, 20, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 12:31:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (361, 20, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (362, 20, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (363, 20, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (364, 20, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (365, 20, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (366, 20, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (367, 20, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (368, 20, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (369, 20, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (370, 20, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (371, 20, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (372, 20, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (373, 20, 'isIncludeTaxSale', '销售是否含税（0不含税，1含税）', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:31:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (374, 20, 'payments', '总货款', 'varchar(20)', 'String', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:31:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (375, 20, 'landCarID', '陆运车辆ID', 'int(11)', 'Long', 'landCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:31:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (376, 20, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:31:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (377, 20, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:31:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (378, 20, 'landDriverName', '陆地司机姓名', 'varchar(255)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 27, 'admin', '2024-07-29 12:31:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (379, 20, 'seaCarID', '海运车辆ID', 'int(11)', 'Long', 'seaCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 12:31:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (380, 20, 'seaCarNo', '海运车牌', 'varchar(550)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 29, 'admin', '2024-07-29 12:31:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (381, 20, 'seaDriverTel', '海运司机电话', 'varchar(550)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 30, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (382, 20, 'seaDriverName', '海运司机姓名', 'varchar(255)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 31, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (383, 20, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (384, 20, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (385, 20, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (386, 20, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (387, 20, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (388, 20, 'freight', '运费（海运费+陆运费）', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 12:31:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (389, 20, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-29 12:31:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (390, 20, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 12:31:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (391, 20, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 12:31:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (392, 20, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 12:31:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (393, 20, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 12:31:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (394, 20, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 12:31:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (395, 20, 'rebate', '返利金额', 'double', 'Double', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 12:31:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (396, 20, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 12:31:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (397, 20, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 12:31:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (398, 20, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-29 12:31:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (399, 20, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 48, 'admin', '2024-07-29 12:31:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (400, 20, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 49, 'admin', '2024-07-29 12:31:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (401, 20, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 50, 'admin', '2024-07-29 12:31:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (402, 20, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 51, 'admin', '2024-07-29 12:31:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (403, 20, 'showFlag', '订单仓库选择时是否显示（ 显示， 不显示）', 'int(11)', 'Long', 'showFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 52, 'admin', '2024-07-29 12:31:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (404, 21, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (405, 21, 'inventoryID', '原货物存储ID', 'int(11)', 'Long', 'inventoryID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (406, 21, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (407, 21, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 12:31:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (408, 21, 'storeDate', '入库日期', 'varchar(50)', 'String', 'storeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (409, 21, 'stockNumber', '库存量（片数）', 'int(11)', 'Long', 'stockNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (410, 21, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (411, 21, 'supplierId', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (412, 21, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (413, 21, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (414, 21, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (415, 21, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (416, 21, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (417, 21, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (418, 21, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (419, 21, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (420, 21, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (421, 21, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:31:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (422, 21, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:31:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (423, 21, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:31:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (424, 21, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:31:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (425, 21, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:31:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (426, 21, 'isIncludeTaxSale', '销售是否含税（0不含税，1含税）', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:31:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (427, 21, 'payments', '总货款', 'varchar(20)', 'String', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:31:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (428, 21, 'landCarID', '陆运车辆ID', 'int(11)', 'Long', 'landCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:31:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (429, 21, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:31:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (430, 21, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 12:31:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (431, 21, 'landDriverName', '陆地司机姓名', 'varchar(255)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 28, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (432, 21, 'seaCarID', '海运车辆ID', 'int(11)', 'Long', 'seaCarID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (433, 21, 'seaCarNo', '海运车牌', 'varchar(550)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 30, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (434, 21, 'seaDriverTel', '海运司机电话', 'varchar(550)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 31, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (435, 21, 'seaDriverName', '海运司机姓名', 'varchar(255)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 32, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (436, 21, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (437, 21, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (438, 21, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 12:31:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (439, 21, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 12:31:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (440, 21, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 12:31:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (441, 21, 'freight', '运费（海运费+陆运费）', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-29 12:31:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (442, 21, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 12:31:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (443, 21, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 12:31:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (444, 21, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 12:31:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (445, 21, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 12:31:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (446, 21, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (447, 21, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (448, 21, 'rebate', '返利金额', 'double', 'Double', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (449, 21, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (450, 21, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (451, 21, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 48, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (452, 21, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 49, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (453, 21, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 50, 'admin', '2024-07-29 12:31:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (454, 21, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 51, 'admin', '2024-07-29 12:31:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (455, 21, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 52, 'admin', '2024-07-29 12:31:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (456, 21, 'showFlag', '订单仓库选择时是否显示（ 显示， 不显示）', 'int(11)', 'Long', 'showFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 53, 'admin', '2024-07-29 12:31:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (457, 22, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (458, 22, 'invoiceDate', '开票日期', 'varchar(55)', 'String', 'invoiceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (459, 22, 'invoiceObject', '我方开票实体', 'varchar(55)', 'String', 'invoiceObject', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (460, 22, 'invoiceAmount', '开票金额', 'double', 'Double', 'invoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (461, 22, 'companyType', '对方公司类别（客户、供应商,其他）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (462, 22, 'companyName', '对方公司名称', 'varchar(120)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (463, 22, 'companyID', '对方公司ID', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (464, 22, 'invoiceCompanyName', '票据单位名称', 'varchar(120)', 'String', 'invoiceCompanyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (465, 22, 'ticketPoint', '票点', 'double', 'Double', 'ticketPoint', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (466, 22, 'ticketPointAmount', '票点金额（开票金额*票点）', 'double', 'Double', 'ticketPointAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (467, 22, 'isOrderTax', '是否订单对应票点', 'int(11)', 'Long', 'isOrderTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (468, 22, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (469, 22, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (470, 22, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (471, 22, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 15, 'admin', '2024-07-29 12:31:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (472, 22, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2024-07-29 12:31:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (473, 22, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (474, 23, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (475, 23, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (476, 23, 'invoiceDate', '开票日期', 'varchar(55)', 'String', 'invoiceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (477, 23, 'invoiceAmount', '开票金额', 'double', 'Double', 'invoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (478, 23, 'supplierTicketPoint', '供应商票点', 'double', 'Double', 'supplierTicketPoint', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (479, 23, 'supplierPointAmount', '供应商票点金额（开票金额*供应商票点）', 'double', 'Double', 'supplierPointAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (480, 23, 'Supplier', '供应商公司名称', 'varchar(120)', 'String', 'Supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (481, 23, 'SupplierID', '供应商ID', 'int(11)', 'Long', 'SupplierID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (482, 23, 'customer', '客户公司名称', 'varchar(120)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (483, 23, 'CustomerID', '客户ID', 'int(11)', 'Long', 'CustomerID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (484, 23, 'invoiceCompanyName', '票据单位名称', 'varchar(120)', 'String', 'invoiceCompanyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 12:31:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (485, 23, 'customerTicketPoint', '客户票点', 'double', 'Double', 'customerTicketPoint', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (486, 23, 'customerPointAmount', '票点金额（开票金额*客户票点）', 'double', 'Double', 'customerPointAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (487, 23, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (488, 23, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (489, 23, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (490, 23, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-29 12:31:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (491, 23, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-29 12:31:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (492, 23, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:31:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (493, 24, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (494, 24, 'invoiceDate', '开票日期', 'varchar(55)', 'String', 'invoiceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (495, 24, 'invoiceObject', '我方开票实体', 'varchar(55)', 'String', 'invoiceObject', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (496, 24, 'invoiceAmount', '开票金额', 'double', 'Double', 'invoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (497, 24, 'companyType', '公司类别（客户、供应商,其他）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (498, 24, 'companyName', '公司名称', 'varchar(120)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (499, 24, 'companyID', '公司ID', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (500, 24, 'invoiceCompanyName', '票据单位名称', 'varchar(120)', 'String', 'invoiceCompanyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:31:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (501, 24, 'ticketPoint', '票点', 'double', 'Double', 'ticketPoint', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:31:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (502, 24, 'ticketPointAmount', '票点金额（开票金额*票点）', 'double', 'Double', 'ticketPointAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (503, 24, 'isOrderTax', '是否订单对应票点', 'int(11)', 'Long', 'isOrderTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (504, 24, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:31:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (505, 24, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (506, 24, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (507, 24, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 15, 'admin', '2024-07-29 12:31:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (508, 24, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2024-07-29 12:31:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (509, 24, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (510, 25, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (511, 25, 'futuresNO', '借出款编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (512, 25, 'futuresMarginCompany', '期货保证金公司', 'varchar(80)', 'String', 'futuresMarginCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:31:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (513, 25, 'targetType', '对象类型(员工、客户、供应商、其他)', 'varchar(50)', 'String', 'targetType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-29 12:31:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (514, 25, 'target', '对象(员工姓名、公司名称)', 'varchar(50)', 'String', 'target', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (515, 25, 'moneyAmount', '保证金金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (516, 25, 'targetAcountsName', '对方账户', 'varchar(80)', 'String', 'targetAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 12:31:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (517, 25, 'targetBankNo', '对方账号', 'varchar(80)', 'String', 'targetBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:31:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (518, 25, 'targetBankName', '对方开户行', 'varchar(80)', 'String', 'targetBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 12:31:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (519, 25, 'selfAcountsName', '我方支付账户', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:31:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (520, 25, 'selfBankNo', '我方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:31:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (521, 25, 'selfBankName', '我方开户行', 'varchar(80)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (522, 25, 'futuresDate', '支付期货保证金时间', 'varchar(50)', 'String', 'futuresDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (523, 25, 'reason', '事由', 'varchar(200)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (524, 25, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (525, 25, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (526, 25, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (527, 25, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 18, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (528, 25, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2024-07-29 12:31:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (529, 25, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:31:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (530, 26, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:31:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (531, 26, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:31:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (532, 26, 'oilType', '加油卡类别（主卡、副卡）', 'varchar(15)', 'String', 'oilType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2024-07-29 12:31:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (533, 26, 'moneyAmount', '当前金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:31:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (534, 26, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:31:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (535, 26, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:31:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (536, 26, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:31:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (537, 26, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:31:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (538, 26, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2024-07-29 12:31:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (539, 26, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:31:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (540, 27, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (541, 27, 'oilMainCardNo', '主加油卡卡号', 'varchar(55)', 'String', 'oilMainCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (542, 27, 'oilSecondCardNo', '副加油卡卡号', 'varchar(55)', 'String', 'oilSecondCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (543, 27, 'rechargeMoney', '充值金额', 'double', 'Double', 'rechargeMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (544, 27, 'rechargeDate', '充值时间', 'varchar(50)', 'String', 'rechargeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (545, 27, 'rechargeName', '充值人员姓名', 'varchar(50)', 'String', 'rechargeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (546, 27, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (547, 27, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (548, 27, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (549, 27, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:32:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (550, 27, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2024-07-29 12:32:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (551, 27, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:32:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (552, 28, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (553, 28, 'bTripId', '出差编号UUID', 'varchar(50)', 'String', 'bTripId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (554, 28, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (555, 28, 'rechargeType', '充值类型（银行卡、现金）', 'varchar(55)', 'String', 'rechargeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (556, 28, 'rechargeMoney', '充值金额', 'double', 'Double', 'rechargeMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (557, 28, 'rechargeDate', '充值时间', 'varchar(50)', 'String', 'rechargeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (558, 28, 'acountsName', '银行开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (559, 28, 'bankNo', '银行账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (560, 28, 'rechargeName', '充值人员姓名', 'varchar(50)', 'String', 'rechargeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 12:32:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (561, 28, 'attachment', '充值附件', 'varchar(300)', 'String', 'attachment', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (562, 28, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (563, 28, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:32:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (564, 28, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:32:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (565, 28, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-29 12:32:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (566, 28, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2024-07-29 12:32:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (567, 28, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:32:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (568, 29, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (569, 29, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (570, 29, 'orderDate', '订单日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (571, 29, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (572, 29, 'supplierID', '供应商ID', 'int(11)', 'Long', 'supplierID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (573, 29, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (574, 29, 'customerID', '客户ID', 'int(11)', 'Long', 'customerID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (575, 29, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (576, 29, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 12:32:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (577, 29, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (578, 29, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (579, 29, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:32:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (580, 29, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:32:05', '', NULL);
INSERT INTO `gen_table_column` VALUES (581, 29, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (582, 29, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (583, 29, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (584, 29, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (585, 29, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (586, 29, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (587, 29, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (588, 29, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:32:06', '', NULL);
INSERT INTO `gen_table_column` VALUES (589, 29, 'isIncludeTaxSale', '销售是否含税', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:32:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (590, 29, 'payments', '总货款', 'double', 'Double', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:32:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (591, 29, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:32:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (592, 29, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:32:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (593, 29, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:32:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (594, 29, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 12:32:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (595, 29, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 12:32:07', '', NULL);
INSERT INTO `gen_table_column` VALUES (596, 29, 'freight', '总运费', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 12:32:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (597, 29, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 12:32:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (598, 29, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 12:32:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (599, 29, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 12:32:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (600, 29, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 12:32:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (601, 29, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 12:32:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (602, 29, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 12:32:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (603, 29, 'storeHouseID', '仓库ID', 'int(11)', 'Long', 'storeHouseID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (604, 29, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 37, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (605, 29, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (606, 29, 'logisticsProfit', '物流利润', 'double', 'Double', 'logisticsProfit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (607, 29, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (608, 29, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (609, 29, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (610, 29, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 12:32:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (611, 29, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 12:32:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (612, 29, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 12:32:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (613, 29, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 12:32:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (614, 29, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 47, 'admin', '2024-07-29 12:32:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (615, 29, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 48, 'admin', '2024-07-29 12:32:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (616, 30, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (617, 30, 'orderId', '原订单详情ID', 'int(11)', 'Long', 'orderId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (618, 30, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (619, 30, 'orderDate', '订单日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (620, 30, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (621, 30, 'supplierID', '供应商ID', 'int(11)', 'Long', 'supplierID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (622, 30, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (623, 30, 'customerID', '客户ID', 'int(11)', 'Long', 'customerID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (624, 30, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (625, 30, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:32:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (626, 30, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (627, 30, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:32:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (628, 30, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:32:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (629, 30, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:32:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (630, 30, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:32:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (631, 30, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:32:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (632, 30, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:32:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (633, 30, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:32:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (634, 30, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:32:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (635, 30, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:32:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (636, 30, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:32:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (637, 30, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:32:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (638, 30, 'isIncludeTaxSale', '销售是否含税', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (639, 30, 'payments', '总货款', 'double', 'Double', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (640, 30, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (641, 30, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (642, 30, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (643, 30, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (644, 30, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (645, 30, 'freight', '总运费', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 12:32:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (646, 30, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 12:32:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (647, 30, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 12:32:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (648, 30, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 12:32:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (649, 30, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 12:32:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (650, 30, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 12:32:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (651, 30, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 12:32:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (652, 30, 'storeHouseID', '仓库ID', 'int(11)', 'Long', 'storeHouseID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 12:32:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (653, 30, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 38, 'admin', '2024-07-29 12:32:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (654, 30, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 12:32:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (655, 30, 'logisticsProfit', '物流利润', 'double', 'Double', 'logisticsProfit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 12:32:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (656, 30, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 12:32:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (657, 30, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 12:32:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (658, 30, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 12:32:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (659, 30, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 12:32:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (660, 30, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 12:32:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (661, 30, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 12:32:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (662, 30, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-29 12:32:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (663, 30, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 48, 'admin', '2024-07-29 12:32:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (664, 30, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 49, 'admin', '2024-07-29 12:32:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (665, 31, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (666, 31, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (667, 31, 'freightType', '运费类型（ 陆运、海运）', 'varchar(55)', 'String', 'freightType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (668, 31, 'moneyAmount', '金额', 'varchar(55)', 'String', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (669, 31, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (670, 31, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (671, 31, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (672, 31, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (673, 31, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (674, 31, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:32:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (675, 31, 'content', '备注', 'varchar(150)', 'String', 'content', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 11, 'admin', '2024-07-29 12:32:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (676, 31, 'paymentState', '支付状态（ 已支付、 未支付、  申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:32:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (677, 31, 'driverName', '司机姓名', 'varchar(150)', 'String', 'driverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-29 12:32:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (678, 31, 'driverId', '司机ID', 'int(11)', 'Long', 'driverId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:32:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (679, 31, 'CarNo', '车牌号', 'varchar(20)', 'String', 'CarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:32:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (680, 31, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:32:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (681, 31, 'applyUserId', '申请人员ID', 'int(11)', 'Long', 'applyUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:32:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (682, 31, 'applyUserName', '申请人员姓名', 'varchar(50)', 'String', 'applyUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 18, 'admin', '2024-07-29 12:32:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (683, 31, 'applyDate', '申请日期', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:32:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (684, 31, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:32:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (685, 31, 'payUserId', '付款人员ID', 'int(11)', 'Long', 'payUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:32:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (686, 31, 'payUserName', '付款人员姓名', 'varchar(50)', 'String', 'payUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-29 12:32:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (687, 31, 'payDate', '付款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:32:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (688, 31, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:32:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (689, 31, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:32:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (690, 31, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 12:32:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (691, 31, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 12:32:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (692, 31, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 28, 'admin', '2024-07-29 12:32:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (693, 31, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 12:32:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (694, 32, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (695, 32, 'payNO', '付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (696, 32, 'fundsDate', '日期', 'varchar(50)', 'String', 'fundsDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (697, 32, 'payType', '支付类型', 'varchar(55)', 'String', 'payType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-29 12:32:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (698, 32, 'tableName', '对应的表名', 'varchar(55)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 12:32:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (699, 32, 'tID', '对应的表主键', 'varchar(55)', 'String', 'tID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (700, 32, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (701, 32, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (702, 32, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (703, 32, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (704, 32, 'selfBankID', '己方账号ID', 'varchar(150)', 'String', 'selfBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (705, 32, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (706, 32, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (707, 32, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (708, 32, 'paymentState', '支付状态（已支付、未支付、申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:32:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (709, 32, 'companyName', '对方公司', 'varchar(150)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-29 12:32:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (710, 32, 'companyId', '对方公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:32:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (711, 32, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 18, 'admin', '2024-07-29 12:32:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (712, 32, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:32:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (713, 32, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:32:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (714, 32, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:32:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (715, 32, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-29 12:32:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (716, 32, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 23, 'admin', '2024-07-29 12:32:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (717, 32, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:32:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (718, 33, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (719, 33, 'levelNo', '级别编码', 'varchar(20)', 'String', 'levelNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (720, 33, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 12:32:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (721, 33, 'categoryNo', '分类编号', 'int(11)', 'Long', 'categoryNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (722, 33, 'categoryName', '分类名称', 'varchar(80)', 'String', 'categoryName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 12:32:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (723, 33, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (724, 33, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (725, 33, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (726, 33, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (727, 33, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (728, 33, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (729, 33, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:32:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (730, 33, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 12:32:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (731, 33, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:32:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (732, 34, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (733, 34, 'receiveNO', '收款编号（UUID）', 'varchar(50)', 'String', 'receiveNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (734, 34, 'fundsDate', '日期', 'varchar(50)', 'String', 'fundsDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (735, 34, 'receiveType', '支付类型', 'varchar(55)', 'String', 'receiveType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (736, 34, 'tableName', '对应的表名', 'varchar(55)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (737, 34, 'tID', '对应的表主键', 'varchar(55)', 'String', 'tID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (738, 34, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (739, 34, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (740, 34, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (741, 34, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (742, 34, 'selfBankID', '己方账号ID', 'varchar(150)', 'String', 'selfBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (743, 34, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:32:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (744, 34, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:32:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (745, 34, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-29 12:32:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (746, 34, 'companyName', '对方公司', 'varchar(150)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 15, 'admin', '2024-07-29 12:32:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (747, 34, 'companyId', '对方公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:32:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (748, 34, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 17, 'admin', '2024-07-29 12:32:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (749, 34, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:32:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (750, 34, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:32:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (751, 34, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:32:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (752, 34, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-29 12:32:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (753, 34, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-29 12:32:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (754, 34, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:32:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (755, 35, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (756, 35, 'futuresNO', '借出款编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (757, 35, 'recoverNO', '还款编号（UUID）', 'varchar(50)', 'String', 'recoverNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (758, 35, 'moneyAmount', '收回金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (759, 35, 'recoverDate', '收回日期', 'varchar(50)', 'String', 'recoverDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (760, 35, 'acountsName', '收回账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (761, 35, 'bankNo', '收回账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (762, 35, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (763, 35, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (764, 35, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (765, 35, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 12:32:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (766, 35, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-29 12:32:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (767, 35, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:32:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (768, 36, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (769, 36, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (770, 36, 'payNO', '还款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (771, 36, 'moneyAmount', '还（本）金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (772, 36, 'ratio', '付息（金额）', 'double', 'Double', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (773, 36, 'payDate', '还款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (774, 36, 'acountsName', '还款账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 12:32:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (775, 36, 'bankNo', '还款账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (776, 36, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (777, 36, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (778, 36, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (779, 36, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 12:32:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (780, 36, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 12:32:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (781, 36, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:32:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (782, 37, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (783, 37, 'basicSocialInsurance', '社保缴纳基数', 'double', 'Double', 'basicSocialInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (784, 37, 'basicHousingFund', '公积金基数', 'double', 'Double', 'basicHousingFund', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (785, 37, 'depName', '部门', 'varchar(50)', 'String', 'depName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 12:32:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (786, 37, 'employeeName', '姓名', 'varchar(15)', 'String', 'employeeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 12:32:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (787, 37, 'employeeID', '人员编号', 'varchar(15)', 'String', 'employeeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (788, 37, 'insuranceDate', '缴费时间', 'varchar(50)', 'String', 'insuranceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (789, 37, 'isRecruiting', '是否增员（是，否）', 'varchar(10)', 'String', 'isRecruiting', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (790, 37, 'isDepletion', '是否减员', 'varchar(10)', 'String', 'isDepletion', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (791, 37, 'healthySecuritySelf', '基本医疗保险-个人', 'double', 'Double', 'healthySecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (792, 37, 'healthySecurityCompany', '基本医疗保险-公司', 'double', 'Double', 'healthySecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (793, 37, 'injuryInsurance', '工伤保险', 'double', 'Double', 'injuryInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (794, 37, 'unemploymentSecuritySelf', '失业保险-个人', 'double', 'Double', 'unemploymentSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (795, 37, 'unemploymentSecurityCompany', '失业保险-公司', 'double', 'Double', 'unemploymentSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (796, 37, 'retirementSecuritySelf', '养老保险-个人', 'double', 'Double', 'retirementSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 12:32:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (797, 37, 'retirementSecurityCompany', '养老保险-公司', 'double', 'Double', 'retirementSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 12:32:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (798, 37, 'largeMedicalSecuritySelf', '大额医保-个人', 'double', 'Double', 'largeMedicalSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 12:32:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (799, 37, 'largeMedicalSecurityCompany', '大额医保-公司', 'double', 'Double', 'largeMedicalSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 12:32:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (800, 37, 'housingFundSelf', '公积金-个人', 'double', 'Double', 'housingFundSelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 12:32:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (801, 37, 'housingFundCompany', '公积金-公司', 'double', 'Double', 'housingFundCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 12:32:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (802, 37, 'sumSelf', '个人缴费总额', 'double', 'Double', 'sumSelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 12:32:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (803, 37, 'sumCompany', '公司缴费总额', 'double', 'Double', 'sumCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 12:32:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (804, 37, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 12:32:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (805, 37, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 12:32:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (806, 37, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 12:32:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (807, 37, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 26, 'admin', '2024-07-29 12:32:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (808, 37, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 27, 'admin', '2024-07-29 12:32:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (809, 37, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 12:32:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (810, 38, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (811, 38, 'tableName', '表名', 'varchar(50)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 12:32:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (812, 38, 'modifyTime', '修改时间', 'varchar(80)', 'String', 'modifyTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (813, 38, 'reason', '修改原因', 'varchar(280)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (814, 38, 'tid', '修改表对应信息的id', 'int(11)', 'Long', 'tid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (815, 38, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (816, 38, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (817, 38, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:32:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (818, 39, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (819, 39, 'bTripId', '出差ID', 'int(11)', 'Long', 'bTripId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (820, 39, 'item', '报销项', 'varchar(50)', 'String', 'item', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 12:32:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (821, 39, 'itemCost', '费用', 'varchar(250)', 'String', 'itemCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (822, 39, 'comments', '备注', 'varchar(550)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2024-07-29 12:32:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (823, 39, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 12:32:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (824, 39, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (825, 39, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 12:32:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (826, 39, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2024-07-29 12:32:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (827, 39, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (828, 40, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 12:32:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (829, 40, 'companyId', '公司ID', 'varchar(80)', 'String', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (830, 40, 'tableName', '发生操作行为的表', 'varchar(80)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (831, 40, 'payNO', '发生操作行为的冲抵款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (832, 40, 'operateDate', '日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (833, 40, 'changeType', '变动类型（收入、支出）', 'varchar(15)', 'String', 'changeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (834, 40, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (835, 40, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (836, 40, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 12:32:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (837, 40, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 12:32:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (838, 40, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 12:32:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (839, 40, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-29 12:32:43', '', NULL);

-- ----------------------------
-- Table structure for goodsOrder
-- ----------------------------
DROP TABLE IF EXISTS `goodsOrder`;
CREATE TABLE `goodsOrder`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customerID` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `landCarID` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCarID` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
  `seaCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运车牌',
  `seaDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机电话',
  `seaDriverName` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机姓名',
  `checkUserId` int(11) NULL DEFAULT NULL COMMENT '审核人编号',
  `checkState` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核状态（已审核、未审核）',
  `invoiceState` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开票状态（未开票，部分开票，已开票）',
  `path` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件路径',
  `PaymentState` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '打款状态(申请中，已打款，未打款)',
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goodsOrder
-- ----------------------------

-- ----------------------------
-- Table structure for goodsOrder_back
-- ----------------------------
DROP TABLE IF EXISTS `goodsOrder_back`;
CREATE TABLE `goodsOrder_back`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goodsOrderID` int(11) NULL DEFAULT NULL COMMENT '原订单ID',
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customerID` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `landCarID` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCarID` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单表备份' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goodsOrder_back
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
  `height` double NULL DEFAULT 0 COMMENT '厚度',
  `length` double NULL DEFAULT 0 COMMENT '长度',
  `width` double NULL DEFAULT 0 COMMENT '宽度',
  `pieces` int(11) NULL DEFAULT NULL COMMENT '出厂片数',
  `piecesPerPack` int(11) NULL DEFAULT NULL COMMENT '每包片数',
  `packs` int(11) NULL DEFAULT NULL COMMENT '包数',
  `price` double NULL DEFAULT 0 COMMENT '出厂单价',
  `isIncludeTaxFactory` int(11) NULL DEFAULT NULL COMMENT '出厂是否含税',
  `sundryCost` double NULL DEFAULT 0 COMMENT '杂费',
  `paymentFactory` double NULL DEFAULT 0 COMMENT '出厂货款',
  `paymentUnload` double NULL DEFAULT 0 COMMENT '卸货价',
  `isIncludeTaxSale` int(11) NULL DEFAULT NULL COMMENT '销售是否含税（0不含税，1含税）',
  `payments` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '总货款',
  `landCarID` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCarID` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
  `seaCarNo` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运车牌',
  `seaDriverTel` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机电话',
  `seaDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机姓名',
  `erro` double NULL DEFAULT 0 COMMENT '误差',
  `tonnage` double NULL DEFAULT 0 COMMENT '吨位',
  `landFreightPrice` double NULL DEFAULT 0 COMMENT '陆运费单价',
  `landFreight` double NULL DEFAULT 0 COMMENT '陆运费',
  `seaFreight` double NULL DEFAULT 0 COMMENT '海运费',
  `freight` double NULL DEFAULT 0 COMMENT '运费（海运费+陆运费）',
  `otherCost` double NULL DEFAULT 0 COMMENT '其他费用',
  `profit` double NULL DEFAULT 0 COMMENT '利润',
  `profitNoTax` double NULL DEFAULT 0 COMMENT '不含税利润',
  `actualPieces` int(11) NULL DEFAULT NULL COMMENT '实际片数',
  `paymentsWithSundry` double NULL DEFAULT 0 COMMENT '总货款杂费',
  `additionalFees` double NULL DEFAULT 0 COMMENT '加费',
  `rebate` double NULL DEFAULT 0 COMMENT '返利金额',
  `customerCommission` double NULL DEFAULT 0 COMMENT '客户佣金',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  `showFlag` int(11) NULL DEFAULT 0 COMMENT '订单仓库选择时是否显示（ 显示， 不显示）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory
-- ----------------------------

-- ----------------------------
-- Table structure for inventory_back
-- ----------------------------
DROP TABLE IF EXISTS `inventory_back`;
CREATE TABLE `inventory_back`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventoryID` int(11) NULL DEFAULT 0 COMMENT '原货物存储ID',
  `storeHouseid` int(11) NULL DEFAULT 0 COMMENT '仓库ID',
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `storeDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '入库日期',
  `stockNumber` int(11) NULL DEFAULT 0 COMMENT '库存量（片数）',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplierId` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `levelID` int(11) NULL DEFAULT NULL COMMENT '级别编码',
  `levelName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别名称',
  `countingUnit` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `height` double NULL DEFAULT 0 COMMENT '厚度',
  `length` double NULL DEFAULT 0 COMMENT '长度',
  `width` double NULL DEFAULT 0 COMMENT '宽度',
  `pieces` int(11) NULL DEFAULT NULL COMMENT '出厂片数',
  `piecesPerPack` int(11) NULL DEFAULT NULL COMMENT '每包片数',
  `packs` int(11) NULL DEFAULT NULL COMMENT '包数',
  `price` double NULL DEFAULT 0 COMMENT '出厂单价',
  `isIncludeTaxFactory` int(11) NULL DEFAULT NULL COMMENT '出厂是否含税',
  `sundryCost` double NULL DEFAULT 0 COMMENT '杂费',
  `paymentFactory` double NULL DEFAULT 0 COMMENT '出厂货款',
  `paymentUnload` double NULL DEFAULT 0 COMMENT '卸货价',
  `isIncludeTaxSale` int(11) NULL DEFAULT NULL COMMENT '销售是否含税（0不含税，1含税）',
  `payments` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '总货款',
  `landCarID` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCarID` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
  `seaCarNo` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运车牌',
  `seaDriverTel` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机电话',
  `seaDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海运司机姓名',
  `erro` double NULL DEFAULT 0 COMMENT '误差',
  `tonnage` double NULL DEFAULT 0 COMMENT '吨位',
  `landFreightPrice` double NULL DEFAULT 0 COMMENT '陆运费单价',
  `landFreight` double NULL DEFAULT 0 COMMENT '陆运费',
  `seaFreight` double NULL DEFAULT 0 COMMENT '海运费',
  `freight` double NULL DEFAULT 0 COMMENT '运费（海运费+陆运费）',
  `otherCost` double NULL DEFAULT 0 COMMENT '其他费用',
  `profit` double NULL DEFAULT 0 COMMENT '利润',
  `profitNoTax` double NULL DEFAULT 0 COMMENT '不含税利润',
  `actualPieces` int(11) NULL DEFAULT NULL COMMENT '实际片数',
  `paymentsWithSundry` double NULL DEFAULT 0 COMMENT '总货款杂费',
  `additionalFees` double NULL DEFAULT 0 COMMENT '加费',
  `rebate` double NULL DEFAULT 0 COMMENT '返利金额',
  `customerCommission` double NULL DEFAULT 0 COMMENT '客户佣金',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  `showFlag` int(11) NULL DEFAULT 0 COMMENT '订单仓库选择时是否显示（ 显示， 不显示）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存备份' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory_back
-- ----------------------------

-- ----------------------------
-- Table structure for invoiceIn
-- ----------------------------
DROP TABLE IF EXISTS `invoiceIn`;
CREATE TABLE `invoiceIn`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoiceDate` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开票日期',
  `invoiceObject` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方开票实体',
  `invoiceAmount` double NULL DEFAULT 0 COMMENT '开票金额',
  `companyType` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司类别（客户、供应商,其他）',
  `companyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司名称',
  `companyID` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `invoiceCompanyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据单位名称',
  `ticketPoint` double NULL DEFAULT 0 COMMENT '票点',
  `ticketPointAmount` double NULL DEFAULT 0 COMMENT '票点金额（开票金额*票点）',
  `isOrderTax` int(11) NULL DEFAULT 0 COMMENT '是否订单对应票点',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '发票购入信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoiceIn
-- ----------------------------

-- ----------------------------
-- Table structure for invoiceOther
-- ----------------------------
DROP TABLE IF EXISTS `invoiceOther`;
CREATE TABLE `invoiceOther`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `invoiceDate` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开票日期',
  `invoiceAmount` double NULL DEFAULT 0 COMMENT '开票金额',
  `supplierTicketPoint` double NULL DEFAULT 0 COMMENT '供应商票点',
  `supplierPointAmount` double NULL DEFAULT 0 COMMENT '供应商票点金额（开票金额*供应商票点）',
  `Supplier` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商公司名称',
  `SupplierID` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `customer` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户公司名称',
  `CustomerID` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `invoiceCompanyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据单位名称',
  `customerTicketPoint` double NULL DEFAULT 0 COMMENT '客户票点',
  `customerPointAmount` double NULL DEFAULT 0 COMMENT '票点金额（开票金额*客户票点）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商家直接给客户开发票' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoiceOther
-- ----------------------------

-- ----------------------------
-- Table structure for invoiceOut
-- ----------------------------
DROP TABLE IF EXISTS `invoiceOut`;
CREATE TABLE `invoiceOut`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoiceDate` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开票日期',
  `invoiceObject` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方开票实体',
  `invoiceAmount` double NULL DEFAULT 0 COMMENT '开票金额',
  `companyType` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司类别（客户、供应商,其他）',
  `companyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司名称',
  `companyID` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `invoiceCompanyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据单位名称',
  `ticketPoint` double NULL DEFAULT 0 COMMENT '票点',
  `ticketPointAmount` double NULL DEFAULT 0 COMMENT '票点金额（开票金额*票点）',
  `isOrderTax` int(11) NULL DEFAULT 0 COMMENT '是否订单对应票点',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '发票卖出信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoiceOut
-- ----------------------------

-- ----------------------------
-- Table structure for lendMoney
-- ----------------------------
DROP TABLE IF EXISTS `lendMoney`;
CREATE TABLE `lendMoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `futuresNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '借出款编号（UUID）',
  `futuresMarginCompany` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '期货保证金公司',
  `targetType` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对象类型(员工、客户、供应商、其他)',
  `target` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对象(员工姓名、公司名称)',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '保证金金额',
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
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '向外部借出款信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lendMoney
-- ----------------------------

-- ----------------------------
-- Table structure for oilCard
-- ----------------------------
DROP TABLE IF EXISTS `oilCard`;
CREATE TABLE `oilCard`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oilCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡卡号',
  `oilType` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡类别（主卡、副卡）',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '当前金额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加油卡信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oilCard
-- ----------------------------
INSERT INTO `oilCard` VALUES (1, NULL, NULL, 300, NULL, 'Tue Jul 30 16:46:02 CST 2024', 1, NULL, '2024-07-30 16:46:15', 1);
INSERT INTO `oilCard` VALUES (2, NULL, NULL, 600, NULL, 'Tue Jul 30 16:56:05 CST 2024', 1, NULL, '2024-07-30 16:56:26', 1);
INSERT INTO `oilCard` VALUES (3, NULL, NULL, 0, NULL, 'Tue Jul 30 17:08:17 CST 2024', 1, NULL, NULL, 1);
INSERT INTO `oilCard` VALUES (4, NULL, NULL, 0, NULL, 'Tue Jul 30 17:08:33 CST 2024', 1, NULL, NULL, 1);
INSERT INTO `oilCard` VALUES (5, NULL, NULL, 0, NULL, 'Tue Jul 30 17:08:36 CST 2024', 1, NULL, NULL, 1);
INSERT INTO `oilCard` VALUES (6, NULL, NULL, 0, NULL, 'Tue Jul 30 17:08:58 CST 2024', 1, NULL, NULL, 1);

-- ----------------------------
-- Table structure for oilCardFundTransfer
-- ----------------------------
DROP TABLE IF EXISTS `oilCardFundTransfer`;
CREATE TABLE `oilCardFundTransfer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oilMainCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主加油卡卡号',
  `oilSecondCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '副加油卡卡号',
  `rechargeMoney` double NULL DEFAULT 0 COMMENT '充值金额',
  `rechargeDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值时间',
  `rechargeName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值人员姓名',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加油卡圈存' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oilCardFundTransfer
-- ----------------------------

-- ----------------------------
-- Table structure for oilRecharge
-- ----------------------------
DROP TABLE IF EXISTS `oilRecharge`;
CREATE TABLE `oilRecharge`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bTripId` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出差编号UUID',
  `oilCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡卡号',
  `rechargeType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值类型（银行卡、现金）',
  `rechargeMoney` double NULL DEFAULT 0 COMMENT '充值金额',
  `rechargeDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值时间',
  `acountsName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '银行开户名',
  `bankNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '银行账号',
  `rechargeName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值人员姓名',
  `attachment` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '充值附件',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加油卡充值信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oilRecharge
-- ----------------------------

-- ----------------------------
-- Table structure for orderDetail
-- ----------------------------
DROP TABLE IF EXISTS `orderDetail`;
CREATE TABLE `orderDetail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单日期',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplierID` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customerID` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `levelID` int(11) NULL DEFAULT NULL COMMENT '级别编码',
  `levelName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别名称',
  `countingUnit` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `height` double NULL DEFAULT 0 COMMENT '厚度',
  `length` double NULL DEFAULT 0 COMMENT '长度',
  `width` double NULL DEFAULT 0 COMMENT '宽度',
  `pieces` int(11) NULL DEFAULT NULL COMMENT '出厂片数',
  `piecesPerPack` int(11) NULL DEFAULT NULL COMMENT '每包片数',
  `packs` int(11) NULL DEFAULT NULL COMMENT '包数',
  `price` double NULL DEFAULT NULL COMMENT '出厂单价',
  `isIncludeTaxFactory` int(11) NULL DEFAULT NULL COMMENT '出厂是否含税',
  `sundryCost` double NULL DEFAULT NULL COMMENT '杂费',
  `paymentFactory` double NULL DEFAULT NULL COMMENT '出厂货款',
  `paymentUnload` double NULL DEFAULT NULL COMMENT '卸货价',
  `isIncludeTaxSale` int(11) NULL DEFAULT NULL COMMENT '销售是否含税',
  `payments` double NULL DEFAULT NULL COMMENT '总货款',
  `erro` double NULL DEFAULT 0 COMMENT '误差',
  `tonnage` double NULL DEFAULT 0 COMMENT '吨位',
  `landFreightPrice` double NULL DEFAULT 0 COMMENT '陆运费单价',
  `landFreight` double NULL DEFAULT 0 COMMENT '陆运费',
  `seaFreight` double NULL DEFAULT 0 COMMENT '海运费',
  `freight` double NULL DEFAULT 0 COMMENT '总运费',
  `otherCost` double NULL DEFAULT NULL COMMENT '其他费用',
  `profit` double NULL DEFAULT NULL COMMENT '利润',
  `profitNoTax` double NULL DEFAULT NULL COMMENT '不含税利润',
  `actualPieces` int(11) NULL DEFAULT NULL COMMENT '实际片数',
  `paymentsWithSundry` double NULL DEFAULT 0 COMMENT '总货款杂费',
  `additionalFees` double NULL DEFAULT 0 COMMENT '加费',
  `storeHouseID` int(11) NULL DEFAULT 0 COMMENT '仓库ID',
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `storeID` int(11) NULL DEFAULT 0 COMMENT '仓库存储的货物ID',
  `logisticsProfit` double NULL DEFAULT 0 COMMENT '物流利润',
  `customerCommission` double NULL DEFAULT 0 COMMENT '客户佣金',
  `isAdjusted` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否被调整单（ 是  否）',
  `adjustDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调整日期',
  `cancelFlag` int(11) NULL DEFAULT 0 COMMENT '作废标记',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderDetail
-- ----------------------------

-- ----------------------------
-- Table structure for orderDetail_back
-- ----------------------------
DROP TABLE IF EXISTS `orderDetail_back`;
CREATE TABLE `orderDetail_back`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NULL DEFAULT NULL COMMENT '原订单详情ID',
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单日期',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplierID` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customerID` int(11) NULL DEFAULT NULL COMMENT '客户ID',
  `levelID` int(11) NULL DEFAULT NULL COMMENT '级别编码',
  `levelName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别名称',
  `countingUnit` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `height` double NULL DEFAULT 0 COMMENT '厚度',
  `length` double NULL DEFAULT 0 COMMENT '长度',
  `width` double NULL DEFAULT 0 COMMENT '宽度',
  `pieces` int(11) NULL DEFAULT NULL COMMENT '出厂片数',
  `piecesPerPack` int(11) NULL DEFAULT NULL COMMENT '每包片数',
  `packs` int(11) NULL DEFAULT NULL COMMENT '包数',
  `price` double NULL DEFAULT NULL COMMENT '出厂单价',
  `isIncludeTaxFactory` int(11) NULL DEFAULT NULL COMMENT '出厂是否含税',
  `sundryCost` double NULL DEFAULT NULL COMMENT '杂费',
  `paymentFactory` double NULL DEFAULT NULL COMMENT '出厂货款',
  `paymentUnload` double NULL DEFAULT NULL COMMENT '卸货价',
  `isIncludeTaxSale` int(11) NULL DEFAULT NULL COMMENT '销售是否含税',
  `payments` double NULL DEFAULT NULL COMMENT '总货款',
  `erro` double NULL DEFAULT 0 COMMENT '误差',
  `tonnage` double NULL DEFAULT 0 COMMENT '吨位',
  `landFreightPrice` double NULL DEFAULT 0 COMMENT '陆运费单价',
  `landFreight` double NULL DEFAULT 0 COMMENT '陆运费',
  `seaFreight` double NULL DEFAULT 0 COMMENT '海运费',
  `freight` double NULL DEFAULT 0 COMMENT '总运费',
  `otherCost` double NULL DEFAULT NULL COMMENT '其他费用',
  `profit` double NULL DEFAULT NULL COMMENT '利润',
  `profitNoTax` double NULL DEFAULT NULL COMMENT '不含税利润',
  `actualPieces` int(11) NULL DEFAULT NULL COMMENT '实际片数',
  `paymentsWithSundry` double NULL DEFAULT 0 COMMENT '总货款杂费',
  `additionalFees` double NULL DEFAULT 0 COMMENT '加费',
  `storeHouseID` int(11) NULL DEFAULT 0 COMMENT '仓库ID',
  `storeHouseName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `storeID` int(11) NULL DEFAULT 0 COMMENT '仓库存储的货物ID',
  `logisticsProfit` double NULL DEFAULT 0 COMMENT '物流利润',
  `customerCommission` double NULL DEFAULT 0 COMMENT '客户佣金',
  `isAdjusted` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否被调整单（ 是  否）',
  `adjustDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '调整日期',
  `cancelFlag` int(11) NULL DEFAULT 0 COMMENT '作废标记',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单详情备份' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderDetail_back
-- ----------------------------

-- ----------------------------
-- Table structure for orderFreight
-- ----------------------------
DROP TABLE IF EXISTS `orderFreight`;
CREATE TABLE `orderFreight`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `freightType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运费类型（ 陆运、海运）',
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
  `applyUserId` int(11) NULL DEFAULT NULL COMMENT '申请人员ID',
  `applyUserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人员姓名',
  `applyDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请日期',
  `isedit` int(11) NULL DEFAULT 1 COMMENT '是否可编辑',
  `payUserId` int(11) NULL DEFAULT NULL COMMENT '付款人员ID',
  `payUserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款人员姓名',
  `payDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款日期',
  `cancelFlag` int(11) NULL DEFAULT 0 COMMENT '作废标记',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单运费' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderFreight
-- ----------------------------

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款编号（UUID）',
  `fundsDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `payType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付类型',
  `tableName` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应的表名',
  `tID` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应的表主键',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `selfAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方户名',
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `selfBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方开户行',
  `selfBankID` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号ID',
  `otherAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方户名',
  `otherBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号',
  `otherBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方开户行',
  `paymentState` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付状态（已支付、未支付、申请中）',
  `companyName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司',
  `companyId` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '对方公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '付款信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment
-- ----------------------------

-- ----------------------------
-- Table structure for productLevel
-- ----------------------------
DROP TABLE IF EXISTS `productLevel`;
CREATE TABLE `productLevel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `levelNo` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别编码',
  `levelName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '级别名称',
  `categoryNo` int(11) NULL DEFAULT 0 COMMENT '分类编号',
  `categoryName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `height` double NULL DEFAULT 0 COMMENT '厚度',
  `length` double NULL DEFAULT 0 COMMENT '长度',
  `width` double NULL DEFAULT 0 COMMENT '宽度',
  `tonnage` double NULL DEFAULT 0 COMMENT '吨位',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `only_one`(`levelNo`) USING BTREE COMMENT '唯一索引，保证级别编号不重复'
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品级别' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of productLevel
-- ----------------------------
INSERT INTO `productLevel` VALUES (1, '123123', '123123', 123123, '123123', 1, 1, 1, 1, NULL, NULL, NULL, NULL, 1);
INSERT INTO `productLevel` VALUES (3, '123122', '123123', 123, '123', 123, 123, 123, 123, NULL, NULL, NULL, NULL, 1);
INSERT INTO `productLevel` VALUES (4, 'L001', '高级', 101, '玻璃安强021', 10.5, 200, 100, 1.5, NULL, NULL, NULL, NULL, 0);

-- ----------------------------
-- Table structure for receiveMoney
-- ----------------------------
DROP TABLE IF EXISTS `receiveMoney`;
CREATE TABLE `receiveMoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `receiveNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收款编号（UUID）',
  `fundsDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `receiveType` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付类型',
  `tableName` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应的表名',
  `tID` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应的表主键',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `selfAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方户名',
  `selfBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号',
  `selfBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方开户行',
  `selfBankID` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '己方账号ID',
  `otherAcountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方户名',
  `otherBankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方账号',
  `otherBankName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方开户行',
  `companyName` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司',
  `companyId` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '对方公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '收款信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of receiveMoney
-- ----------------------------

-- ----------------------------
-- Table structure for recoverMoney
-- ----------------------------
DROP TABLE IF EXISTS `recoverMoney`;
CREATE TABLE `recoverMoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `futuresNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '借出款编号（UUID）',
  `recoverNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款编号（UUID）',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '收回金额',
  `recoverDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收回日期',
  `acountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收回账户',
  `bankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收回账号',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '借出款收回信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recoverMoney
-- ----------------------------

-- ----------------------------
-- Table structure for repayment
-- ----------------------------
DROP TABLE IF EXISTS `repayment`;
CREATE TABLE `repayment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `loanNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贷款编号（UUID）',
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款编号（UUID）',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '还（本）金额',
  `ratio` double NULL DEFAULT 0 COMMENT '付息（金额）',
  `payDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款日期',
  `acountsName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款账户',
  `bankNo` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还款账号',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '贷款还款信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of repayment
-- ----------------------------

-- ----------------------------
-- Table structure for socialInsurance
-- ----------------------------
DROP TABLE IF EXISTS `socialInsurance`;
CREATE TABLE `socialInsurance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `basicSocialInsurance` double NULL DEFAULT 0 COMMENT '社保缴纳基数',
  `basicHousingFund` double NULL DEFAULT 0 COMMENT '公积金基数',
  `depName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `employeeName` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `employeeID` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '人员编号',
  `insuranceDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缴费时间',
  `isRecruiting` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否增员（是，否）',
  `isDepletion` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否减员',
  `healthySecuritySelf` double NULL DEFAULT 0 COMMENT '基本医疗保险-个人',
  `healthySecurityCompany` double NULL DEFAULT 0 COMMENT '基本医疗保险-公司',
  `injuryInsurance` double NULL DEFAULT 0 COMMENT '工伤保险',
  `unemploymentSecuritySelf` double NULL DEFAULT 0 COMMENT '失业保险-个人',
  `unemploymentSecurityCompany` double NULL DEFAULT 0 COMMENT '失业保险-公司',
  `retirementSecuritySelf` double NULL DEFAULT 0 COMMENT '养老保险-个人',
  `retirementSecurityCompany` double NULL DEFAULT 0 COMMENT '养老保险-公司',
  `largeMedicalSecuritySelf` double NULL DEFAULT 0 COMMENT '大额医保-个人',
  `largeMedicalSecurityCompany` double NULL DEFAULT 0 COMMENT '大额医保-公司',
  `housingFundSelf` double NULL DEFAULT 0 COMMENT '公积金-个人',
  `housingFundCompany` double NULL DEFAULT 0 COMMENT '公积金-公司',
  `sumSelf` double NULL DEFAULT 0 COMMENT '个人缴费总额',
  `sumCompany` double NULL DEFAULT 0 COMMENT '公司缴费总额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '社保基金' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of socialInsurance
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
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-07-29 12:13:00', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-07-29 12:13:00', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-07-29 12:13:00', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-07-29 12:13:00', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-07-29 12:13:00', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-07-29 12:13:00', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

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
INSERT INTO `sys_dept` VALUES (100, 0, '0', 'DZU科技', 0, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 0, '鲁A济南车', 'aaaaaa', 'order_cars', NULL, 'default', 'N', '0', 'admin', '2024-07-30 10:47:55', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 0, '鲁B青岛的~', 'BBBB', 'order_cars', NULL, 'default', 'N', '0', 'admin', '2024-07-30 10:48:08', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 0, '鲁C淄博', 'ccccc', 'order_cars', NULL, 'default', 'N', '0', 'admin', '2024-07-30 10:48:18', '', NULL, NULL);

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
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '公司车辆', 'order_cars', '0', 'admin', '2024-07-30 10:21:32', 'admin', '2024-07-30 10:46:31', '公司车辆列表');
INSERT INTO `sys_dict_type` VALUES (101, '公司加油卡信息', 'order_oilcard', '0', 'admin', '2024-07-30 10:23:02', '', NULL, '公司加油卡信息');
INSERT INTO `sys_dict_type` VALUES (102, '产品分类信息', 'order_product_categories', '0', 'admin', '2024-07-30 10:24:20', 'admin', '2024-07-30 10:35:05', '产品分类信息');
INSERT INTO `sys_dict_type` VALUES (103, '科目', 'order_ohtertype', '0', 'admin', '2024-07-30 15:50:19', '', NULL, '自定义科目信息');

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
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-07-29 12:13:00', '', NULL, '');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

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
  INDEX `idx_sys_logininfor_s`(`STATUS`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 279 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-29 12:15:47');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-29 12:15:49');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-29 12:16:00');
INSERT INTO `sys_logininfor` VALUES (103, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 12:20:10');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 12:23:25');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 12:23:34');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome', 'Windows 10', '0', '登录成功', '2024-07-29 12:46:41');
INSERT INTO `sys_logininfor` VALUES (107, 'adminW', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-29 12:49:12');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 12:49:25');
INSERT INTO `sys_logininfor` VALUES (109, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 12:51:42');
INSERT INTO `sys_logininfor` VALUES (110, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 12:53:25');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 12:55:46');
INSERT INTO `sys_logininfor` VALUES (112, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 13:06:04');
INSERT INTO `sys_logininfor` VALUES (113, 'Admin2', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-29 13:28:37');
INSERT INTO `sys_logininfor` VALUES (114, 'Admin2', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-29 13:28:43');
INSERT INTO `sys_logininfor` VALUES (115, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 13:35:16');
INSERT INTO `sys_logininfor` VALUES (116, 'Admin2', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-29 13:38:09');
INSERT INTO `sys_logininfor` VALUES (117, 'AdminW', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-29 13:38:16');
INSERT INTO `sys_logininfor` VALUES (118, 'AdminW', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-29 13:38:22');
INSERT INTO `sys_logininfor` VALUES (119, 'AdminW', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '1', '用户不存在/密码错误', '2024-07-29 13:39:57');
INSERT INTO `sys_logininfor` VALUES (120, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 13:40:39');
INSERT INTO `sys_logininfor` VALUES (121, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 14:00:48');
INSERT INTO `sys_logininfor` VALUES (122, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 14:26:06');
INSERT INTO `sys_logininfor` VALUES (123, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 14:26:14');
INSERT INTO `sys_logininfor` VALUES (124, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 14:29:47');
INSERT INTO `sys_logininfor` VALUES (125, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 14:31:22');
INSERT INTO `sys_logininfor` VALUES (126, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 15:15:49');
INSERT INTO `sys_logininfor` VALUES (127, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 15:16:16');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 15:16:32');
INSERT INTO `sys_logininfor` VALUES (129, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 15:20:19');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 16:51:34');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 16:52:17');
INSERT INTO `sys_logininfor` VALUES (132, 'adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-29 17:34:48');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-29 17:35:44');
INSERT INTO `sys_logininfor` VALUES (134, 'adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-29 17:45:55');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 17:58:18');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 18:06:15');
INSERT INTO `sys_logininfor` VALUES (137, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 18:31:44');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-29 18:36:39');
INSERT INTO `sys_logininfor` VALUES (139, 'adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-29 19:21:53');
INSERT INTO `sys_logininfor` VALUES (140, 'adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-29 19:24:02');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 19:37:08');
INSERT INTO `sys_logininfor` VALUES (142, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:43:59');
INSERT INTO `sys_logininfor` VALUES (143, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:45:46');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 19:45:50');
INSERT INTO `sys_logininfor` VALUES (145, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:48:13');
INSERT INTO `sys_logininfor` VALUES (146, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:50:12');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:52:22');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:58:12');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:58:22');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 19:59:55');
INSERT INTO `sys_logininfor` VALUES (151, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 20:07:44');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 20:08:00');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:08:06');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 20:10:31');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:10:35');
INSERT INTO `sys_logininfor` VALUES (156, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:14:50');
INSERT INTO `sys_logininfor` VALUES (157, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 20:16:28');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:26:52');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:28:40');
INSERT INTO `sys_logininfor` VALUES (160, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 20:30:46');
INSERT INTO `sys_logininfor` VALUES (161, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 20:30:47');
INSERT INTO `sys_logininfor` VALUES (162, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 20:30:48');
INSERT INTO `sys_logininfor` VALUES (163, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:30:54');
INSERT INTO `sys_logininfor` VALUES (164, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 20:31:01');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:37:58');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 20:38:09');
INSERT INTO `sys_logininfor` VALUES (167, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-29 20:54:37');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 21:45:22');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 21:45:26');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 21:46:07');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 21:46:08');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-29 22:11:55');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 22:11:59');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 07:02:36');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 08:07:32');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 08:30:44');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 08:42:58');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Firefox 11', 'Windows 10', '0', '登录成功', '2024-07-30 08:54:54');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Firefox 11', 'Windows 10', '0', '退出成功', '2024-07-30 09:04:24');
INSERT INTO `sys_logininfor` VALUES (180, 'common', '127.0.0.1', '内网IP', 'Firefox 11', 'Windows 10', '0', '登录成功', '2024-07-30 09:04:33');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:12:14');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 09:13:54');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:21:57');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:24:12');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:46:24');
INSERT INTO `sys_logininfor` VALUES (186, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-30 09:48:39');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:49:30');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:51:44');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 09:52:10');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:52:27');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:52:36');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 09:52:43');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 10:04:37');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:04:41');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 10:18:26');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:18:34');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 10:18:42');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:18:55');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:20:21');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 10:24:33');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:24:58');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:26:29');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 10:26:35');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:26:44');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:34:25');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:34:57');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:41:38');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 10:45:01');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 10:45:12');
INSERT INTO `sys_logininfor` VALUES (210, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 10:48:42');
INSERT INTO `sys_logininfor` VALUES (211, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 11:05:26');
INSERT INTO `sys_logininfor` VALUES (212, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 11:06:00');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 11:27:07');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 11:34:44');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 11:34:48');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 11:36:01');
INSERT INTO `sys_logininfor` VALUES (217, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 11:36:07');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 11:43:21');
INSERT INTO `sys_logininfor` VALUES (219, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 11:43:32');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 11:55:21');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 12:19:35');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 12:24:03');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 13:43:35');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 13:47:47');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 13:55:43');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 13:55:55');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 14:47:17');
INSERT INTO `sys_logininfor` VALUES (228, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-30 14:53:55');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 15:22:58');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 15:29:19');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 15:48:01');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 15:49:48');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 15:52:43');
INSERT INTO `sys_logininfor` VALUES (234, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-30 16:15:38');
INSERT INTO `sys_logininfor` VALUES (235, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-30 16:16:24');
INSERT INTO `sys_logininfor` VALUES (236, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-30 16:16:31');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:26:01');
INSERT INTO `sys_logininfor` VALUES (238, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:27:34');
INSERT INTO `sys_logininfor` VALUES (239, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:35:46');
INSERT INTO `sys_logininfor` VALUES (240, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:36:12');
INSERT INTO `sys_logininfor` VALUES (241, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:36:43');
INSERT INTO `sys_logininfor` VALUES (242, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:39:23');
INSERT INTO `sys_logininfor` VALUES (243, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:40:11');
INSERT INTO `sys_logininfor` VALUES (244, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:40:30');
INSERT INTO `sys_logininfor` VALUES (245, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:41:22');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 16:44:26');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 16:54:21');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 17:18:24');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 17:25:27');
INSERT INTO `sys_logininfor` VALUES (250, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 17:25:50');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 17:27:48');
INSERT INTO `sys_logininfor` VALUES (252, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 17:31:25');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 17:45:05');
INSERT INTO `sys_logininfor` VALUES (254, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:07:49');
INSERT INTO `sys_logininfor` VALUES (255, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:16:32');
INSERT INTO `sys_logininfor` VALUES (256, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:17:00');
INSERT INTO `sys_logininfor` VALUES (257, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:20:29');
INSERT INTO `sys_logininfor` VALUES (258, 'Admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:20:58');
INSERT INTO `sys_logininfor` VALUES (259, 'admin123', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-30 19:21:46');
INSERT INTO `sys_logininfor` VALUES (260, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-30 19:22:16');
INSERT INTO `sys_logininfor` VALUES (261, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 19:22:29');
INSERT INTO `sys_logininfor` VALUES (262, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:22:35');
INSERT INTO `sys_logininfor` VALUES (263, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:22:36');
INSERT INTO `sys_logininfor` VALUES (264, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:22:52');
INSERT INTO `sys_logininfor` VALUES (265, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:24:16');
INSERT INTO `sys_logininfor` VALUES (266, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:27:25');
INSERT INTO `sys_logininfor` VALUES (267, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 19:30:51');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:35:07');
INSERT INTO `sys_logininfor` VALUES (269, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 19:35:57');
INSERT INTO `sys_logininfor` VALUES (270, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 20:01:56');
INSERT INTO `sys_logininfor` VALUES (271, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-30 20:31:21');
INSERT INTO `sys_logininfor` VALUES (272, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 20:31:34');
INSERT INTO `sys_logininfor` VALUES (273, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 20:34:43');
INSERT INTO `sys_logininfor` VALUES (274, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 20:36:55');
INSERT INTO `sys_logininfor` VALUES (275, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-30 20:50:55');
INSERT INTO `sys_logininfor` VALUES (276, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-30 21:02:19');
INSERT INTO `sys_logininfor` VALUES (277, 'admin', '127.0.0.1', '内网IP', 'Chrome 10', 'Windows 10', '0', '登录成功', '2024-07-30 21:50:52');
INSERT INTO `sys_logininfor` VALUES (278, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-30 22:00:19');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2273 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-07-29 12:13:00', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-07-29 12:13:00', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-07-29 12:13:00', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, 'DZU官网', 0, 4, 'http://dzu.vip', NULL, '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-07-29 12:13:00', '', NULL, 'DZU官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-07-29 12:13:00', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-07-29 12:13:00', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-07-29 12:13:00', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-07-29 12:13:00', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-07-29 12:13:00', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-07-29 12:13:00', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-07-29 12:13:00', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-07-29 12:13:00', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-07-29 12:13:00', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-07-29 12:13:00', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-07-29 12:13:00', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-07-29 12:13:00', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-07-29 12:13:00', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-07-29 12:13:00', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-07-29 12:13:00', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-07-29 12:13:00', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-07-29 12:13:00', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-07-29 12:13:00', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-07-29 12:13:00', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-07-29 12:13:00', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-07-29 12:13:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '订单备份信息', 3, 1, 'back', 'system/back/index', NULL, 1, 0, 'C', '0', '0', 'system:back:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '订单备份信息菜单');
INSERT INTO `sys_menu` VALUES (2001, '订单备份信息查询', 2000, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2002, '订单备份信息新增', 2000, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '订单备份信息修改', 2000, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '订单备份信息删除', 2000, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '订单备份信息导出', 2000, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '平账', 3, 1, 'balanceaccounts', 'system/balanceaccounts/index', NULL, 1, 0, 'C', '0', '0', 'system:balanceaccounts:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '平账菜单');
INSERT INTO `sys_menu` VALUES (2007, '平账查询', 2006, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '平账新增', 2006, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '平账修改', 2006, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '平账删除', 2006, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '平账导出', 2006, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '商业票据、银行承兑', 3, 1, 'bankacceptance', 'system/bankacceptance/index', NULL, 1, 0, 'C', '0', '0', 'system:bankacceptance:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '商业票据、银行承兑菜单');
INSERT INTO `sys_menu` VALUES (2013, '商业票据、银行承兑查询', 2012, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '商业票据、银行承兑新增', 2012, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '商业票据、银行承兑修改', 2012, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '商业票据、银行承兑删除', 2012, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '商业票据、银行承兑导出', 2012, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '银行卡资金变动', 3, 1, 'bankaccountchange', 'system/bankaccountchange/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccountchange:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '银行卡资金变动菜单');
INSERT INTO `sys_menu` VALUES (2019, '银行卡资金变动查询', 2018, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '银行卡资金变动新增', 2018, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '银行卡资金变动修改', 2018, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '银行卡资金变动删除', 2018, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '银行卡资金变动导出', 2018, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '银行卡管理', 2192, 1, 'bankaccount', 'system/bankaccount/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccount:list', '#', 'admin', '2024-07-29 12:37:25', 'admin', '2024-07-29 18:13:24', '银行卡管理菜单');
INSERT INTO `sys_menu` VALUES (2025, '银行卡管理查询', 2024, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '银行卡管理新增', 2024, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '银行卡管理修改', 2024, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '银行卡管理删除', 2024, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '银行卡管理导出', 2024, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '从外部借入款、贷款', 3, 1, 'borrowedmoney', 'system/borrowedmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:borrowedmoney:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '从外部借入款、贷款菜单');
INSERT INTO `sys_menu` VALUES (2031, '从外部借入款、贷款查询', 2030, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '从外部借入款、贷款新增', 2030, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '从外部借入款、贷款修改', 2030, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '从外部借入款、贷款删除', 2030, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '从外部借入款、贷款导出', 2030, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '出差登记', 3, 1, 'businesstrip', 'system/businesstrip/index', NULL, 1, 0, 'C', '0', '0', 'system:businesstrip:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '出差登记菜单');
INSERT INTO `sys_menu` VALUES (2037, '出差登记查询', 2036, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '出差登记新增', 2036, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '出差登记修改', 2036, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '出差登记删除', 2036, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '出差登记导出', 2036, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '车辆派出管理', 3, 1, 'carapply', 'system/carapply/index', NULL, 1, 0, 'C', '0', '0', 'system:carapply:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '车辆派出管理菜单');
INSERT INTO `sys_menu` VALUES (2043, '车辆派出管理查询', 2042, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '车辆派出管理新增', 2042, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '车辆派出管理修改', 2042, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '车辆派出管理删除', 2042, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '车辆派出管理导出', 2042, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '车辆管理', 3, 1, 'cars', 'system/cars/index', NULL, 1, 0, 'C', '0', '0', 'system:cars:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '车辆管理菜单');
INSERT INTO `sys_menu` VALUES (2049, '车辆管理查询', 2048, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '车辆管理新增', 2048, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '车辆管理修改', 2048, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '车辆管理删除', 2048, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '车辆管理导出', 2048, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '客户管理', 2192, 1, 'company', 'system/company/index', NULL, 1, 0, 'C', '0', '0', 'system:company:list', '#', 'admin', '2024-07-29 12:37:25', 'admin', '2024-07-29 18:12:03', '客户管理菜单');
INSERT INTO `sys_menu` VALUES (2055, '客户管理查询', 2054, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '客户管理新增', 2054, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '客户管理修改', 2054, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '客户管理删除', 2054, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '客户管理导出', 2054, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '走访记录', 3, 1, 'customervisit', 'system/customervisit/index', NULL, 1, 0, 'C', '0', '0', 'system:customervisit:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '走访记录菜单');
INSERT INTO `sys_menu` VALUES (2061, '走访记录查询', 2060, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '走访记录新增', 2060, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '走访记录修改', 2060, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '走访记录删除', 2060, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '走访记录导出', 2060, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2066, '出库', 3, 1, 'exwarehouse', 'system/exwarehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:exwarehouse:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '出库菜单');
INSERT INTO `sys_menu` VALUES (2067, '出库查询', 2066, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '出库新增', 2066, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '出库修改', 2066, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '出库删除', 2066, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '出库导出', 2066, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '固定资产', 3, 1, 'fixedassets', 'system/fixedassets/index', NULL, 1, 0, 'C', '0', '0', 'system:fixedassets:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '固定资产菜单');
INSERT INTO `sys_menu` VALUES (2073, '固定资产查询', 2072, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2074, '固定资产新增', 2072, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2075, '固定资产修改', 2072, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2076, '固定资产删除', 2072, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2077, '固定资产导出', 2072, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2078, '车队管理', 2192, 1, 'fleet', 'system/fleet/index', NULL, 1, 0, 'C', '0', '0', 'system:fleet:list', '#', 'admin', '2024-07-29 12:37:25', 'admin', '2024-07-30 16:54:50', '车队管理菜单');
INSERT INTO `sys_menu` VALUES (2079, '车队管理查询', 2078, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2080, '车队管理新增', 2078, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2081, '车队管理修改', 2078, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2082, '车队管理删除', 2078, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2083, '车队管理导出', 2078, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2084, '订单', 3, 1, 'goodsorder', 'system/goodsorder/index', NULL, 1, 0, 'C', '0', '0', 'system:goodsorder:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '订单菜单');
INSERT INTO `sys_menu` VALUES (2085, '订单查询', 2084, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2086, '订单新增', 2084, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2087, '订单修改', 2084, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2088, '订单删除', 2084, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2089, '订单导出', 2084, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2090, '货物入库', 3, 1, 'inventory', 'system/inventory/index', NULL, 1, 0, 'C', '0', '0', 'system:inventory:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '货物入库菜单');
INSERT INTO `sys_menu` VALUES (2091, '货物入库查询', 2090, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2092, '货物入库新增', 2090, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2093, '货物入库修改', 2090, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2094, '货物入库删除', 2090, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2095, '货物入库导出', 2090, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2096, '资金借出（期货）', 3, 1, 'lendmoney', 'system/lendmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:lendmoney:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '资金借出（期货）菜单');
INSERT INTO `sys_menu` VALUES (2097, '资金借出（期货）查询', 2096, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2098, '资金借出（期货）新增', 2096, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2099, '资金借出（期货）修改', 2096, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2100, '资金借出（期货）删除', 2096, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2101, '资金借出（期货）导出', 2096, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2102, '资金调整单信息', 3, 1, 'offsetting', 'system/offsetting/index', NULL, 1, 0, 'C', '0', '0', 'system:offsetting:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '资金调整单信息菜单');
INSERT INTO `sys_menu` VALUES (2103, '资金调整单信息查询', 2102, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2104, '资金调整单信息新增', 2102, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2105, '资金调整单信息修改', 2102, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2106, '资金调整单信息删除', 2102, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2107, '资金调整单信息导出', 2102, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2108, '基础信息-加油卡主卡登记', 3, 1, 'oilcardmain', 'system/oilcardmain/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcardmain:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '基础信息-加油卡主卡登记菜单');
INSERT INTO `sys_menu` VALUES (2109, '基础信息-加油卡主卡登记查询', 2108, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '基础信息-加油卡主卡登记新增', 2108, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '基础信息-加油卡主卡登记修改', 2108, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '基础信息-加油卡主卡登记删除', 2108, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '基础信息-加油卡主卡登记导出', 2108, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '加油卡', 3, 1, 'oilcard', 'system/oilcard/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcard:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '加油卡菜单');
INSERT INTO `sys_menu` VALUES (2115, '加油卡查询', 2114, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2116, '加油卡新增', 2114, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2117, '加油卡修改', 2114, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2118, '加油卡删除', 2114, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2119, '加油卡导出', 2114, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '订单详情', 3, 1, 'orderdetail', 'system/orderdetail/index', NULL, 1, 0, 'C', '0', '0', 'system:orderdetail:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '订单详情菜单');
INSERT INTO `sys_menu` VALUES (2121, '订单详情查询', 2120, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '订单详情新增', 2120, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2123, '订单详情修改', 2120, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2124, '订单详情删除', 2120, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2125, '订单详情导出', 2120, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2126, '订单运费', 3, 1, 'orderfreight', 'system/orderfreight/index', NULL, 1, 0, 'C', '0', '0', 'system:orderfreight:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '订单运费菜单');
INSERT INTO `sys_menu` VALUES (2127, '订单运费查询', 2126, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2128, '订单运费新增', 2126, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2129, '订单运费修改', 2126, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, '订单运费删除', 2126, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, '订单运费导出', 2126, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, '订单发票', 3, 1, 'orderinvoice', 'system/orderinvoice/index', NULL, 1, 0, 'C', '0', '0', 'system:orderinvoice:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '订单发票菜单');
INSERT INTO `sys_menu` VALUES (2133, '订单发票查询', 2132, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2134, '订单发票新增', 2132, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2135, '订单发票修改', 2132, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2136, '订单发票删除', 2132, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2137, '订单发票导出', 2132, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2138, '资产管理-收付款:收付款信息', 3, 1, 'payment', 'system/payment/index', NULL, 1, 0, 'C', '0', '0', 'system:payment:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '资产管理-收付款:收付款信息菜单');
INSERT INTO `sys_menu` VALUES (2139, '资产管理-收付款:收付款信息查询', 2138, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2140, '资产管理-收付款:收付款信息新增', 2138, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2141, '资产管理-收付款:收付款信息修改', 2138, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2142, '资产管理-收付款:收付款信息删除', 2138, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2143, '资产管理-收付款:收付款信息导出', 2138, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2144, '产品级别管理', 2192, 1, 'productlevel', 'system/productlevel/index', NULL, 1, 0, 'C', '0', '0', 'system:productlevel:list', '#', 'admin', '2024-07-29 12:37:25', 'admin', '2024-07-30 14:48:11', '产品级别管理菜单');
INSERT INTO `sys_menu` VALUES (2145, '产品级别管理查询', 2144, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2146, '产品级别管理新增', 2144, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2147, '产品级别管理修改', 2144, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2148, '产品级别管理删除', 2144, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2149, '产品级别管理导出', 2144, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2150, '供应商返利', 3, 1, 'rebate', 'system/rebate/index', NULL, 1, 0, 'C', '0', '0', 'system:rebate:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '供应商返利菜单');
INSERT INTO `sys_menu` VALUES (2151, '供应商返利查询', 2150, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2152, '供应商返利新增', 2150, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2153, '供应商返利修改', 2150, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2154, '供应商返利删除', 2150, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2155, '供应商返利导出', 2150, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2156, '资金回收', 3, 1, 'recovermoney', 'system/recovermoney/index', NULL, 1, 0, 'C', '0', '0', 'system:recovermoney:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '资金回收菜单');
INSERT INTO `sys_menu` VALUES (2157, '资金回收查询', 2156, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2158, '资金回收新增', 2156, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2159, '资金回收修改', 2156, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2160, '资金回收删除', 2156, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2161, '资金回收导出', 2156, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2162, '还款记录', 3, 1, 'repayment', 'system/repayment/index', NULL, 1, 0, 'C', '0', '0', 'system:repayment:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '还款记录菜单');
INSERT INTO `sys_menu` VALUES (2163, '还款记录查询', 2162, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2164, '还款记录新增', 2162, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2165, '还款记录修改', 2162, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2166, '还款记录删除', 2162, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2167, '还款记录导出', 2162, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2168, '社保基金', 3, 1, 'socialinsurance', 'system/socialinsurance/index', NULL, 1, 0, 'C', '0', '0', 'system:socialinsurance:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '社保基金菜单');
INSERT INTO `sys_menu` VALUES (2169, '社保基金查询', 2168, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2170, '社保基金新增', 2168, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2171, '社保基金修改', 2168, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2172, '社保基金删除', 2168, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2173, '社保基金导出', 2168, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2174, '仓库管理', 2192, 1, 'storehouse', 'system/storehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:storehouse:list', '#', 'admin', '2024-07-29 12:37:25', 'admin', '2024-07-30 16:56:25', '仓库管理菜单');
INSERT INTO `sys_menu` VALUES (2175, '仓库管理查询', 2174, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2176, '仓库管理新增', 2174, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2177, '仓库管理修改', 2174, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2178, '仓库管理删除', 2174, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2179, '仓库管理导出', 2174, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2180, '变动日志信息', 3, 1, 'tableeditmessage', 'system/tableeditmessage/index', NULL, 1, 0, 'C', '0', '0', 'system:tableeditmessage:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '变动日志信息菜单');
INSERT INTO `sys_menu` VALUES (2181, '变动日志信息查询', 2180, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2182, '变动日志信息新增', 2180, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2183, '变动日志信息修改', 2180, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2184, '变动日志信息删除', 2180, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2185, '变动日志信息导出', 2180, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2186, '虚拟银行账户变动信息', 3, 1, 'virtualbankaccountchange', 'system/virtualbankaccountchange/index', NULL, 1, 0, 'C', '0', '0', 'system:virtualbankaccountchange:list', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '虚拟银行账户变动信息菜单');
INSERT INTO `sys_menu` VALUES (2187, '虚拟银行账户变动信息查询', 2186, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:query', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2188, '虚拟银行账户变动信息新增', 2186, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:add', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2189, '虚拟银行账户变动信息修改', 2186, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:edit', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2190, '虚拟银行账户变动信息删除', 2186, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:remove', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2191, '虚拟银行账户变动信息导出', 2186, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:export', '#', 'admin', '2024-07-29 12:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2192, '基础信息维护', 0, 2, '/baseInfo', NULL, NULL, 1, 0, 'M', '0', '0', '', 'build', 'admin', '2024-07-29 18:11:18', 'admin', '2024-07-29 18:11:41', '');
INSERT INTO `sys_menu` VALUES (2193, '供应商管理', 2192, 2, 'companygive', 'system/companygive/index', NULL, 1, 0, 'C', '0', '0', 'system:company:list', '#', 'admin', '2024-07-29 18:44:47', 'admin', '2024-07-29 18:45:32', '');
INSERT INTO `sys_menu` VALUES (2195, '用户中心', 0, 2, 'userCenter', NULL, NULL, 1, 0, 'M', '0', '0', '', 'user', 'admin', '2024-07-30 09:39:38', 'admin', '2024-07-30 09:52:33', '');
INSERT INTO `sys_menu` VALUES (2196, '资金管理', 0, 2, 'fund', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'money', 'admin', '2024-07-30 09:52:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2197, '订单管理', 0, 2, 'order', NULL, NULL, 1, 0, 'M', '0', '0', '', 'edit', 'admin', '2024-07-30 09:55:37', 'admin', '2024-07-30 16:58:26', '');
INSERT INTO `sys_menu` VALUES (2198, '来往管理', 0, 2, 'traffic', NULL, NULL, 1, 0, 'M', '0', '0', '', 'edit', 'admin', '2024-07-30 09:57:18', 'admin', '2024-07-30 18:31:51', '');
INSERT INTO `sys_menu` VALUES (2199, '运费管理', 0, 2, 'freight', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'money', 'admin', '2024-07-30 09:58:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2200, '数据统计', 0, 2, 'statistics', NULL, NULL, 1, 0, 'M', '0', '0', '', 'chart', 'admin', '2024-07-30 09:59:51', 'admin', '2024-07-30 18:44:38', '');
INSERT INTO `sys_menu` VALUES (2201, '凭证管理', 0, 2, 'voucher', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'edit', 'admin', '2024-07-30 10:00:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2202, '报表管理', 0, 2, 'reports', NULL, NULL, 1, 0, 'M', '0', '0', '', 'form', 'admin', '2024-07-30 10:01:42', 'admin', '2024-07-30 19:02:38', '');
INSERT INTO `sys_menu` VALUES (2203, '日报管理', 0, 2, 'daily', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'edit', 'admin', '2024-07-30 10:02:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2204, '出差管理', 0, 2, 'business', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'edit', 'admin', '2024-07-30 10:04:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2205, '序时明细账', 0, 2, 'journal', NULL, NULL, 1, 0, 'M', '0', '0', '', 'money', 'admin', '2024-07-30 10:05:31', 'admin', '2024-07-30 19:27:41', '');
INSERT INTO `sys_menu` VALUES (2206, '更改密码', 2195, 1, 'changepassword', 'userCenter:changepassword:index', NULL, 1, 0, 'C', '0', '0', 'userCenter:changepassword:list', 'edit', 'admin', '2024-07-30 10:14:57', 'admin', '2024-07-30 10:16:38', '');
INSERT INTO `sys_menu` VALUES (2207, '订单列表', 2197, 1, 'orderlist', 'order/orderlist/index', NULL, 1, 0, 'C', '0', '0', 'order:orderlist:list', 'list', 'admin', '2024-07-30 17:16:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2208, '票点管理', 2197, 2, 'ticketPointmanagement', 'order/ticketPointmanagement/index', NULL, 1, 0, 'C', '0', '0', 'order:ticketPointmanagement:list', 'edit', 'admin', '2024-07-30 17:23:50', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2209, '票点管理-总台账', 2197, 3, 'generalLedger', 'order/generalLedger/index', NULL, 1, 0, 'C', '0', '0', 'order:generalLedger:list', 'edit', 'admin', '2024-07-30 17:26:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2211, '票点管理-我方主体缺票主动采购', 2197, 4, 'proactivePurchasing', 'order/proactivePurchasing/index', NULL, 1, 0, 'C', '0', '0', 'order:proactivePurchasing:list', 'edit', 'admin', '2024-07-30 17:29:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2212, '票点管理-收入-我方', 2197, 5, 'income', 'order/income/index', NULL, 1, 0, 'C', '0', '0', 'order:income:list', 'edit', 'admin', '2024-07-30 17:31:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2213, '票点管理-成本-客户含税部分', 2197, 6, 'cost', 'order/cost/index', NULL, 1, 0, 'C', '0', '0', 'order:cost:list', 'edit', 'admin', '2024-07-30 17:32:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2214, '票点管理-收入和成本-第三方', 2197, 7, 'revenueAndcosts', 'order/revenueAndcosts/index', NULL, 1, 0, 'C', '0', '0', 'order:revenueAndcosts:list', 'edit', 'admin', '2024-07-30 17:33:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2215, '进货单', 2197, 8, 'purchaseOrder', 'order/purchaseOrder/index', NULL, 1, 0, 'C', '0', '0', 'order:purchaseOrder:list', 'log', 'admin', '2024-07-30 17:35:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2216, '发货单', 2197, 9, 'invoice', 'order/invoice/index', NULL, 1, 0, 'C', '0', '0', 'order:invoice:list', 'log', 'admin', '2024-07-30 17:37:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2217, '调整单-订单', 2197, 10, 'adjustmentOrder', 'order/adjustmentOrder/index', NULL, 1, 0, 'C', '0', '0', 'order:adjustmentOrder:list', 'form', 'admin', '2024-07-30 17:38:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2218, '调整单-发货', 2197, 11, 'adjustmentShipping', 'order/adjustmentShipping/index', NULL, 1, 0, 'C', '0', '0', 'order:adjustmentShipping:list', 'form', 'admin', '2024-07-30 17:39:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2219, '调整单-进货', 2197, 11, 'adjustmentPurchasing', 'order/adjustmentPurchasing/index', NULL, 1, 0, 'C', '0', '0', 'order：adjustmentPurchasing：list', 'form', 'admin', '2024-07-30 17:42:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2220, '库存', 2197, 12, 'stock', 'order/stock/index', NULL, 1, 0, 'C', '0', '0', 'order:stock:list', 'edit', 'admin', '2024-07-30 17:44:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2221, '收付款', 2196, 1, 'collectionAndpayment', 'fund/collectionAndpayment/index', NULL, 1, 0, 'C', '0', '0', 'fund:collectionAndpayment:list', 'money', 'admin', '2024-07-30 17:47:07', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2222, '资金余额明细表', 2196, 2, 'balanceDetails', 'fund/balanceDetails/index', NULL, 1, 0, 'C', '0', '0', 'order:balanceDetails:list', 'money', 'admin', '2024-07-30 17:49:24', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2223, '资金余额表', 2196, 3, 'balanceSheet', 'fund/balanceSheet/index', NULL, 1, 0, 'C', '0', '0', 'fund:balanceSheet:list', 'money', 'admin', '2024-07-30 17:50:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2224, '商业票据', 2196, 4, 'commercialPaper', 'fund/commercialPaper/index', NULL, 1, 0, 'C', '0', '0', 'fund:commercialPaper:list', 'money', 'admin', '2024-07-30 17:52:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2225, '资产管理', 2196, 5, 'assetManagement', 'order/assetManagement/index', NULL, 1, 0, 'C', '0', '0', 'order:assetManagement:list', 'money', 'admin', '2024-07-30 17:53:55', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2226, '借贷管理', 2196, 6, 'loanManagement', 'fund/loanManagement/index', NULL, 1, 0, 'C', '0', '0', 'fund:loanManagement:list', 'money', 'admin', '2024-07-30 17:55:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2227, '供应商返利', 2196, 7, 'rebate', 'fund/rebate/index', NULL, 1, 0, 'C', '0', '0', 'fund:rebate:list', 'money', 'admin', '2024-07-30 17:56:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2228, '应收账款', 2196, 8, 'accountsReceivable', 'fund/accountsReceivable/index', NULL, 1, 0, 'C', '0', '0', 'fund:accountsReceivable:list', 'money', 'admin', '2024-07-30 17:58:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2229, '我司从外面借贷', 2196, 9, 'externalBorrowing', 'fund/externalBorrowing/index', NULL, 1, 0, 'C', '0', '0', 'fund:externalBorrowing:list', 'money', 'admin', '2024-07-30 18:00:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2230, '期货保证金台账', 2196, 10, 'earnestMoney', 'fund/earnestMoney/index', NULL, 1, 0, 'C', '0', '0', 'fund:earnestMoney:list', 'money', 'admin', '2024-07-30 18:01:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2231, '个人或公司从我司借款', 2196, 11, 'borrowingFromourCompany', 'fund/borrowingFromourCompany/index', NULL, 1, 0, 'C', '0', '0', 'fund:borrowingFromourCompany:list', 'money', 'admin', '2024-07-30 18:03:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2232, '客户余额管理', 2198, 1, 'customerBalance', 'traffic/customerBalance/index', NULL, 1, 0, 'C', '0', '0', 'traffic:customerBalance:list', '#', 'admin', '2024-07-30 18:31:41', 'admin', '2024-07-30 18:32:20', '');
INSERT INTO `sys_menu` VALUES (2233, '客户明细', 2198, 2, 'customerDetails', 'traffic/customerDetails/index', NULL, 1, 0, 'C', '0', '0', 'traffic:customerDetails:list', '#', 'admin', '2024-07-30 18:33:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2234, '供应商余额管理', 2198, 3, 'supplierBalance', 'traffic/supplierBalance/index', NULL, 1, 0, 'C', '0', '0', 'traffic:supplierBalance:list', '#', 'admin', '2024-07-30 18:35:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2235, '供应商明细', 2198, 4, 'supplierDetails', 'traffic/supplierDetails/index', NULL, 1, 0, 'C', '0', '0', 'traffic:supplierDetails:list', '#', 'admin', '2024-07-30 18:37:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2236, '运费明细', 2198, 5, 'freightDetails', 'traffic/Freight details/index', NULL, 1, 0, 'C', '0', '0', 'traffic:freightDetails:list', '#', 'admin', '2024-07-30 18:38:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2237, '订单-申请打款', 2199, 1, 'order', 'freight/order/index', NULL, 1, 0, 'C', '0', '0', 'freight:order:list', '#', 'admin', '2024-07-30 18:40:24', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2238, '进货单-申请打款', 2199, 2, 'purchaseOrder', 'freight/purchaseOrder/index', NULL, 1, 0, 'C', '0', '0', 'freight:purchaseOrder:list', '#', 'admin', '2024-07-30 18:41:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2239, '发货单-申请打款', 2199, 3, 'invoice', 'freight/invoice/index', NULL, 1, 0, 'C', '0', '0', 'freight:invoice:list', '#', 'admin', '2024-07-30 18:42:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2240, '数据统计', 2200, 1, 'dataStatistics', 'statistics/dataStatistics/index', NULL, 1, 0, 'C', '0', '0', 'statistics:dataStatistics:list', '#', 'admin', '2024-07-30 18:44:30', 'admin', '2024-07-30 18:45:15', '');
INSERT INTO `sys_menu` VALUES (2241, '资金变动统计', 2200, 2, 'fundChange ', 'statistics/fundChange /index', NULL, 1, 0, 'C', '0', '0', 'statistics:fundChange:list', '#', 'admin', '2024-07-30 18:46:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2242, '资金总额', 2200, 3, 'totalFunds', 'statistics/totalFunds/index', NULL, 1, 0, 'C', '0', '0', 'statistics:totalFunds:list', '#', 'admin', '2024-07-30 18:48:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2243, '资金变动统计2', 2200, 4, 'fundChangestatistics2', 'statistics/fundChangestatistics2/index', NULL, 1, 0, 'C', '0', '0', 'statistics:fundChangestatistics2:list', '#', 'admin', '2024-07-30 18:50:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2244, '区域统计', 2200, 5, 'regionalStatistics', 'statistics/regionalStatistics/index', NULL, 1, 0, 'C', '0', '0', 'statistics:regionalStatistics:list', '#', 'admin', '2024-07-30 18:51:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2245, '客户统计', 2200, 6, 'customerStatistics', 'statistics/customerStatistics/index', NULL, 1, 0, 'C', '0', '0', 'statistics:customerStatistics:list', '#', 'admin', '2024-07-30 18:52:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2246, '销售经理统计', 2200, 7, 'salesManagerstatistics', 'statistiics/salesManagerstatistics/index', NULL, 1, 0, 'C', '0', '0', 'statistics:salesManagerstatistics:list', '#', 'admin', '2024-07-30 18:54:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2247, '当日未入账', 2200, 8, 'notCredited ', 'statistics/notCredited /index', NULL, 1, 0, 'C', '0', '0', 'statistics:notCredited:list ', '#', 'admin', '2024-07-30 18:55:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2248, '填制凭证', 2201, 1, 'fillInvouchers', 'voucher/fillInvouchers/index', NULL, 1, 0, 'C', '0', '0', 'voucher:fillInvouchers:list', '#', 'admin', '2024-07-30 18:57:14', 'admin', '2024-07-30 18:57:50', '');
INSERT INTO `sys_menu` VALUES (2249, '查询凭证', 2201, 2, 'queryVouchers', 'vouchers/queryVouchers/index', NULL, 1, 0, 'C', '0', '0', 'vouchers:queryVouchers:list', '#', 'admin', '2024-07-30 19:00:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2250, '单据生成凭证', 2201, 3, 'documentGenerationvoucher', 'vouchers/documentGenerationvoucher/index', NULL, 1, 0, 'C', '0', '0', 'vouchers:documentGenerationvoucher:list', '#', 'admin', '2024-07-30 19:01:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2251, '供应商报表', 2202, 1, 'supplierReport', 'reports/supplierReport/index', NULL, 1, 0, 'C', '0', '0', 'reports:supplierReport:list', '#', 'admin', '2024-07-30 19:02:29', 'admin', '2024-07-30 19:03:10', '');
INSERT INTO `sys_menu` VALUES (2252, '供应商报表2', 2202, 2, 'supplierReport2', 'reports/supplierReport2/index', NULL, 1, 0, 'C', '0', '0', 'reports:supplierReport2:list', '#', 'admin', '2024-07-30 19:04:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2253, '客户报表', 2202, 3, 'customerReport', 'reports/customerReport/index', NULL, 1, 0, 'C', '0', '0', 'reports:customerReport:list', '#', 'admin', '2024-07-30 19:05:50', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2254, '客户报表2', 2202, 4, 'customerReport2', 'reports/customerReport2/index', NULL, 1, 0, 'C', '0', '0', 'reports:customerReport2:list', '#', 'admin', '2024-07-30 19:06:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2255, '运费报表', 2202, 5, 'inboundFreight ', 'reports/inboundFreight /index', NULL, 1, 0, 'C', '0', '0', 'reports:inboundFreight:list', '#', 'admin', '2024-07-30 19:07:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2256, '资金日报表', 2202, 6, 'financialDailyreport', 'reports/financialDailyreport/index', NULL, 1, 0, 'C', '0', '0', 'reports:financialDailyreport:list', '#', 'admin', '2024-07-30 19:08:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2257, '供应商日报', 2203, 1, 'supplierDailyreport', 'daily/supplierDailyreport/index', NULL, 1, 0, 'C', '0', '0', 'daily:supplierDailyreport:list', '#', 'admin', '2024-07-30 19:10:25', 'admin', '2024-07-30 19:10:56', '');
INSERT INTO `sys_menu` VALUES (2258, '客户日报', 2203, 2, 'customerDaily', 'daily/customerDaily/index', NULL, 1, 0, 'C', '0', '0', 'daily:customerDaily:list', '#', 'admin', '2024-07-30 19:11:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2259, '运费日报', 2203, 3, 'freightDailyreport', 'daily/freightDailyreport/index', NULL, 1, 0, 'C', '0', '0', 'daily:freightDailyreport:list', '#', 'admin', '2024-07-30 19:12:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2260, '暂存库存', 2203, 4, 'temporaryInventory', 'daily/temporaryInventory/index', NULL, 1, 0, 'C', '0', '0', 'daily:temporaryInventory:list', '#', 'admin', '2024-07-30 19:13:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2261, '短期借贷', 2203, 5, 'shortTermborrowing', 'daily/shortTermborrowing/index', NULL, 1, 0, 'C', '0', '0', 'daily:shortTermborrowing:list', '#', 'admin', '2024-07-30 19:14:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2262, '其他应收款', 2203, 6, 'otherReceivables', 'daily/otherReceivables/index', NULL, 1, 0, 'C', '0', '0', 'daily:otherReceivables:list', '#', 'admin', '2024-07-30 19:16:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2263, '资金流日报', 2203, 7, 'dailyFinancialflowReport', 'daily/dailyFinancialflowReport/index', NULL, 1, 0, 'C', '0', '0', 'daily:dailyFinancialflowReport:list', '#', 'admin', '2024-07-30 19:17:24', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2264, '日常费用日报', 2203, 8, 'dailyExpensereport', 'daily/dailyExpensereport/index', NULL, 1, 0, 'C', '0', '0', 'daily:dailyExpensereport:list', '#', 'admin', '2024-07-30 19:18:27', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2265, 'APP用户', 2204, 1, 'APPusers', 'business/APPusers/index', NULL, 1, 0, 'C', '0', '0', 'business:APPusers:list', '#', 'admin', '2024-07-30 19:20:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2266, '出差记录', 2204, 2, 'businessTriprecords', 'business/businessTriprecords/index', NULL, 1, 0, 'C', '0', '0', 'business:businessTriprecords:list', '#', 'admin', '2024-07-30 19:21:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2267, '走访记录', 2204, 3, 'visitRecords', 'business/visitRecords/index', NULL, 1, 0, 'C', '0', '0', 'business:visitRecords:list', '#', 'admin', '2024-07-30 19:23:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2268, '车辆管理', 2204, 4, 'vehicleManagement', 'business/vehicleManagement/index', NULL, 1, 0, 'C', '0', '0', 'business:vehicleManagement:list', '#', 'admin', '2024-07-30 19:24:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2269, '加油副卡登记', 2204, 5, 'refuelingAuxiliarycard', 'business/refuelingAuxiliarycard/index', NULL, 1, 0, 'C', '0', '0', 'business:refuelingAuxiliarycard:list', '#', 'admin', '2024-07-30 19:25:53', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2270, '加油主卡登记', 2204, 6, 'refuelingMaincard', 'business/refuelingMaincard/index', NULL, 1, 0, 'C', '0', '0', 'business:refuelingMaincard:list', '#', 'admin', '2024-07-30 19:26:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2271, '客户明细', 2205, 1, 'customerDetails', 'journal/customerDetails/index', NULL, 1, 0, 'C', '0', '0', 'journal:customerDetails:list', '#', 'admin', '2024-07-30 19:27:29', 'admin', '2024-07-30 19:28:03', '');
INSERT INTO `sys_menu` VALUES (2272, '供应商明细', 2205, 2, 'supplierDetails', 'journal/supplierDetails/index', NULL, 1, 0, 'C', '0', '0', 'journal:supplierDetails:list', '#', 'admin', '2024-07-30 19:29:10', '', NULL, '');

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
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`STATUS`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 423 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"socialInsurance,oilCard,repayment,Offsetting,lendMoney,company,recoverMoney,invoiceOut,receiveMoney,invoiceOther,productLevel,BalanceAccounts,invoiceIn,virtualBankAccountChange,borrowedMoney,payment,bankAccountChange,orderFreight,tableEditMessage,bankAccount,orderDetail_back,goodsOrder_back,bankAcceptance,orderDetail,goodsOrder,oilRecharge,Rebate,oilCardFundTransfer,fixedAssets,OilCardConsume,exWarehouse,CustomerVisit,cars,BusinessTrip,carApply,tripReimbursement,inventory_back,inventory,StoreHouse\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 12:27:48', 124197);
INSERT INTO `sys_oper_log` VALUES (101, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"BusinessTrip,carApply\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 12:30:19', 6661);
INSERT INTO `sys_oper_log` VALUES (102, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"socialInsurance,oilCard,repayment,Offsetting,lendMoney,company,recoverMoney,invoiceOut,receiveMoney,invoiceOther,BalanceAccounts,productLevel,invoiceIn,virtualBankAccountChange,borrowedMoney,payment,bankAccountChange,orderFreight,tableEditMessage,bankAccount,orderDetail_back,goodsOrder_back,bankAcceptance,orderDetail,goodsOrder,oilRecharge,Rebate,oilCardFundTransfer,fixedAssets,OilCardConsume,exWarehouse,CustomerVisit,cars,tripReimbursement,inventory_back,inventory,StoreHouse,fleet\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 12:32:43', 116106);
INSERT INTO `sys_oper_log` VALUES (103, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"BusinessTrip,carApply,BalanceAccounts,CustomerVisit,Offsetting,OilCardConsume,Rebate,StoreHouse,bankAcceptance,bankAccount,bankAccountChange,borrowedMoney,cars,company,exWarehouse,fixedAssets,fleet,goodsOrder,goodsOrder_back,inventory,inventory_back,invoiceIn,invoiceOther,invoiceOut,lendMoney,oilCard,oilCardFundTransfer,oilRecharge,orderDetail,orderDetail_back,orderFreight,payment,productLevel,receiveMoney,recoverMoney,repayment,socialInsurance,tableEditMessage,tripReimbursement,virtualBankAccountChange\"}', NULL, 0, NULL, '2024-07-29 12:34:51', 8810);
INSERT INTO `sys_oper_log` VALUES (104, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"addtime\":\"Mon Jul 29 13:45:17 CST 2024\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"delFlag\":0,\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"张三\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 13:45:16', 218);
INSERT INTO `sys_oper_log` VALUES (105, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省-济南市-高新区\",\"relationName\":\"张三123\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-29 13:55:38\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 13:55:37', 192);
INSERT INTO `sys_oper_log` VALUES (106, '客户、供应商信息', 3, 'org.dzu.system.controller.CompanyController.remove()', 'DELETE', 1, NULL, NULL, '/system/company/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 14:01:15', 141);
INSERT INTO `sys_oper_log` VALUES (107, '银行账号', 1, 'org.dzu.system.controller.BankAccountController.add()', 'POST', 1, NULL, NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"acountsType\":\"己方公司\",\"amount\":100000.0,\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"comments\":\"公司主要银行账户\",\"companyId\":999,\"companyName\":\"山东省某科技有限公司\",\"delFlag\":0,\"id\":1,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 14:16:10', 198);
INSERT INTO `sys_oper_log` VALUES (108, '银行账号', 2, 'org.dzu.system.controller.BankAccountController.edit()', 'PUT', 1, NULL, NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"acountsType\":\"己方公司\",\"amount\":1000020.0,\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"comments\":\"公司主要银行账户\",\"companyId\":999,\"companyName\":\"山东省某科技有限公司\",\"delFlag\":0,\"id\":1,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 14:17:29', 126);
INSERT INTO `sys_oper_log` VALUES (109, '银行账号', 3, 'org.dzu.system.controller.BankAccountController.remove()', 'DELETE', 1, NULL, NULL, '/system/bankAccount/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 14:18:59', 178);
INSERT INTO `sys_oper_log` VALUES (110, '银行账号', 1, 'org.dzu.system.controller.BankAccountController.add()', 'POST', 1, NULL, NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"acountsType\":\"己方公司\",\"amount\":100000.0,\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"comments\":\"公司主要银行账户\",\"companyId\":999,\"companyName\":\"山东省某科技有限公司\",\"delFlag\":0,\"id\":2,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 14:19:10', 122);
INSERT INTO `sys_oper_log` VALUES (111, '银行账号', 3, 'org.dzu.system.controller.BankAccountController.remove()', 'DELETE', 1, NULL, NULL, '/system/bankAccount/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 14:19:24', 122);
INSERT INTO `sys_oper_log` VALUES (112, '外部车辆信息', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"addtime\":\"Mon Jul 29 15:21:14 CST 2024\",\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567890\",\"carNo\":\"鲁A12345\",\"carType\":\"陆运\",\"delFlag\":0,\"driver\":\"李司机\",\"params\":{},\"tel\":\"13512345678\",\"userId\":1}', NULL, 1, '出现异常，请刷新页面后重试', '2024-07-29 15:21:13', 79);
INSERT INTO `sys_oper_log` VALUES (113, '外部车辆信息', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"addtime\":\"Mon Jul 29 15:31:11 CST 2024\",\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567890\",\"carNo\":\"鲁A12345\",\"carType\":\"陆运\",\"delFlag\":0,\"driver\":\"李司机\",\"params\":{},\"tel\":\"13512345678\",\"userId\":1}', NULL, 1, '', '2024-07-29 15:31:10', 540);
INSERT INTO `sys_oper_log` VALUES (114, '外部车辆信息', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"addtime\":\"Mon Jul 29 15:32:30 CST 2024\",\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567890\",\"carNo\":\"鲁A12345\",\"carType\":\"陆运\",\"delFlag\":0,\"driver\":\"李司机\",\"id\":1,\"params\":{},\"tel\":\"13512345678\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:32:29', 541);
INSERT INTO `sys_oper_log` VALUES (115, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567890\",\"carNo\":\"\",\"carType\":\"陆运\",\"driver\":\"李司机\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:37:58\",\"userId\":1}', NULL, 1, '陆运车辆必须填写车牌号信息', '2024-07-29 15:37:57', 122);
INSERT INTO `sys_oper_log` VALUES (116, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567890\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"driver\":\"李司机\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:38:16\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:38:19', 4150);
INSERT INTO `sys_oper_log` VALUES (117, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"7228481234567890\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"driver\":\"李司机\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:38:54\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:38:53', 566);
INSERT INTO `sys_oper_log` VALUES (118, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"7228481234567890\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"driver\":\"李司机\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:40:08\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:41:57', 110920);
INSERT INTO `sys_oper_log` VALUES (119, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"7228481234567890\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"driver\":\"李司机2\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:43:54\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:43:56', 3054);
INSERT INTO `sys_oper_log` VALUES (120, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"7228481234567890\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"driver\":\"李司机2\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:44:13\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:44:22', 10841);
INSERT INTO `sys_oper_log` VALUES (121, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567890\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"driver\":\"李司机2\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:44:40\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:44:42', 3543);
INSERT INTO `sys_oper_log` VALUES (122, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567860\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"driver\":\"李司机2\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:45:06\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:45:23', 17830);
INSERT INTO `sys_oper_log` VALUES (123, '外部车辆信息', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"毛账户名\",\"acountsType\":1,\"addtime\":\"Mon Jul 29 15:47:36 CST 2024\",\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567860\",\"carNo\":\"鲁A济南车~\",\"carType\":\"陆运\",\"delFlag\":0,\"driver\":\"毛司机\",\"id\":2,\"params\":{},\"tel\":\"19512345678\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:47:39', 4580);
INSERT INTO `sys_oper_log` VALUES (124, '外部车辆信息', 3, 'org.dzu.system.controller.CarsController.remove()', 'DELETE', 1, NULL, NULL, '/system/cars/1,2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:48:02', 142);
INSERT INTO `sys_oper_log` VALUES (125, '外部车辆信息', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"毛账户名\",\"acountsType\":1,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"6228481234567860\",\"carType\":\"海运\",\"driver\":\"毛司机\",\"id\":1,\"params\":{},\"tel\":\"19512345678\",\"updateTime\":\"2024-07-29 15:48:55\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:48:56', 2285);
INSERT INTO `sys_oper_log` VALUES (126, '银行账号', 1, 'org.dzu.system.controller.BankAccountController.add()', 'POST', 1, NULL, NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"amount\":100000.0,\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"comments\":\"公司主要银行账户\",\"companyId\":999,\"companyName\":\"山东省某科技有限公司\",\"delFlag\":0,\"id\":13,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:49:36', 140);
INSERT INTO `sys_oper_log` VALUES (127, '银行账号', 1, 'org.dzu.system.controller.BankAccountController.add()', 'POST', 1, NULL, NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"acountsType\":\"己方公司\",\"amount\":100000.0,\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"comments\":\"公司主要银行账户\",\"companyId\":999,\"companyName\":\"山东省某科技有限公司\",\"delFlag\":0,\"id\":14,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 15:49:43', 134);
INSERT INTO `sys_oper_log` VALUES (128, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"BusinessTrip,carApply,BalanceAccounts,CustomerVisit,Offsetting,OilCardConsume,Rebate,StoreHouse,bankAcceptance,bankAccount,bankAccountChange,borrowedMoney,cars,company,exWarehouse,fixedAssets,fleet,goodsOrder,goodsOrder_back,inventory,inventory_back,invoiceIn,invoiceOther,invoiceOut,lendMoney,oilCard,oilCardFundTransfer,oilRecharge,orderDetail,orderDetail_back,orderFreight,payment,productLevel,receiveMoney,recoverMoney,repayment,socialInsurance,tableEditMessage,tripReimbursement,virtualBankAccountChange\"}', NULL, 0, NULL, '2024-07-29 16:51:56', 4705);
INSERT INTO `sys_oper_log` VALUES (129, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"基础信息维护\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"/baseInfo\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:11:18', 226);
INSERT INTO `sys_oper_log` VALUES (130, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-29 18:11:18\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2192,\"menuName\":\"基础信息维护\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"/baseInfo\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:11:42', 203);
INSERT INTO `sys_oper_log` VALUES (131, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/company/index\",\"createTime\":\"2024-07-29 12:37:25\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2054,\"menuName\":\"客户管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2192,\"path\":\"company\",\"perms\":\"system:company:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:12:04', 257);
INSERT INTO `sys_oper_log` VALUES (132, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/bankaccount/index\",\"createTime\":\"2024-07-29 12:37:25\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2024,\"menuName\":\"银行卡管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2192,\"path\":\"bankaccount\",\"perms\":\"system:bankaccount:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:13:24', 202);
INSERT INTO `sys_oper_log` VALUES (133, '银行账号', 1, 'org.dzu.system.controller.BankAccountController.add()', 'POST', 1, NULL, NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"acountsType\":\"己方公司\",\"amount\":100000.0,\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"comments\":\"公司主要银行账户\",\"companyId\":999,\"companyName\":\"山东省某科技有限公司\",\"delFlag\":0,\"id\":15,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:32:02', 145);
INSERT INTO `sys_oper_log` VALUES (134, '银行账号', 1, 'org.dzu.system.controller.BankAccountController.add()', 'POST', 1, NULL, NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"acountsType\":\"己方公司\",\"amount\":100000.0,\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"comments\":\"公司主要银行账户\",\"companyId\":999,\"companyName\":\"山东省某科技有限公司\",\"delFlag\":0,\"id\":16,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:32:23', 136);
INSERT INTO `sys_oper_log` VALUES (135, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/companygive/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商信息\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2192,\"path\":\"companygive\",\"perms\":\"system:company:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:44:47', 244);
INSERT INTO `sys_oper_log` VALUES (136, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/companygive/index\",\"createTime\":\"2024-07-29 18:44:47\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2193,\"menuName\":\"供应商管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2192,\"path\":\"companygive\",\"perms\":\"system:company:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 18:45:32', 203);
INSERT INTO `sys_oper_log` VALUES (137, '银行账号', 2, 'org.dzu.system.controller.BankAccountController.edit()', 'PUT', 1, 'admin', NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":\"己方公司\",\"amount\":0.0,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"7228481234567890\",\"companyId\":1,\"companyName\":\"李司机2\",\"delFlag\":0,\"id\":9,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 19:07:19', 169);
INSERT INTO `sys_oper_log` VALUES (138, '银行账号', 2, 'org.dzu.system.controller.BankAccountController.edit()', 'PUT', 1, 'admin', NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"李司机\",\"acountsType\":\"己方公司\",\"amount\":0.0,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"7228481234567890\",\"companyId\":1,\"companyName\":\"张司机\",\"delFlag\":0,\"id\":9,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 19:07:33', 153);
INSERT INTO `sys_oper_log` VALUES (139, '银行账号', 2, 'org.dzu.system.controller.BankAccountController.edit()', 'PUT', 1, 'admin', NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"张司机\",\"acountsType\":\"己方公司\",\"amount\":0.0,\"bankName\":\"中国农业银行济南分行\",\"bankNo\":\"7228481234567890\",\"companyId\":1,\"companyName\":\"张司机\",\"delFlag\":0,\"id\":9,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 19:08:25', 149);
INSERT INTO `sys_oper_log` VALUES (140, '银行账号', 2, 'org.dzu.system.controller.BankAccountController.edit()', 'PUT', 1, 'admin', NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"张司机\",\"acountsType\":\"己方公司\",\"amount\":0.0,\"bankName\":\"中国农业银行济南分行123\",\"bankNo\":\"7228481234567890\",\"companyId\":1,\"companyName\":\"张司机\",\"delFlag\":0,\"id\":9,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 19:08:31', 106);
INSERT INTO `sys_oper_log` VALUES (141, '银行账号', 2, 'org.dzu.system.controller.BankAccountController.edit()', 'PUT', 1, 'admin', NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"张司机\",\"acountsType\":\"己方公司\",\"amount\":0.0,\"bankName\":\"中国农业银行济南分行123\",\"bankNo\":\"7228481234567891\",\"companyId\":1,\"companyName\":\"张司机\",\"delFlag\":0,\"id\":9,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 19:08:38', 157);
INSERT INTO `sys_oper_log` VALUES (142, '银行账号', 3, 'org.dzu.system.controller.BankAccountController.remove()', 'DELETE', 1, 'admin', NULL, '/system/bankAccount/9', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 19:09:12', 153);
INSERT INTO `sys_oper_log` VALUES (143, '银行账号', 5, 'org.dzu.system.controller.BankAccountController.export()', 'POST', 1, 'admin', NULL, '/system/bankAccount/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-07-29 19:32:29', 960);
INSERT INTO `sys_oper_log` VALUES (144, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"addtime\":\"Mon Jul 29 20:03:32 CST 2024\",\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"delFlag\":0,\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 20:03:31', 297);
INSERT INTO `sys_oper_log` VALUES (145, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"addtime\":\"Mon Jul 29 20:03:38 CST 2024\",\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"delFlag\":0,\"id\":3,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 20:03:37', 199);
INSERT INTO `sys_oper_log` VALUES (146, '银行账号', 1, 'org.dzu.system.controller.BankAccountController.add()', 'POST', 1, 'admin', NULL, '/system/bankAccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"张先生\",\"acountsType\":\"己方公司\",\"amount\":null,\"bankName\":\"中国银行\",\"bankNo\":\"1226555855985548\",\"delFlag\":0,\"id\":17,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 21:40:50', 296);
INSERT INTO `sys_oper_log` VALUES (147, '角色管理', 2, 'org.dzu.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', NULL, '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-07-29 12:13:00\",\"dataScope\":\"2\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,2192,2054,2055,2056,2057,2058,2059,2024,2025,2026,2027,2028,2029,2193,3,2048,2049,2050,2051,2052,2053,2060,2061,2062,2063,2064,2065,2066,2067,2068,2069,2070,2071,2072,2073,2074,2075,2076,2077,2078,2079,2080,2081,2082,2083,2084,2085,2086,2087,2088,2089,2090,2091,2092,2093,2094,2095,2096,2097,2098,2099,2100,2101,2102,2103,2104,2105,2106,2107,2108,2109,2110,2111,2112,2113,2114,2115,2116,2117,2118,2119,2120,2121,2122,2123,2124,2125,2126,2127,2128,2129,2130,2131,2132,2133,2134,2135,2136,2137,2138,2139,2140,2141,2142,2143,2144,2145,2146,2147,2148,2149,2150,2151,2152,2153,2154,2155,2156,2157,2158,2159,2160,2161,2162,2163,2164,2165,2166,2167,115,2168,2169,2170,2171,2172,2173,2174,2175,2176,2177,2178,2179,2180,2181,2182,2183,2184,2185,2186,2187,2188,2189,2190,2191,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2030,2031,2032,2033,2034,2035,2036,2037,2038,2039,2040,2041,2042,2043,2044,2045,2046,2047,116,1055,1056,1057,1058,1059,1060,117,4],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 08:45:55', 7792);
INSERT INTO `sys_oper_log` VALUES (148, '用户管理', 1, 'org.dzu.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', NULL, '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptId\":100,\"email\":\"teste@exemplo.us\",\"nickName\":\"common\",\"params\":{},\"phonenumber\":\"18217133333\",\"postIds\":[],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userName\":\"common\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'trueName\' doesn\'t have a default value\r\n### The error may exist in file [D:\\Code\\project\\order-system\\order-serv\\target\\classes\\mapper\\system\\SysUserMapper.xml]\r\n### The error may involve org.dzu.system.mapper.SysUserMapper.insertUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_user(            dept_id,       user_name,       nick_name,       email,             phonenumber,       sex,       password,       status,       create_by,            create_time    )values(            ?,       ?,       ?,       ?,             ?,       ?,       ?,       ?,       ?,            sysdate()    )\r\n### Cause: java.sql.SQLException: Field \'trueName\' doesn\'t have a default value\n; Field \'trueName\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'trueName\' doesn\'t have a default value', '2024-07-30 08:52:21', 5250);
INSERT INTO `sys_oper_log` VALUES (149, '加油卡信息', 5, 'org.dzu.system.controller.OilCardController.export()', 'POST', 1, 'admin', NULL, '/system/oilCard/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-07-30 09:12:45', 746);
INSERT INTO `sys_oper_log` VALUES (150, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"userCenter\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:38:07', 328);
INSERT INTO `sys_oper_log` VALUES (151, '菜单管理', 3, 'org.dzu.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', NULL, '/system/menu/2194', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:38:18', 243);
INSERT INTO `sys_oper_log` VALUES (152, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"userCenter\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:39:38', 178);
INSERT INTO `sys_oper_log` VALUES (153, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:39:38\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2195,\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"userCenter\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:40:03', 248);
INSERT INTO `sys_oper_log` VALUES (154, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:39:38\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2195,\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"userCenter\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:40:21', 183);
INSERT INTO `sys_oper_log` VALUES (155, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:39:38\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2195,\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"user\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:40:37', 489);
INSERT INTO `sys_oper_log` VALUES (156, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:39:38\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2195,\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"userCenter\",\"perms\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'用户中心\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2024-07-30 09:40:51', 53);
INSERT INTO `sys_oper_log` VALUES (157, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:39:38\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2195,\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"userCenter\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:41:00', 961);
INSERT INTO `sys_oper_log` VALUES (158, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"5222001234567890\",\"companyType\":\"客户\",\"params\":{},\"region\":\"nullnullnull\",\"surplusMoney\":null,\"updateTime\":\"2024-07-30 09:42:38\",\"userId\":1}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 09:42:37', 177);
INSERT INTO `sys_oper_log` VALUES (159, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"5222001234567890\",\"companyType\":\"客户\",\"params\":{},\"region\":\"nullnullnull\",\"surplusMoney\":null,\"updateTime\":\"2024-07-30 09:43:05\",\"userId\":1}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 09:43:04', 154);
INSERT INTO `sys_oper_log` VALUES (160, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"5222001234567890\",\"companyType\":\"客户\",\"params\":{},\"region\":\"nullnullnull\",\"surplusMoney\":null,\"updateTime\":\"2024-07-30 09:44:04\",\"userId\":1}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 09:44:03', 144);
INSERT INTO `sys_oper_log` VALUES (161, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:39:38\",\"icon\":\"user\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2195,\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"userCenter\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:52:33', 179);
INSERT INTO `sys_oper_log` VALUES (162, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"fund\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:53:00', 178);
INSERT INTO `sys_oper_log` VALUES (163, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"订单管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"order\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:55:38', 225);
INSERT INTO `sys_oper_log` VALUES (164, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"来往管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"traffic\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:57:18', 242);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:55:37\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2197,\"menuName\":\"订单管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"order\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:57:42', 175);
INSERT INTO `sys_oper_log` VALUES (166, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"运费管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"freight\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:58:50', 168);
INSERT INTO `sys_oper_log` VALUES (167, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"数据统计\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"statistics\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 09:59:51', 163);
INSERT INTO `sys_oper_log` VALUES (168, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"凭证管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"voucher\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:00:33', 159);
INSERT INTO `sys_oper_log` VALUES (169, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"报表管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"reports\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:01:43', 162);
INSERT INTO `sys_oper_log` VALUES (170, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"日报管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"daily\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:02:51', 616);
INSERT INTO `sys_oper_log` VALUES (171, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"日报管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"daily\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"新增菜单\'日报管理\'失败，菜单名称已存在\",\"code\":500}', 0, NULL, '2024-07-30 10:02:52', 90);
INSERT INTO `sys_oper_log` VALUES (172, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 10:01:42\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2202,\"menuName\":\"报表管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"reports\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:03:22', 963);
INSERT INTO `sys_oper_log` VALUES (173, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"出差管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"business\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:04:19', 159);
INSERT INTO `sys_oper_log` VALUES (174, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"bankName\":\"山东工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"companyType\":\"客户\",\"params\":{},\"region\":\"nullnullnull\",\"relationName\":\"王五\",\"surplusMoney\":null,\"updateTime\":\"2024-07-30 10:05:02\",\"userId\":1}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 10:05:01', 156);
INSERT INTO `sys_oper_log` VALUES (175, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"序时明细账\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"journal\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:05:31', 204);
INSERT INTO `sys_oper_log` VALUES (176, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"张三123\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"王五\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 10:06:08\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:06:07', 306);
INSERT INTO `sys_oper_log` VALUES (177, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"张三123456\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"王五\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 10:07:43\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:07:42', 260);
INSERT INTO `sys_oper_log` VALUES (178, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"userCenter:change\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"更改密码\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"change\",\"perms\":\"userCenter:change:\",\"query\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:14:57', 210);
INSERT INTO `sys_oper_log` VALUES (179, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"userCenter:change:index\",\"createTime\":\"2024-07-30 10:14:57\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2206,\"menuName\":\"更改密码\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"change\",\"perms\":\"userCenter:change:index\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:15:37', 172);
INSERT INTO `sys_oper_log` VALUES (180, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"userCenter:change:index\",\"createTime\":\"2024-07-30 10:14:57\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2206,\"menuName\":\"更改密码\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"change\",\"perms\":\"userCenter:change:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:15:53', 165);
INSERT INTO `sys_oper_log` VALUES (181, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"userCenter:changepassword:index\",\"createTime\":\"2024-07-30 10:14:57\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2206,\"menuName\":\"更改密码\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"changepassword\",\"perms\":\"userCenter:changepassword:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:16:38', 175);
INSERT INTO `sys_oper_log` VALUES (182, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:55:37\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2197,\"menuName\":\"订单管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"order\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:18:35', 175);
INSERT INTO `sys_oper_log` VALUES (183, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"山东工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 10:19:21\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:19:20', 194);
INSERT INTO `sys_oper_log` VALUES (184, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"德州工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 10:20:51\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:20:50', 199);
INSERT INTO `sys_oper_log` VALUES (185, '字典类型', 1, 'org.dzu.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"公司车辆\",\"dictType\":\"order_cars\",\"params\":{},\"remark\":\"公司车辆列表\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:21:40', 7455);
INSERT INTO `sys_oper_log` VALUES (186, '字典类型', 1, 'org.dzu.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"公司加油卡信息\",\"dictType\":\"order_oilcard\",\"params\":{},\"remark\":\"公司加油卡信息\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:23:03', 1371);
INSERT INTO `sys_oper_log` VALUES (187, '字典类型', 1, 'org.dzu.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"产品分类信息\",\"dictType\":\"order_product_c\",\"params\":{},\"remark\":\"产品分类信息\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:24:21', 916);
INSERT INTO `sys_oper_log` VALUES (188, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"张三123456\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"王五\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 10:24:44\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:24:43', 176);
INSERT INTO `sys_oper_log` VALUES (189, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"张三123457896\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵5\",\"salesman\":\"王五\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 10:25:04\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:25:03', 202);
INSERT INTO `sys_oper_log` VALUES (190, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:24:20\",\"dictId\":102,\"dictName\":\"产品分类信息\",\"dictType\":\"order_product_categories\",\"params\":{},\"remark\":\"产品分类信息\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:35:05', 934);
INSERT INTO `sys_oper_log` VALUES (191, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_car\",\"params\":{},\"remark\":\"公司车辆列表\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:41:01', 872);
INSERT INTO `sys_oper_log` VALUES (192, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_cars\",\"params\":{},\"remark\":\"公司车辆列表\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:42:05', 51424);
INSERT INTO `sys_oper_log` VALUES (193, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_cars1\",\"params\":{},\"remark\":\"公司车辆列表\",\"status\":\"0\",\"updateBy\":\"admin\"}', NULL, 1, '系统业务表，拒绝修改', '2024-07-30 10:43:56', 3903);
INSERT INTO `sys_oper_log` VALUES (194, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_cars\",\"params\":{},\"remark\":\"公司车辆列表1\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:44:05', 2943);
INSERT INTO `sys_oper_log` VALUES (195, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_cars\",\"params\":{},\"remark\":\"公司车辆列表1\",\"status\":\"1\",\"updateBy\":\"admin\"}', NULL, 1, '系统业务表，拒绝修改', '2024-07-30 10:46:17', 3171);
INSERT INTO `sys_oper_log` VALUES (196, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_cars\",\"params\":{},\"remark\":\"公司车辆列表\",\"status\":\"1\",\"updateBy\":\"admin\"}', NULL, 1, '系统业务表，拒绝修改', '2024-07-30 10:46:22', 294);
INSERT INTO `sys_oper_log` VALUES (197, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_cars\",\"params\":{},\"remark\":\"公司车辆列表\",\"status\":\"1\",\"updateBy\":\"admin\"}', NULL, 1, '系统业务表，拒绝修改', '2024-07-30 10:46:24', 295);
INSERT INTO `sys_oper_log` VALUES (198, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 10:21:32\",\"dictId\":100,\"dictName\":\"公司车辆\",\"dictType\":\"order_cars\",\"params\":{},\"remark\":\"公司车辆列表\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:46:32', 834);
INSERT INTO `sys_oper_log` VALUES (199, '字典数据', 1, 'org.dzu.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"鲁A济南车\",\"dictSort\":0,\"dictType\":\"order_cars\",\"dictValue\":\"aaaaaa\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:47:55', 362);
INSERT INTO `sys_oper_log` VALUES (200, '字典数据', 1, 'org.dzu.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"鲁B青岛的~\",\"dictSort\":0,\"dictType\":\"order_cars\",\"dictValue\":\"BBBB\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:48:08', 403);
INSERT INTO `sys_oper_log` VALUES (201, '字典数据', 1, 'org.dzu.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', NULL, '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"鲁C淄博\",\"dictSort\":0,\"dictType\":\"order_cars\",\"dictValue\":\"ccccc\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 10:48:19', 363);
INSERT INTO `sys_oper_log` VALUES (202, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"addtime\":\"Tue Jul 30 11:07:46 CST 2024\",\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某有限公司\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"delFlag\":0,\"id\":4,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王6\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:07:45', 189);
INSERT INTO `sys_oper_log` VALUES (203, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"1\",\"address\":\"1\",\"addtime\":\"Tue Jul 30 11:11:42 GMT+08:00 2024\",\"bankName\":\"1\",\"bankNo\":\"1\",\"companyName\":\"1\",\"companyType\":\"客户\",\"delFlag\":0,\"id\":5,\"leader\":\"1\",\"leaderTel\":\"1\",\"params\":{},\"region\":\"nullnullnull\",\"relationName\":\"1\",\"relationTel\":\"1\",\"salesman\":\"1\",\"surplusMoney\":1.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:11:43', 144);
INSERT INTO `sys_oper_log` VALUES (204, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"id\":4,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王6\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 11:20:55\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:20:54', 171);
INSERT INTO `sys_oper_log` VALUES (205, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"德州工商银行德州分行\",\"bankNo\":\"6222001234567120\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 11:37:27\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:37:26', 179);
INSERT INTO `sys_oper_log` VALUES (206, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"山东工商银行德州分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"id\":4,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王6\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 11:41:12\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:41:12', 184);
INSERT INTO `sys_oper_log` VALUES (207, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省有限公司\",\"address\":\"山东省德州市高新区某街道2000号\",\"addtime\":\"Tue Jul 30 11:50:35 CST 2024\",\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"62220012345671540\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某有限公司\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"delFlag\":0,\"id\":6,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王7\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:50:35', 174);
INSERT INTO `sys_oper_log` VALUES (208, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省公司\",\"address\":\"山东省德州市高新区某街道2000号\",\"addtime\":\"Tue Jul 30 11:50:52 CST 2024\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"62220012345671540\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某有限公司\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"delFlag\":0,\"id\":7,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"粒6\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:50:51', 183);
INSERT INTO `sys_oper_log` VALUES (209, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"山东省德州市高新区某街道2000号\",\"bankName\":\"中国工商银行德州分行\",\"bankNo\":\"63220012345671540\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"id\":6,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王7\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 11:52:02\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 11:52:02', 171);
INSERT INTO `sys_oper_log` VALUES (210, '客户、供应商信息', 3, 'org.dzu.system.controller.CompanyController.remove()', 'DELETE', 1, 'admin', NULL, '/system/company/5', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 12:49:11', 127);
INSERT INTO `sys_oper_log` VALUES (211, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"德州代悦\",\"addtime\":\"Tue Jul 30 13:57:01 CST 2024\",\"city\":\"太大\",\"comments\":\"无\",\"companyName\":\"山东石油公司\",\"companyType\":\"客户\",\"county\":\"无\",\"delFlag\":0,\"id\":8,\"leader\":\"李老板\",\"leaderTel\":\"15588459866\",\"params\":{},\"province\":\"山东\",\"region\":\"山东太大无\",\"relationName\":\"张客户\",\"relationTel\":\"15588459866\",\"salesManager\":\"李老板\",\"salesman\":\"李老板\",\"surplusMoney\":null,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 13:56:59', 224);
INSERT INTO `sys_oper_log` VALUES (212, '客户、供应商信息', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"德州\",\"addtime\":\"Tue Jul 30 14:02:56 CST 2024\",\"city\":\"德州\",\"comments\":\"无\",\"companyName\":\"山东公司\",\"companyType\":\"供应商\",\"county\":\"德州\",\"delFlag\":0,\"id\":9,\"params\":{},\"province\":\"德州\",\"region\":\"德州德州德州\",\"relationTel\":\"15588459958\",\"surplusMoney\":null,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:02:55', 172);
INSERT INTO `sys_oper_log` VALUES (213, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/productlevel/index\",\"createTime\":\"2024-07-29 12:37:25\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2144,\"menuName\":\"产品级别管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2192,\"path\":\"productlevel\",\"perms\":\"system:productlevel:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:48:11', 225);
INSERT INTO `sys_oper_log` VALUES (214, '产品级别', 1, 'org.dzu.system.controller.ProductLevelController.add()', 'POST', 1, 'admin', NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 14:48:33 CST 2024\",\"categoryName\":\"123123\",\"categoryNo\":123123,\"delFlag\":0,\"height\":1.0,\"id\":1,\"length\":1.0,\"levelName\":\"123123\",\"levelNo\":\"123123\",\"params\":{},\"tonnage\":1.0,\"userId\":1,\"width\":1.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:48:35', 154);
INSERT INTO `sys_oper_log` VALUES (215, '产品级别', 1, 'org.dzu.system.controller.ProductLevelController.add()', 'POST', 1, 'admin', NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 14:48:45 CST 2024\",\"categoryName\":\"123\",\"categoryNo\":123,\"delFlag\":0,\"height\":123.0,\"length\":123.0,\"levelName\":\"123123\",\"levelNo\":\"123123\",\"params\":{},\"tonnage\":123.0,\"userId\":1,\"width\":123.0}', NULL, 1, '本编号已经存在，请修改编号或者删除对应编号信息', '2024-07-30 14:48:47', 185);
INSERT INTO `sys_oper_log` VALUES (216, '产品级别', 1, 'org.dzu.system.controller.ProductLevelController.add()', 'POST', 1, 'admin', NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 14:48:51 CST 2024\",\"categoryName\":\"123\",\"categoryNo\":123,\"delFlag\":0,\"height\":123.0,\"id\":3,\"length\":123.0,\"levelName\":\"123123\",\"levelNo\":\"123122\",\"params\":{},\"tonnage\":123.0,\"userId\":1,\"width\":123.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:48:53', 142);
INSERT INTO `sys_oper_log` VALUES (217, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, 'admin', NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"123123\",\"categoryNo\":123123,\"delFlag\":0,\"height\":1.0,\"id\":1,\"length\":1.0,\"levelName\":\"123123\",\"levelNo\":\"123122\",\"params\":{},\"tonnage\":1.0,\"updateTime\":\"2024-07-30 14:48:56\",\"userId\":1,\"width\":1.0}', NULL, 1, '本编号已经存在，请修改编号或者删除对应编号信息', '2024-07-30 14:48:58', 149);
INSERT INTO `sys_oper_log` VALUES (218, '产品级别', 3, 'org.dzu.system.controller.ProductLevelController.remove()', 'DELETE', 1, 'admin', NULL, '/system/productLevel/1,3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:49:11', 151);
INSERT INTO `sys_oper_log` VALUES (219, '产品级别', 1, 'org.dzu.system.controller.ProductLevelController.add()', 'POST', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 14:57:10 CST 2024\",\"categoryName\":\"玻璃安强001\",\"categoryNo\":101,\"delFlag\":0,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:57:12', 201);
INSERT INTO `sys_oper_log` VALUES (220, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":0,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 14:57:43\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:57:45', 137);
INSERT INTO `sys_oper_log` VALUES (221, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":0,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 14:59:49\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 14:59:51', 26656);
INSERT INTO `sys_oper_log` VALUES (222, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":0,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 15:00:28\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:00:30', 20569);
INSERT INTO `sys_oper_log` VALUES (223, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 15:03:30\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:03:32', 3866);
INSERT INTO `sys_oper_log` VALUES (224, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 15:07:29\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:07:31', 45806);
INSERT INTO `sys_oper_log` VALUES (225, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 15:08:59\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:09:01', 86743);
INSERT INTO `sys_oper_log` VALUES (226, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 15:17:49\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:17:51', 7936);
INSERT INTO `sys_oper_log` VALUES (227, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 15:18:47\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:18:49', 53880);
INSERT INTO `sys_oper_log` VALUES (228, '外部车辆信息', 5, 'org.dzu.system.controller.CarsController.export()', 'POST', 1, NULL, NULL, '/system/cars/export', '127.0.0.1', '内网IP', '{\"UserName\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"bankName\":\"\",\"delFlag\":\"\",\"acountsName\":\"\",\"userId\":\"\",\"createBy\":\"\",\"carType\":\"\",\"driver\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"carNo\":\"\",\"params.key.key\":\"\",\"addtime\":\"\",\"bankNo\":\"\",\"tel\":\"\",\"id\":\"\",\"acountsType\":\"\"}', NULL, 1, '非法操作!已经记录你的ip和对应操作', '2024-07-30 15:29:20', 6279);
INSERT INTO `sys_oper_log` VALUES (229, '外部车辆信息', 5, 'org.dzu.system.controller.CarsController.export()', 'POST', 1, NULL, NULL, '/system/cars/export', '127.0.0.1', '内网IP', '{\"carType\":\"\",\"driver\":\"\",\"carNo\":\"\",\"bankNo\":\"\",\"tel\":\"\",\"bankName\":\"\",\"acountsName\":\"\",\"acountsType\":\"\"}', NULL, 0, NULL, '2024-07-30 15:29:21', 23580);
INSERT INTO `sys_oper_log` VALUES (230, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"updateTime\":\"2024-07-30 15:31:06\",\"userId\":1,\"width\":100.0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:31:08', 12277);
INSERT INTO `sys_oper_log` VALUES (231, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"width\":100.0}', NULL, 1, '', '2024-07-30 15:38:15', 11412);
INSERT INTO `sys_oper_log` VALUES (232, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"width\":100.0}', NULL, 1, '', '2024-07-30 15:39:20', 1);
INSERT INTO `sys_oper_log` VALUES (233, '产品级别', 2, 'org.dzu.system.controller.ProductLevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productLevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"玻璃安强021\",\"categoryNo\":101,\"delFlag\":1,\"height\":10.5,\"id\":4,\"length\":200.0,\"levelName\":\"高级\",\"levelNo\":\"L001\",\"params\":{},\"tonnage\":1.5,\"width\":100.0}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 15:44:44', 14);
INSERT INTO `sys_oper_log` VALUES (234, '字典类型', 1, 'org.dzu.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"科目\",\"dictType\":\"order_ohtertype\",\"params\":{},\"remark\":\"自定义科目信息\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 15:50:20', 393);
INSERT INTO `sys_oper_log` VALUES (235, '字典类型', 2, 'org.dzu.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', NULL, '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2024-07-30 15:50:19\",\"dictId\":103,\"dictName\":\"科目\",\"dictType\":\"order_ohtertype\",\"params\":{},\"remark\":\"自定义科目信息\",\"status\":\"1\",\"updateBy\":\"admin\"}', NULL, 1, '系统业务表，拒绝修改', '2024-07-30 15:50:39', 325);
INSERT INTO `sys_oper_log` VALUES (236, '客户、供应商信息', 5, 'org.dzu.system.controller.CompanyController.export()', 'POST', 1, 'admin', NULL, '/system/company/export', '127.0.0.1', '内网IP', '{\"companyType\":\"客户\",\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-07-30 15:56:07', 736);
INSERT INTO `sys_oper_log` VALUES (237, '库房', 5, 'org.dzu.system.controller.StoreHouseController.export()', 'POST', 1, 'admin', NULL, '/system/StoreHouse/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-07-30 16:04:03', 1044);
INSERT INTO `sys_oper_log` VALUES (238, '银行账号', 5, 'org.dzu.system.controller.BankAccountController.export()', 'POST', 1, 'admin', NULL, '/system/bankAccount/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-07-30 16:07:43', 100);
INSERT INTO `sys_oper_log` VALUES (239, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"address\":\"12\",\"delFlag\":0,\"id\":1,\"params\":{},\"storeHouseName\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:08:06', 226);
INSERT INTO `sys_oper_log` VALUES (240, '库房', 3, 'org.dzu.system.controller.StoreHouseController.remove()', 'DELETE', 1, 'admin', NULL, '/system/StoreHouse/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:08:42', 179);
INSERT INTO `sys_oper_log` VALUES (241, '客户、供应商信息', 5, 'org.dzu.system.controller.CompanyController.export()', 'POST', 1, 'admin', NULL, '/system/company/export', '127.0.0.1', '内网IP', '{\"companyType\":\"供应商\",\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2024-07-30 16:10:01', 216);
INSERT INTO `sys_oper_log` VALUES (242, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"address\":\"12\",\"delFlag\":0,\"id\":2,\"params\":{},\"storeHouseName\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:29:09', 153);
INSERT INTO `sys_oper_log` VALUES (243, '库房', 3, 'org.dzu.system.controller.StoreHouseController.remove()', 'DELETE', 1, 'admin', NULL, '/system/StoreHouse/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:29:59', 110);
INSERT INTO `sys_oper_log` VALUES (244, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"fName\":\"\",\"address\":\"\",\"fLeader\":\"\",\"tel\":\"\"}', NULL, 0, NULL, '2024-07-30 16:32:06', 39563);
INSERT INTO `sys_oper_log` VALUES (245, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"address\":\"12\",\"delFlag\":0,\"id\":3,\"params\":{},\"storeHouseName\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:32:31', 151);
INSERT INTO `sys_oper_log` VALUES (246, '库房', 2, 'org.dzu.system.controller.StoreHouseController.edit()', 'PUT', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"address\":\"113\",\"delFlag\":0,\"id\":3,\"params\":{},\"storeHouseName\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:33:30', 108);
INSERT INTO `sys_oper_log` VALUES (247, '库房', 3, 'org.dzu.system.controller.StoreHouseController.remove()', 'DELETE', 1, 'admin', NULL, '/system/StoreHouse/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:33:37', 100);
INSERT INTO `sys_oper_log` VALUES (248, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"fName\":\"\",\"address\":\"\",\"fLeader\":\"\",\"tel\":\"\"}', NULL, 0, NULL, '2024-07-30 16:33:41', 174);
INSERT INTO `sys_oper_log` VALUES (249, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"fName\":\"\",\"address\":\"\",\"fLeader\":\"\",\"tel\":\"\"}', NULL, 0, NULL, '2024-07-30 16:33:51', 133);
INSERT INTO `sys_oper_log` VALUES (250, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"fName\":\"\",\"address\":\"\",\"fLeader\":\"\",\"tel\":\"\"}', NULL, 0, NULL, '2024-07-30 16:34:09', 107);
INSERT INTO `sys_oper_log` VALUES (251, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"fName\":\"\",\"address\":\"\",\"fLeader\":\"\",\"tel\":\"\"}', NULL, 0, NULL, '2024-07-30 16:34:31', 112);
INSERT INTO `sys_oper_log` VALUES (252, '车队', 1, 'org.dzu.system.controller.FleetController.add()', 'POST', 1, 'admin', NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"21\",\"addtime\":\"Tue Jul 30 16:37:09 CST 2024\",\"delFlag\":0,\"editTime\":\"1\",\"fLeader\":\"12\",\"fName\":\"1\",\"id\":1,\"params\":{},\"tel\":\"123323\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:37:07', 119);
INSERT INTO `sys_oper_log` VALUES (253, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, 'admin', NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"221\",\"addtime\":\"Tue Jul 30 16:37:09 CST 2024\",\"delFlag\":0,\"editTime\":\"1\",\"fLeader\":\"12\",\"fName\":\"1\",\"id\":1,\"params\":{},\"tel\":\"123323\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:37:17', 102);
INSERT INTO `sys_oper_log` VALUES (254, '车队', 3, 'org.dzu.system.controller.FleetController.remove()', 'DELETE', 1, 'admin', NULL, '/system/fleet/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:37:23', 145);
INSERT INTO `sys_oper_log` VALUES (255, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"fName\":\"\",\"address\":\"\",\"fLeader\":\"\",\"tel\":\"\"}', NULL, 0, NULL, '2024-07-30 16:38:20', 184);
INSERT INTO `sys_oper_log` VALUES (256, '走访记录', 1, 'org.dzu.system.controller.CustomerVisitController.add()', 'POST', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 16:44:25 CST 2024\",\"delFlag\":0,\"id\":1,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:44:26', 1110);
INSERT INTO `sys_oper_log` VALUES (257, '走访记录', 3, 'org.dzu.system.controller.CustomerVisitController.remove()', 'DELETE', 1, 'admin', NULL, '/system/CustomerVisit/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:44:37', 152);
INSERT INTO `sys_oper_log` VALUES (258, '走访记录', 1, 'org.dzu.system.controller.CustomerVisitController.add()', 'POST', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 16:44:48 CST 2024\",\"delFlag\":0,\"id\":2,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:44:48', 145);
INSERT INTO `sys_oper_log` VALUES (259, '走访记录', 1, 'org.dzu.system.controller.CustomerVisitController.add()', 'POST', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 16:44:59 CST 2024\",\"delFlag\":0,\"id\":3,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:44:59', 145);
INSERT INTO `sys_oper_log` VALUES (260, '走访记录', 3, 'org.dzu.system.controller.CustomerVisitController.remove()', 'DELETE', 1, 'admin', NULL, '/system/CustomerVisit/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:45:20', 143);
INSERT INTO `sys_oper_log` VALUES (261, '加油卡信息', 1, 'org.dzu.system.controller.OilCardController.add()', 'POST', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 16:46:02 CST 2024\",\"delFlag\":0,\"id\":1,\"moneyAmount\":null,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:46:02', 147);
INSERT INTO `sys_oper_log` VALUES (262, '加油卡信息', 2, 'org.dzu.system.controller.OilCardController.edit()', 'PUT', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 16:46:02 CST 2024\",\"delFlag\":0,\"id\":1,\"moneyAmount\":300.0,\"params\":{},\"updateTime\":\"2024-07-30 16:46:14\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:46:14', 150);
INSERT INTO `sys_oper_log` VALUES (263, '加油卡信息', 3, 'org.dzu.system.controller.OilCardController.remove()', 'DELETE', 1, 'admin', NULL, '/system/oilCard/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:46:27', 147);
INSERT INTO `sys_oper_log` VALUES (264, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/fleet/index\",\"createTime\":\"2024-07-29 12:37:25\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2078,\"menuName\":\"车队管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2192,\"path\":\"fleet\",\"perms\":\"system:fleet:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:54:50', 283);
INSERT INTO `sys_oper_log` VALUES (265, '加油卡信息', 1, 'org.dzu.system.controller.OilCardController.add()', 'POST', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 16:56:05 CST 2024\",\"delFlag\":0,\"id\":2,\"moneyAmount\":null,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:56:05', 168);
INSERT INTO `sys_oper_log` VALUES (266, '加油卡信息', 2, 'org.dzu.system.controller.OilCardController.edit()', 'PUT', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 16:56:05 CST 2024\",\"delFlag\":0,\"id\":2,\"moneyAmount\":600.0,\"params\":{},\"updateTime\":\"2024-07-30 16:56:25\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:56:25', 135);
INSERT INTO `sys_oper_log` VALUES (267, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/storehouse/index\",\"createTime\":\"2024-07-29 12:37:25\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2174,\"menuName\":\"仓库管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2192,\"path\":\"storehouse\",\"perms\":\"system:storehouse:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:56:26', 187);
INSERT INTO `sys_oper_log` VALUES (268, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:55:37\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2197,\"menuName\":\"订单管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"order\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 16:58:26', 255);
INSERT INTO `sys_oper_log` VALUES (269, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"address\":\"12\",\"delFlag\":1,\"params\":{},\"storeHouseName\":\"1\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 17:04:57', 9);
INSERT INTO `sys_oper_log` VALUES (270, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"delFlag\":0,\"id\":4,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:05:04', 133);
INSERT INTO `sys_oper_log` VALUES (271, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"address\":\"12\",\"delFlag\":1,\"params\":{},\"storeHouseName\":\"1\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 17:05:12', 3);
INSERT INTO `sys_oper_log` VALUES (272, '加油卡信息', 3, 'org.dzu.system.controller.OilCardController.remove()', 'DELETE', 1, 'admin', NULL, '/system/oilCard/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:06:55', 135);
INSERT INTO `sys_oper_log` VALUES (273, '库房', 3, 'org.dzu.system.controller.StoreHouseController.remove()', 'DELETE', 1, 'admin', NULL, '/system/StoreHouse/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:07:06', 515);
INSERT INTO `sys_oper_log` VALUES (274, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, 'admin', NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"address\":\"12\",\"delFlag\":1,\"params\":{},\"storeHouseName\":\"1\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 17:07:13', 1);
INSERT INTO `sys_oper_log` VALUES (275, '加油卡信息', 1, 'org.dzu.system.controller.OilCardController.add()', 'POST', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:08:17 CST 2024\",\"delFlag\":0,\"id\":3,\"moneyAmount\":null,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:08:17', 202);
INSERT INTO `sys_oper_log` VALUES (276, '加油卡信息', 1, 'org.dzu.system.controller.OilCardController.add()', 'POST', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:08:33 CST 2024\",\"delFlag\":0,\"id\":4,\"moneyAmount\":null,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:08:33', 145);
INSERT INTO `sys_oper_log` VALUES (277, '加油卡信息', 1, 'org.dzu.system.controller.OilCardController.add()', 'POST', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:08:36 CST 2024\",\"delFlag\":0,\"id\":5,\"moneyAmount\":null,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:08:36', 139);
INSERT INTO `sys_oper_log` VALUES (278, '加油卡信息', 3, 'org.dzu.system.controller.OilCardController.remove()', 'DELETE', 1, 'admin', NULL, '/system/oilCard/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:08:41', 136);
INSERT INTO `sys_oper_log` VALUES (279, '加油卡信息', 3, 'org.dzu.system.controller.OilCardController.remove()', 'DELETE', 1, 'admin', NULL, '/system/oilCard/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:08:54', 136);
INSERT INTO `sys_oper_log` VALUES (280, '加油卡信息', 1, 'org.dzu.system.controller.OilCardController.add()', 'POST', 1, 'admin', NULL, '/system/oilCard', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:08:58 CST 2024\",\"delFlag\":0,\"id\":6,\"moneyAmount\":null,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:08:58', 133);
INSERT INTO `sys_oper_log` VALUES (281, '走访记录', 3, 'org.dzu.system.controller.CustomerVisitController.remove()', 'DELETE', 1, 'admin', NULL, '/system/CustomerVisit/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:15:33', 111);
INSERT INTO `sys_oper_log` VALUES (282, '走访记录', 1, 'org.dzu.system.controller.CustomerVisitController.add()', 'POST', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:16:08 CST 2024\",\"delFlag\":0,\"id\":4,\"params\":{},\"province\":\"山东\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:16:08', 121);
INSERT INTO `sys_oper_log` VALUES (283, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/orderlist/index\",\"createBy\":\"admin\",\"icon\":\"list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"订单列表\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2197,\"path\":\"orderlist\",\"perms\":\"order:orderlist:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:16:12', 254);
INSERT INTO `sys_oper_log` VALUES (284, '走访记录', 1, 'org.dzu.system.controller.CustomerVisitController.add()', 'POST', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:16:21 CST 2024\",\"delFlag\":0,\"id\":5,\"params\":{},\"province\":\"浙江\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:16:21', 109);
INSERT INTO `sys_oper_log` VALUES (285, '走访记录', 1, 'org.dzu.system.controller.CustomerVisitController.add()', 'POST', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:16:30 CST 2024\",\"delFlag\":0,\"id\":6,\"params\":{},\"province\":\"江西\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:16:30', 119);
INSERT INTO `sys_oper_log` VALUES (286, '走访记录', 3, 'org.dzu.system.controller.CustomerVisitController.remove()', 'DELETE', 1, 'admin', NULL, '/system/CustomerVisit/5', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:16:57', 111);
INSERT INTO `sys_oper_log` VALUES (287, '加油卡信息', 3, 'org.dzu.system.controller.OilCardController.remove()', 'DELETE', 1, 'admin', NULL, '/system/oilCard/6', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:20:20', 166);
INSERT INTO `sys_oper_log` VALUES (288, '加油卡信息', 3, 'org.dzu.system.controller.OilCardController.remove()', 'DELETE', 1, 'admin', NULL, '/system/oilCard/5', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:20:23', 109);
INSERT INTO `sys_oper_log` VALUES (289, '外部车辆信息', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, 'admin', NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:22:36 CST 2024\",\"delFlag\":0,\"id\":3,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:22:36', 140);
INSERT INTO `sys_oper_log` VALUES (290, '外部车辆信息', 3, 'org.dzu.system.controller.CarsController.remove()', 'DELETE', 1, 'admin', NULL, '/system/cars/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:22:48', 113);
INSERT INTO `sys_oper_log` VALUES (291, '外部车辆信息', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, 'admin', NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:23:46 CST 2024\",\"delFlag\":0,\"id\":4,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:23:46', 110);
INSERT INTO `sys_oper_log` VALUES (292, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/ticketPointmanagement/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"票点管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2197,\"path\":\"ticketPointmanagement\",\"perms\":\"order:ticketPointmanagement:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:23:51', 226);
INSERT INTO `sys_oper_log` VALUES (293, '外部车辆信息', 3, 'org.dzu.system.controller.CarsController.remove()', 'DELETE', 1, 'admin', NULL, '/system/cars/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:23:52', 113);
INSERT INTO `sys_oper_log` VALUES (294, '车队', 1, 'org.dzu.system.controller.FleetController.add()', 'POST', 1, 'admin', NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:24:09 CST 2024\",\"delFlag\":0,\"id\":2,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:24:09', 144);
INSERT INTO `sys_oper_log` VALUES (295, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, 'admin', NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 17:24:09 CST 2024\",\"delFlag\":0,\"id\":2,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:24:23', 117);
INSERT INTO `sys_oper_log` VALUES (296, '车队', 3, 'org.dzu.system.controller.FleetController.remove()', 'DELETE', 1, 'admin', NULL, '/system/fleet/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:24:29', 110);
INSERT INTO `sys_oper_log` VALUES (297, '走访记录', 3, 'org.dzu.system.controller.CustomerVisitController.remove()', 'DELETE', 1, 'admin', NULL, '/system/CustomerVisit/4,6', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:25:55', 117);
INSERT INTO `sys_oper_log` VALUES (298, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/generalLedger/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"票点管理-总台账\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2197,\"path\":\"generalLedger\",\"perms\":\"order:generalLedger:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:26:22', 232);
INSERT INTO `sys_oper_log` VALUES (299, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/proactivePurchasing/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"票点管理-我方主体缺票主动采购\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2207,\"path\":\"proactivePurchasing\",\"perms\":\"order:proactivePurchasing:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:28:26', 1043);
INSERT INTO `sys_oper_log` VALUES (300, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/proactivePurchasing/index\",\"createTime\":\"2024-07-30 17:28:25\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2210,\"menuName\":\"票点管理-我方主体缺票主动采购\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2207,\"path\":\"proactivePurchasing\",\"perms\":\"order:proactivePurchasing:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:28:42', 167);
INSERT INTO `sys_oper_log` VALUES (301, '菜单管理', 3, 'org.dzu.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', NULL, '/system/menu/2210', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:28:49', 218);
INSERT INTO `sys_oper_log` VALUES (302, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/proactivePurchasing/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"票点管理-我方主体缺票主动采购\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2197,\"path\":\"proactivePurchasing\",\"perms\":\"order:proactivePurchasing:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:29:56', 242);
INSERT INTO `sys_oper_log` VALUES (303, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/income/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"票点管理-收入-我方\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2197,\"path\":\"income\",\"perms\":\"order:income:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:31:19', 391);
INSERT INTO `sys_oper_log` VALUES (304, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/cost/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"票点管理-成本-客户含税部分\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2197,\"path\":\"cost\",\"perms\":\"order:cost:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:32:33', 231);
INSERT INTO `sys_oper_log` VALUES (305, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/revenueAndcosts/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"票点管理-收入和成本-第三方\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":2197,\"path\":\"revenueAndcosts\",\"perms\":\"order:revenueAndcosts:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:33:58', 227);
INSERT INTO `sys_oper_log` VALUES (306, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/purchaseOrder/index\",\"createBy\":\"admin\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"进货单\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2197,\"path\":\"purchaseOrder\",\"perms\":\"order:purchaseOrder:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:35:38', 216);
INSERT INTO `sys_oper_log` VALUES (307, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/invoice/index\",\"createBy\":\"admin\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"发货单\",\"menuType\":\"C\",\"orderNum\":9,\"params\":{},\"parentId\":2197,\"path\":\"invoice\",\"perms\":\"order:invoice:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:37:14', 226);
INSERT INTO `sys_oper_log` VALUES (308, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/adjustmentOrder/index\",\"createBy\":\"admin\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"调整单-订单\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":2197,\"path\":\"adjustmentOrder\",\"perms\":\"order:adjustmentOrder:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:38:33', 232);
INSERT INTO `sys_oper_log` VALUES (309, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/adjustmentShipping/index\",\"createBy\":\"admin\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"调整单-发货\",\"menuType\":\"C\",\"orderNum\":11,\"params\":{},\"parentId\":2197,\"path\":\"adjustmentShipping\",\"perms\":\"order:adjustmentShipping:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:39:48', 217);
INSERT INTO `sys_oper_log` VALUES (310, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/adjustmentPurchasing/index\",\"createBy\":\"admin\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"调整单-进货\",\"menuType\":\"C\",\"orderNum\":11,\"params\":{},\"parentId\":2197,\"path\":\"adjustmentPurchasing\",\"perms\":\"order：adjustmentPurchasing：list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:42:08', 221);
INSERT INTO `sys_oper_log` VALUES (311, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/stock/index\",\"createBy\":\"admin\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"库存\",\"menuType\":\"C\",\"orderNum\":12,\"params\":{},\"parentId\":2197,\"path\":\"stock\",\"perms\":\"order:stock:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:44:13', 213);
INSERT INTO `sys_oper_log` VALUES (312, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/collectionAndpayment/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"收付款\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2196,\"path\":\"collectionAndpayment\",\"perms\":\"fund:collectionAndpayment:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:47:07', 229);
INSERT INTO `sys_oper_log` VALUES (313, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/balanceDetails/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金余额明细表\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2196,\"path\":\"balanceDetails\",\"perms\":\"order:balanceDetails:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:49:24', 224);
INSERT INTO `sys_oper_log` VALUES (314, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/balanceSheet/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金余额表\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2196,\"path\":\"balanceSheet\",\"perms\":\"fund:balanceSheet:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:50:42', 248);
INSERT INTO `sys_oper_log` VALUES (315, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/commercialPaper/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"商业票据\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2196,\"path\":\"commercialPaper\",\"perms\":\"fund:commercialPaper:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:52:15', 226);
INSERT INTO `sys_oper_log` VALUES (316, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"order/assetManagement/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资产管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2196,\"path\":\"assetManagement\",\"perms\":\"order:assetManagement:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:53:55', 225);
INSERT INTO `sys_oper_log` VALUES (317, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/loanManagement/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"借贷管理\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2196,\"path\":\"loanManagement\",\"perms\":\"fund:loanManagement:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:55:36', 215);
INSERT INTO `sys_oper_log` VALUES (318, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/rebate/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商返利\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":2196,\"path\":\"rebate\",\"perms\":\"fund:rebate:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:56:57', 224);
INSERT INTO `sys_oper_log` VALUES (319, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/accountsReceivable/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"应收账款\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2196,\"path\":\"accountsReceivable\",\"perms\":\"fund:accountsReceivable:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 17:58:40', 220);
INSERT INTO `sys_oper_log` VALUES (320, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/externalBorrowing/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"我司从外面借贷\",\"menuType\":\"C\",\"orderNum\":9,\"params\":{},\"parentId\":2196,\"path\":\"externalBorrowing\",\"perms\":\"fund:externalBorrowing:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:00:21', 232);
INSERT INTO `sys_oper_log` VALUES (321, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/earnestMoney/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"期货保证金台账\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":2196,\"path\":\"earnestMoney\",\"perms\":\"fund:earnestMoney:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:01:56', 225);
INSERT INTO `sys_oper_log` VALUES (322, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"fund/borrowingFromourCompany/index\",\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"个人或公司从我司借款\",\"menuType\":\"C\",\"orderNum\":11,\"params\":{},\"parentId\":2196,\"path\":\"borrowingFromourCompany\",\"perms\":\"fund:borrowingFromourCompany:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:03:53', 222);
INSERT INTO `sys_oper_log` VALUES (323, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"客户余额管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2198,\"path\":\"customerBalance\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:31:41', 227);
INSERT INTO `sys_oper_log` VALUES (324, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:57:18\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2198,\"menuName\":\"来往管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"traffic\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:31:51', 196);
INSERT INTO `sys_oper_log` VALUES (325, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"traffic/customerBalance/index\",\"createTime\":\"2024-07-30 18:31:41\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2232,\"menuName\":\"客户余额管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2198,\"path\":\"customerBalance\",\"perms\":\"traffic:customerBalance:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:32:20', 176);
INSERT INTO `sys_oper_log` VALUES (326, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"traffic/customerDetails/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"客户明细\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2198,\"path\":\"customerDetails\",\"perms\":\"traffic:customerDetails:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:33:28', 221);
INSERT INTO `sys_oper_log` VALUES (327, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"traffic/supplierBalance/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商余额管理\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2198,\"path\":\"supplierBalance\",\"perms\":\"traffic:supplierBalance:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:35:27', 235);
INSERT INTO `sys_oper_log` VALUES (328, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"traffic/supplierDetails/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商明细\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2198,\"path\":\"supplierDetails\",\"perms\":\"traffic:supplierDetails:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:37:01', 222);
INSERT INTO `sys_oper_log` VALUES (329, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"traffic/Freight details/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"运费明细\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2198,\"path\":\"freightDetails\",\"perms\":\"traffic:freightDetails:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:38:28', 236);
INSERT INTO `sys_oper_log` VALUES (330, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"freight/order/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"订单-申请打款\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2199,\"path\":\"order\",\"perms\":\"freight:order:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:40:24', 180);
INSERT INTO `sys_oper_log` VALUES (331, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"freight/purchaseOrder/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"进货单-申请打款\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2199,\"path\":\"purchaseOrder\",\"perms\":\"freight:purchaseOrder:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:41:48', 223);
INSERT INTO `sys_oper_log` VALUES (332, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"freight/invoice/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"发货单-申请打款\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2199,\"path\":\"invoice\",\"perms\":\"freight:invoice:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:42:57', 236);
INSERT INTO `sys_oper_log` VALUES (333, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"数据统计\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2200,\"path\":\"dataStatistics\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:44:30', 165);
INSERT INTO `sys_oper_log` VALUES (334, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 09:59:51\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2200,\"menuName\":\"数据统计\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"statistics\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:44:38', 165);
INSERT INTO `sys_oper_log` VALUES (335, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistics/dataStatistics/index\",\"createTime\":\"2024-07-30 18:44:30\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2240,\"menuName\":\"数据统计\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2200,\"path\":\"dataStatistics\",\"perms\":\"statistics:dataStatistics:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:45:16', 179);
INSERT INTO `sys_oper_log` VALUES (336, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistics/fundChange /index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金变动统计\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2200,\"path\":\"fundChange \",\"perms\":\"statistics:fundChange:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:46:46', 235);
INSERT INTO `sys_oper_log` VALUES (337, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistics/totalFunds/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金总额\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2200,\"path\":\"totalFunds\",\"perms\":\"statistics:totalFunds:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:48:49', 227);
INSERT INTO `sys_oper_log` VALUES (338, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistics/fundChangestatistics2/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金变动统计2\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2200,\"path\":\"fundChangestatistics2\",\"perms\":\"statistics:fundChangestatistics2:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:50:14', 243);
INSERT INTO `sys_oper_log` VALUES (339, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistics/regionalStatistics/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"区域统计\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2200,\"path\":\"regionalStatistics\",\"perms\":\"statistics:regionalStatistics:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:51:17', 168);
INSERT INTO `sys_oper_log` VALUES (340, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistics/customerStatistics/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"客户统计\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2200,\"path\":\"customerStatistics\",\"perms\":\"statistics:customerStatistics:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:52:43', 226);
INSERT INTO `sys_oper_log` VALUES (341, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistiics/salesManagerstatistics/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"销售经理统计\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":2200,\"path\":\"salesManagerstatistics\",\"perms\":\"statistics:salesManagerstatistics:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:54:06', 232);
INSERT INTO `sys_oper_log` VALUES (342, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"statistics/notCredited /index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"当日未入账\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2200,\"path\":\"notCredited \",\"perms\":\"statistics:notCredited:list \",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:55:43', 244);
INSERT INTO `sys_oper_log` VALUES (343, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"填制凭证\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2201,\"path\":\"fillInvouchers\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:57:15', 177);
INSERT INTO `sys_oper_log` VALUES (344, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"voucher/fillInvouchers/index\",\"createTime\":\"2024-07-30 18:57:14\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2248,\"menuName\":\"填制凭证\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2201,\"path\":\"fillInvouchers\",\"perms\":\"voucher:fillInvouchers:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 18:57:50', 165);
INSERT INTO `sys_oper_log` VALUES (345, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"fName\":\"\",\"address\":\"\",\"fLeader\":\"\",\"tel\":\"\"}', NULL, 0, NULL, '2024-07-30 18:58:29', 21944);
INSERT INTO `sys_oper_log` VALUES (346, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"vouchers/queryVouchers/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"查询凭证\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2201,\"path\":\"queryVouchers\",\"perms\":\"vouchers:queryVouchers:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:00:10', 220);
INSERT INTO `sys_oper_log` VALUES (347, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"vouchers/documentGenerationvoucher/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"单据生成凭证\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2201,\"path\":\"documentGenerationvoucher\",\"perms\":\"vouchers:documentGenerationvoucher:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:01:35', 235);
INSERT INTO `sys_oper_log` VALUES (348, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商报表\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2202,\"path\":\"supplierReport\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:02:29', 174);
INSERT INTO `sys_oper_log` VALUES (349, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 10:01:42\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2202,\"menuName\":\"报表管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"reports\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:02:38', 168);
INSERT INTO `sys_oper_log` VALUES (350, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"reports/supplierReport/index\",\"createTime\":\"2024-07-30 19:02:29\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2251,\"menuName\":\"供应商报表\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2202,\"path\":\"supplierReport\",\"perms\":\"reports:supplierReport:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:03:10', 170);
INSERT INTO `sys_oper_log` VALUES (351, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"reports/supplierReport2/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商报表2\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2202,\"path\":\"supplierReport2\",\"perms\":\"reports:supplierReport2:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:04:26', 169);
INSERT INTO `sys_oper_log` VALUES (352, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"reports/customerReport/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"客户报表\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2202,\"path\":\"customerReport\",\"perms\":\"reports:customerReport:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:05:50', 233);
INSERT INTO `sys_oper_log` VALUES (353, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"reports/customerReport2/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"客户报表2\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2202,\"path\":\"customerReport2\",\"perms\":\"reports:customerReport2:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:06:30', 166);
INSERT INTO `sys_oper_log` VALUES (354, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"reports/inboundFreight /index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"运费报表\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2202,\"path\":\"inboundFreight \",\"perms\":\"reports:inboundFreight:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:07:46', 221);
INSERT INTO `sys_oper_log` VALUES (355, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"reports/financialDailyreport/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金日报表\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2202,\"path\":\"financialDailyreport\",\"perms\":\"reports:financialDailyreport:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:08:57', 215);
INSERT INTO `sys_oper_log` VALUES (356, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商日报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2203,\"path\":\"supplierDailyreport\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:10:25', 173);
INSERT INTO `sys_oper_log` VALUES (357, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/supplierDailyreport/index\",\"createTime\":\"2024-07-30 19:10:25\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2257,\"menuName\":\"供应商日报\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2203,\"path\":\"supplierDailyreport\",\"perms\":\"daily:supplierDailyreport:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:10:56', 187);
INSERT INTO `sys_oper_log` VALUES (358, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/customerDaily/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"客户日报\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2203,\"path\":\"customerDaily\",\"perms\":\"daily:customerDaily:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:11:41', 170);
INSERT INTO `sys_oper_log` VALUES (359, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/freightDailyreport/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"运费日报\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2203,\"path\":\"freightDailyreport\",\"perms\":\"daily:freightDailyreport:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:12:37', 172);
INSERT INTO `sys_oper_log` VALUES (360, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/temporaryInventory/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"暂存库存\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2203,\"path\":\"temporaryInventory\",\"perms\":\"daily:temporaryInventory:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:13:36', 171);
INSERT INTO `sys_oper_log` VALUES (361, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/shortTermborrowing/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"短期借贷\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2203,\"path\":\"shortTermborrowing\",\"perms\":\"daily:shortTermborrowing:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:14:38', 167);
INSERT INTO `sys_oper_log` VALUES (362, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/otherReceivables/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"其他应收款\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2203,\"path\":\"otherReceivables\",\"perms\":\"daily:otherReceivables:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:16:15', 230);
INSERT INTO `sys_oper_log` VALUES (363, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/dailyFinancialflowReport/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金流日报\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":2203,\"path\":\"dailyFinancialflowReport\",\"perms\":\"daily:dailyFinancialflowReport:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:17:24', 220);
INSERT INTO `sys_oper_log` VALUES (364, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"daily/dailyExpensereport/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"日常费用日报\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":2203,\"path\":\"dailyExpensereport\",\"perms\":\"daily:dailyExpensereport:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:18:27', 172);
INSERT INTO `sys_oper_log` VALUES (365, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/APPusers/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"APP用户\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2204,\"path\":\"APPusers\",\"perms\":\"business:APPusers:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:20:47', 218);
INSERT INTO `sys_oper_log` VALUES (366, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/businessTriprecords/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"出差记录\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2204,\"path\":\"businessTriprecords\",\"perms\":\"business:businessTriprecords:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:21:59', 231);
INSERT INTO `sys_oper_log` VALUES (367, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/visitRecords/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"走访记录\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2204,\"path\":\"visitRecords\",\"perms\":\"business:visitRecords:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:23:01', 184);
INSERT INTO `sys_oper_log` VALUES (368, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/vehicleManagement/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"车辆管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2204,\"path\":\"vehicleManagement\",\"perms\":\"business:vehicleManagement:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:24:09', 171);
INSERT INTO `sys_oper_log` VALUES (369, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/refuelingAuxiliarycard/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"加油副卡登记\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2204,\"path\":\"refuelingAuxiliarycard\",\"perms\":\"business:refuelingAuxiliarycard:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:25:54', 222);
INSERT INTO `sys_oper_log` VALUES (370, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/refuelingMaincard/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"加油主卡登记\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2204,\"path\":\"refuelingMaincard\",\"perms\":\"business:refuelingMaincard:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:26:58', 179);
INSERT INTO `sys_oper_log` VALUES (371, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"客户明细\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2205,\"path\":\"customerDetails\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:27:29', 176);
INSERT INTO `sys_oper_log` VALUES (372, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-30 10:05:31\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2205,\"menuName\":\"序时明细账\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"journal\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:27:41', 184);
INSERT INTO `sys_oper_log` VALUES (373, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"journal/customerDetails/index\",\"createTime\":\"2024-07-30 19:27:29\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2271,\"menuName\":\"客户明细\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2205,\"path\":\"customerDetails\",\"perms\":\"journal:customerDetails:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:28:03', 181);
INSERT INTO `sys_oper_log` VALUES (374, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"journal/supplierDetails/index\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"供应商明细\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2205,\"path\":\"supplierDetails\",\"perms\":\"journal:supplierDetails:list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 19:29:10', 221);
INSERT INTO `sys_oper_log` VALUES (375, '走访记录', 1, 'org.dzu.system.controller.CustomerVisitController.add()', 'POST', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 20:03:05 CST 2024\",\"delFlag\":0,\"id\":7,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 20:03:05', 122);
INSERT INTO `sys_oper_log` VALUES (376, '走访记录', 2, 'org.dzu.system.controller.CustomerVisitController.edit()', 'PUT', 1, 'admin', NULL, '/system/CustomerVisit', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 20:03:05 CST 2024\",\"checkState\":0,\"checkUserID\":0,\"delFlag\":0,\"id\":7,\"params\":{},\"province\":\"山东\",\"updateTime\":\"2024-07-30 20:03:18\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 20:03:18', 123);
INSERT INTO `sys_oper_log` VALUES (377, '走访记录', 3, 'org.dzu.system.controller.CustomerVisitController.remove()', 'DELETE', 1, 'admin', NULL, '/system/CustomerVisit/7', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 20:03:23', 120);
INSERT INTO `sys_oper_log` VALUES (378, '外部车辆信息', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, 'admin', NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"addtime\":\"Tue Jul 30 20:05:22 CST 2024\",\"delFlag\":0,\"id\":5,\"params\":{},\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 20:05:21', 176);
INSERT INTO `sys_oper_log` VALUES (379, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 20:52:12', 103);
INSERT INTO `sys_oper_log` VALUES (380, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 20:52:36', 94);
INSERT INTO `sys_oper_log` VALUES (381, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 20:54:35', 147);
INSERT INTO `sys_oper_log` VALUES (382, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 20:58:33', 171);
INSERT INTO `sys_oper_log` VALUES (383, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 20:58:59', 88);
INSERT INTO `sys_oper_log` VALUES (384, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"德州工商银行德州分行\",\"bankNo\":\"5622001234567120\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 20:59:07\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 20:59:05', 227);
INSERT INTO `sys_oper_log` VALUES (385, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 20:59:16', 89);
INSERT INTO `sys_oper_log` VALUES (386, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 21:00:55', 267);
INSERT INTO `sys_oper_log` VALUES (387, '库房', 5, 'org.dzu.system.controller.StoreHouseController.export()', 'POST', 1, NULL, NULL, '/system/StoreHouse/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"id\":\"\",\"delFlag\":\"\",\"storeHouseName\":\"\"}', NULL, 0, NULL, '2024-07-30 21:01:55', 81);
INSERT INTO `sys_oper_log` VALUES (388, '库房', 3, 'org.dzu.system.controller.StoreHouseController.remove()', 'DELETE', 1, NULL, NULL, '/system/StoreHouse/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:03:19', 199);
INSERT INTO `sys_oper_log` VALUES (389, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"张三\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:03:31\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:03:32', 213);
INSERT INTO `sys_oper_log` VALUES (390, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"山东省某科技有限公司\",\"address\":\"山东省济南市高新区某街道100号\",\"bankName\":\"中国工商银行济南分行\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyName\":\"山东省某科技有限公司\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":1,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"张三\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:04:44\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:04:45', 176);
INSERT INTO `sys_oper_log` VALUES (391, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 21:05:45', 146);
INSERT INTO `sys_oper_log` VALUES (392, '客户、供应商信息', 5, 'org.dzu.system.controller.CompanyController.export()', 'POST', 1, NULL, NULL, '/system/company/export', '127.0.0.1', '内网IP', '{\"leader\":\"\",\"city\":\"\",\"companyName\":\"\",\"leaderTel\":\"\",\"county\":\"\",\"remark\":\"\",\"bankName\":\"\",\"delFlag\":\"\",\"province\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"bankNo\":\"\",\"salesManager\":\"\",\"id\":\"\",\"address\":\"\",\"comments\":\"\",\"UserName\":\"\",\"companyType\":\"\",\"surplusMoney\":\"\",\"updateTime\":\"\",\"acountsName\":\"\",\"userId\":\"\",\"relationTel\":\"\",\"createBy\":\"\",\"relationName\":\"\",\"createTime\":\"\",\"addtime\":\"\",\"salesman\":\"\",\"region\":\"\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 21:06:06', 3);
INSERT INTO `sys_oper_log` VALUES (393, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"省某科技有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"\",\"bankNo\":\"5622001234567120\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:12:50\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:12:48', 136);
INSERT INTO `sys_oper_log` VALUES (394, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"某科技有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"\",\"bankNo\":\"5622001234567120\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:14:18\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:14:16', 106);
INSERT INTO `sys_oper_log` VALUES (395, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"HB6Zy%04vMmWogZ(r*pw1\",\"createTime\":\"1983-02-20 13:14:06\",\"fLeader\":\"#6BPDuU&9ui1t1vS7o*\",\"fName\":\"xcEbm]Ks9!\",\"id\":29,\"params\":{\"key\":{}},\"tel\":\"18125943942\",\"updateTime\":\"2024-04-03 02:51:56\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:16:00', 204);
INSERT INTO `sys_oper_log` VALUES (396, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"科技有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"\",\"bankNo\":\"5622001234567120\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:16:18\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:16:16', 122);
INSERT INTO `sys_oper_log` VALUES (397, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"\",\"bankNo\":\"5622001234567120\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:17:22\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:17:20', 165);
INSERT INTO `sys_oper_log` VALUES (398, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"泰安有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"\",\"bankNo\":\"5622001234567120\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"客户\",\"county\":\"高新区\",\"id\":2,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王五\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:19:31\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:19:29', 172);
INSERT INTO `sys_oper_log` VALUES (399, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"省有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"id\":4,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王6\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:21:00\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:20:58', 139);
INSERT INTO `sys_oper_log` VALUES (400, '客户、供应商信息', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, 'admin', NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"江西省有限公司\",\"address\":\"山东省德州市高新区某街道100号\",\"bankName\":\"\",\"bankNo\":\"6222001234567890\",\"city\":\"济南市\",\"comments\":\"优质客户\",\"companyType\":\"供应商\",\"county\":\"高新区\",\"id\":4,\"leader\":\"王五\",\"leaderTel\":\"13987654321\",\"params\":{},\"province\":\"山东省\",\"region\":\"山东省济南市高新区\",\"relationName\":\"王6\",\"relationTel\":\"13812345678\",\"salesManager\":\"赵六\",\"salesman\":\"李四\",\"surplusMoney\":50000.0,\"updateTime\":\"2024-07-30 21:22:00\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:21:58', 113);
INSERT INTO `sys_oper_log` VALUES (401, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"HB6Zy%04vMmWogZ(r*pw1\",\"createTime\":\"1983-02-20 13:14:06\",\"fLeader\":\"#6BPDuU&9ui1t1vS7o*\",\"fName\":\"xcEbm]Ks9!\",\"id\":29,\"params\":{\"key\":{}},\"tel\":\"18125943942\",\"updateTime\":\"2024-04-03 02:51:56\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:24:14', 20024);
INSERT INTO `sys_oper_log` VALUES (402, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"HB6Zy%04vMmWogZ(r*pw1\",\"createTime\":\"1983-02-20 13:14:06\",\"fLeader\":\"#6BPDuU&9ui1t1vS7o*\",\"fName\":\"xcEbm]Ks9!\",\"id\":29,\"params\":{\"key\":{}},\"tel\":\"18125943942\",\"updateTime\":\"2024-04-03 02:51:56\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:24:20', 112);
INSERT INTO `sys_oper_log` VALUES (403, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"HB6Zy%04vMmWogZ(r*pw1\",\"createTime\":\"1983-02-20 13:14:06\",\"fLeader\":\"#6BPDuU&9ui1t1vS7o*\",\"fName\":\"xcEbm]Ks9!\",\"id\":29,\"params\":{\"key\":{}},\"tel\":\"18125943942\",\"updateTime\":\"2024-04-03 02:51:56\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:24:32', 19378);
INSERT INTO `sys_oper_log` VALUES (404, '车队', 3, 'org.dzu.system.controller.FleetController.remove()', 'DELETE', 1, NULL, NULL, '/system/fleet/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:24:34', 126);
INSERT INTO `sys_oper_log` VALUES (405, '车队', 5, 'org.dzu.system.controller.FleetController.export()', 'POST', 1, NULL, NULL, '/system/fleet/export', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"fName\":\"\",\"address\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"fLeader\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"tel\":\"\",\"id\":\"\"}', NULL, 0, NULL, '2024-07-30 21:26:23', 173);
INSERT INTO `sys_oper_log` VALUES (406, '商业票据、银行承兑', 5, 'org.dzu.system.controller.BankAcceptanceController.export()', 'POST', 1, NULL, NULL, '/system/bankAcceptance/export', '127.0.0.1', '内网IP', '{\"reason\":\"\",\"dueDate\":\"\",\"origin\":\"\",\"remark\":\"\",\"inDiscountPoints\":\"\",\"delFlag\":\"\",\"billAmount\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"endorser\":\"\",\"id\":\"\",\"issueDate\":\"\",\"billNo\":\"\",\"endorseReason\":\"\",\"billCategory\":\"\",\"comments\":\"\",\"UserName\":\"\",\"billType\":\"\",\"updateTime\":\"\",\"billDate\":\"\",\"inDiscountAmount\":\"\",\"userId\":\"\",\"endorsee\":\"\",\"createBy\":\"\",\"billAccount\":\"\",\"createTime\":\"\",\"addtime\":\"\",\"operateDate\":\"\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 21:26:57', 2);
INSERT INTO `sys_oper_log` VALUES (407, '商业票据、银行承兑', 5, 'org.dzu.system.controller.BankAcceptanceController.export()', 'POST', 1, NULL, NULL, '/system/bankAcceptance/export', '127.0.0.1', '内网IP', '{\"reason\":\"\",\"dueDate\":\"\",\"origin\":\"\",\"remark\":\"\",\"inDiscountPoints\":\"\",\"delFlag\":\"\",\"billAmount\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"endorser\":\"\",\"id\":\"\",\"issueDate\":\"\",\"billNo\":\"\",\"endorseReason\":\"\",\"billCategory\":\"\",\"comments\":\"\",\"UserName\":\"\",\"billType\":\"\",\"updateTime\":\"\",\"billDate\":\"\",\"inDiscountAmount\":\"\",\"userId\":\"\",\"endorsee\":\"\",\"createBy\":\"\",\"billAccount\":\"\",\"createTime\":\"\",\"addtime\":\"\",\"operateDate\":\"\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 21:27:21', 6);
INSERT INTO `sys_oper_log` VALUES (408, '商业票据、银行承兑', 5, 'org.dzu.system.controller.BankAcceptanceController.export()', 'POST', 1, NULL, NULL, '/system/bankAcceptance/export', '127.0.0.1', '内网IP', '{\"reason\":\"\",\"dueDate\":\"\",\"origin\":\"\",\"remark\":\"\",\"inDiscountPoints\":\"\",\"delFlag\":\"\",\"billAmount\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"endorser\":\"\",\"id\":\"\",\"issueDate\":\"\",\"billNo\":\"\",\"endorseReason\":\"\",\"billCategory\":\"\",\"comments\":\"\",\"UserName\":\"\",\"billType\":\"\",\"updateTime\":\"\",\"billDate\":\"\",\"inDiscountAmount\":\"\",\"userId\":\"\",\"endorsee\":\"\",\"createBy\":\"\",\"billAccount\":\"\",\"createTime\":\"\",\"addtime\":\"\",\"operateDate\":\"\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 21:27:25', 1);
INSERT INTO `sys_oper_log` VALUES (409, '商业票据、银行承兑', 5, 'org.dzu.system.controller.BankAcceptanceController.export()', 'POST', 1, NULL, NULL, '/system/bankAcceptance/export', '127.0.0.1', '内网IP', '{\"endorseReason\":\"\",\"reason\":\"\",\"billCategory\":\"\",\"comments\":\"\",\"dueDate\":\"\",\"billType\":\"\",\"origin\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"billDate\":\"\",\"inDiscountPoints\":\"\",\"inDiscountAmount\":\"\",\"endorsee\":\"\",\"createBy\":\"\",\"billAmount\":\"\",\"billAccount\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"endorser\":\"\",\"id\":\"\",\"issueDate\":\"\",\"operateDate\":\"\",\"billNo\":\"\"}', NULL, 0, NULL, '2024-07-30 21:28:02', 87);
INSERT INTO `sys_oper_log` VALUES (410, '商业票据、银行承兑', 5, 'org.dzu.system.controller.BankAcceptanceController.export()', 'POST', 1, NULL, NULL, '/system/bankAcceptance/export', '127.0.0.1', '内网IP', '{\"endorseReason\":\"\",\"reason\":\"\",\"billCategory\":\"\",\"comments\":\"\",\"dueDate\":\"\",\"billType\":\"\",\"origin\":\"\",\"updateTime\":\"\",\"remark\":\"\",\"billDate\":\"\",\"inDiscountPoints\":\"\",\"inDiscountAmount\":\"\",\"endorsee\":\"\",\"createBy\":\"\",\"billAmount\":\"\",\"billAccount\":\"\",\"createTime\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"endorser\":\"\",\"id\":\"\",\"issueDate\":\"\",\"operateDate\":\"\",\"billNo\":\"\"}', NULL, 0, NULL, '2024-07-30 21:28:16', 115);
INSERT INTO `sys_oper_log` VALUES (411, '客户、供应商信息', 5, 'org.dzu.system.controller.CompanyController.export()', 'POST', 1, NULL, NULL, '/system/company/export', '127.0.0.1', '内网IP', '{\"leader\":\"\",\"city\":\"\",\"companyName\":\"\",\"leaderTel\":\"\",\"county\":\"\",\"remark\":\"\",\"bankName\":\"\",\"delFlag\":\"\",\"province\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"bankNo\":\"\",\"salesManager\":\"\",\"id\":\"\",\"address\":\"\",\"comments\":\"\",\"UserName\":\"\",\"companyType\":\"\",\"surplusMoney\":\"\",\"updateTime\":\"\",\"acountsName\":\"\",\"userId\":\"\",\"relationTel\":\"\",\"createBy\":\"\",\"relationName\":\"\",\"createTime\":\"\",\"addtime\":\"\",\"salesman\":\"\",\"region\":\"\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 21:28:36', 2);
INSERT INTO `sys_oper_log` VALUES (412, '车队', 1, 'org.dzu.system.controller.FleetController.add()', 'POST', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"&S2@gg*FVj\",\"addtime\":\"Tue Jul 30 21:31:35 CST 2024\",\"createBy\":\"Lorem dolore proident deserunt voluptate\",\"createTime\":\"2018-11-20 04:59:25\",\"delFlag\":0,\"fLeader\":\"yx*vdiv21^)p^&\",\"fName\":\"QpoVFg#w*SW#Yvv[i&\",\"id\":3,\"params\":{\"key\":{}},\"remark\":\"officia\",\"tel\":\"18638478643\",\"updateBy\":\"mollit consectetur\",\"updateTime\":\"1987-11-16 11:44:12\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:31:35', 206);
INSERT INTO `sys_oper_log` VALUES (413, '客户、供应商信息', 5, 'org.dzu.system.controller.CompanyController.export()', 'POST', 1, NULL, NULL, '/system/company/export', '127.0.0.1', '内网IP', '{\"leader\":\"\",\"city\":\"\",\"companyName\":\"\",\"leaderTel\":\"\",\"county\":\"\",\"remark\":\"\",\"bankName\":\"\",\"delFlag\":\"\",\"province\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"bankNo\":\"\",\"salesManager\":\"\",\"id\":\"\",\"address\":\"\",\"comments\":\"\",\"UserName\":\"\",\"companyType\":\"\",\"surplusMoney\":\"\",\"updateTime\":\"\",\"acountsName\":\"\",\"userId\":\"\",\"relationTel\":\"\",\"createBy\":\"\",\"relationName\":\"\",\"createTime\":\"\",\"addtime\":\"\",\"salesman\":\"\",\"region\":\"\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 21:32:41', 0);
INSERT INTO `sys_oper_log` VALUES (414, '客户、供应商信息', 5, 'org.dzu.system.controller.CompanyController.export()', 'POST', 1, NULL, NULL, '/system/company/export', '127.0.0.1', '内网IP', '{\"leader\":\"\",\"city\":\"\",\"companyName\":\"\",\"leaderTel\":\"\",\"county\":\"\",\"remark\":\"\",\"bankName\":\"\",\"delFlag\":\"\",\"province\":\"\",\"updateBy\":\"\",\"params.key.key\":\"\",\"bankNo\":\"\",\"salesManager\":\"\",\"id\":\"\",\"address\":\"\",\"comments\":\"\",\"UserName\":\"\",\"companyType\":\"\",\"surplusMoney\":\"\",\"updateTime\":\"\",\"acountsName\":\"\",\"userId\":\"\",\"relationTel\":\"\",\"createBy\":\"\",\"relationName\":\"\",\"createTime\":\"\",\"addtime\":\"\",\"salesman\":\"\",\"region\":\"\"}', NULL, 1, '非法操作！已经记录你的ip和对应操作', '2024-07-30 21:33:26', 0);
INSERT INTO `sys_oper_log` VALUES (415, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"HB6Zy%04vMmWogZ(r*pw1\",\"createTime\":\"1983-02-20 13:14:06\",\"fLeader\":\"#6BPDuU&9ui1t1vS7o*\",\"fName\":\"xcEbm]Ks9!\",\"id\":29,\"params\":{\"key\":{}},\"tel\":\"18125943942\",\"updateTime\":\"2024-04-03 02:51:56\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:33:47', 126);
INSERT INTO `sys_oper_log` VALUES (416, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"HB6Zy%04vMmWogZ(r*pw1\",\"createTime\":\"1983-02-20 13:14:06\",\"fLeader\":\"#6BPDuU&9ui1t1vS7o*\",\"fName\":\"xcEbm]Ks9!\",\"id\":29,\"params\":{\"key\":{}},\"tel\":\"18125943942\",\"updateTime\":\"2024-04-03 02:51:56\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:33:50', 133);
INSERT INTO `sys_oper_log` VALUES (417, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"jFSBv6*&i9M2S4W4v3\",\"createTime\":\"1974-08-23 01:23:06\",\"fLeader\":\"!aA#uc\",\"fName\":\"O\",\"id\":59,\"params\":{\"key\":{}},\"tel\":\"18697405894\",\"updateTime\":\"2000-01-30 07:45:41\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:35:54', 184);
INSERT INTO `sys_oper_log` VALUES (418, '车队', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"jFSBv6*&i9M2S4W4v3\",\"fLeader\":\"!aA#uc\",\"fName\":\"O\",\"id\":59,\"params\":{},\"tel\":\"18697405894\"}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-30 21:36:29', 124);
INSERT INTO `sys_oper_log` VALUES (419, '车队', 3, 'org.dzu.system.controller.FleetController.remove()', 'DELETE', 1, NULL, NULL, '/system/fleet/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:36:35', 126);
INSERT INTO `sys_oper_log` VALUES (420, '库房', 1, 'org.dzu.system.controller.StoreHouseController.add()', 'POST', 1, NULL, NULL, '/system/StoreHouse', '127.0.0.1', '内网IP', '{\"createBy\":\"in non ea laborum\",\"createTime\":\"2013-10-12 07:36:03\",\"delFlag\":0,\"id\":5,\"params\":{\"key\":{}},\"updateTime\":\"1994-02-08 07:12:56\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:37:24', 165);
INSERT INTO `sys_oper_log` VALUES (421, '库房', 3, 'org.dzu.system.controller.StoreHouseController.remove()', 'DELETE', 1, NULL, NULL, '/system/StoreHouse/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:37:47', 133);
INSERT INTO `sys_oper_log` VALUES (422, '外部车辆信息', 3, 'org.dzu.system.controller.CarsController.remove()', 'DELETE', 1, 'admin', NULL, '/system/cars/5', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-30 21:54:10', 216);

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
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-07-29 12:13:00', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2024-07-29 12:13:00', 'admin', '2024-07-30 08:45:48', '普通角色');

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
INSERT INTO `sys_role_menu` VALUES (2, 2000);
INSERT INTO `sys_role_menu` VALUES (2, 2001);
INSERT INTO `sys_role_menu` VALUES (2, 2002);
INSERT INTO `sys_role_menu` VALUES (2, 2003);
INSERT INTO `sys_role_menu` VALUES (2, 2004);
INSERT INTO `sys_role_menu` VALUES (2, 2005);
INSERT INTO `sys_role_menu` VALUES (2, 2006);
INSERT INTO `sys_role_menu` VALUES (2, 2007);
INSERT INTO `sys_role_menu` VALUES (2, 2008);
INSERT INTO `sys_role_menu` VALUES (2, 2009);
INSERT INTO `sys_role_menu` VALUES (2, 2010);
INSERT INTO `sys_role_menu` VALUES (2, 2011);
INSERT INTO `sys_role_menu` VALUES (2, 2012);
INSERT INTO `sys_role_menu` VALUES (2, 2013);
INSERT INTO `sys_role_menu` VALUES (2, 2014);
INSERT INTO `sys_role_menu` VALUES (2, 2015);
INSERT INTO `sys_role_menu` VALUES (2, 2016);
INSERT INTO `sys_role_menu` VALUES (2, 2017);
INSERT INTO `sys_role_menu` VALUES (2, 2018);
INSERT INTO `sys_role_menu` VALUES (2, 2019);
INSERT INTO `sys_role_menu` VALUES (2, 2020);
INSERT INTO `sys_role_menu` VALUES (2, 2021);
INSERT INTO `sys_role_menu` VALUES (2, 2022);
INSERT INTO `sys_role_menu` VALUES (2, 2023);
INSERT INTO `sys_role_menu` VALUES (2, 2024);
INSERT INTO `sys_role_menu` VALUES (2, 2025);
INSERT INTO `sys_role_menu` VALUES (2, 2026);
INSERT INTO `sys_role_menu` VALUES (2, 2027);
INSERT INTO `sys_role_menu` VALUES (2, 2028);
INSERT INTO `sys_role_menu` VALUES (2, 2029);
INSERT INTO `sys_role_menu` VALUES (2, 2030);
INSERT INTO `sys_role_menu` VALUES (2, 2031);
INSERT INTO `sys_role_menu` VALUES (2, 2032);
INSERT INTO `sys_role_menu` VALUES (2, 2033);
INSERT INTO `sys_role_menu` VALUES (2, 2034);
INSERT INTO `sys_role_menu` VALUES (2, 2035);
INSERT INTO `sys_role_menu` VALUES (2, 2036);
INSERT INTO `sys_role_menu` VALUES (2, 2037);
INSERT INTO `sys_role_menu` VALUES (2, 2038);
INSERT INTO `sys_role_menu` VALUES (2, 2039);
INSERT INTO `sys_role_menu` VALUES (2, 2040);
INSERT INTO `sys_role_menu` VALUES (2, 2041);
INSERT INTO `sys_role_menu` VALUES (2, 2042);
INSERT INTO `sys_role_menu` VALUES (2, 2043);
INSERT INTO `sys_role_menu` VALUES (2, 2044);
INSERT INTO `sys_role_menu` VALUES (2, 2045);
INSERT INTO `sys_role_menu` VALUES (2, 2046);
INSERT INTO `sys_role_menu` VALUES (2, 2047);
INSERT INTO `sys_role_menu` VALUES (2, 2048);
INSERT INTO `sys_role_menu` VALUES (2, 2049);
INSERT INTO `sys_role_menu` VALUES (2, 2050);
INSERT INTO `sys_role_menu` VALUES (2, 2051);
INSERT INTO `sys_role_menu` VALUES (2, 2052);
INSERT INTO `sys_role_menu` VALUES (2, 2053);
INSERT INTO `sys_role_menu` VALUES (2, 2054);
INSERT INTO `sys_role_menu` VALUES (2, 2055);
INSERT INTO `sys_role_menu` VALUES (2, 2056);
INSERT INTO `sys_role_menu` VALUES (2, 2057);
INSERT INTO `sys_role_menu` VALUES (2, 2058);
INSERT INTO `sys_role_menu` VALUES (2, 2059);
INSERT INTO `sys_role_menu` VALUES (2, 2060);
INSERT INTO `sys_role_menu` VALUES (2, 2061);
INSERT INTO `sys_role_menu` VALUES (2, 2062);
INSERT INTO `sys_role_menu` VALUES (2, 2063);
INSERT INTO `sys_role_menu` VALUES (2, 2064);
INSERT INTO `sys_role_menu` VALUES (2, 2065);
INSERT INTO `sys_role_menu` VALUES (2, 2066);
INSERT INTO `sys_role_menu` VALUES (2, 2067);
INSERT INTO `sys_role_menu` VALUES (2, 2068);
INSERT INTO `sys_role_menu` VALUES (2, 2069);
INSERT INTO `sys_role_menu` VALUES (2, 2070);
INSERT INTO `sys_role_menu` VALUES (2, 2071);
INSERT INTO `sys_role_menu` VALUES (2, 2072);
INSERT INTO `sys_role_menu` VALUES (2, 2073);
INSERT INTO `sys_role_menu` VALUES (2, 2074);
INSERT INTO `sys_role_menu` VALUES (2, 2075);
INSERT INTO `sys_role_menu` VALUES (2, 2076);
INSERT INTO `sys_role_menu` VALUES (2, 2077);
INSERT INTO `sys_role_menu` VALUES (2, 2078);
INSERT INTO `sys_role_menu` VALUES (2, 2079);
INSERT INTO `sys_role_menu` VALUES (2, 2080);
INSERT INTO `sys_role_menu` VALUES (2, 2081);
INSERT INTO `sys_role_menu` VALUES (2, 2082);
INSERT INTO `sys_role_menu` VALUES (2, 2083);
INSERT INTO `sys_role_menu` VALUES (2, 2084);
INSERT INTO `sys_role_menu` VALUES (2, 2085);
INSERT INTO `sys_role_menu` VALUES (2, 2086);
INSERT INTO `sys_role_menu` VALUES (2, 2087);
INSERT INTO `sys_role_menu` VALUES (2, 2088);
INSERT INTO `sys_role_menu` VALUES (2, 2089);
INSERT INTO `sys_role_menu` VALUES (2, 2090);
INSERT INTO `sys_role_menu` VALUES (2, 2091);
INSERT INTO `sys_role_menu` VALUES (2, 2092);
INSERT INTO `sys_role_menu` VALUES (2, 2093);
INSERT INTO `sys_role_menu` VALUES (2, 2094);
INSERT INTO `sys_role_menu` VALUES (2, 2095);
INSERT INTO `sys_role_menu` VALUES (2, 2096);
INSERT INTO `sys_role_menu` VALUES (2, 2097);
INSERT INTO `sys_role_menu` VALUES (2, 2098);
INSERT INTO `sys_role_menu` VALUES (2, 2099);
INSERT INTO `sys_role_menu` VALUES (2, 2100);
INSERT INTO `sys_role_menu` VALUES (2, 2101);
INSERT INTO `sys_role_menu` VALUES (2, 2102);
INSERT INTO `sys_role_menu` VALUES (2, 2103);
INSERT INTO `sys_role_menu` VALUES (2, 2104);
INSERT INTO `sys_role_menu` VALUES (2, 2105);
INSERT INTO `sys_role_menu` VALUES (2, 2106);
INSERT INTO `sys_role_menu` VALUES (2, 2107);
INSERT INTO `sys_role_menu` VALUES (2, 2108);
INSERT INTO `sys_role_menu` VALUES (2, 2109);
INSERT INTO `sys_role_menu` VALUES (2, 2110);
INSERT INTO `sys_role_menu` VALUES (2, 2111);
INSERT INTO `sys_role_menu` VALUES (2, 2112);
INSERT INTO `sys_role_menu` VALUES (2, 2113);
INSERT INTO `sys_role_menu` VALUES (2, 2114);
INSERT INTO `sys_role_menu` VALUES (2, 2115);
INSERT INTO `sys_role_menu` VALUES (2, 2116);
INSERT INTO `sys_role_menu` VALUES (2, 2117);
INSERT INTO `sys_role_menu` VALUES (2, 2118);
INSERT INTO `sys_role_menu` VALUES (2, 2119);
INSERT INTO `sys_role_menu` VALUES (2, 2120);
INSERT INTO `sys_role_menu` VALUES (2, 2121);
INSERT INTO `sys_role_menu` VALUES (2, 2122);
INSERT INTO `sys_role_menu` VALUES (2, 2123);
INSERT INTO `sys_role_menu` VALUES (2, 2124);
INSERT INTO `sys_role_menu` VALUES (2, 2125);
INSERT INTO `sys_role_menu` VALUES (2, 2126);
INSERT INTO `sys_role_menu` VALUES (2, 2127);
INSERT INTO `sys_role_menu` VALUES (2, 2128);
INSERT INTO `sys_role_menu` VALUES (2, 2129);
INSERT INTO `sys_role_menu` VALUES (2, 2130);
INSERT INTO `sys_role_menu` VALUES (2, 2131);
INSERT INTO `sys_role_menu` VALUES (2, 2132);
INSERT INTO `sys_role_menu` VALUES (2, 2133);
INSERT INTO `sys_role_menu` VALUES (2, 2134);
INSERT INTO `sys_role_menu` VALUES (2, 2135);
INSERT INTO `sys_role_menu` VALUES (2, 2136);
INSERT INTO `sys_role_menu` VALUES (2, 2137);
INSERT INTO `sys_role_menu` VALUES (2, 2138);
INSERT INTO `sys_role_menu` VALUES (2, 2139);
INSERT INTO `sys_role_menu` VALUES (2, 2140);
INSERT INTO `sys_role_menu` VALUES (2, 2141);
INSERT INTO `sys_role_menu` VALUES (2, 2142);
INSERT INTO `sys_role_menu` VALUES (2, 2143);
INSERT INTO `sys_role_menu` VALUES (2, 2144);
INSERT INTO `sys_role_menu` VALUES (2, 2145);
INSERT INTO `sys_role_menu` VALUES (2, 2146);
INSERT INTO `sys_role_menu` VALUES (2, 2147);
INSERT INTO `sys_role_menu` VALUES (2, 2148);
INSERT INTO `sys_role_menu` VALUES (2, 2149);
INSERT INTO `sys_role_menu` VALUES (2, 2150);
INSERT INTO `sys_role_menu` VALUES (2, 2151);
INSERT INTO `sys_role_menu` VALUES (2, 2152);
INSERT INTO `sys_role_menu` VALUES (2, 2153);
INSERT INTO `sys_role_menu` VALUES (2, 2154);
INSERT INTO `sys_role_menu` VALUES (2, 2155);
INSERT INTO `sys_role_menu` VALUES (2, 2156);
INSERT INTO `sys_role_menu` VALUES (2, 2157);
INSERT INTO `sys_role_menu` VALUES (2, 2158);
INSERT INTO `sys_role_menu` VALUES (2, 2159);
INSERT INTO `sys_role_menu` VALUES (2, 2160);
INSERT INTO `sys_role_menu` VALUES (2, 2161);
INSERT INTO `sys_role_menu` VALUES (2, 2162);
INSERT INTO `sys_role_menu` VALUES (2, 2163);
INSERT INTO `sys_role_menu` VALUES (2, 2164);
INSERT INTO `sys_role_menu` VALUES (2, 2165);
INSERT INTO `sys_role_menu` VALUES (2, 2166);
INSERT INTO `sys_role_menu` VALUES (2, 2167);
INSERT INTO `sys_role_menu` VALUES (2, 2168);
INSERT INTO `sys_role_menu` VALUES (2, 2169);
INSERT INTO `sys_role_menu` VALUES (2, 2170);
INSERT INTO `sys_role_menu` VALUES (2, 2171);
INSERT INTO `sys_role_menu` VALUES (2, 2172);
INSERT INTO `sys_role_menu` VALUES (2, 2173);
INSERT INTO `sys_role_menu` VALUES (2, 2174);
INSERT INTO `sys_role_menu` VALUES (2, 2175);
INSERT INTO `sys_role_menu` VALUES (2, 2176);
INSERT INTO `sys_role_menu` VALUES (2, 2177);
INSERT INTO `sys_role_menu` VALUES (2, 2178);
INSERT INTO `sys_role_menu` VALUES (2, 2179);
INSERT INTO `sys_role_menu` VALUES (2, 2180);
INSERT INTO `sys_role_menu` VALUES (2, 2181);
INSERT INTO `sys_role_menu` VALUES (2, 2182);
INSERT INTO `sys_role_menu` VALUES (2, 2183);
INSERT INTO `sys_role_menu` VALUES (2, 2184);
INSERT INTO `sys_role_menu` VALUES (2, 2185);
INSERT INTO `sys_role_menu` VALUES (2, 2186);
INSERT INTO `sys_role_menu` VALUES (2, 2187);
INSERT INTO `sys_role_menu` VALUES (2, 2188);
INSERT INTO `sys_role_menu` VALUES (2, 2189);
INSERT INTO `sys_role_menu` VALUES (2, 2190);
INSERT INTO `sys_role_menu` VALUES (2, 2191);
INSERT INTO `sys_role_menu` VALUES (2, 2192);
INSERT INTO `sys_role_menu` VALUES (2, 2193);

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
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '联系电话',
  `sex` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户性别（男 女 ）',
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
INSERT INTO `sys_user` VALUES (1, NULL, 'admin', 'ml', '00', '', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-07-30 22:00:22', '', NULL, '', '2024-07-30 22:00:19', NULL, 'maolei', '职称', '1', '', '2020200202020202', '15277777777', '1', '阿瓦达', 'awsd 阿瓦达', 'asd ', '阿斯顿', '撒支持', '设置XC', 'awd ', '123123', '阿瓦达', '阿瓦撒旦', '阿瓦撒旦', ' 大物大晚上的', '阿瓦撒旦', '阿斯顿我', '2020020202020202');
INSERT INTO `sys_user` VALUES (2, NULL, 'common', 'ml', '00', '', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-07-30 09:04:30', '', NULL, '', '2024-07-30 09:04:33', NULL, 'maolei', '职称', '1', '', '2020200202020202', '15277777777', '1', '阿瓦达', 'awsd 阿瓦达', 'asd ', '阿斯顿', '撒支持', '设置XC', 'awd ', '123123', '阿瓦达', '阿瓦撒旦', '阿瓦撒旦', ' 大物大晚上的', '阿瓦撒旦', '阿斯顿我', '2020020202020202');

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
-- Table structure for tableEditMessage
-- ----------------------------
DROP TABLE IF EXISTS `tableEditMessage`;
CREATE TABLE `tableEditMessage`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tableName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表名',
  `modifyTime` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改时间',
  `reason` varchar(280) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改原因',
  `tid` int(11) NULL DEFAULT 0 COMMENT '修改表对应信息的id',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '表编辑原因' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tableEditMessage
-- ----------------------------

-- ----------------------------
-- Table structure for tripReimbursement
-- ----------------------------
DROP TABLE IF EXISTS `tripReimbursement`;
CREATE TABLE `tripReimbursement`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bTripId` int(11) NULL DEFAULT 0 COMMENT '出差ID',
  `item` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报销项',
  `itemCost` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '费用',
  `comments` varchar(550) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出差报销' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tripReimbursement
-- ----------------------------

-- ----------------------------
-- Table structure for virtualBankAccountChange
-- ----------------------------
DROP TABLE IF EXISTS `virtualBankAccountChange`;
CREATE TABLE `virtualBankAccountChange`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companyId` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司ID',
  `tableName` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发生操作行为的表',
  `payNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发生操作行为的冲抵款编号（UUID）',
  `operateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `changeType` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '变动类型（收入、支出）',
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '虚拟银行账号' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of virtualBankAccountChange
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
