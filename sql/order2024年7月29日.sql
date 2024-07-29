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

 Date: 29/07/2024 11:59:30
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
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `company` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方公司',
  `companyID` int(11) NULL DEFAULT NULL COMMENT '对方公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '对方公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平账' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商业票据、银行承兑' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of bankacceptance
-- ----------------------------

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
  `amount` double NULL DEFAULT 0 COMMENT '当前资金额',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1652 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '银行卡管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of bankaccount
-- ----------------------------
INSERT INTO `bankaccount` VALUES (1647, '毛磊2', 10, '农商银行', '毛磊账户', '银行账号', '客户', 'elit consequat exercitation', 1231231.12, 1);
INSERT INTO `bankaccount` VALUES (1648, '毛磊', 10, '农商银行', '毛磊账户', '银行账号', '客户', 'elit consequat exercitation', 1231231.12, 0);
INSERT INTO `bankaccount` VALUES (1649, '毛司机', 1, '工商银行', '213421341364', NULL, '司机', NULL, 0, 0);
INSERT INTO `bankaccount` VALUES (1650, '毛司机', 2, '工商银行', '213421341364', NULL, '司机', NULL, 0, 0);
INSERT INTO `bankaccount` VALUES (1651, '毛司机', 3, '工商银行', '213421341364', NULL, '司机', NULL, 0, 0);

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
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '银行卡资金变动' ROW_FORMAT = DYNAMIC;

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
  `moneyAmount` double NULL DEFAULT 0 COMMENT '借入金额',
  `ratio` double NULL DEFAULT 0 COMMENT '贷款利率',
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
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从外部借入款、贷款' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出差登记' ROW_FORMAT = DYNAMIC;

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
) ENGINE = MyISAM AUTO_INCREMENT = 85 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车辆派出管理' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车辆管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cars
-- ----------------------------
INSERT INTO `cars` VALUES (1, NULL, '毛司机', '18632024906', '工商银行', '213421341364', '2134123412341234', 1, '海运', '2024-07-20 11:44:40', 1, NULL, '2024-07-20 11:51:48', 0);
INSERT INTO `cars` VALUES (2, NULL, '毛司机', '18632024906', '工商银行', '213421341364', '2134123412341234', 1, '陆运', '2024-07-20 11:45:25', 1, NULL, NULL, 0);
INSERT INTO `cars` VALUES (3, '123123123', '毛司机', '18632024906', '工商银行', '213421341364', '2134123412341234', 1, '陆运', '2024-07-20 11:50:11', 1, NULL, NULL, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of company
-- ----------------------------
INSERT INTO `company` VALUES (1, '毛磊2测试', '新志体最办许关', '18157849887', '黑龙江省白城市深坑区', '干内装委史', '先气增海报过', 'consectetur', 123457000, '客户', 'laboris', NULL, '18148469617', '湖南省-苏州市=enim ea ullamco pariatur officia', NULL, '湖南省', '苏州市', 'enim ea ullamco pariatur officia', 'fugiat', '2024-07-19 21:41:49', 1, NULL, '2024-07-19 21:41:49', 0);
INSERT INTO `company` VALUES (2, '毛磊测试', '新志体最办许关', '18157849887', '黑龙江省白城市深坑区', '干内装委史', '先气增海报过', 'consectetur', 123457000, '客户', 'laboris', NULL, '18148469617', '湖南省-苏州市=ml村', NULL, '湖南省', '苏州市', 'ml村', 'fugiat', '2024-07-20 07:52:29', 1, NULL, NULL, 0);
INSERT INTO `company` VALUES (3, '毛磊测试', '新志体最办许关', '18157849887', '黑龙江省白城市深坑区', '干内装委史', '先气增海报过', 'consectetur', 1239.39, '客户', 'laboris', NULL, '18148469617', '湖南省-苏州市=ml村', NULL, '湖南省', '苏州市', 'ml村', 'fugiat', '2024-07-20 08:46:09', 1, NULL, NULL, 0);
INSERT INTO `company` VALUES (4, '毛磊测试', '新志体最办许关', '18157849887', '黑龙江省白城市深坑区', '干内装委史', '先气增海报过', 'consectetur', 1239.39, '客户', 'laboris', NULL, '18148469617', '湖南省-苏州市=ml村', NULL, '湖南省', '苏州市', 'ml村', 'fugiat', '2024-07-20 08:49:11', 1, NULL, NULL, 0);
INSERT INTO `company` VALUES (5, '毛磊测试', '新志体最办许关', '18157849887', '黑龙江省白城市深坑区', '干内装委史', '先气增海报过', 'consectetur', 1234567891111.39, '客户', 'laboris', NULL, '18148469617', '湖南省-苏州市=ml村', NULL, '湖南省', '苏州市', 'ml村', 'fugiat', '2024-07-20 08:49:22', 1, NULL, NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '走访记录' ROW_FORMAT = DYNAMIC;

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
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '固定资产' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车队管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of fleet
-- ----------------------------
INSERT INTO `fleet` VALUES (1, '毛家军', '毛磊', '18197761021', '湖北省阿坝藏族羌族自治州-', '2024-07-20 12:14:08', '2024-07-20 12:16:46', 1);
INSERT INTO `fleet` VALUES (2, '毛家队', '毛磊', '18197761021', '湖北省阿坝藏族羌族自治州-', '2024-07-20 12:15:52', NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 287 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (253, 'balanceaccounts', '平账', NULL, NULL, 'Balanceaccounts', 'crud', '', 'org.dzu.system', 'system', 'balanceaccounts', '平账', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:14', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (254, 'bankacceptance', '商业票据、银行承兑', NULL, NULL, 'Bankacceptance', 'crud', '', 'org.dzu.system', 'system', 'bankacceptance', '商业票据、银行承兑', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:16', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (255, 'bankaccount', '银行卡管理', NULL, NULL, 'Bankaccount', 'crud', '', 'org.dzu.system', 'system', 'bankaccount', '银行卡管理', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:19', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (256, 'bankaccountchange', '银行卡资金变动', NULL, NULL, 'Bankaccountchange', 'crud', '', 'org.dzu.system', 'system', 'bankaccountchange', '银行卡资金变动', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:20', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (257, 'borrowedmoney', '从外部借入款、贷款', NULL, NULL, 'Borrowedmoney', 'crud', '', 'org.dzu.system', 'system', 'borrowedmoney', '从外部借入款、贷款', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:22', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (258, 'businesstrip', '出差登记', NULL, NULL, 'Businesstrip', 'crud', '', 'org.dzu.system', 'system', 'businesstrip', '出差登记', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:24', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (259, 'carapply', '车辆派出管理', NULL, NULL, 'Carapply', 'crud', '', 'org.dzu.system', 'system', 'carapply', '车辆派出管理', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:27', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (260, 'cars', '车辆管理', NULL, NULL, 'Cars', 'crud', '', 'org.dzu.system', 'system', 'cars', '车辆管理', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:31', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (261, 'company', '客户管理', NULL, NULL, 'Company', 'crud', '', 'org.dzu.system', 'system', 'company', '客户管理', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:33', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (262, 'customervisit', '走访记录', NULL, NULL, 'Customervisit', 'crud', '', 'org.dzu.system', 'system', 'customervisit', '走访记录', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:37', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (263, 'exwarehouse', '出库', NULL, NULL, 'Exwarehouse', 'crud', '', 'org.dzu.system', 'system', 'exwarehouse', '出库', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:40', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (264, 'fixedassets', '固定资产', NULL, NULL, 'Fixedassets', 'crud', '', 'org.dzu.system', 'system', 'fixedassets', '固定资产', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:42', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (265, 'fleet', '车队管理', NULL, NULL, 'Fleet', 'crud', '', 'org.dzu.system', 'system', 'fleet', '车队管理', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:44', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (266, 'goodsorder', '订单', NULL, NULL, 'Goodsorder', 'crud', '', 'org.dzu.system', 'system', 'goodsorder', '订单', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:46', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (267, 'goodsorder_back', '订单备份信息', NULL, NULL, 'GoodsorderBack', 'crud', 'element-ui', 'org.dzu.system', 'system', 'GoodsorderBack', '订单备份信息', 'ml', '0', '/', '{}', 'admin', '2024-07-29 08:33:51', '', '2024-07-29 11:21:28', NULL);
INSERT INTO `gen_table` VALUES (268, 'inventory', '货物入库', NULL, NULL, 'Inventory', 'crud', '', 'org.dzu.system', 'system', 'inventory', '货物入库', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:33:56', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (269, 'inventory_back', '货物入库信息', NULL, NULL, 'InventoryBack', 'crud', 'element-ui', 'org.dzu.system', 'system', 'InventoryBack', '货物入库信息', 'ml', '0', '/', '{}', 'admin', '2024-07-29 08:34:03', '', '2024-07-29 11:21:49', NULL);
INSERT INTO `gen_table` VALUES (270, 'lendmoney', '资金借出（期货）', NULL, NULL, 'Lendmoney', 'crud', '', 'org.dzu.system', 'system', 'lendmoney', '资金借出（期货）', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (271, 'offsetting', '资金调整单信息', NULL, NULL, 'Offsetting', 'crud', '', 'org.dzu.system', 'system', 'offsetting', '资金调整单信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:13', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (272, 'oilcard', '加油卡', NULL, NULL, 'Oilcard', 'crud', '', 'org.dzu.system', 'system', 'oilcard', '加油卡', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:15', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (273, 'oilcardmain', '基础信息-加油卡主卡登记', NULL, NULL, 'Oilcardmain', 'crud', '', 'org.dzu.system', 'system', 'oilcardmain', '基础信息-加油卡主卡登记', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:16', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (274, 'orderdetail', '订单详情', NULL, NULL, 'Orderdetail', 'crud', '', 'org.dzu.system', 'system', 'orderdetail', '订单详情', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:19', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (275, 'orderdetail_back', '订单详情备份', NULL, NULL, 'OrderdetailBack', 'crud', 'element-ui', 'org.dzu.system', 'system', 'OrderdetailBack', '订单详情备份', 'ml', '0', '/', '{}', 'admin', '2024-07-29 08:34:25', '', '2024-07-29 11:20:56', NULL);
INSERT INTO `gen_table` VALUES (276, 'orderfreight', '订单运费', NULL, NULL, 'Orderfreight', 'crud', '', 'org.dzu.system', 'system', 'orderfreight', '订单运费', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:32', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (277, 'orderinvoice', '订单发票', NULL, NULL, 'Orderinvoice', 'crud', '', 'org.dzu.system', 'system', 'orderinvoice', '订单发票', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:36', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (278, 'payment', '资产管理-收付款:收付款信息', NULL, NULL, 'Payment', 'crud', '', 'org.dzu.system', 'system', 'payment', '资产管理-收付款:收付款信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:38', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (279, 'productlevel', '产品级别管理', NULL, NULL, 'Productlevel', 'crud', '', 'org.dzu.system', 'system', 'productlevel', '产品级别管理', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:41', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (280, 'rebate', '供应商返利', NULL, NULL, 'Rebate', 'crud', '', 'org.dzu.system', 'system', 'rebate', '供应商返利', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:43', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (281, 'recovermoney', '资金回收', NULL, NULL, 'Recovermoney', 'crud', '', 'org.dzu.system', 'system', 'recovermoney', '资金回收', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:46', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (282, 'repayment', '还款记录', NULL, NULL, 'Repayment', 'crud', '', 'org.dzu.system', 'system', 'repayment', '还款记录', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:48', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (283, 'socialinsurance', '社保基金', NULL, NULL, 'Socialinsurance', 'crud', '', 'org.dzu.system', 'system', 'socialinsurance', '社保基金', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:50', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (284, 'storehouse', '仓库管理', NULL, NULL, 'Storehouse', 'crud', '', 'org.dzu.system', 'system', 'storehouse', '仓库管理', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (285, 'tableeditmessage', '表变动日志信息', NULL, NULL, 'Tableeditmessage', 'crud', '', 'org.dzu.system', 'system', 'tableeditmessage', '变动日志信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:54', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (286, 'virtualbankaccountchange', '虚拟银行账户变动信息', NULL, NULL, 'Virtualbankaccountchange', 'crud', '', 'org.dzu.system', 'system', 'virtualbankaccountchange', '虚拟银行账户变动信息', 'ml', '0', '/', NULL, 'admin', '2024-07-29 08:34:55', '', NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 6060 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (5317, 253, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5318, 253, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5319, 253, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5320, 253, 'company', '对方公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5321, 253, 'companyID', '对方公司ID', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5322, 253, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5323, 253, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5324, 253, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5325, 253, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5326, 253, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5327, 253, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5328, 253, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5329, 254, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5330, 254, 'operateDate', '操作日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5331, 254, 'billNo', '票据号码', 'varchar(55)', 'String', 'billNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5332, 254, 'issueDate', '出票日期', 'varchar(50)', 'String', 'issueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5333, 254, 'dueDate', '到期日期', 'varchar(50)', 'String', 'dueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5334, 254, 'billAccount', '我方承兑账户', 'varchar(50)', 'String', 'billAccount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5335, 254, 'billDate', '票据日期', 'varchar(50)', 'String', 'billDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5336, 254, 'billType', '分类（收入、支出）', 'varchar(55)', 'String', 'billType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-29 08:33:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5337, 254, 'reason', '事由', 'varchar(155)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5338, 254, 'billAmount', '票据金额', 'double', 'Double', 'billAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5339, 254, 'inDiscountPoints', '贴息点数', 'double', 'Double', 'inDiscountPoints', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5340, 254, 'inDiscountAmount', '贴息金额', 'double', 'Double', 'inDiscountAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5341, 254, 'billCategory', '票据种类（电子/纸质）', 'varchar(55)', 'String', 'billCategory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5342, 254, 'origin', '来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5343, 254, 'endorser', '背书人', 'varchar(155)', 'String', 'endorser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5344, 254, 'endorsee', '被背书人', 'varchar(155)', 'String', 'endorsee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5345, 254, 'endorseReason', '背书事由（出卖/付货款）', 'varchar(255)', 'String', 'endorseReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5346, 254, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5347, 254, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5348, 254, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5349, 254, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-29 08:33:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5350, 254, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-29 08:33:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5351, 254, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:33:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5352, 255, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5353, 255, 'companyName', '公司名称', 'varchar(50)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 08:33:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5354, 255, 'companyId', '对应公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5355, 255, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 08:33:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5356, 255, 'acountsName', '开户名称', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 08:33:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5357, 255, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5358, 255, 'acountsType', '账户类型（己方公司，客户，供应商，司机，其它）', 'varchar(50)', 'String', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 7, 'admin', '2024-07-29 08:33:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5359, 255, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5360, 255, 'amount', '当前资金额', 'double', 'Double', 'amount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5361, 255, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5362, 256, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5363, 256, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5364, 256, 'tableName', '发生操作行为的表', 'varchar(80)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5365, 256, 'payNO', '发生操作行为的付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5366, 256, 'operateDate', '日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5367, 256, 'changeType', '变动类型（收入、支出）', 'varchar(15)', 'String', 'changeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5368, 256, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5369, 256, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5370, 256, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5371, 256, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5372, 256, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 08:33:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5373, 256, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-29 08:33:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5374, 257, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5375, 257, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5376, 257, 'origin', '贷款来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5377, 257, 'moneyAmount', '借入金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5378, 257, 'ratio', '贷款利率', 'double', 'Double', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5379, 257, 'loanDate', '贷款发放日期', 'varchar(50)', 'String', 'loanDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5380, 257, 'loanDuring', '贷款年限（年）', 'varchar(50)', 'String', 'loanDuring', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5381, 257, 'mortgageGuarantee', '抵押担保', 'varchar(200)', 'String', 'mortgageGuarantee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5382, 257, 'acountsName', '打入账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5383, 257, 'bankNo', '打入账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5384, 257, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5385, 257, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5386, 257, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5387, 257, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-29 08:33:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5388, 257, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2024-07-29 08:33:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5389, 257, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5390, 258, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5391, 258, 'personnel', '出差人员', 'varchar(150)', 'String', 'personnel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5392, 258, 'starttime', '出差时间', 'varchar(50)', 'String', 'starttime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5393, 258, 'startMilesPhoto', '出发里程拍照', 'varchar(250)', 'String', 'startMilesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5394, 258, 'refuelPhoto', '加油拍照', 'varchar(250)', 'String', 'refuelPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5395, 258, 'endtime', '出差结束时间', 'varchar(50)', 'String', 'endtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5396, 258, 'endMilesPhoto', '结束里程拍照', 'varchar(250)', 'String', 'endMilesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5397, 258, 'feesPhoto', '出差费用拍照', 'varchar(250)', 'String', 'feesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (5398, 258, 'isReimburse', '是否已报销（0未报销，1已报销）', 'int(11)', 'Long', 'isReimburse', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (5399, 258, 'comments', '备注', 'varchar(550)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 10, 'admin', '2024-07-29 08:33:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (5400, 258, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (5401, 258, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (5402, 258, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-29 08:33:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (5403, 258, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2024-07-29 08:33:26', '', NULL);
INSERT INTO `gen_table_column` VALUES (5404, 258, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (5405, 259, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (5406, 259, 'applyDate', '申请时间', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (5407, 259, 'applyUser', '申请人', 'varchar(25)', 'String', 'applyUser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (5408, 259, 'department', '部门', 'varchar(25)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (5409, 259, 'carNo', '车牌', 'varchar(20)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:27', '', NULL);
INSERT INTO `gen_table_column` VALUES (5410, 259, 'isUseOilCard', '是否携带油卡', 'int(11)', 'Long', 'isUseOilCard', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5411, 259, 'iolCardNo', '油卡号', 'varchar(55)', 'String', 'iolCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5412, 259, 'peers', '随同乘车人员', 'varchar(155)', 'String', 'peers', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5413, 259, 'startTime', '用车时间', 'varchar(55)', 'String', 'startTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5414, 259, 'endTime', '还车时间', 'varchar(55)', 'String', 'endTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5415, 259, 'ApplyPurpose', '用车事由', 'varchar(255)', 'String', 'ApplyPurpose', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5416, 259, 'startMile', '出车前里程', 'varchar(55)', 'String', 'startMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5417, 259, 'startCarState', '出车前车况（外观是否损坏，车胎等）', 'varchar(155)', 'String', 'startCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:28', '', NULL);
INSERT INTO `gen_table_column` VALUES (5418, 259, 'endMile', '回来后里程', 'varchar(55)', 'String', 'endMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5419, 259, 'endCarState', '回来后车况（外观是否损坏，车胎等）', 'varchar(255)', 'String', 'endCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5420, 259, 'miles', '用车里程数', 'varchar(55)', 'String', 'miles', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5421, 259, 'backStopPlace', '回程停靠位置', 'varchar(155)', 'String', 'backStopPlace', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5422, 259, 'violationsCount', '行程中违法次数', 'varchar(15)', 'String', 'violationsCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5423, 259, 'fine', '违章罚款金额金额', 'varchar(25)', 'String', 'fine', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5424, 259, 'isMaintenance', '行程中是否维修/保养', 'varchar(5)', 'String', 'isMaintenance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5425, 259, 'maintenanceMoney', '保养金额', 'varchar(15)', 'String', 'maintenanceMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:33:29', '', NULL);
INSERT INTO `gen_table_column` VALUES (5426, 259, 'refuelingFrequency', '行程中使用加油卡加油次数', 'varchar(15)', 'String', 'refuelingFrequency', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (5427, 259, 'refuelingMoney', '加油金额', 'varchar(25)', 'String', 'refuelingMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (5428, 259, 'oilCardSurplus', '加油卡余额', 'varchar(25)', 'String', 'oilCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 08:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (5429, 259, 'isOilTicket', '加油小票记录是否交给公司管理车辆人员', 'varchar(5)', 'String', 'isOilTicket', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (5430, 259, 'refuelingCash', '现金加油金额', 'varchar(25)', 'String', 'refuelingCash', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (5431, 259, 'dispatchPerson', '派车人', 'varchar(25)', 'String', 'dispatchPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 08:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (5432, 259, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 08:33:30', '', NULL);
INSERT INTO `gen_table_column` VALUES (5433, 259, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 08:33:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (5434, 259, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 08:33:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (5435, 259, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 31, 'admin', '2024-07-29 08:33:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (5436, 259, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 32, 'admin', '2024-07-29 08:33:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (5437, 259, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 08:33:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (5438, 259, 'path', '附件路径', 'varchar(255)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 08:33:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (5439, 260, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:31', '', NULL);
INSERT INTO `gen_table_column` VALUES (5440, 260, 'carNo', '车牌', 'varchar(20)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5441, 260, 'driver', '司机', 'varchar(20)', 'String', 'driver', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5442, 260, 'tel', '司机电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5443, 260, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 08:33:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5444, 260, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 08:33:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5445, 260, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5446, 260, 'acountsType', '账号类型（1收款，2付款）', 'int(11)', 'Long', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-29 08:33:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5447, 260, 'carType', '运输类型(陆运，海运)', 'varchar(50)', 'String', 'carType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 9, 'admin', '2024-07-29 08:33:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5448, 260, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5449, 260, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5450, 260, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 08:33:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5451, 260, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 08:33:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5452, 260, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5453, 261, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5454, 261, 'company', '公司', 'varchar(550)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 2, 'admin', '2024-07-29 08:33:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5455, 261, 'relationName', '联系人', 'varchar(50)', 'String', 'relationName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 08:33:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5456, 261, 'relationTel', '联系人电话', 'varchar(30)', 'String', 'relationTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5457, 261, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5458, 261, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 08:33:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5459, 261, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 08:33:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5460, 261, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5461, 261, 'surplusMoney', '余额', 'double', 'Double', 'surplusMoney', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5462, 261, 'companyType', '客户类别（ 客户，供应商）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 10, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5463, 261, 'salesman', '业务员', 'varchar(55)', 'String', 'salesman', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5464, 261, 'leader', '老板', 'varchar(50)', 'String', 'leader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5465, 261, 'leaderTel', '联系人电话', 'varchar(30)', 'String', 'leaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5466, 261, 'region', '区域（省+市县+乡镇）', 'varchar(280)', 'String', 'region', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5467, 261, 'salesManager', '销售经理', 'varchar(55)', 'String', 'salesManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5468, 261, 'province', '省', 'varchar(55)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5469, 261, 'city', '市县', 'varchar(155)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5470, 261, 'county', '乡镇', 'varchar(155)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5471, 261, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5472, 261, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5473, 261, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5474, 261, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5475, 261, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 23, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5476, 261, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 08:33:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5477, 262, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5478, 262, 'province', '省', 'varchar(50)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5479, 262, 'city', '市县', 'varchar(50)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5480, 262, 'county', '乡镇（街道）', 'varchar(100)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5481, 262, 'customer', '客户', 'varchar(550)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2024-07-29 08:33:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5482, 262, 'leaderName', '负责人', 'varchar(550)', 'String', 'leaderName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 6, 'admin', '2024-07-29 08:33:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5483, 262, 'LeaderTel', '负责人电话', 'varchar(550)', 'String', 'LeaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 7, 'admin', '2024-07-29 08:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5484, 262, 'equipment', '厂房设备', 'varchar(200)', 'String', 'equipment', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5485, 262, 'competitor', '竞争对手', 'varchar(200)', 'String', 'competitor', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5486, 262, 'localDealer', '当地经销商', 'varchar(200)', 'String', 'localDealer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5487, 262, 'monthlyConsumption', '月用货量（车数）', 'varchar(200)', 'String', 'monthlyConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5488, 262, 'whiteGlassFactory', '白玻用货习惯及厂家', 'varchar(200)', 'String', 'whiteGlassFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5489, 262, 'loweGlassConsumption', 'lowe玻璃用货厂家及用量', 'varchar(200)', 'String', 'loweGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5490, 262, 'colorGlassConsumption', '色玻、过度色玻璃用货厂家及用量', 'varchar(200)', 'String', 'colorGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5491, 262, 'specialGlassConsumption', '特色厚度、特殊尺寸、协议品用货厂家及用量', 'varchar(200)', 'String', 'specialGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5492, 262, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5493, 262, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5494, 262, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5495, 262, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5496, 262, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 20, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5497, 262, 'visitDate', '走访日期', 'varchar(50)', 'String', 'visitDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:33:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5498, 262, 'checkState', '审核标志', 'int(11)', 'Long', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:33:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5499, 262, 'checkUserID', '审核人ID', 'int(11)', 'Long', 'checkUserID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:33:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5500, 262, 'checkUserName', '审核人', 'varchar(50)', 'String', 'checkUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-29 08:33:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5501, 262, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:33:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5502, 263, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5503, 263, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5504, 263, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5505, 263, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5506, 263, 'outDate', '出库日期', 'varchar(50)', 'String', 'outDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5507, 263, 'outAmount', '出库量（片数）', 'int(11)', 'Long', 'outAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5508, 263, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5509, 263, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5510, 263, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5511, 263, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5512, 263, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5513, 263, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 08:33:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5514, 264, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5515, 264, 'buyDate', '购入日期', 'varchar(50)', 'String', 'buyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5516, 264, 'assetNo', '资产编号', 'varchar(55)', 'String', 'assetNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5517, 264, 'assetName', '资产名称', 'varchar(155)', 'String', 'assetName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 08:33:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5518, 264, ' specification', '规格型号（车牌号）', 'varchar(100)', 'String', ' specification', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5519, 264, 'number', '数量', 'varchar(20)', 'String', 'number', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5520, 264, 'measurementUnit ', '计量单位', 'varchar(55)', 'String', 'measurementUnit ', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5521, 264, 'amountIncludeTax', '含税金额', 'double', 'Double', 'amountIncludeTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5522, 264, 'amountNoTax', '不含税金额', 'double', 'Double', 'amountNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5523, 264, 'account', '户名名称（公户/个人）', 'varchar(55)', 'String', 'account', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5524, 264, 'department', '使用部门', 'varchar(55)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5525, 264, 'scrapDate', '固定资产清理时间', 'varchar(50)', 'String', 'scrapDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5526, 264, 'saleAmount', '清理/变卖价值', 'double', 'Double', 'saleAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5527, 264, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5528, 264, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5529, 264, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5530, 264, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-29 08:33:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5531, 264, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-29 08:33:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5532, 264, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:33:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5533, 265, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5534, 265, 'fName', '车队名称', 'varchar(50)', 'String', 'fName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 08:33:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5535, 265, 'fLeader', '车队经理', 'varchar(50)', 'String', 'fLeader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5536, 265, 'tel', '车队经理电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5537, 265, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5538, 265, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5539, 265, 'editTime', '编辑时间', 'varchar(55)', 'String', 'editTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5540, 265, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5541, 266, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5542, 266, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5543, 266, 'orderDate', '日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5544, 266, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5545, 266, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5546, 266, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5547, 266, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5548, 266, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5549, 266, 'landDriverName', '陆地司机姓名', 'varchar(55)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5550, 266, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5551, 266, 'seaCarNo', '海运车牌', 'varchar(50)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5552, 266, 'seaDriverTel', '海运司机电话', 'varchar(50)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5553, 266, 'seaDriverName', '海运司机姓名', 'varchar(55)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-29 08:33:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5554, 266, 'checkUserId', '审核人编号', 'int(11)', 'Long', 'checkUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5555, 266, 'checkState', '审核状态（已审核、未审核）', 'varchar(20)', 'String', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5556, 266, 'invoiceState', '开票状态（未开票，部分开票，已开票）', 'varchar(20)', 'String', 'invoiceState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5557, 266, 'path', '附件路径', 'varchar(250)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:33:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5558, 266, 'PaymentState', '打款状态(申请中，已打款，未打款)', 'varchar(20)', 'String', 'PaymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:33:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5559, 266, 'landBankName', '陆运银行户名', 'varchar(50)', 'String', 'landBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-29 08:33:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5560, 266, 'landBankNo', '陆运银行账号', 'varchar(50)', 'String', 'landBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:33:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5561, 266, 'seaBankName', '海运银行户名', 'varchar(50)', 'String', 'seaBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5562, 266, 'seaBankNo', '海运银行账号', 'varchar(50)', 'String', 'seaBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5563, 266, 'receiveProof', '收到条附件路径', 'text', 'String', 'receiveProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 23, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5564, 266, 'saleManager', '销售经理', 'varchar(25)', 'String', 'saleManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5565, 266, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5566, 266, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5567, 266, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5568, 266, 'isAdjust', '是否调整单（是  否）', 'varchar(10)', 'String', 'isAdjust', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 08:33:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (5569, 266, 'adjustOrderid', '原订单编号', 'int(11)', 'Long', 'adjustOrderid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5570, 266, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5571, 266, 'customerIsInvoice', '客户是否开票', 'int(11)', 'Long', 'customerIsInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5572, 266, 'isSupplierInvoice', '供应商是否开票', 'int(11)', 'Long', 'isSupplierInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5573, 266, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5574, 266, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5575, 266, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5576, 266, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 08:33:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (5577, 266, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 37, 'admin', '2024-07-29 08:33:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (5578, 266, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 38, 'admin', '2024-07-29 08:33:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (5579, 267, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:51', '', '2024-07-29 11:21:29');
INSERT INTO `gen_table_column` VALUES (5580, 267, 'goodsOrderID', '原订单ID', 'int(11)', 'Long', 'goodsOrderID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:51', '', '2024-07-29 11:21:29');
INSERT INTO `gen_table_column` VALUES (5581, 267, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:33:51', '', '2024-07-29 11:21:29');
INSERT INTO `gen_table_column` VALUES (5582, 267, 'orderDate', '日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:51', '', '2024-07-29 11:21:29');
INSERT INTO `gen_table_column` VALUES (5583, 267, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:52', '', '2024-07-29 11:21:29');
INSERT INTO `gen_table_column` VALUES (5584, 267, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:52', '', '2024-07-29 11:21:29');
INSERT INTO `gen_table_column` VALUES (5585, 267, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:52', '', '2024-07-29 11:21:29');
INSERT INTO `gen_table_column` VALUES (5586, 267, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:52', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5587, 267, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:33:52', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5588, 267, 'landDriverName', '陆地司机姓名', 'varchar(55)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 08:33:52', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5589, 267, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:52', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5590, 267, 'seaCarNo', '海运车牌', 'varchar(50)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5591, 267, 'seaDriverTel', '海运司机电话', 'varchar(50)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5592, 267, 'seaDriverName', '海运司机姓名', 'varchar(55)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5593, 267, 'checkUserId', '审核人编号', 'int(11)', 'Long', 'checkUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:30');
INSERT INTO `gen_table_column` VALUES (5594, 267, 'checkState', '审核状态（已审核、未审核）', 'varchar(20)', 'String', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:31');
INSERT INTO `gen_table_column` VALUES (5595, 267, 'invoiceState', '开票状态（未开票，部分开票，已开票）', 'varchar(20)', 'String', 'invoiceState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:31');
INSERT INTO `gen_table_column` VALUES (5596, 267, 'path', '附件路径', 'varchar(250)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:31');
INSERT INTO `gen_table_column` VALUES (5597, 267, 'PaymentState', '打款状态(已打款，未打款)', 'varchar(20)', 'String', 'PaymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:33:53', '', '2024-07-29 11:21:31');
INSERT INTO `gen_table_column` VALUES (5598, 267, 'landBankName', '陆运银行户名', 'varchar(50)', 'String', 'landBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 20, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:31');
INSERT INTO `gen_table_column` VALUES (5599, 267, 'landBankNo', '陆运银行账号', 'varchar(50)', 'String', 'landBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:31');
INSERT INTO `gen_table_column` VALUES (5600, 267, 'seaBankName', '海运银行户名', 'varchar(50)', 'String', 'seaBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:31');
INSERT INTO `gen_table_column` VALUES (5601, 267, 'seaBankNo', '海运银行账号', 'varchar(50)', 'String', 'seaBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:32');
INSERT INTO `gen_table_column` VALUES (5602, 267, 'receiveProof', '收到条附件路径', 'text', 'String', 'receiveProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 24, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:32');
INSERT INTO `gen_table_column` VALUES (5603, 267, 'saleManager', '销售经理', 'varchar(25)', 'String', 'saleManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:32');
INSERT INTO `gen_table_column` VALUES (5604, 267, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:32');
INSERT INTO `gen_table_column` VALUES (5605, 267, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 08:33:54', '', '2024-07-29 11:21:32');
INSERT INTO `gen_table_column` VALUES (5606, 267, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 08:33:55', '', '2024-07-29 11:21:32');
INSERT INTO `gen_table_column` VALUES (5607, 267, 'isAdjust', '是否调整单（是  否）', 'varchar(10)', 'String', 'isAdjust', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 08:33:55', '', '2024-07-29 11:21:32');
INSERT INTO `gen_table_column` VALUES (5608, 267, 'adjustOrderid', '原订单编号', 'int(11)', 'Long', 'adjustOrderid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 08:33:55', '', '2024-07-29 11:21:33');
INSERT INTO `gen_table_column` VALUES (5609, 267, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 08:33:55', '', '2024-07-29 11:21:33');
INSERT INTO `gen_table_column` VALUES (5610, 267, 'customerIsInvoice', '客户是否开票', 'int(11)', 'Long', 'customerIsInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 08:33:55', '', '2024-07-29 11:21:33');
INSERT INTO `gen_table_column` VALUES (5611, 267, 'isSupplierInvoice', '供应商是否开票', 'int(11)', 'Long', 'isSupplierInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 08:33:55', '', '2024-07-29 11:21:33');
INSERT INTO `gen_table_column` VALUES (5612, 267, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 08:33:55', '', '2024-07-29 11:21:33');
INSERT INTO `gen_table_column` VALUES (5613, 267, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 08:33:56', '', '2024-07-29 11:21:33');
INSERT INTO `gen_table_column` VALUES (5614, 267, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 08:33:56', '', '2024-07-29 11:21:33');
INSERT INTO `gen_table_column` VALUES (5615, 267, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 08:33:56', '', '2024-07-29 11:21:34');
INSERT INTO `gen_table_column` VALUES (5616, 267, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 38, 'admin', '2024-07-29 08:33:56', '', '2024-07-29 11:21:34');
INSERT INTO `gen_table_column` VALUES (5617, 267, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 39, 'admin', '2024-07-29 08:33:56', '', '2024-07-29 11:21:34');
INSERT INTO `gen_table_column` VALUES (5618, 268, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:33:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (5619, 268, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5620, 268, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5621, 268, 'storeDate', '入库日期', 'varchar(50)', 'String', 'storeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5622, 268, 'stockNumber', '库存量（片数）', 'int(11)', 'Long', 'stockNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5623, 268, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5624, 268, 'supplierId', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5625, 268, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5626, 268, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 08:33:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (5627, 268, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:33:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (5628, 268, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:33:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (5629, 268, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:33:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (5630, 268, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:33:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (5631, 268, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:33:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (5632, 268, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:33:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (5633, 268, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:33:58', '', NULL);
INSERT INTO `gen_table_column` VALUES (5634, 268, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5635, 268, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5636, 268, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5637, 268, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5638, 268, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5639, 268, 'isIncludeTaxSale', '销售是否含税（0不含税，1含税）', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5640, 268, 'payments', '总货款', 'varchar(20)', 'String', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5641, 268, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 08:33:59', '', NULL);
INSERT INTO `gen_table_column` VALUES (5642, 268, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5643, 268, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5644, 268, 'landDriverName', '陆地司机姓名', 'varchar(255)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 27, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5645, 268, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5646, 268, 'seaCarNo', '海运车牌', 'varchar(550)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 29, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5647, 268, 'seaDriverTel', '海运司机电话', 'varchar(550)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 30, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5648, 268, 'seaDriverName', '海运司机姓名', 'varchar(255)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 31, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5649, 268, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 08:34:00', '', NULL);
INSERT INTO `gen_table_column` VALUES (5650, 268, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 08:34:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (5651, 268, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 08:34:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (5652, 268, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 08:34:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (5653, 268, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 08:34:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (5654, 268, 'freight', '运费（海运费+陆运费）', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 08:34:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (5655, 268, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-29 08:34:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (5656, 268, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 08:34:01', '', NULL);
INSERT INTO `gen_table_column` VALUES (5657, 268, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5658, 268, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5659, 268, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5660, 268, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5661, 268, 'rebate', '返利金额', 'double', 'Double', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5662, 268, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5663, 268, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5664, 268, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-29 08:34:02', '', NULL);
INSERT INTO `gen_table_column` VALUES (5665, 268, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 48, 'admin', '2024-07-29 08:34:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (5666, 268, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 49, 'admin', '2024-07-29 08:34:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (5667, 268, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 50, 'admin', '2024-07-29 08:34:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (5668, 268, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 51, 'admin', '2024-07-29 08:34:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (5669, 268, 'showFlag', '订单仓库选择时是否显示（ 显示， 不显示）', 'int(11)', 'Long', 'showFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 52, 'admin', '2024-07-29 08:34:03', '', NULL);
INSERT INTO `gen_table_column` VALUES (5670, 269, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:03', '', '2024-07-29 11:21:49');
INSERT INTO `gen_table_column` VALUES (5671, 269, 'inventory_id', '原货物存储ID', 'int(11)', 'Long', 'inventoryId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:49');
INSERT INTO `gen_table_column` VALUES (5672, 269, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:49');
INSERT INTO `gen_table_column` VALUES (5673, 269, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:49');
INSERT INTO `gen_table_column` VALUES (5674, 269, 'storeDate', '入库日期', 'varchar(50)', 'String', 'storeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:49');
INSERT INTO `gen_table_column` VALUES (5675, 269, 'stockNumber', '库存量（片数）', 'int(11)', 'Long', 'stockNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:49');
INSERT INTO `gen_table_column` VALUES (5676, 269, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5677, 269, 'supplierId', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5678, 269, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:04', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5679, 269, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5680, 269, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5681, 269, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5682, 269, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5683, 269, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:50');
INSERT INTO `gen_table_column` VALUES (5684, 269, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:51');
INSERT INTO `gen_table_column` VALUES (5685, 269, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:51');
INSERT INTO `gen_table_column` VALUES (5686, 269, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:34:05', '', '2024-07-29 11:21:51');
INSERT INTO `gen_table_column` VALUES (5687, 269, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:51');
INSERT INTO `gen_table_column` VALUES (5688, 269, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:51');
INSERT INTO `gen_table_column` VALUES (5689, 269, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:51');
INSERT INTO `gen_table_column` VALUES (5690, 269, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:51');
INSERT INTO `gen_table_column` VALUES (5691, 269, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:52');
INSERT INTO `gen_table_column` VALUES (5692, 269, 'isIncludeTaxSale', '销售是否含税（0不含税，1含税）', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:52');
INSERT INTO `gen_table_column` VALUES (5693, 269, 'payments', '总货款', 'varchar(20)', 'String', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:52');
INSERT INTO `gen_table_column` VALUES (5694, 269, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:34:06', '', '2024-07-29 11:21:52');
INSERT INTO `gen_table_column` VALUES (5695, 269, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:34:07', '', '2024-07-29 11:21:52');
INSERT INTO `gen_table_column` VALUES (5696, 269, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 08:34:07', '', '2024-07-29 11:21:52');
INSERT INTO `gen_table_column` VALUES (5697, 269, 'landDriverName', '陆地司机姓名', 'varchar(255)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 28, 'admin', '2024-07-29 08:34:07', '', '2024-07-29 11:21:52');
INSERT INTO `gen_table_column` VALUES (5698, 269, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 08:34:07', '', '2024-07-29 11:21:53');
INSERT INTO `gen_table_column` VALUES (5699, 269, 'seaCarNo', '海运车牌', 'varchar(550)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 30, 'admin', '2024-07-29 08:34:07', '', '2024-07-29 11:21:53');
INSERT INTO `gen_table_column` VALUES (5700, 269, 'seaDriverTel', '海运司机电话', 'varchar(550)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 31, 'admin', '2024-07-29 08:34:07', '', '2024-07-29 11:21:53');
INSERT INTO `gen_table_column` VALUES (5701, 269, 'seaDriverName', '海运司机姓名', 'varchar(255)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 32, 'admin', '2024-07-29 08:34:07', '', '2024-07-29 11:21:53');
INSERT INTO `gen_table_column` VALUES (5702, 269, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:53');
INSERT INTO `gen_table_column` VALUES (5703, 269, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:53');
INSERT INTO `gen_table_column` VALUES (5704, 269, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:53');
INSERT INTO `gen_table_column` VALUES (5705, 269, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:54');
INSERT INTO `gen_table_column` VALUES (5706, 269, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:54');
INSERT INTO `gen_table_column` VALUES (5707, 269, 'freight', '运费（海运费+陆运费）', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:54');
INSERT INTO `gen_table_column` VALUES (5708, 269, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:54');
INSERT INTO `gen_table_column` VALUES (5709, 269, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 08:34:08', '', '2024-07-29 11:21:54');
INSERT INTO `gen_table_column` VALUES (5710, 269, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:54');
INSERT INTO `gen_table_column` VALUES (5711, 269, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:54');
INSERT INTO `gen_table_column` VALUES (5712, 269, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5713, 269, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5714, 269, 'rebate', '返利金额', 'double', 'Double', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5715, 269, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5716, 269, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5717, 269, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 48, 'admin', '2024-07-29 08:34:09', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5718, 269, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 49, 'admin', '2024-07-29 08:34:10', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5719, 269, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 50, 'admin', '2024-07-29 08:34:10', '', '2024-07-29 11:21:55');
INSERT INTO `gen_table_column` VALUES (5720, 269, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 51, 'admin', '2024-07-29 08:34:10', '', '2024-07-29 11:21:56');
INSERT INTO `gen_table_column` VALUES (5721, 269, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 52, 'admin', '2024-07-29 08:34:10', '', '2024-07-29 11:21:56');
INSERT INTO `gen_table_column` VALUES (5722, 269, 'showFlag', '订单仓库选择时是否显示（ 显示， 不显示）', 'int(11)', 'Long', 'showFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 53, 'admin', '2024-07-29 08:34:10', '', '2024-07-29 11:21:56');
INSERT INTO `gen_table_column` VALUES (5723, 270, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (5724, 270, 'futuresNO', '借出款编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5725, 270, 'futuresMarginCompany', '期货保证金公司', 'varchar(80)', 'String', 'futuresMarginCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5726, 270, 'target', '对象(员工、外面公司在我公司借款)', 'varchar(50)', 'String', 'target', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5727, 270, 'moneyAmount', '保证金金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5728, 270, 'targetAcountsName', '对方账户', 'varchar(80)', 'String', 'targetAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5729, 270, 'targetBankNo', '对方账号', 'varchar(80)', 'String', 'targetBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5730, 270, 'targetBankName', '对方开户行', 'varchar(80)', 'String', 'targetBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5731, 270, 'selfAcountsName', '我方支付账户', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 08:34:11', '', NULL);
INSERT INTO `gen_table_column` VALUES (5732, 270, 'selfBankNo', '我方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (5733, 270, 'selfBankName', '我方开户行', 'varchar(80)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 08:34:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (5734, 270, 'futuresDate', '支付期货保证金时间', 'varchar(50)', 'String', 'futuresDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (5735, 270, 'reason', '事由', 'varchar(200)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (5736, 270, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (5737, 270, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (5738, 270, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:12', '', NULL);
INSERT INTO `gen_table_column` VALUES (5739, 270, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-29 08:34:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (5740, 270, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-29 08:34:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (5741, 270, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (5742, 271, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (5743, 271, 'OffsetNO', '冲抵编号（UUID）', 'varchar(50)', 'String', 'OffsetNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (5744, 271, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:13', '', NULL);
INSERT INTO `gen_table_column` VALUES (5745, 271, 'operateType', '冲抵类型（收入、支出）', 'varchar(50)', 'String', 'operateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5746, 271, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5747, 271, 'company', '公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5748, 271, 'company_id', '公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5749, 271, 'companyType', '公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5750, 271, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5751, 271, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5752, 271, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:14', '', NULL);
INSERT INTO `gen_table_column` VALUES (5753, 271, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 08:34:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5754, 271, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 08:34:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5755, 271, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5756, 272, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5757, 272, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5758, 272, 'oilType', '加油卡类别（主卡、副卡）', 'varchar(15)', 'String', 'oilType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2024-07-29 08:34:15', '', NULL);
INSERT INTO `gen_table_column` VALUES (5759, 272, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5760, 272, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5761, 272, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5762, 272, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 08:34:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5763, 272, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2024-07-29 08:34:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5764, 272, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5765, 273, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:16', '', NULL);
INSERT INTO `gen_table_column` VALUES (5766, 273, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5767, 273, 'useDate', '使用加油卡时间', 'varchar(50)', 'String', 'useDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5768, 273, 'carNo', '使用加油卡车辆车牌号', 'varchar(55)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5769, 273, 'destination', '地点、事由', 'varchar(155)', 'String', 'destination', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5770, 273, 'startCardSurplus', '期初余额', 'varchar(55)', 'String', 'startCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5771, 273, 'toPlusCardMoney', '主卡转副卡充值金额', 'varchar(55)', 'String', 'toPlusCardMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5772, 273, 'refuelingNumber', '加油量（升）', 'varchar(255)', 'String', 'refuelingNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (5773, 273, 'unitPrice', '单价', 'varchar(255)', 'String', 'unitPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5774, 273, 'refuelingMoney', '加油金额(元）', 'varchar(255)', 'String', 'refuelingMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5775, 273, 'rechargeMoney', '充值金额', 'varchar(255)', 'String', 'rechargeMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5776, 273, 'isTicket', '是否有小票', 'varchar(255)', 'String', 'isTicket', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5777, 273, 'endCardSurplus', '加油卡余额', 'varchar(255)', 'String', 'endCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5778, 273, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5779, 273, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5780, 273, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:18', '', NULL);
INSERT INTO `gen_table_column` VALUES (5781, 273, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-29 08:34:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5782, 273, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-29 08:34:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5783, 273, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5784, 274, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5785, 274, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5786, 274, 'orderDate', '订单日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:19', '', NULL);
INSERT INTO `gen_table_column` VALUES (5787, 274, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5788, 274, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5789, 274, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5790, 274, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5791, 274, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5792, 274, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5793, 274, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5794, 274, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:20', '', NULL);
INSERT INTO `gen_table_column` VALUES (5795, 274, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5796, 274, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5797, 274, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5798, 274, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5799, 274, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5800, 274, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5801, 274, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5802, 274, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:21', '', NULL);
INSERT INTO `gen_table_column` VALUES (5803, 274, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5804, 274, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5805, 274, 'isIncludeTaxSale', '销售是否含税', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5806, 274, 'payments', '总货款', 'double', 'Double', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5807, 274, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5808, 274, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5809, 274, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5810, 274, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 08:34:22', '', NULL);
INSERT INTO `gen_table_column` VALUES (5811, 274, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 08:34:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5812, 274, 'freight', '总运费', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 08:34:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5813, 274, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 08:34:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5814, 274, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 08:34:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5815, 274, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 08:34:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5816, 274, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 08:34:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5817, 274, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 08:34:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (5818, 274, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5819, 274, 'storeHouseID', '仓库ID', 'int(11)', 'Long', 'storeHouseID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5820, 274, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 37, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5821, 274, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5822, 274, 'logisticsProfit', '物流利润', 'double', 'Double', 'logisticsProfit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5823, 274, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5824, 274, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5825, 274, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 08:34:24', '', NULL);
INSERT INTO `gen_table_column` VALUES (5826, 274, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 08:34:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5827, 274, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 08:34:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5828, 274, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 08:34:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5829, 274, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 08:34:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5830, 274, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 47, 'admin', '2024-07-29 08:34:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5831, 274, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 48, 'admin', '2024-07-29 08:34:25', '', NULL);
INSERT INTO `gen_table_column` VALUES (5832, 275, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:56');
INSERT INTO `gen_table_column` VALUES (5833, 275, 'orderId', '原订单详情ID', 'int(11)', 'Long', 'orderId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:56');
INSERT INTO `gen_table_column` VALUES (5834, 275, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:56');
INSERT INTO `gen_table_column` VALUES (5835, 275, 'orderDate', '订单日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:56');
INSERT INTO `gen_table_column` VALUES (5836, 275, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:56');
INSERT INTO `gen_table_column` VALUES (5837, 275, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5838, 275, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5839, 275, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:26', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5840, 275, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5841, 275, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5842, 275, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5843, 275, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5844, 275, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:57');
INSERT INTO `gen_table_column` VALUES (5845, 275, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:58');
INSERT INTO `gen_table_column` VALUES (5846, 275, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:58');
INSERT INTO `gen_table_column` VALUES (5847, 275, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:27', '', '2024-07-29 11:20:58');
INSERT INTO `gen_table_column` VALUES (5848, 275, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:58');
INSERT INTO `gen_table_column` VALUES (5849, 275, 'price', '出厂单价', 'double', 'Double', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:58');
INSERT INTO `gen_table_column` VALUES (5850, 275, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:58');
INSERT INTO `gen_table_column` VALUES (5851, 275, 'sundryCost', '杂费', 'double', 'Double', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:58');
INSERT INTO `gen_table_column` VALUES (5852, 275, 'paymentFactory', '出厂货款', 'double', 'Double', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5853, 275, 'paymentUnload', '卸货价', 'double', 'Double', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5854, 275, 'isIncludeTaxSale', '销售是否含税', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5855, 275, 'payments', '总货款', 'double', 'Double', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-29 08:34:28', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5856, 275, 'erro', '误差', 'double', 'Double', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:34:29', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5857, 275, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:34:29', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5858, 275, 'landFreightPrice', '陆运费单价', 'double', 'Double', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 08:34:29', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5859, 275, 'landFreight', '陆运费', 'double', 'Double', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-29 08:34:29', '', '2024-07-29 11:20:59');
INSERT INTO `gen_table_column` VALUES (5860, 275, 'seaFreight', '海运费', 'double', 'Double', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 08:34:29', '', '2024-07-29 11:21:00');
INSERT INTO `gen_table_column` VALUES (5861, 275, 'freight', '总运费', 'double', 'Double', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-29 08:34:29', '', '2024-07-29 11:21:00');
INSERT INTO `gen_table_column` VALUES (5862, 275, 'otherCost', '其他费用', 'double', 'Double', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-29 08:34:29', '', '2024-07-29 11:21:00');
INSERT INTO `gen_table_column` VALUES (5863, 275, 'profit', '利润', 'double', 'Double', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:00');
INSERT INTO `gen_table_column` VALUES (5864, 275, 'profitNoTax', '不含税利润', 'double', 'Double', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:00');
INSERT INTO `gen_table_column` VALUES (5865, 275, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:00');
INSERT INTO `gen_table_column` VALUES (5866, 275, 'paymentsWithSundry', '总货款杂费', 'double', 'Double', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:00');
INSERT INTO `gen_table_column` VALUES (5867, 275, 'additionalFees', '加费', 'double', 'Double', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5868, 275, 'storeHouseID', '仓库ID', 'int(11)', 'Long', 'storeHouseID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5869, 275, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 38, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5870, 275, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-29 08:34:30', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5871, 275, 'logisticsProfit', '物流利润', 'double', 'Double', 'logisticsProfit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5872, 275, 'customerCommission', '客户佣金', 'double', 'Double', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5873, 275, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5874, 275, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:01');
INSERT INTO `gen_table_column` VALUES (5875, 275, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:02');
INSERT INTO `gen_table_column` VALUES (5876, 275, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:02');
INSERT INTO `gen_table_column` VALUES (5877, 275, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:02');
INSERT INTO `gen_table_column` VALUES (5878, 275, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-29 08:34:31', '', '2024-07-29 11:21:02');
INSERT INTO `gen_table_column` VALUES (5879, 275, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 48, 'admin', '2024-07-29 08:34:32', '', '2024-07-29 11:21:02');
INSERT INTO `gen_table_column` VALUES (5880, 275, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 49, 'admin', '2024-07-29 08:34:32', '', '2024-07-29 11:21:02');
INSERT INTO `gen_table_column` VALUES (5881, 276, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5882, 276, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5883, 276, 'freightState', '运费类型（ 陆运、海运）', 'varchar(55)', 'String', 'freightState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5884, 276, 'moneyAmount', '金额', 'varchar(55)', 'String', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:32', '', NULL);
INSERT INTO `gen_table_column` VALUES (5885, 276, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5886, 276, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5887, 276, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5888, 276, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5889, 276, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5890, 276, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5891, 276, 'content', '备注', 'varchar(150)', 'String', 'content', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 11, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5892, 276, 'paymentState', '支付状态（ 已支付、 未支付、  申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:33', '', NULL);
INSERT INTO `gen_table_column` VALUES (5893, 276, 'driverName', '司机姓名', 'varchar(150)', 'String', 'driverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5894, 276, 'driverId', '司机ID', 'int(11)', 'Long', 'driverId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5895, 276, 'CarNo', '车牌号', 'varchar(20)', 'String', 'CarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5896, 276, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5897, 276, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5898, 276, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5899, 276, 'applyUserId', '申请人员ID', 'int(11)', 'Long', 'applyUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5900, 276, 'applyUserName', '申请人员姓名', 'varchar(50)', 'String', 'applyUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 20, 'admin', '2024-07-29 08:34:34', '', NULL);
INSERT INTO `gen_table_column` VALUES (5901, 276, 'applyDate', '申请日期', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:34:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5902, 276, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:34:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5903, 276, 'payUserId', '付款人员ID', 'int(11)', 'Long', 'payUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:34:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5904, 276, 'payUserName', '付款人员姓名', 'varchar(50)', 'String', 'payUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-29 08:34:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5905, 276, 'payDate', '付款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-29 08:34:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5906, 276, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:34:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5907, 276, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-29 08:34:35', '', NULL);
INSERT INTO `gen_table_column` VALUES (5908, 276, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 28, 'admin', '2024-07-29 08:34:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5909, 276, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-29 08:34:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5910, 277, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5911, 277, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5912, 277, 'invoiceDate', '开票日期', 'varchar(55)', 'String', 'invoiceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5913, 277, 'invoiceType', '开票类型（购入、卖出）', 'double', 'Double', 'invoiceType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-29 08:34:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5914, 277, 'invoiceAmount', '应开票金额', 'double', 'Double', 'invoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:36', '', NULL);
INSERT INTO `gen_table_column` VALUES (5915, 277, 'companyType', '公司类别（客户、供应商）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-29 08:34:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5916, 277, 'companyName', '公司名称', 'varchar(120)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 08:34:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5917, 277, 'companyID', '公司名称', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5918, 277, 'invoiceCompanyName', '票据单位名称', 'varchar(120)', 'String', 'invoiceCompanyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 08:34:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5919, 277, 'actualInvoiceAmount', '实际开票金额', 'double', 'Double', 'actualInvoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5920, 277, 'ticketPoint', '票点', 'double', 'Double', 'ticketPoint', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5921, 277, 'ticketPointAmount', '票点金额（实际开票金额*票点）', 'double', 'Double', 'ticketPointAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:37', '', NULL);
INSERT INTO `gen_table_column` VALUES (5922, 277, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5923, 277, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5924, 277, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5925, 277, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-29 08:34:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5926, 277, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-29 08:34:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5927, 277, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5928, 278, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:38', '', NULL);
INSERT INTO `gen_table_column` VALUES (5929, 278, 'payCategory', '收付款类型（收款，付款）', 'varchar(55)', 'String', 'payCategory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5930, 278, 'payNO', '付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5931, 278, 'fundsDate', '日期', 'varchar(50)', 'String', 'fundsDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5932, 278, 'payType', '支付类型', 'varchar(55)', 'String', 'payType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-29 08:34:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5933, 278, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5934, 278, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 08:34:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5935, 278, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:39', '', NULL);
INSERT INTO `gen_table_column` VALUES (5936, 278, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5937, 278, 'selfBankID', '己方账号ID', 'varchar(150)', 'String', 'selfBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5938, 278, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5939, 278, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5940, 278, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5941, 278, 'paymentState', '支付状态（已支付、未支付、申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5942, 278, 'company', '对方公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5943, 278, 'company_id', '对方公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:40', '', NULL);
INSERT INTO `gen_table_column` VALUES (5944, 278, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 17, 'admin', '2024-07-29 08:34:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5945, 278, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5946, 278, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5947, 278, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:34:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5948, 278, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-29 08:34:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5949, 278, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-29 08:34:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5950, 278, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:34:41', '', NULL);
INSERT INTO `gen_table_column` VALUES (5951, 279, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5952, 279, 'levelNo', '级别编码', 'varchar(20)', 'String', 'levelNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5953, 279, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 08:34:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5954, 279, 'categoryNo', '分类编号', 'int(11)', 'Long', 'categoryNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5955, 279, 'categoryName', '分类名称', 'varchar(80)', 'String', 'categoryName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 08:34:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5956, 279, 'height', '厚度', 'double', 'Double', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5957, 279, 'length', '长度', 'double', 'Double', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:42', '', NULL);
INSERT INTO `gen_table_column` VALUES (5958, 279, 'width', '宽度', 'double', 'Double', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5959, 279, 'tonnage', '吨位', 'double', 'Double', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5960, 279, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5961, 279, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5962, 279, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 08:34:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5963, 279, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 08:34:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5964, 279, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:43', '', NULL);
INSERT INTO `gen_table_column` VALUES (5965, 280, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5966, 280, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5967, 280, 'rebateDate', '日期', 'varchar(50)', 'String', 'rebateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5968, 280, 'rebate', '金额', 'double', 'Double', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5969, 280, 'rebateType', '返利类型（返利、降价、售后质量赔偿）', 'varchar(80)', 'String', 'rebateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-29 08:34:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5970, 280, 'inAcountsName', '收款户名', 'varchar(80)', 'String', 'inAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 08:34:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5971, 280, 'inBankNo', '收款账号', 'varchar(80)', 'String', 'inBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:44', '', NULL);
INSERT INTO `gen_table_column` VALUES (5972, 280, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5973, 280, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5974, 280, 'outAcountsName', '付款户名', 'varchar(80)', 'String', 'outAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5975, 280, 'outBankNo', '付款款账号', 'varchar(80)', 'String', 'outBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5976, 280, 'rebateReason', '返利原因', 'varchar(55)', 'String', 'rebateReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5977, 280, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5978, 280, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5979, 280, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:45', '', NULL);
INSERT INTO `gen_table_column` VALUES (5980, 280, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-29 08:34:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5981, 280, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-29 08:34:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5982, 280, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5983, 281, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5984, 281, 'futuresNO', '借出款编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5985, 281, 'recoverNO', '还款编号（UUID）', 'varchar(50)', 'String', 'recoverNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:46', '', NULL);
INSERT INTO `gen_table_column` VALUES (5986, 281, 'moneyAmount', '收回金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5987, 281, 'recoverDate', '收回日期', 'varchar(50)', 'String', 'recoverDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5988, 281, 'acountsName', '收回账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5989, 281, 'bankNo', '收回账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5990, 281, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5991, 281, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5992, 281, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5993, 281, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 08:34:47', '', NULL);
INSERT INTO `gen_table_column` VALUES (5994, 281, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-29 08:34:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5995, 281, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5996, 282, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5997, 282, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5998, 282, 'payNO', '还款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (5999, 282, 'moneyAmount', '还（本）金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:48', '', NULL);
INSERT INTO `gen_table_column` VALUES (6000, 282, 'ratio', '付息（金额）', 'double', 'Double', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6001, 282, 'payDate', '还款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6002, 282, 'acountsName', '还款账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6003, 282, 'bankNo', '还款账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6004, 282, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6005, 282, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6006, 282, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6007, 282, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-29 08:34:49', '', NULL);
INSERT INTO `gen_table_column` VALUES (6008, 282, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-29 08:34:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (6009, 282, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (6010, 283, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (6011, 283, 'basicSocialInsurance', '社保缴纳基数', 'double', 'Double', 'basicSocialInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (6012, 283, 'basicHousingFund', '公积金基数', 'double', 'Double', 'basicHousingFund', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (6013, 283, 'depName', '部门', 'varchar(50)', 'String', 'depName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-29 08:34:50', '', NULL);
INSERT INTO `gen_table_column` VALUES (6014, 283, 'employeeName', '姓名', 'varchar(15)', 'String', 'employeeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6015, 283, 'employeeID', '人员编号', 'varchar(15)', 'String', 'employeeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6016, 283, 'insuranceDate', '缴费时间', 'varchar(50)', 'String', 'insuranceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6017, 283, 'isRecruiting', '是否增员（是，否）', 'varchar(10)', 'String', 'isRecruiting', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6018, 283, 'isDepletion', '是否减员', 'varchar(10)', 'String', 'isDepletion', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6019, 283, 'healthySecuritySelf', '基本医疗保险-个人', 'double', 'Double', 'healthySecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6020, 283, 'healthySecurityCompany', '基本医疗保险-公司', 'double', 'Double', 'healthySecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6021, 283, 'injuryInsurance', '工伤保险', 'double', 'Double', 'injuryInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-29 08:34:51', '', NULL);
INSERT INTO `gen_table_column` VALUES (6022, 283, 'unemploymentSecuritySelf', '失业保险-个人', 'double', 'Double', 'unemploymentSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-29 08:34:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (6023, 283, 'unemploymentSecurityCompany', '失业保险-公司', 'double', 'Double', 'unemploymentSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-29 08:34:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (6024, 283, 'retirementSecuritySelf', '养老保险-个人', 'double', 'Double', 'retirementSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-29 08:34:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (6025, 283, 'retirementSecurityCompany', '养老保险-公司', 'double', 'Double', 'retirementSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-29 08:34:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (6026, 283, 'largeMedicalSecuritySelf', '大额医保-个人', 'double', 'Double', 'largeMedicalSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-29 08:34:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (6027, 283, 'largeMedicalSecurityCompany', '大额医保-公司', 'double', 'Double', 'largeMedicalSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-29 08:34:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (6028, 283, 'housingFundSelf', '公积金-个人', 'double', 'Double', 'housingFundSelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-29 08:34:52', '', NULL);
INSERT INTO `gen_table_column` VALUES (6029, 283, 'housingFundCompany', '公积金-公司', 'double', 'Double', 'housingFundCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-29 08:34:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (6030, 283, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-29 08:34:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (6031, 283, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-29 08:34:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (6032, 283, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-29 08:34:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (6033, 283, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-29 08:34:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (6034, 283, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 25, 'admin', '2024-07-29 08:34:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (6035, 283, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-29 08:34:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (6036, 284, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (6037, 284, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 08:34:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (6038, 284, 'address', '地址', 'varchar(100)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (6039, 284, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (6040, 285, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (6041, 285, 'tableName', '表名', 'varchar(50)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-29 08:34:54', '', NULL);
INSERT INTO `gen_table_column` VALUES (6042, 285, 'modifyTime', '修改时间', 'varchar(80)', 'String', 'modifyTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-29 08:34:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (6043, 285, 'reason', '修改原因', 'varchar(280)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (6044, 285, 'tid', '修改表对应信息的id', 'int(11)', 'Long', 'tid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (6045, 285, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-29 08:34:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (6046, 285, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (6047, 285, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-29 08:34:55', '', NULL);
INSERT INTO `gen_table_column` VALUES (6048, 286, 'id', 'id', 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6049, 286, 'companyId', '公司ID', 'varchar(80)', 'String', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6050, 286, 'tableName', '发生操作行为的表', 'varchar(80)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6051, 286, 'payNO', '发生操作行为的冲抵款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6052, 286, 'operateDate', '日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6053, 286, 'changeType', '变动类型（收入、支出）', 'varchar(15)', 'String', 'changeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6054, 286, 'moneyAmount', '金额', 'double', 'Double', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6055, 286, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-29 08:34:56', '', NULL);
INSERT INTO `gen_table_column` VALUES (6056, 286, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-29 08:34:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (6057, 286, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-29 08:34:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (6058, 286, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-29 08:34:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (6059, 286, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-29 08:34:57', '', NULL);

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
) ENGINE = MyISAM AUTO_INCREMENT = 23854 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of goodsorder
-- ----------------------------
INSERT INTO `goodsorder` VALUES (23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存1此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2024-07-19 17:37:21');
INSERT INTO `goodsorder` VALUES (23850, '8cb269c1-2631-4115-9c62-2051c3ffc808', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder` VALUES (23851, '15c67809-444f-4af9-84ab-ca042171c59f', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder` VALUES (23852, '8f944461-317a-450e-93b6-2bcacc691c17', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder` VALUES (23853, '1db10918-652c-4838-aab5-6bcb800c7555', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 1, 'voluptate', '2024-07-19 18:21:47', 1, NULL, '2004-01-23 23:54:04');

-- ----------------------------
-- Table structure for goodsorder_back
-- ----------------------------
DROP TABLE IF EXISTS `goodsorder_back`;
CREATE TABLE `goodsorder_back`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goodsOrderID` int(11) NULL DEFAULT NULL COMMENT '原订单ID',
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
) ENGINE = MyISAM AUTO_INCREMENT = 23856 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单备份信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of goodsorder_back
-- ----------------------------
INSERT INTO `goodsorder_back` VALUES (23849, 23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder_back` VALUES (23850, 23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder_back` VALUES (23851, 23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder_back` VALUES (23852, 23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder_back` VALUES (23853, 23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2004-01-23 23:54:04');
INSERT INTO `goodsorder_back` VALUES (23854, 23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存1此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2024-07-19 17:28:11');
INSERT INTO `goodsorder_back` VALUES (23855, 23849, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1982-10-20', 'Ut anim magna', 21, 8, NULL, '18195573273', '料消存1此边', 60, 'mollit', '13596554422', '率年白', 23, '1', '1', NULL, NULL, '电手门点极为', NULL, '着志西年部', 'nisi eiusmod ipsum qui amet', NULL, 'dolore cillum', NULL, '1', '2009-04-03', '1', 3, 18, 95, 26, 53, 'voluptate', '1981-03-17 19:20:50', 39, NULL, '2024-07-19 17:37:12');

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
  `landCar_id` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCar_id` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '货物入库' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory
-- ----------------------------

-- ----------------------------
-- Table structure for inventory_back
-- ----------------------------
DROP TABLE IF EXISTS `inventory_back`;
CREATE TABLE `inventory_back`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_id` int(11) NULL DEFAULT 0 COMMENT '原货物存储ID',
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
  `landCar_id` int(11) NULL DEFAULT NULL COMMENT '陆运车辆ID',
  `landCarNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运车牌',
  `landDriverTel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆运司机电话',
  `landDriverName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '陆地司机姓名',
  `seaCar_id` int(11) NULL DEFAULT NULL COMMENT '海运车辆ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '货物入库信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory_back
-- ----------------------------

-- ----------------------------
-- Table structure for lendmoney
-- ----------------------------
DROP TABLE IF EXISTS `lendmoney`;
CREATE TABLE `lendmoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `futuresNO` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '借出款编号（UUID）',
  `futuresMarginCompany` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '期货保证金公司',
  `target` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对象(员工、外面公司在我公司借款)',
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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资金借出（期货）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of lendmoney
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
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
  `company` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司',
  `company_id` int(11) NULL DEFAULT NULL COMMENT '公司ID',
  `companyType` int(11) NULL DEFAULT 0 COMMENT '公司类型（1、客户 2、供应商）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资金调整单信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of offsetting
-- ----------------------------

-- ----------------------------
-- Table structure for oilcard
-- ----------------------------
DROP TABLE IF EXISTS `oilcard`;
CREATE TABLE `oilcard`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oilCardNo` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡卡号',
  `oilType` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加油卡类别（主卡、副卡）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加油卡' ROW_FORMAT = DYNAMIC;

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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '基础信息-加油卡主卡登记' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of oilcardmain
-- ----------------------------

-- ----------------------------
-- Table structure for orderdetail
-- ----------------------------
DROP TABLE IF EXISTS `orderdetail`;
CREATE TABLE `orderdetail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单日期',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 62864 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单详情' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orderdetail
-- ----------------------------
INSERT INTO `orderdetail` VALUES (62859, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 56, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');
INSERT INTO `orderdetail` VALUES (62860, '8cb269c1-2631-4115-9c62-2051c3ffc808', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 56, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');
INSERT INTO `orderdetail` VALUES (62861, '15c67809-444f-4af9-84ab-ca042171c59f', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 56, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');
INSERT INTO `orderdetail` VALUES (62862, '8f944461-317a-450e-93b6-2bcacc691c17', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 56, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');
INSERT INTO `orderdetail` VALUES (62863, '1db10918-652c-4838-aab5-6bcb800c7555', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 1, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');

-- ----------------------------
-- Table structure for orderdetail_back
-- ----------------------------
DROP TABLE IF EXISTS `orderdetail_back`;
CREATE TABLE `orderdetail_back`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NULL DEFAULT NULL COMMENT '原订单详情ID',
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `orderDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单日期',
  `supplier` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `supplier_id` int(11) NULL DEFAULT NULL COMMENT '供应商ID',
  `customer` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户',
  `customer_id` int(11) NULL DEFAULT NULL COMMENT '客户ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 62866 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单详情备份' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orderdetail_back
-- ----------------------------
INSERT INTO `orderdetail_back` VALUES (62863, 62859, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 56, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');
INSERT INTO `orderdetail_back` VALUES (62864, 62859, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 56, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');
INSERT INTO `orderdetail_back` VALUES (62865, 62859, '00450796-a26e-4f1c-8fa3-c878c6b655a9', '1987-12-20', 'incididunt minim id', 6, NULL, 88, 16, '格厂战南', NULL, 25, 12, 100, 91, 26, 52, 43, 71, 19, 99, 92, 19, 63, 61, 3, 85, 9, 68, 72, 37, 89, 76, 98, 92, 52, 61, '路影林', 90, 43, 56, '1', '2022-05-07', 56, NULL, '2002-07-14 15:11:50', 52, NULL, '2017-10-18 14:00:44');

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
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单运费' ROW_FORMAT = DYNAMIC;

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
  `invoiceType` double NULL DEFAULT 0 COMMENT '开票类型（购入、卖出）',
  `invoiceAmount` double NULL DEFAULT 0 COMMENT '应开票金额',
  `companyType` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司类别（客户、供应商）',
  `companyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司名称',
  `companyID` int(11) NULL DEFAULT NULL COMMENT '公司名称',
  `invoiceCompanyName` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '票据单位名称',
  `actualInvoiceAmount` double NULL DEFAULT 0 COMMENT '实际开票金额',
  `ticketPoint` double NULL DEFAULT 0 COMMENT '票点',
  `ticketPointAmount` double NULL DEFAULT 0 COMMENT '票点金额（实际开票金额*票点）',
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1459 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单发票' ROW_FORMAT = DYNAMIC;

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
  `moneyAmount` double NULL DEFAULT 0 COMMENT '金额',
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
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资产管理-收付款:收付款信息' ROW_FORMAT = DYNAMIC;

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
  `height` double NULL DEFAULT 0 COMMENT '厚度',
  `length` double NULL DEFAULT 0 COMMENT '长度',
  `width` double NULL DEFAULT 0 COMMENT '宽度',
  `tonnage` double NULL DEFAULT 0 COMMENT '吨位',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品级别管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of productlevel
-- ----------------------------
INSERT INTO `productlevel` VALUES (1, 'esse sed', '放复提知', 3, '电物共下格把那', 87, 23, 70, 552, '2024-07-20 09:32:09', 1, NULL, '2024-07-20 09:36:31', 1);

-- ----------------------------
-- Table structure for rebate
-- ----------------------------
DROP TABLE IF EXISTS `rebate`;
CREATE TABLE `rebate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordersNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号（UUID）',
  `rebateDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日期',
  `rebate` double NULL DEFAULT 0 COMMENT '金额',
  `rebateType` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '返利类型（返利、降价、售后质量赔偿）',
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
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商返利' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rebate
-- ----------------------------

-- ----------------------------
-- Table structure for recovermoney
-- ----------------------------
DROP TABLE IF EXISTS `recovermoney`;
CREATE TABLE `recovermoney`  (
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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资金回收' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of recovermoney
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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '还款记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of repayment
-- ----------------------------

-- ----------------------------
-- Table structure for socialinsurance
-- ----------------------------
DROP TABLE IF EXISTS `socialinsurance`;
CREATE TABLE `socialinsurance`  (
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
  `comments` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `addtime` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `userId` int(11) NULL DEFAULT NULL COMMENT '操作人员ID',
  `UserName` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作人员姓名',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `delFlag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '社保基金' ROW_FORMAT = DYNAMIC;

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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库管理' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-07-19 10:12:49', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-07-19 10:12:49', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-07-19 10:12:49', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-07-19 10:12:49', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2024-07-19 10:12:49', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-07-19 10:12:49', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

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
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', 'DZU科技', 0, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, 'DZU', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '停用状态');

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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '登录状态列表');

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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-07-19 10:12:49', '', NULL, '');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-19 10:22:11');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-19 10:22:14');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-19 10:22:17');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-19 10:29:35');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-19 11:33:38');
INSERT INTO `sys_logininfor` VALUES (105, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-19 16:33:43');
INSERT INTO `sys_logininfor` VALUES (106, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-19 17:00:51');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-19 17:29:44');
INSERT INTO `sys_logininfor` VALUES (108, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-19 17:39:19');
INSERT INTO `sys_logininfor` VALUES (109, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-19 17:39:24');
INSERT INTO `sys_logininfor` VALUES (110, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-19 18:12:01');
INSERT INTO `sys_logininfor` VALUES (111, 'adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-19 20:22:48');
INSERT INTO `sys_logininfor` VALUES (112, 'adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-19 20:22:53');
INSERT INTO `sys_logininfor` VALUES (113, 'adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-19 20:22:58');
INSERT INTO `sys_logininfor` VALUES (114, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-19 20:23:36');
INSERT INTO `sys_logininfor` VALUES (115, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-19 20:31:22');
INSERT INTO `sys_logininfor` VALUES (116, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-19 21:37:44');
INSERT INTO `sys_logininfor` VALUES (117, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-20 07:47:04');
INSERT INTO `sys_logininfor` VALUES (118, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-20 08:45:41');
INSERT INTO `sys_logininfor` VALUES (119, 'Adminw', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2024-07-20 10:25:37');
INSERT INTO `sys_logininfor` VALUES (120, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-20 20:17:20');
INSERT INTO `sys_logininfor` VALUES (121, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-20 20:17:25');
INSERT INTO `sys_logininfor` VALUES (122, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-20 20:30:32');
INSERT INTO `sys_logininfor` VALUES (123, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-20 20:30:39');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-20 20:56:14');
INSERT INTO `sys_logininfor` VALUES (125, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-21 09:46:48');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-21 09:51:16');
INSERT INTO `sys_logininfor` VALUES (127, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-21 10:17:37');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-21 11:24:20');
INSERT INTO `sys_logininfor` VALUES (129, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-21 13:06:57');
INSERT INTO `sys_logininfor` VALUES (130, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-21 14:55:45');
INSERT INTO `sys_logininfor` VALUES (131, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 13:39:48');
INSERT INTO `sys_logininfor` VALUES (132, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-22 13:41:09');
INSERT INTO `sys_logininfor` VALUES (133, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 13:41:17');
INSERT INTO `sys_logininfor` VALUES (134, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-22 13:41:39');
INSERT INTO `sys_logininfor` VALUES (135, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 13:41:46');
INSERT INTO `sys_logininfor` VALUES (136, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-22 13:42:12');
INSERT INTO `sys_logininfor` VALUES (137, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 13:42:18');
INSERT INTO `sys_logininfor` VALUES (138, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-22 13:42:30');
INSERT INTO `sys_logininfor` VALUES (139, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 13:43:29');
INSERT INTO `sys_logininfor` VALUES (140, NULL, '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '退出成功', '2024-07-22 13:44:17');
INSERT INTO `sys_logininfor` VALUES (141, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 14:02:59');
INSERT INTO `sys_logininfor` VALUES (142, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 14:03:10');
INSERT INTO `sys_logininfor` VALUES (143, 'Adminw ', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-22 22:00:35');
INSERT INTO `sys_logininfor` VALUES (144, 'Adminw ', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-22 22:00:41');
INSERT INTO `sys_logininfor` VALUES (145, 'Adminw ', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-22 22:01:17');
INSERT INTO `sys_logininfor` VALUES (146, 'Adminw ', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-22 22:01:25');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '用户不存在/密码错误', '2024-07-22 22:01:38');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 22:01:47');
INSERT INTO `sys_logininfor` VALUES (149, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-22 22:04:48');
INSERT INTO `sys_logininfor` VALUES (150, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-23 12:45:10');
INSERT INTO `sys_logininfor` VALUES (151, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-23 12:45:19');
INSERT INTO `sys_logininfor` VALUES (152, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-23 19:59:14');
INSERT INTO `sys_logininfor` VALUES (153, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-24 13:55:03');
INSERT INTO `sys_logininfor` VALUES (154, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-24 14:15:32');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-28 19:03:32');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-28 19:03:35');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-28 21:12:41');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-28 22:33:17');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-28 22:33:20');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 07:50:39');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 08:25:47');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-29 09:12:52');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 09:13:00');
INSERT INTO `sys_logininfor` VALUES (164, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 10:27:04');
INSERT INTO `sys_logininfor` VALUES (165, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 10:31:05');
INSERT INTO `sys_logininfor` VALUES (166, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 10:33:14');
INSERT INTO `sys_logininfor` VALUES (167, 'Adminw', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 11:03:21');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '1', '验证码错误', '2024-07-29 11:19:39');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 11:19:42');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 11:19:43');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 11:19:46');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 12', 'Windows 10', '0', '登录成功', '2024-07-29 11:20:02');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2205 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 0, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-07-19 10:12:49', 'admin', '2024-07-21 10:51:21', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', 1, 0, 'M', '1', '1', '', 'monitor', 'admin', '2024-07-19 10:12:49', 'admin', '2024-07-21 10:48:37', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 1, 3, 'tool', NULL, '', 1, 0, 'M', '1', '0', '', 'tool', 'admin', '2024-07-19 10:12:49', 'admin', '2024-07-28 21:13:15', '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-07-19 10:12:49', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-07-19 10:12:49', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-07-19 10:12:49', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-07-19 10:12:49', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-07-19 10:12:49', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-07-19 10:12:49', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-07-19 10:12:49', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-07-19 10:12:49', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-07-19 10:12:49', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-07-19 10:12:49', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-07-19 10:12:49', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-07-19 10:12:49', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-07-19 10:12:49', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-07-19 10:12:49', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-07-19 10:12:49', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-07-19 10:12:49', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-07-19 10:12:49', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '订单备份信息', 3, 1, 'back', 'system/back/index', NULL, 1, 0, 'C', '0', '0', 'system:back:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '订单备份信息菜单');
INSERT INTO `sys_menu` VALUES (2001, '订单备份信息查询', 2000, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2002, '订单备份信息新增', 2000, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '订单备份信息修改', 2000, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '订单备份信息删除', 2000, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '订单备份信息导出', 2000, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:back:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '平账', 2195, 1, 'balanceaccounts', 'system/balanceaccounts/index', NULL, 1, 0, 'C', '0', '0', 'system:balanceaccounts:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:06:44', '平账菜单');
INSERT INTO `sys_menu` VALUES (2007, '平账查询', 2006, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '平账新增', 2006, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '平账修改', 2006, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '平账删除', 2006, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '平账导出', 2006, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '商业票据、银行承兑', 2195, 1, 'bankacceptance', 'system/bankacceptance/index', NULL, 1, 0, 'C', '0', '0', 'system:bankacceptance:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:06:52', '商业票据、银行承兑菜单');
INSERT INTO `sys_menu` VALUES (2013, '商业票据、银行承兑查询', 2012, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '商业票据、银行承兑新增', 2012, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '商业票据、银行承兑修改', 2012, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '商业票据、银行承兑删除', 2012, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '商业票据、银行承兑导出', 2012, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '银行卡资金变动', 2193, 1, 'bankaccountchange', 'system/bankaccountchange/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccountchange:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:03:17', '银行卡资金变动菜单');
INSERT INTO `sys_menu` VALUES (2019, '银行卡资金变动查询', 2018, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '银行卡资金变动新增', 2018, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '银行卡资金变动修改', 2018, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '银行卡资金变动删除', 2018, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '银行卡资金变动导出', 2018, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '银行卡管理', 2193, 1, 'bankaccount', 'system/bankaccount/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccount:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:03:24', '银行卡管理菜单');
INSERT INTO `sys_menu` VALUES (2025, '银行卡管理查询', 2024, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '银行卡管理新增', 2024, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '银行卡管理修改', 2024, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '银行卡管理删除', 2024, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '银行卡管理导出', 2024, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '从外部借入款、贷款', 2195, 1, 'borrowedmoney', 'system/borrowedmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:borrowedmoney:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:07:00', '从外部借入款、贷款菜单');
INSERT INTO `sys_menu` VALUES (2031, '从外部借入款、贷款查询', 2030, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '从外部借入款、贷款新增', 2030, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '从外部借入款、贷款修改', 2030, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '从外部借入款、贷款删除', 2030, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '从外部借入款、贷款导出', 2030, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '出差登记', 2202, 1, 'businesstrip', 'system/businesstrip/index', NULL, 1, 0, 'C', '0', '0', 'system:businesstrip:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:05:12', '出差登记菜单');
INSERT INTO `sys_menu` VALUES (2037, '出差登记查询', 2036, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '出差登记新增', 2036, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '出差登记修改', 2036, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '出差登记删除', 2036, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '出差登记导出', 2036, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '车辆派出管理', 2202, 1, 'carapply', 'system/carapply/index', NULL, 1, 0, 'C', '0', '0', 'system:carapply:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:05:18', '车辆派出管理菜单');
INSERT INTO `sys_menu` VALUES (2043, '车辆派出管理查询', 2042, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '车辆派出管理新增', 2042, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '车辆派出管理修改', 2042, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '车辆派出管理删除', 2042, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '车辆派出管理导出', 2042, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '车辆管理', 2193, 1, 'cars', 'system/cars/index', NULL, 1, 0, 'C', '0', '0', 'system:cars:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 10:59:33', '车辆管理菜单');
INSERT INTO `sys_menu` VALUES (2049, '车辆管理查询', 2048, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '车辆管理新增', 2048, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '车辆管理修改', 2048, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '车辆管理删除', 2048, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '车辆管理导出', 2048, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '客户管理', 2193, 1, 'company', 'system/company/index', NULL, 1, 0, 'C', '0', '0', 'system:company:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:00:10', '客户管理菜单');
INSERT INTO `sys_menu` VALUES (2055, '客户管理查询', 2054, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '客户管理新增', 2054, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '客户管理修改', 2054, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '客户管理删除', 2054, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '客户管理导出', 2054, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '走访记录', 2202, 1, 'customervisit', 'system/customervisit/index', NULL, 1, 0, 'C', '0', '0', 'system:customervisit:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:06:24', '走访记录菜单');
INSERT INTO `sys_menu` VALUES (2061, '走访记录查询', 2060, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '走访记录新增', 2060, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '走访记录修改', 2060, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '走访记录删除', 2060, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '走访记录导出', 2060, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2066, '出库', 2194, 1, 'exwarehouse', 'system/exwarehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:exwarehouse:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:05:54', '出库菜单');
INSERT INTO `sys_menu` VALUES (2067, '出库查询', 2066, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '出库新增', 2066, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '出库修改', 2066, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '出库删除', 2066, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '出库导出', 2066, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '固定资产', 2195, 1, 'fixedassets', 'system/fixedassets/index', NULL, 1, 0, 'C', '0', '0', 'system:fixedassets:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:07:47', '固定资产菜单');
INSERT INTO `sys_menu` VALUES (2073, '固定资产查询', 2072, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2074, '固定资产新增', 2072, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2075, '固定资产修改', 2072, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2076, '固定资产删除', 2072, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2077, '固定资产导出', 2072, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2078, '车队管理', 2193, 1, 'fleet', 'system/fleet/index', NULL, 1, 0, 'C', '0', '0', 'system:fleet:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:00:35', '车队管理菜单');
INSERT INTO `sys_menu` VALUES (2079, '车队管理查询', 2078, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2080, '车队管理新增', 2078, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2081, '车队管理修改', 2078, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2082, '车队管理删除', 2078, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2083, '车队管理导出', 2078, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2084, '订单', 2194, 1, 'goodsorder', 'system/goodsorder/index', NULL, 1, 0, 'C', '0', '0', 'system:goodsorder:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:01:54', '订单菜单');
INSERT INTO `sys_menu` VALUES (2085, '订单查询', 2084, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2086, '订单新增', 2084, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2087, '订单修改', 2084, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2088, '订单删除', 2084, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2089, '订单导出', 2084, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2090, '货物入库', 2194, 1, 'inventory', 'system/inventory/index', NULL, 1, 0, 'C', '0', '0', 'system:inventory:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:07:56', '货物入库菜单');
INSERT INTO `sys_menu` VALUES (2091, '货物入库查询', 2090, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2092, '货物入库新增', 2090, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2093, '货物入库修改', 2090, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2094, '货物入库删除', 2090, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2095, '货物入库导出', 2090, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2096, '资金借出（期货）', 2195, 1, 'lendmoney', 'system/lendmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:lendmoney:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:08:04', '资金借出（期货）菜单');
INSERT INTO `sys_menu` VALUES (2097, '资金借出（期货）查询', 2096, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2098, '资金借出（期货）新增', 2096, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2099, '资金借出（期货）修改', 2096, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2100, '资金借出（期货）删除', 2096, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2101, '资金借出（期货）导出', 2096, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2102, '资金调整单信息', 2194, 1, 'offsetting', 'system/offsetting/index', NULL, 1, 0, 'C', '0', '0', 'system:offsetting:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:08:11', '资金调整单信息菜单');
INSERT INTO `sys_menu` VALUES (2103, '资金调整单信息查询', 2102, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2104, '资金调整单信息新增', 2102, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2105, '资金调整单信息修改', 2102, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2106, '资金调整单信息删除', 2102, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2107, '资金调整单信息导出', 2102, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2108, '加油卡主卡登记', 2202, 1, 'oilcardmain', 'system/oilcardmain/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcardmain:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:10:23', '基础信息-加油卡主卡登记菜单');
INSERT INTO `sys_menu` VALUES (2109, '基础信息-加油卡主卡登记查询', 2108, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '基础信息-加油卡主卡登记新增', 2108, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '基础信息-加油卡主卡登记修改', 2108, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '基础信息-加油卡主卡登记删除', 2108, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '基础信息-加油卡主卡登记导出', 2108, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '加油卡', 2193, 1, 'oilcard', 'system/oilcard/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcard:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:09:38', '加油卡菜单');
INSERT INTO `sys_menu` VALUES (2115, '加油卡查询', 2114, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2116, '加油卡新增', 2114, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2117, '加油卡修改', 2114, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2118, '加油卡删除', 2114, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2119, '加油卡导出', 2114, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '订单详情', 2194, 1, 'orderdetail', 'system/orderdetail/index', NULL, 1, 0, 'C', '0', '0', 'system:orderdetail:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:05:45', '订单详情菜单');
INSERT INTO `sys_menu` VALUES (2121, '订单详情查询', 2120, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '订单详情新增', 2120, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2123, '订单详情修改', 2120, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2124, '订单详情删除', 2120, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2125, '订单详情导出', 2120, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2126, '订单运费', 2197, 1, 'orderfreight', 'system/orderfreight/index', NULL, 1, 0, 'C', '0', '0', 'system:orderfreight:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:08:51', '订单运费菜单');
INSERT INTO `sys_menu` VALUES (2127, '订单运费查询', 2126, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2128, '订单运费新增', 2126, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2129, '订单运费修改', 2126, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, '订单运费删除', 2126, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, '订单运费导出', 2126, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, '订单发票', 2194, 1, 'orderinvoice', 'system/orderinvoice/index', NULL, 1, 0, 'C', '0', '0', 'system:orderinvoice:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:09:00', '订单发票菜单');
INSERT INTO `sys_menu` VALUES (2133, '订单发票查询', 2132, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2134, '订单发票新增', 2132, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2135, '订单发票修改', 2132, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2136, '订单发票删除', 2132, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2137, '订单发票导出', 2132, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2138, '收付款', 2195, 1, 'payment', 'system/payment/index', NULL, 1, 0, 'C', '0', '0', 'system:payment:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:10:48', '资产管理-收付款:收付款信息菜单');
INSERT INTO `sys_menu` VALUES (2139, '资产管理-收付款:收付款信息查询', 2138, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2140, '资产管理-收付款:收付款信息新增', 2138, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2141, '资产管理-收付款:收付款信息修改', 2138, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2142, '资产管理-收付款:收付款信息删除', 2138, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2143, '资产管理-收付款:收付款信息导出', 2138, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2144, '产品级别', 2193, 1, 'productlevel', 'system/productlevel/index', NULL, 1, 0, 'C', '0', '0', 'system:productlevel:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:03:00', '产品级别管理菜单');
INSERT INTO `sys_menu` VALUES (2145, '产品级别管理查询', 2144, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2146, '产品级别管理新增', 2144, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2147, '产品级别管理修改', 2144, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2148, '产品级别管理删除', 2144, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2149, '产品级别管理导出', 2144, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2150, '供应商返利', 2195, 1, 'rebate', 'system/rebate/index', NULL, 1, 0, 'C', '0', '0', 'system:rebate:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:11:06', '供应商返利菜单');
INSERT INTO `sys_menu` VALUES (2151, '供应商返利查询', 2150, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2152, '供应商返利新增', 2150, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2153, '供应商返利修改', 2150, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2154, '供应商返利删除', 2150, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2155, '供应商返利导出', 2150, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2156, '资金回收', 2195, 1, 'recovermoney', 'system/recovermoney/index', NULL, 1, 0, 'C', '0', '0', 'system:recovermoney:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:11:13', '资金回收菜单');
INSERT INTO `sys_menu` VALUES (2157, '资金回收查询', 2156, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2158, '资金回收新增', 2156, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2159, '资金回收修改', 2156, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2160, '资金回收删除', 2156, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2161, '资金回收导出', 2156, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2162, '还款记录', 2195, 1, 'repayment', 'system/repayment/index', NULL, 1, 0, 'C', '0', '0', 'system:repayment:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:11:22', '还款记录菜单');
INSERT INTO `sys_menu` VALUES (2163, '还款记录查询', 2162, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2164, '还款记录新增', 2162, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2165, '还款记录修改', 2162, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2166, '还款记录删除', 2162, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2167, '还款记录导出', 2162, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2168, '社保基金', 2192, 1, 'socialinsurance', 'system/socialinsurance/index', NULL, 1, 0, 'C', '0', '0', 'system:socialinsurance:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:10:37', '社保基金菜单');
INSERT INTO `sys_menu` VALUES (2169, '社保基金查询', 2168, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2170, '社保基金新增', 2168, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2171, '社保基金修改', 2168, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2172, '社保基金删除', 2168, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2173, '社保基金导出', 2168, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2174, '仓库管理', 2193, 1, 'storehouse', 'system/storehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:storehouse:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:03:38', '仓库管理菜单');
INSERT INTO `sys_menu` VALUES (2175, '仓库管理查询', 2174, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2176, '仓库管理新增', 2174, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2177, '仓库管理修改', 2174, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2178, '仓库管理删除', 2174, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2179, '仓库管理导出', 2174, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2180, '变动日志信息', 1, 1, 'tableeditmessage', 'system/tableeditmessage/index', NULL, 1, 0, 'C', '0', '0', 'system:tableeditmessage:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:05:36', '变动日志信息菜单');
INSERT INTO `sys_menu` VALUES (2181, '变动日志信息查询', 2180, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2182, '变动日志信息新增', 2180, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2183, '变动日志信息修改', 2180, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2184, '变动日志信息删除', 2180, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2185, '变动日志信息导出', 2180, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2186, '虚拟银行账户变动信息', 2193, 1, 'virtualbankaccountchange', 'system/virtualbankaccountchange/index', NULL, 1, 0, 'C', '0', '0', 'system:virtualbankaccountchange:list', '#', 'admin', '2024-07-19 10:53:23', 'admin', '2024-07-21 11:05:27', '虚拟银行账户变动信息菜单');
INSERT INTO `sys_menu` VALUES (2187, '虚拟银行账户变动信息查询', 2186, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2188, '虚拟银行账户变动信息新增', 2186, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2189, '虚拟银行账户变动信息修改', 2186, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2190, '虚拟银行账户变动信息删除', 2186, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2191, '虚拟银行账户变动信息导出', 2186, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2192, '用户中心', 0, 10, 'user', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'people', 'admin', '2024-07-21 10:52:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2193, '基础数据维护', 0, 30, 'basedata', NULL, NULL, 1, 0, 'M', '0', '0', '', 'druid', 'admin', '2024-07-21 10:53:16', 'admin', '2024-07-21 10:53:25', '');
INSERT INTO `sys_menu` VALUES (2194, '订单管理', 0, 40, 'order', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'documentation', 'admin', '2024-07-21 10:53:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2195, '资金管理', 0, 50, 'money', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'money', 'admin', '2024-07-21 10:54:12', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2196, '往来管理', 2204, 60, 'transaction', NULL, NULL, 1, 0, 'M', '0', '0', '', '#', 'admin', '2024-07-21 10:55:03', 'admin', '2024-07-21 11:26:13', '');
INSERT INTO `sys_menu` VALUES (2197, '运费管理', 0, 70, 'freight', NULL, NULL, 1, 0, 'M', '0', '0', NULL, '#', 'admin', '2024-07-21 10:55:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2198, '数据统计', 2204, 80, 'statistics', NULL, NULL, 1, 0, 'M', '0', '0', '', 'table', 'admin', '2024-07-21 10:56:00', 'admin', '2024-07-21 11:27:17', '');
INSERT INTO `sys_menu` VALUES (2199, '凭证管理', 2204, 90, 'credential ', NULL, NULL, 1, 0, 'M', '0', '0', '', '#', 'admin', '2024-07-21 10:56:21', 'admin', '2024-07-21 11:26:41', '');
INSERT INTO `sys_menu` VALUES (2200, '报表管理', 2204, 100, 'report ', NULL, NULL, 1, 0, 'M', '0', '0', '', 'tab', 'admin', '2024-07-21 10:56:53', 'admin', '2024-07-21 11:27:05', '');
INSERT INTO `sys_menu` VALUES (2201, '日报管理', 2204, 110, 'daily', NULL, NULL, 1, 0, 'M', '0', '0', '', '#', 'admin', '2024-07-21 10:57:34', 'admin', '2024-07-21 11:26:50', '');
INSERT INTO `sys_menu` VALUES (2202, '出差管理', 0, 120, 'businesstrip', NULL, NULL, 1, 0, 'M', '0', '0', NULL, '#', 'admin', '2024-07-21 10:58:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2203, '序时明细账', 2204, 130, 'detailed', NULL, NULL, 1, 0, 'M', '0', '0', '', '#', 'admin', '2024-07-21 10:58:55', 'admin', '2024-07-21 11:27:10', '');
INSERT INTO `sys_menu` VALUES (2204, '杂项', 0, 1, 'some', NULL, NULL, 1, 0, 'M', '0', '0', NULL, 'clipboard', 'admin', '2024-07-21 11:25:15', '', NULL, '');

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
) ENGINE = InnoDB AUTO_INCREMENT = 239 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"businesstrip,goodsorder,orderdetail,repayment,carapply,goodsorder_back,orderdetail_back,socialinsurance,tableeditmessage,cars,orderfreight,virtualbankaccountchange,balanceaccounts,company,orderinvoice,bankacceptance,customervisit,lendmoney,payment,bankaccount,offsetting,productlevel,bankaccountchange,fixedassets,oilcard,rebate,borrowedmoney,fleet,oilcardmain,recovermoney,inventory,storehouse,inventory_back,exwarehouse\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 10:43:31', 1994);
INSERT INTO `sys_oper_log` VALUES (101, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"businesstrip,goodsorder,orderdetail,repayment,carapply,goodsorder_back,orderdetail_back,socialinsurance,tableeditmessage,cars,orderfreight,virtualbankaccountchange,balanceaccounts,company,orderinvoice,bankacceptance,customervisit,lendmoney,payment,bankaccount,offsetting,productlevel,bankaccountchange,fixedassets,oilcard,rebate,borrowedmoney,fleet,oilcardmain,recovermoney,inventory,storehouse,inventory_back,exwarehouse\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 10:43:33', 1918);
INSERT INTO `sys_oper_log` VALUES (102, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"goodsorder,orderdetail,repayment,socialinsurance,orderfreight,balanceaccounts,orderinvoice,bankacceptance,lendmoney,exwarehouse,fixedassets,rebate,borrowedmoney,recovermoney,businesstrip,carapply,cars,inventory,storehouse,company,customervisit,bankaccount,productlevel,bankaccountchange,oilcard,fleet,tableeditmessage,orderdetail_back,virtualbankaccountchange,inventory_back,goodsorder_back,payment,offsetting,oilcardmain\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 10:47:10', 1786);
INSERT INTO `sys_oper_log` VALUES (103, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-19 10:47:32', 1789);
INSERT INTO `sys_oper_log` VALUES (104, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', NULL, '/tool/gen/86,78', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 11:34:32', 38);
INSERT INTO `sys_oper_log` VALUES (105, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"goodsorder\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 11:34:37', 194);
INSERT INTO `sys_oper_log` VALUES (106, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"orderdetail\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 11:35:04', 181);
INSERT INTO `sys_oper_log` VALUES (107, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', NULL, '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"goodsorder\",\"className\":\"Goodsorder\",\"columns\":[{\"capJavaField\":\"Id\",\"columnId\":1974,\"columnName\":\"id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-19 11:34:37\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":99,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrdersNo\",\"columnComment\":\"订单编号（UUID）\",\"columnId\":1975,\"columnName\":\"ordersNo\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-19 11:34:37\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ordersNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":99,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderDate\",\"columnComment\":\"日期\",\"columnId\":1976,\"columnName\":\"orderDate\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-19 11:34:37\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"orderDate\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":99,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Customer\",\"columnComment\":\"客户\",\"columnId\":1977,\"columnName\":\"customer\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-19 11:34:37\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 11:36:21', 120);
INSERT INTO `sys_oper_log` VALUES (108, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"goodsorder\"}', NULL, 0, NULL, '2024-07-19 11:37:41', 94);
INSERT INTO `sys_oper_log` VALUES (109, '订单', 1, 'org.dzu.system.controller.GoodsorderController.add()', 'POST', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"createBy\":\"officia occaecat\",\"createTime\":\"1982-01-24 04:59:40\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"createBy\":\"qui dolor irure\",\"createTime\":\"1985-12-30 18:18:52\",\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"remark\":\"commodo cupidatat\",\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateBy\":\"do quis\",\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2004-01-23 23:54:04\",\"userId\":39}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 17:01:34', 511);
INSERT INTO `sys_oper_log` VALUES (110, '订单', 1, 'org.dzu.system.controller.GoodsorderController.add()', 'POST', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"createBy\":\"officia occaecat\",\"createTime\":\"1982-01-24 04:59:40\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23850,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"createBy\":\"qui dolor irure\",\"createTime\":\"1985-12-30 18:18:52\",\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"8cb269c1-2631-4115-9c62-2051c3ffc808\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"remark\":\"commodo cupidatat\",\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateBy\":\"do quis\",\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"8cb269c1-2631-4115-9c62-2051c3ffc808\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2004-01-23 23:54:04\",\"userId\":39}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 17:01:41', 498);
INSERT INTO `sys_oper_log` VALUES (111, '订单', 1, 'org.dzu.system.controller.GoodsorderController.add()', 'POST', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"createBy\":\"officia occaecat\",\"createTime\":\"1982-01-24 04:59:40\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23851,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"createBy\":\"qui dolor irure\",\"createTime\":\"1985-12-30 18:18:52\",\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"15c67809-444f-4af9-84ab-ca042171c59f\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"remark\":\"commodo cupidatat\",\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateBy\":\"do quis\",\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"15c67809-444f-4af9-84ab-ca042171c59f\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2004-01-23 23:54:04\",\"userId\":39}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 17:01:43', 475);
INSERT INTO `sys_oper_log` VALUES (112, '订单', 1, 'org.dzu.system.controller.GoodsorderController.add()', 'POST', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"createBy\":\"officia occaecat\",\"createTime\":\"1982-01-24 04:59:40\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23852,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"createBy\":\"qui dolor irure\",\"createTime\":\"1985-12-30 18:18:52\",\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"8f944461-317a-450e-93b6-2bcacc691c17\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"remark\":\"commodo cupidatat\",\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateBy\":\"do quis\",\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"8f944461-317a-450e-93b6-2bcacc691c17\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2004-01-23 23:54:04\",\"userId\":39}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 17:01:48', 475);
INSERT INTO `sys_oper_log` VALUES (113, '订单', 2, 'org.dzu.system.controller.GoodsorderController.edit()', 'PUT', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存1此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"id\":62859,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2024-07-19 17:02:44\",\"userId\":39}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\r\n### The error may exist in file [D:\\Code\\project\\order-system\\order-serv\\target\\classes\\mapper\\system\\GoodsorderMapper.xml]\r\n### The error may involve org.dzu.system.mapper.GoodsorderMapper.deleteOrderdetailByOrdersNo-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from orderdetail where ordersNo = ?\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\n; Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'', '2024-07-19 17:02:42', 668);
INSERT INTO `sys_oper_log` VALUES (114, '订单', 2, 'org.dzu.system.controller.GoodsorderController.edit()', 'PUT', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存1此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"id\":62859,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2024-07-19 17:10:06\",\"userId\":39}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\r\n### The error may exist in file [D:\\Code\\project\\order-system\\order-serv\\target\\classes\\mapper\\system\\GoodsorderMapper.xml]\r\n### The error may involve org.dzu.system.mapper.GoodsorderMapper.deleteOrderdetailByOrdersNo-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from orderdetail where ordersNo = ?\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\n; Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'', '2024-07-19 17:10:28', 23428);
INSERT INTO `sys_oper_log` VALUES (115, '订单', 2, 'org.dzu.system.controller.GoodsorderController.edit()', 'PUT', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存1此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"id\":62859,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2024-07-19 17:10:57\",\"userId\":39}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\r\n### The error may exist in file [D:\\Code\\project\\order-system\\order-serv\\target\\classes\\mapper\\system\\GoodsorderMapper.xml]\r\n### The error may involve org.dzu.system.mapper.GoodsorderMapper.deleteOrderdetailByOrdersNo-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from orderdetail where ordersNo = ?\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\n; Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'', '2024-07-19 17:10:56', 626);
INSERT INTO `sys_oper_log` VALUES (116, '订单', 2, 'org.dzu.system.controller.GoodsorderController.edit()', 'PUT', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存1此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"id\":62859,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2024-07-19 17:12:51\",\"userId\":39}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\r\n### The error may exist in file [D:\\Code\\project\\order-system\\order-serv\\target\\classes\\mapper\\system\\GoodsorderMapper.xml]\r\n### The error may involve org.dzu.system.mapper.GoodsorderMapper.deleteOrderdetailByOrdersNo-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from orderdetail where ordersNo = ?\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\n; Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'', '2024-07-19 17:13:10', 20984);
INSERT INTO `sys_oper_log` VALUES (117, '订单', 2, 'org.dzu.system.controller.GoodsorderController.edit()', 'PUT', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存1此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"id\":62859,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2024-07-19 17:28:10\",\"userId\":39}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 17:28:11', 2891);
INSERT INTO `sys_oper_log` VALUES (118, '订单', 2, 'org.dzu.system.controller.GoodsorderController.edit()', 'PUT', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存1此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"id\":62859,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2024-07-19 17:37:12\",\"userId\":39}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 17:37:14', 4041);
INSERT INTO `sys_oper_log` VALUES (119, '订单', 2, 'org.dzu.system.controller.GoodsorderController.edit()', 'PUT', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"1981-03-17 19:20:50\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":53,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23849,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存1此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"id\":62859,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"00450796-a26e-4f1c-8fa3-c878c6b655a9\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2024-07-19 17:37:20\",\"userId\":39}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 17:37:19', 846);
INSERT INTO `sys_oper_log` VALUES (120, '订单', 1, 'org.dzu.system.controller.GoodsorderController.add()', 'POST', 1, NULL, NULL, '/system/goodsorder', '127.0.0.1', '内网IP', '{\"addtime\":\"2024-07-19 18:21:47\",\"adjustDate\":\"2009-04-03\",\"adjustOrderid\":3,\"cancelFlag\":0,\"checkState\":\"1\",\"checkUserId\":23,\"comments\":\"voluptate\",\"createBy\":\"officia occaecat\",\"createTime\":\"1982-01-24 04:59:40\",\"customer\":\"Ut anim magna\",\"customerId\":21,\"customerIsInvoice\":95,\"id\":23853,\"invoiceState\":\"1\",\"isAdjust\":\"1\",\"isAdjusted\":\"1\",\"isSupplierInvoice\":26,\"isedit\":18,\"landBankName\":\"电手门点极为\",\"landDriverName\":\"料消存此边\",\"landDriverTel\":\"18195573273\",\"landcarId\":8,\"orderDate\":\"1982-10-20\",\"orderdetailList\":[{\"actualPieces\":98,\"additionalFees\":52,\"addtime\":\"2002-07-14 15:11:50\",\"adjustDate\":\"2022-05-07\",\"cancelFlag\":56,\"createBy\":\"qui dolor irure\",\"createTime\":\"1985-12-30 18:18:52\",\"customerCommission\":56,\"customerId\":88,\"erro\":61,\"freight\":72,\"height\":25,\"isAdjusted\":\"1\",\"isIncludeTaxFactory\":71,\"isIncludeTaxSale\":19,\"landFreight\":9,\"landFreightPrice\":85,\"length\":12,\"levelID\":16,\"levelName\":\"格厂战南\",\"logisticsProfit\":43,\"orderDate\":\"1987-12-20\",\"ordersNo\":\"1db10918-652c-4838-aab5-6bcb800c7555\",\"otherCost\":37,\"packs\":52,\"params\":{},\"paymentFactory\":99,\"paymentUnload\":92,\"payments\":63,\"paymentsWithSundry\":92,\"pieces\":91,\"piecesPerPack\":26,\"price\":43,\"profit\":89,\"profitNoTax\":76,\"remark\":\"commodo cupidatat\",\"seaFreight\":68,\"storeHouseID\":61,\"storeHouseName\":\"路影林\",\"storeID\":90,\"sundryCost\":19,\"supplier\":\"incididunt minim id\",\"supplierId\":6,\"tonnage\":3,\"updateBy\":\"do quis\",\"updateTime\":\"2017-10-18 14:00:44\",\"userId\":52,\"width\":100}],\"ordersNo\":\"1db10918-652c-4838-aab5-6bcb800c7555\",\"params\":{},\"saleManager\":\"dolore cillum\",\"seaBankName\":\"着志西年部\",\"seaBankNo\":\"nisi eiusmod ipsum qui amet\",\"seaCarNo\":\"mollit\",\"seaDriverName\":\"率年白\",\"seaDriverTel\":\"13596554422\",\"seacarId\":60,\"updateTime\":\"2004-01-23 23:54:04\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 18:21:46', 500);
INSERT INTO `sys_oper_log` VALUES (121, '订单', 3, 'org.dzu.system.controller.GoodsorderController.remove()', 'DELETE', 1, NULL, NULL, '/system/goodsorder/23853', '127.0.0.1', '内网IP', '{}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\r\n### The error may exist in file [D:\\Code\\project\\order-system\\order-serv\\target\\classes\\mapper\\system\\GoodsorderMapper.xml]\r\n### The error may involve org.dzu.system.mapper.GoodsorderMapper.deleteOrderdetailByOrdersNos-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update  orderdetail set cancelFlag = 1 where ordersNo in          (               ?          )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'\n; Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Truncated incorrect DOUBLE value: \'00450796-a26e-4f1c-8fa3-c878c6b655a9\'', '2024-07-19 18:22:03', 355);
INSERT INTO `sys_oper_log` VALUES (122, '订单', 3, 'org.dzu.system.controller.GoodsorderController.remove()', 'DELETE', 1, NULL, NULL, '/system/goodsorder/23853', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 18:28:16', 544);
INSERT INTO `sys_oper_log` VALUES (123, '客户管理', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"先气增海报过\",\"address\":\"黑龙江省白城市深坑区\",\"addtime\":\"2024-07-19 21:39:20\",\"bankName\":\"干内装委史\",\"bankNo\":\"consectetur\",\"city\":\"苏州市\",\"comments\":\"fugiat\",\"company\":\"毛磊测试\",\"companyType\":\"客户\",\"county\":\"enim ea ullamco pariatur officia\",\"delFlag\":0,\"id\":1,\"leaderTel\":\"18148469617\",\"params\":{},\"province\":\"湖南省\",\"region\":\"湖南省-苏州市=enim ea ullamco pariatur officia\",\"relationName\":\"新志体最办许关\",\"relationTel\":\"18157849887\",\"salesman\":\"laboris\",\"surplusMoney\":64.0,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 21:39:18', 147);
INSERT INTO `sys_oper_log` VALUES (124, '客户管理', 2, 'org.dzu.system.controller.CompanyController.edit()', 'PUT', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"先气增海报过\",\"address\":\"黑龙江省白城市深坑区\",\"addtime\":\"2024-07-19 21:41:49\",\"bankName\":\"干内装委史\",\"bankNo\":\"consectetur\",\"city\":\"苏州市\",\"comments\":\"fugiat\",\"company\":\"毛磊2测试\",\"companyType\":\"客户\",\"county\":\"enim ea ullamco pariatur officia\",\"delFlag\":0,\"id\":1,\"leaderTel\":\"18148469617\",\"params\":{},\"province\":\"湖南省\",\"region\":\"湖南省-苏州市=enim ea ullamco pariatur officia\",\"relationName\":\"新志体最办许关\",\"relationTel\":\"18157849887\",\"salesman\":\"laboris\",\"surplusMoney\":64.0,\"updateTime\":\"2024-07-19 21:41:49\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 21:41:47', 145);
INSERT INTO `sys_oper_log` VALUES (125, '客户管理', 3, 'org.dzu.system.controller.CompanyController.remove()', 'DELETE', 1, NULL, NULL, '/system/company/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-19 21:42:19', 122);
INSERT INTO `sys_oper_log` VALUES (126, '客户管理', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"先气增海报过\",\"address\":\"黑龙江省白城市深坑区\",\"addtime\":\"2024-07-20 07:52:29\",\"bankName\":\"干内装委史\",\"bankNo\":\"consectetur\",\"city\":\"苏州市\",\"comments\":\"fugiat\",\"company\":\"毛磊测试\",\"companyType\":\"客户\",\"county\":\"ml村\",\"delFlag\":0,\"id\":2,\"leaderTel\":\"18148469617\",\"params\":{},\"province\":\"湖南省\",\"region\":\"湖南省-苏州市=ml村\",\"relationName\":\"新志体最办许关\",\"relationTel\":\"18157849887\",\"salesman\":\"laboris\",\"surplusMoney\":1.2345679E8,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 07:53:07', 38660);
INSERT INTO `sys_oper_log` VALUES (127, '客户管理', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"先气增海报过\",\"address\":\"黑龙江省白城市深坑区\",\"addtime\":\"2024-07-20 08:46:09\",\"bankName\":\"干内装委史\",\"bankNo\":\"consectetur\",\"city\":\"苏州市\",\"comments\":\"fugiat\",\"company\":\"毛磊测试\",\"companyType\":\"客户\",\"county\":\"ml村\",\"delFlag\":0,\"id\":3,\"leaderTel\":\"18148469617\",\"params\":{},\"province\":\"湖南省\",\"region\":\"湖南省-苏州市=ml村\",\"relationName\":\"新志体最办许关\",\"relationTel\":\"18157849887\",\"salesman\":\"laboris\",\"surplusMoney\":1239.39,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 08:46:09', 174);
INSERT INTO `sys_oper_log` VALUES (128, '客户管理', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"先气增海报过\",\"address\":\"黑龙江省白城市深坑区\",\"addtime\":\"2024-07-20 08:49:11\",\"bankName\":\"干内装委史\",\"bankNo\":\"consectetur\",\"city\":\"苏州市\",\"comments\":\"fugiat\",\"company\":\"毛磊测试\",\"companyType\":\"客户\",\"county\":\"ml村\",\"delFlag\":0,\"id\":4,\"leaderTel\":\"18148469617\",\"params\":{},\"province\":\"湖南省\",\"region\":\"湖南省-苏州市=ml村\",\"relationName\":\"新志体最办许关\",\"relationTel\":\"18157849887\",\"salesman\":\"laboris\",\"surplusMoney\":1239.39,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 08:49:11', 161);
INSERT INTO `sys_oper_log` VALUES (129, '客户管理', 1, 'org.dzu.system.controller.CompanyController.add()', 'POST', 1, NULL, NULL, '/system/company', '127.0.0.1', '内网IP', '{\"acountsName\":\"先气增海报过\",\"address\":\"黑龙江省白城市深坑区\",\"addtime\":\"2024-07-20 08:49:22\",\"bankName\":\"干内装委史\",\"bankNo\":\"consectetur\",\"city\":\"苏州市\",\"comments\":\"fugiat\",\"company\":\"毛磊测试\",\"companyType\":\"客户\",\"county\":\"ml村\",\"delFlag\":0,\"id\":5,\"leaderTel\":\"18148469617\",\"params\":{},\"province\":\"湖南省\",\"region\":\"湖南省-苏州市=ml村\",\"relationName\":\"新志体最办许关\",\"relationTel\":\"18157849887\",\"salesman\":\"laboris\",\"surplusMoney\":1.23456789111139E12,\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 08:49:22', 123);
INSERT INTO `sys_oper_log` VALUES (130, '产品级别管理', 1, 'org.dzu.system.controller.ProductlevelController.add()', 'POST', 1, NULL, NULL, '/system/productlevel', '127.0.0.1', '内网IP', '{\"addtime\":\"2024-07-20 09:32:09\",\"categoryName\":\"电物共下格把那\",\"categoryNo\":3,\"delFlag\":0,\"height\":87,\"id\":1,\"length\":23,\"levelName\":\"放复提知\",\"levelNo\":\"esse sed\",\"params\":{},\"tonnage\":55,\"updateTime\":\"2024-07-20 09:32:09\",\"userId\":1,\"width\":70}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 09:32:09', 343);
INSERT INTO `sys_oper_log` VALUES (131, '产品级别管理', 2, 'org.dzu.system.controller.ProductlevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productlevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"电物共下格把那\",\"categoryNo\":3,\"delFlag\":0,\"height\":87,\"length\":23,\"levelName\":\"放复提知\",\"levelNo\":\"esse sed\",\"params\":{},\"tonnage\":552,\"updateTime\":\"2024-07-20 09:36:06\",\"userId\":1,\"width\":70}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-20 09:36:06', 161);
INSERT INTO `sys_oper_log` VALUES (132, '产品级别管理', 2, 'org.dzu.system.controller.ProductlevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productlevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"电物共下格把那\",\"categoryNo\":3,\"delFlag\":0,\"height\":87,\"length\":23,\"levelName\":\"放复提知\",\"levelNo\":\"esse sed\",\"params\":{},\"tonnage\":552,\"updateTime\":\"2024-07-20 09:36:22\",\"userId\":1,\"width\":70}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2024-07-20 09:36:21', 144);
INSERT INTO `sys_oper_log` VALUES (133, '产品级别管理', 2, 'org.dzu.system.controller.ProductlevelController.edit()', 'PUT', 1, NULL, NULL, '/system/productlevel', '127.0.0.1', '内网IP', '{\"categoryName\":\"电物共下格把那\",\"categoryNo\":3,\"delFlag\":0,\"height\":87,\"id\":1,\"length\":23,\"levelName\":\"放复提知\",\"levelNo\":\"esse sed\",\"params\":{},\"tonnage\":552,\"updateTime\":\"2024-07-20 09:36:30\",\"userId\":1,\"width\":70}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 09:36:30', 144);
INSERT INTO `sys_oper_log` VALUES (134, '产品级别管理', 3, 'org.dzu.system.controller.ProductlevelController.remove()', 'DELETE', 1, NULL, NULL, '/system/productlevel/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 09:36:40', 146);
INSERT INTO `sys_oper_log` VALUES (135, '银行卡管理', 1, 'org.dzu.system.controller.BankaccountController.add()', 'POST', 1, NULL, NULL, '/system/bankaccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"毛磊账户\",\"acountsType\":\"客户\",\"amount\":1231231.12,\"bankName\":\"农商银行\",\"bankNo\":\"银行账号\",\"comments\":\"elit consequat exercitation\",\"companyId\":10,\"companyName\":\"毛磊\",\"delFlag\":0,\"id\":1647,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 10:27:40', 178);
INSERT INTO `sys_oper_log` VALUES (136, '银行卡管理', 1, 'org.dzu.system.controller.BankaccountController.add()', 'POST', 1, NULL, NULL, '/system/bankaccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"毛磊账户\",\"acountsType\":\"客户\",\"amount\":1231231.12,\"bankName\":\"农商银行\",\"bankNo\":\"银行账号\",\"comments\":\"elit consequat exercitation\",\"companyId\":10,\"companyName\":\"毛磊\",\"delFlag\":0,\"id\":1648,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 10:29:19', 112);
INSERT INTO `sys_oper_log` VALUES (137, '银行卡管理', 2, 'org.dzu.system.controller.BankaccountController.edit()', 'PUT', 1, NULL, NULL, '/system/bankaccount', '127.0.0.1', '内网IP', '{\"acountsName\":\"毛磊账户\",\"acountsType\":\"客户\",\"amount\":1231231.12,\"bankName\":\"农商银行\",\"bankNo\":\"银行账号\",\"comments\":\"elit consequat exercitation\",\"companyId\":10,\"companyName\":\"毛磊2\",\"delFlag\":0,\"id\":1647,\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 10:32:14', 153);
INSERT INTO `sys_oper_log` VALUES (138, '银行卡管理', 3, 'org.dzu.system.controller.BankaccountController.remove()', 'DELETE', 1, NULL, NULL, '/system/bankaccount/1647', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 10:32:33', 139);
INSERT INTO `sys_oper_log` VALUES (139, '车辆管理', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"213421341364\",\"acountsType\":1,\"addtime\":\"2024-07-20 11:44:40\",\"bankName\":\"工商银行\",\"bankNo\":\"2134123412341234\",\"carType\":\"陆运\",\"delFlag\":0,\"driver\":\"毛司机\",\"id\":1,\"params\":{},\"tel\":\"18632024906\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 11:44:40', 373);
INSERT INTO `sys_oper_log` VALUES (140, '车辆管理', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"213421341364\",\"acountsType\":1,\"addtime\":\"2024-07-20 11:45:25\",\"bankName\":\"工商银行\",\"bankNo\":\"2134123412341234\",\"carType\":\"陆运\",\"delFlag\":0,\"driver\":\"毛司机\",\"id\":2,\"params\":{},\"tel\":\"18632024906\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 11:45:25', 24893);
INSERT INTO `sys_oper_log` VALUES (141, '车辆管理', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"213421341364\",\"acountsType\":1,\"bankName\":\"工商银行\",\"bankNo\":\"2134123412341234\",\"carType\":\"陆运\",\"driver\":\"毛司机\",\"params\":{},\"tel\":\"18632024906\"}', NULL, 1, '陆运必须填写车牌号信息', '2024-07-20 11:49:19', 12);
INSERT INTO `sys_oper_log` VALUES (142, '车辆管理', 1, 'org.dzu.system.controller.CarsController.add()', 'POST', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"213421341364\",\"acountsType\":1,\"addtime\":\"2024-07-20 11:50:11\",\"bankName\":\"工商银行\",\"bankNo\":\"2134123412341234\",\"carNo\":\"123123123\",\"carType\":\"陆运\",\"delFlag\":0,\"driver\":\"毛司机\",\"id\":3,\"params\":{},\"tel\":\"18632024906\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 11:50:11', 499);
INSERT INTO `sys_oper_log` VALUES (143, '车辆管理', 2, 'org.dzu.system.controller.CarsController.edit()', 'PUT', 1, NULL, NULL, '/system/cars', '127.0.0.1', '内网IP', '{\"acountsName\":\"213421341364\",\"acountsType\":1,\"bankName\":\"工商银行\",\"bankNo\":\"2134123412341234\",\"carType\":\"海运\",\"driver\":\"毛司机\",\"id\":1,\"params\":{},\"tel\":\"18632024906\",\"updateTime\":\"2024-07-20 11:51:48\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 11:51:47', 734);
INSERT INTO `sys_oper_log` VALUES (144, '车辆管理', 3, 'org.dzu.system.controller.CarsController.remove()', 'DELETE', 1, NULL, NULL, '/system/cars/3', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 11:52:51', 131);
INSERT INTO `sys_oper_log` VALUES (145, '车队管理', 1, 'org.dzu.system.controller.FleetController.add()', 'POST', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"湖北省阿坝藏族羌族自治州-\",\"addtime\":\"2024-07-20 12:14:08\",\"delFlag\":0,\"fLeader\":\"毛磊\",\"fName\":\"毛家队\",\"id\":1,\"params\":{},\"tel\":\"18197761021\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 12:14:08', 168);
INSERT INTO `sys_oper_log` VALUES (146, '车队管理', 1, 'org.dzu.system.controller.FleetController.add()', 'POST', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"湖北省阿坝藏族羌族自治州-\",\"addtime\":\"2024-07-20 12:15:52\",\"delFlag\":0,\"fLeader\":\"毛磊\",\"fName\":\"毛家队\",\"id\":2,\"params\":{},\"tel\":\"18197761021\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 12:15:51', 218);
INSERT INTO `sys_oper_log` VALUES (147, '车队管理', 2, 'org.dzu.system.controller.FleetController.edit()', 'PUT', 1, NULL, NULL, '/system/fleet', '127.0.0.1', '内网IP', '{\"address\":\"湖北省阿坝藏族羌族自治州-\",\"addtime\":\"2024-07-20 12:14:08\",\"delFlag\":0,\"editTime\":\"2024-07-20 12:16:46\",\"fLeader\":\"毛磊\",\"fName\":\"毛家军\",\"id\":1,\"params\":{},\"tel\":\"18197761021\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 12:16:46', 142);
INSERT INTO `sys_oper_log` VALUES (148, '车队管理', 3, 'org.dzu.system.controller.FleetController.remove()', 'DELETE', 1, NULL, NULL, '/system/fleet/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 12:17:22', 144);
INSERT INTO `sys_oper_log` VALUES (149, '车队管理', 3, 'org.dzu.system.controller.FleetController.remove()', 'DELETE', 1, NULL, NULL, '/system/fleet/1', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-20 12:17:35', 139);
INSERT INTO `sys_oper_log` VALUES (150, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/cars/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2048,\"menuName\":\"车辆管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"cars\",\"perms\":\"system:cars:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 09:51:43', 244);
INSERT INTO `sys_oper_log` VALUES (151, '角色管理', 3, 'com.ruoyi.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', NULL, '/system/role/2', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:48:20', 707);
INSERT INTO `sys_oper_log` VALUES (152, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', NULL, '/system/menu/4', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:48:26', 280);
INSERT INTO `sys_oper_log` VALUES (153, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-19 10:12:49\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:48:31', 183);
INSERT INTO `sys_oper_log` VALUES (154, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-19 10:12:49\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:48:37', 177);
INSERT INTO `sys_oper_log` VALUES (155, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', NULL, '/system/menu/104', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2024-07-21 10:48:50', 70);
INSERT INTO `sys_oper_log` VALUES (156, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-19 10:12:49\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:51:21', 212);
INSERT INTO `sys_oper_log` VALUES (157, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"people\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"用户中心\",\"menuType\":\"M\",\"orderNum\":10,\"params\":{},\"parentId\":0,\"path\":\"user\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:52:13', 215);
INSERT INTO `sys_oper_log` VALUES (158, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"基础数据维护\",\"menuType\":\"M\",\"orderNum\":20,\"params\":{},\"parentId\":0,\"path\":\"basedata\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:53:17', 212);
INSERT INTO `sys_oper_log` VALUES (159, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:53:16\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2193,\"menuName\":\"基础数据维护\",\"menuType\":\"M\",\"orderNum\":30,\"params\":{},\"parentId\":0,\"path\":\"basedata\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:53:26', 213);
INSERT INTO `sys_oper_log` VALUES (160, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"订单管理\",\"menuType\":\"M\",\"orderNum\":40,\"params\":{},\"parentId\":0,\"path\":\"order\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:53:49', 177);
INSERT INTO `sys_oper_log` VALUES (161, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"money\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"资金管理\",\"menuType\":\"M\",\"orderNum\":50,\"params\":{},\"parentId\":0,\"path\":\"money\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:54:12', 181);
INSERT INTO `sys_oper_log` VALUES (162, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"往来管理\",\"menuType\":\"M\",\"orderNum\":60,\"params\":{},\"parentId\":0,\"path\":\"transaction\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:55:04', 211);
INSERT INTO `sys_oper_log` VALUES (163, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"运费管理\",\"menuType\":\"M\",\"orderNum\":70,\"params\":{},\"parentId\":0,\"path\":\"freight\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:55:26', 215);
INSERT INTO `sys_oper_log` VALUES (164, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"数据统计\",\"menuType\":\"M\",\"orderNum\":80,\"params\":{},\"parentId\":0,\"path\":\"statistics\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:56:01', 354);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"凭证管理\",\"menuType\":\"M\",\"orderNum\":90,\"params\":{},\"parentId\":0,\"path\":\"credential \",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:56:21', 175);
INSERT INTO `sys_oper_log` VALUES (166, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"tab\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"报表管理\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"report \",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:56:53', 209);
INSERT INTO `sys_oper_log` VALUES (167, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"日报管理\",\"menuType\":\"M\",\"orderNum\":110,\"params\":{},\"parentId\":0,\"path\":\"daily\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:57:34', 212);
INSERT INTO `sys_oper_log` VALUES (168, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"出差管理\",\"menuType\":\"M\",\"orderNum\":120,\"params\":{},\"parentId\":0,\"path\":\"businesstrip\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:58:03', 176);
INSERT INTO `sys_oper_log` VALUES (169, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"序时明细账\",\"menuType\":\"M\",\"orderNum\":130,\"params\":{},\"parentId\":0,\"path\":\"detailed\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:58:55', 173);
INSERT INTO `sys_oper_log` VALUES (170, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/cars/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2048,\"menuName\":\"车辆管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"cars\",\"perms\":\"system:cars:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 10:59:34', 212);
INSERT INTO `sys_oper_log` VALUES (171, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:53:48\",\"icon\":\"documentation\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2194,\"menuName\":\"订单管理\",\"menuType\":\"M\",\"orderNum\":40,\"params\":{},\"parentId\":2194,\"path\":\"order\",\"perms\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'订单管理\'失败，上级菜单不能选择自己\",\"code\":500}', 0, NULL, '2024-07-21 10:59:52', 59);
INSERT INTO `sys_oper_log` VALUES (172, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/company/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2054,\"menuName\":\"客户管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"company\",\"perms\":\"system:company:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:00:10', 212);
INSERT INTO `sys_oper_log` VALUES (173, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/fleet/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2078,\"menuName\":\"车队管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"fleet\",\"perms\":\"system:fleet:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:00:35', 210);
INSERT INTO `sys_oper_log` VALUES (174, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', NULL, '/system/menu/117', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:01:41', 346);
INSERT INTO `sys_oper_log` VALUES (175, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/goodsorder/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2084,\"menuName\":\"订单\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2194,\"path\":\"goodsorder\",\"perms\":\"system:goodsorder:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:01:55', 212);
INSERT INTO `sys_oper_log` VALUES (176, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/productlevel/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2144,\"menuName\":\"产品级别\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"productlevel\",\"perms\":\"system:productlevel:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:03:00', 175);
INSERT INTO `sys_oper_log` VALUES (177, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/bankaccountchange/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2018,\"menuName\":\"银行卡资金变动\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"bankaccountchange\",\"perms\":\"system:bankaccountchange:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:03:17', 174);
INSERT INTO `sys_oper_log` VALUES (178, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/bankaccount/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2024,\"menuName\":\"银行卡管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"bankaccount\",\"perms\":\"system:bankaccount:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:03:24', 210);
INSERT INTO `sys_oper_log` VALUES (179, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/storehouse/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2174,\"menuName\":\"仓库管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"storehouse\",\"perms\":\"system:storehouse:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:03:38', 211);
INSERT INTO `sys_oper_log` VALUES (180, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/businesstrip/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2036,\"menuName\":\"出差登记\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2202,\"path\":\"businesstrip\",\"perms\":\"system:businesstrip:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:05:12', 212);
INSERT INTO `sys_oper_log` VALUES (181, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/carapply/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"车辆派出管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2202,\"path\":\"carapply\",\"perms\":\"system:carapply:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:05:18', 214);
INSERT INTO `sys_oper_log` VALUES (182, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/virtualbankaccountchange/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2186,\"menuName\":\"虚拟银行账户变动信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"virtualbankaccountchange\",\"perms\":\"system:virtualbankaccountchange:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:05:27', 210);
INSERT INTO `sys_oper_log` VALUES (183, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/tableeditmessage/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2180,\"menuName\":\"变动日志信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1,\"path\":\"tableeditmessage\",\"perms\":\"system:tableeditmessage:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:05:36', 213);
INSERT INTO `sys_oper_log` VALUES (184, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/orderdetail/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2120,\"menuName\":\"订单详情\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2194,\"path\":\"orderdetail\",\"perms\":\"system:orderdetail:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:05:45', 210);
INSERT INTO `sys_oper_log` VALUES (185, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/exwarehouse/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2066,\"menuName\":\"出库\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2194,\"path\":\"exwarehouse\",\"perms\":\"system:exwarehouse:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:05:54', 212);
INSERT INTO `sys_oper_log` VALUES (186, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/customervisit/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"走访记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2202,\"path\":\"customervisit\",\"perms\":\"system:customervisit:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:06:25', 211);
INSERT INTO `sys_oper_log` VALUES (187, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/balanceaccounts/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2006,\"menuName\":\"平账\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"balanceaccounts\",\"perms\":\"system:balanceaccounts:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:06:44', 230);
INSERT INTO `sys_oper_log` VALUES (188, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/bankacceptance/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2012,\"menuName\":\"商业票据、银行承兑\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"bankacceptance\",\"perms\":\"system:bankacceptance:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:06:52', 210);
INSERT INTO `sys_oper_log` VALUES (189, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/borrowedmoney/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2030,\"menuName\":\"从外部借入款、贷款\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"borrowedmoney\",\"perms\":\"system:borrowedmoney:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:07:01', 211);
INSERT INTO `sys_oper_log` VALUES (190, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/fixedassets/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2072,\"menuName\":\"固定资产\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"fixedassets\",\"perms\":\"system:fixedassets:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:07:48', 210);
INSERT INTO `sys_oper_log` VALUES (191, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/inventory/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2090,\"menuName\":\"货物入库\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2194,\"path\":\"inventory\",\"perms\":\"system:inventory:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:07:56', 209);
INSERT INTO `sys_oper_log` VALUES (192, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/lendmoney/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2096,\"menuName\":\"资金借出（期货）\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"lendmoney\",\"perms\":\"system:lendmoney:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:08:04', 209);
INSERT INTO `sys_oper_log` VALUES (193, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/offsetting/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2102,\"menuName\":\"资金调整单信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2194,\"path\":\"offsetting\",\"perms\":\"system:offsetting:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:08:11', 212);
INSERT INTO `sys_oper_log` VALUES (194, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/orderfreight/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2126,\"menuName\":\"订单运费\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2197,\"path\":\"orderfreight\",\"perms\":\"system:orderfreight:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:08:51', 211);
INSERT INTO `sys_oper_log` VALUES (195, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/orderinvoice/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2132,\"menuName\":\"订单发票\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2194,\"path\":\"orderinvoice\",\"perms\":\"system:orderinvoice:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:09:00', 211);
INSERT INTO `sys_oper_log` VALUES (196, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/payment/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2138,\"menuName\":\"收付款\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":3,\"path\":\"payment\",\"perms\":\"system:payment:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:09:26', 210);
INSERT INTO `sys_oper_log` VALUES (197, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/oilcard/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2114,\"menuName\":\"加油卡\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2193,\"path\":\"oilcard\",\"perms\":\"system:oilcard:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:09:38', 209);
INSERT INTO `sys_oper_log` VALUES (198, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/oilcardmain/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2108,\"menuName\":\"加油卡主卡登记\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2197,\"path\":\"oilcardmain\",\"perms\":\"system:oilcardmain:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:09:57', 212);
INSERT INTO `sys_oper_log` VALUES (199, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/oilcardmain/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2108,\"menuName\":\"加油卡主卡登记\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2202,\"path\":\"oilcardmain\",\"perms\":\"system:oilcardmain:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:10:23', 211);
INSERT INTO `sys_oper_log` VALUES (200, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/socialinsurance/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2168,\"menuName\":\"社保基金\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2192,\"path\":\"socialinsurance\",\"perms\":\"system:socialinsurance:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:10:37', 211);
INSERT INTO `sys_oper_log` VALUES (201, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/payment/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2138,\"menuName\":\"收付款\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"payment\",\"perms\":\"system:payment:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:10:48', 211);
INSERT INTO `sys_oper_log` VALUES (202, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/rebate/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2150,\"menuName\":\"供应商返利\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"rebate\",\"perms\":\"system:rebate:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:11:06', 211);
INSERT INTO `sys_oper_log` VALUES (203, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/recovermoney/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2156,\"menuName\":\"资金回收\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"recovermoney\",\"perms\":\"system:recovermoney:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:11:13', 210);
INSERT INTO `sys_oper_log` VALUES (204, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/repayment/index\",\"createTime\":\"2024-07-19 10:53:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2162,\"menuName\":\"还款记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2195,\"path\":\"repayment\",\"perms\":\"system:repayment:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:11:22', 211);
INSERT INTO `sys_oper_log` VALUES (205, '菜单管理', 1, 'org.dzu.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"杂项\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"123\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:25:16', 255);
INSERT INTO `sys_oper_log` VALUES (206, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:55:03\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2196,\"menuName\":\"往来管理\",\"menuType\":\"M\",\"orderNum\":60,\"params\":{},\"parentId\":2204,\"path\":\"transaction\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:26:14', 229);
INSERT INTO `sys_oper_log` VALUES (207, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:56:21\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2199,\"menuName\":\"凭证管理\",\"menuType\":\"M\",\"orderNum\":90,\"params\":{},\"parentId\":2204,\"path\":\"credential \",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:26:41', 205);
INSERT INTO `sys_oper_log` VALUES (208, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:57:34\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2201,\"menuName\":\"日报管理\",\"menuType\":\"M\",\"orderNum\":110,\"params\":{},\"parentId\":2204,\"path\":\"daily\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:26:50', 358);
INSERT INTO `sys_oper_log` VALUES (209, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:56:53\",\"icon\":\"tab\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2200,\"menuName\":\"报表管理\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":2204,\"path\":\"report \",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:27:05', 260);
INSERT INTO `sys_oper_log` VALUES (210, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:58:55\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2203,\"menuName\":\"序时明细账\",\"menuType\":\"M\",\"orderNum\":130,\"params\":{},\"parentId\":2204,\"path\":\"detailed\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:27:10', 260);
INSERT INTO `sys_oper_log` VALUES (211, '菜单管理', 2, 'org.dzu.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-21 10:56:00\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2198,\"menuName\":\"数据统计\",\"menuType\":\"M\",\"orderNum\":80,\"params\":{},\"parentId\":2204,\"path\":\"statistics\",\"perms\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-21 11:27:17', 307);
INSERT INTO `sys_oper_log` VALUES (212, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-19 10:12:49\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 19:07:00', 221);
INSERT INTO `sys_oper_log` VALUES (213, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-07-19 10:12:49\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":1,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:13:15', 236);
INSERT INTO `sys_oper_log` VALUES (214, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', NULL, '/tool/gen/65,66,67,68,69,70,71,72,73,74,75,76,77,79,80,81,82,83,84,85,87,88,89,90,91,92,93,94,95,96,97,98,99,100', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:18:09', 482);
INSERT INTO `sys_oper_log` VALUES (215, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"virtualbankaccountchange,tableeditmessage,socialinsurance,repayment,recovermoney,rebate,productlevel,payment,orderinvoice,orderfreight,orderdetail_back,orderdetail,oilcardmain,lendmoney,inventory_back,oilcard,offsetting,inventory,goodsorder_back,goodsorder,fleet,fixedassets,exwarehouse,customervisit,carapply,businesstrip,company,cars,borrowedmoney,bankaccountchange,bankaccount,bankacceptance,balanceaccounts,storehouse\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:20:16', 99316);
INSERT INTO `sys_oper_log` VALUES (216, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"virtualbankaccountchange,tableeditmessage,socialinsurance,repayment,recovermoney,rebate,productlevel,payment,orderinvoice,orderfreight,orderdetail_back,orderdetail,oilcardmain,lendmoney,inventory_back,oilcard,offsetting,inventory,goodsorder_back,goodsorder,fleet,fixedassets,exwarehouse,customervisit,carapply,businesstrip,company,cars,borrowedmoney,bankaccountchange,bankaccount,bankacceptance,balanceaccounts,storehouse\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:20:18', 105556);
INSERT INTO `sys_oper_log` VALUES (217, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"virtualbankaccountchange,tableeditmessage,socialinsurance,repayment,recovermoney,rebate,productlevel,payment,orderinvoice,orderfreight,orderdetail_back,orderdetail,oilcardmain,lendmoney,inventory_back,oilcard,offsetting,inventory,goodsorder_back,goodsorder,fleet,fixedassets,exwarehouse,customervisit,carapply,businesstrip,company,cars,borrowedmoney,bankaccountchange,bankaccount,bankacceptance,balanceaccounts,storehouse\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:20:34', 119367);
INSERT INTO `sys_oper_log` VALUES (218, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', NULL, '/tool/gen/101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:22:38', 435);
INSERT INTO `sys_oper_log` VALUES (219, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', NULL, '/tool/gen/151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:22:42', 423);
INSERT INTO `sys_oper_log` VALUES (220, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', NULL, '/tool/gen/201,202', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:22:46', 395);
INSERT INTO `sys_oper_log` VALUES (221, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"virtualbankaccountchange,tableeditmessage,repayment,sys_config,storehouse,recovermoney,rebate,productlevel,payment,orderinvoice,orderfreight,orderdetail_back,orderdetail,oilcardmain,oilcard,offsetting,lendmoney,inventory_back,inventory,goodsorder_back,goodsorder,fleet,fixedassets,exwarehouse,customervisit,company,cars,carapply,businesstrip,borrowedmoney,bankaccountchange,bankaccount,bankacceptance,balanceaccounts,socialinsurance\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-28 21:24:40', 91315);
INSERT INTO `sys_oper_log` VALUES (222, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment\"}', NULL, 0, NULL, '2024-07-29 07:51:12', 3531);
INSERT INTO `sys_oper_log` VALUES (223, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,sys_config,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 08:26:41', 4654);
INSERT INTO `sys_oper_log` VALUES (224, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', NULL, '/tool/gen/218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 08:32:02', 482);
INSERT INTO `sys_oper_log` VALUES (225, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', NULL, '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"virtualbankaccountchange,tableeditmessage,repayment,storehouse,socialinsurance,recovermoney,rebate,productlevel,payment,orderinvoice,orderfreight,orderdetail_back,orderdetail,oilcardmain,offsetting,lendmoney,inventory_back,oilcard,inventory,goodsorder_back,goodsorder,fleet,fixedassets,exwarehouse,customervisit,company,cars,carapply,businesstrip,borrowedmoney,bankaccountchange,bankaccount,bankacceptance,balanceaccounts\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 08:34:57', 103611);
INSERT INTO `sys_oper_log` VALUES (226, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 08:40:14', 4127);
INSERT INTO `sys_oper_log` VALUES (227, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 09:13:26', 7789);
INSERT INTO `sys_oper_log` VALUES (228, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 09:17:45', 7638);
INSERT INTO `sys_oper_log` VALUES (229, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 09:19:30', 7097);
INSERT INTO `sys_oper_log` VALUES (230, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 09:33:22', 7478);
INSERT INTO `sys_oper_log` VALUES (231, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 09:35:36', 7199);
INSERT INTO `sys_oper_log` VALUES (232, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 09:38:42', 7979);
INSERT INTO `sys_oper_log` VALUES (233, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', NULL, '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"OrderdetailBack\",\"className\":\"OrderdetailBack\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":5832,\"columnName\":\"id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":275,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderId\",\"columnComment\":\"原订单详情ID\",\"columnId\":5833,\"columnName\":\"orderId\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"orderId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":275,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrdersNo\",\"columnComment\":\"订单编号（UUID）\",\"columnId\":5834,\"columnName\":\"ordersNo\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ordersNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":275,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderDate\",\"columnComment\":\"订单日期\",\"columnId\":5835,\"columnName\":\"orderDate\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 11:20:56', 7191);
INSERT INTO `sys_oper_log` VALUES (234, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', NULL, '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"OrderdetailBack\",\"className\":\"OrderdetailBack\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":5832,\"columnName\":\"id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":275,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderId\",\"columnComment\":\"原订单详情ID\",\"columnId\":5833,\"columnName\":\"orderId\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"orderId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":275,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrdersNo\",\"columnComment\":\"订单编号（UUID）\",\"columnId\":5834,\"columnName\":\"ordersNo\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ordersNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":275,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderDate\",\"columnComment\":\"订单日期\",\"columnId\":5835,\"columnName\":\"orderDate\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:26\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 11:21:03', 12150);
INSERT INTO `sys_oper_log` VALUES (235, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', NULL, '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"GoodsorderBack\",\"className\":\"GoodsorderBack\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":5579,\"columnName\":\"id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:33:51\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":267,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"GoodsOrderID\",\"columnComment\":\"原订单ID\",\"columnId\":5580,\"columnName\":\"goodsOrderID\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:33:51\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"goodsOrderID\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":267,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrdersNo\",\"columnComment\":\"订单编号（UUID）\",\"columnId\":5581,\"columnName\":\"ordersNo\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:33:51\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ordersNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":267,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderDate\",\"columnComment\":\"日期\",\"columnId\":5582,\"columnName\":\"orderDate\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:33:51\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"i', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 11:21:34', 5803);
INSERT INTO `sys_oper_log` VALUES (236, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', NULL, '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"InventoryBack\",\"className\":\"InventoryBack\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":5670,\"columnName\":\"id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":269,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"InventoryId\",\"columnComment\":\"原货物存储ID\",\"columnId\":5671,\"columnName\":\"inventory_id\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:04\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"inventoryId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":269,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StoreHouseid\",\"columnComment\":\"仓库ID\",\"columnId\":5672,\"columnName\":\"storeHouseid\",\"columnType\":\"int(11)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:04\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"storeHouseid\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":269,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StoreHouseName\",\"columnComment\":\"仓库名称\",\"columnId\":5673,\"columnName\":\"storeHouseName\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2024-07-29 08:34:04\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"i', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2024-07-29 11:21:56', 7681);
INSERT INTO `sys_oper_log` VALUES (237, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 11:22:34', 7522);
INSERT INTO `sys_oper_log` VALUES (238, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', NULL, '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"balanceaccounts,bankacceptance,bankaccount,bankaccountchange,borrowedmoney,businesstrip,carapply,cars,company,customervisit,exwarehouse,fixedassets,fleet,goodsorder,goodsorder_back,inventory,inventory_back,lendmoney,offsetting,oilcard,oilcardmain,orderdetail,orderdetail_back,orderfreight,orderinvoice,payment,productlevel,rebate,recovermoney,repayment,socialinsurance,storehouse,tableeditmessage,virtualbankaccountchange\"}', NULL, 0, NULL, '2024-07-29 11:26:00', 7661);

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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '2', 'admin', '2024-07-19 10:12:49', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------

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
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '联系电话',
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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, NULL, 'admin', 'admin', '00', '', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-07-29 11:20:03', '', NULL, '', '2024-07-29 11:20:02', NULL, 'admin', 'admin', '1', '', '', '', '', '', '', '', '', '', 'asd', 'asd', 'asd', 'awsd', 'awd', 'awsda', 'awsd', 'awsd', 'awsd');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);

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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '表变动日志信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tableeditmessage
-- ----------------------------

-- ----------------------------
-- Table structure for virtualbankaccountchange
-- ----------------------------
DROP TABLE IF EXISTS `virtualbankaccountchange`;
CREATE TABLE `virtualbankaccountchange`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 62859 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '虚拟银行账户变动信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of virtualbankaccountchange
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
