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

 Date: 21/07/2024 09:17:33
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
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (65, 'balanceaccounts', '平账', NULL, NULL, 'Balanceaccounts', 'crud', '', 'com.ruoyi.system', 'system', 'balanceaccounts', '平账', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:08', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (66, 'bankacceptance', '商业票据、银行承兑', NULL, NULL, 'Bankacceptance', 'crud', '', 'com.ruoyi.system', 'system', 'bankacceptance', '商业票据、银行承兑', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:08', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (67, 'bankaccount', '银行卡管理', NULL, NULL, 'Bankaccount', 'crud', '', 'com.ruoyi.system', 'system', 'bankaccount', '银行卡管理', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (68, 'bankaccountchange', '银行卡资金变动', NULL, NULL, 'Bankaccountchange', 'crud', '', 'com.ruoyi.system', 'system', 'bankaccountchange', '银行卡资金变动', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (69, 'borrowedmoney', '从外部借入款、贷款', NULL, NULL, 'Borrowedmoney', 'crud', '', 'com.ruoyi.system', 'system', 'borrowedmoney', '从外部借入款、贷款', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (70, 'businesstrip', '出差登记', NULL, NULL, 'Businesstrip', 'crud', '', 'com.ruoyi.system', 'system', 'businesstrip', '出差登记', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (71, 'carapply', '车辆派出管理', NULL, NULL, 'Carapply', 'crud', '', 'com.ruoyi.system', 'system', 'carapply', '车辆派出管理', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (72, 'cars', '车辆管理', NULL, NULL, 'Cars', 'crud', '', 'com.ruoyi.system', 'system', 'cars', '车辆管理', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (73, 'company', '客户管理', NULL, NULL, 'Company', 'crud', '', 'com.ruoyi.system', 'system', 'company', '客户管理', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (74, 'customervisit', '走访记录', NULL, NULL, 'Customervisit', 'crud', '', 'com.ruoyi.system', 'system', 'customervisit', '走访记录', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (75, 'exwarehouse', '出库', NULL, NULL, 'Exwarehouse', 'crud', '', 'com.ruoyi.system', 'system', 'exwarehouse', '出库', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (76, 'fixedassets', '固定资产', NULL, NULL, 'Fixedassets', 'crud', '', 'com.ruoyi.system', 'system', 'fixedassets', '固定资产', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (77, 'fleet', '车队管理', NULL, NULL, 'Fleet', 'crud', '', 'com.ruoyi.system', 'system', 'fleet', '车队管理', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (79, 'goodsorder_back', '订单备份信息', NULL, NULL, 'GoodsorderBack', 'crud', '', 'com.ruoyi.system', 'system', 'back', '订单备份信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (80, 'inventory', '货物入库', NULL, NULL, 'Inventory', 'crud', '', 'com.ruoyi.system', 'system', 'inventory', '货物入库', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (81, 'inventory_back', '货物入库信息', NULL, NULL, 'InventoryBack', 'crud', '', 'com.ruoyi.system', 'system', 'back', '货物入库信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (82, 'lendmoney', '资金借出（期货）', NULL, NULL, 'Lendmoney', 'crud', '', 'com.ruoyi.system', 'system', 'lendmoney', '资金借出（期货）', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (83, 'offsetting', '资金调整单信息', NULL, NULL, 'Offsetting', 'crud', '', 'com.ruoyi.system', 'system', 'offsetting', '资金调整单信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (84, 'oilcard', '加油卡', NULL, NULL, 'Oilcard', 'crud', '', 'com.ruoyi.system', 'system', 'oilcard', '加油卡', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (85, 'oilcardmain', '基础信息-加油卡主卡登记', NULL, NULL, 'Oilcardmain', 'crud', '', 'com.ruoyi.system', 'system', 'oilcardmain', '基础信息-加油卡主卡登记', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:09', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (87, 'orderdetail_back', '订单详情备份', NULL, NULL, 'OrderdetailBack', 'crud', '', 'com.ruoyi.system', 'system', 'back', '订单详情备份', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (88, 'orderfreight', '订单运费', NULL, NULL, 'Orderfreight', 'crud', '', 'com.ruoyi.system', 'system', 'orderfreight', '订单运费', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (89, 'orderinvoice', '订单发票', NULL, NULL, 'Orderinvoice', 'crud', '', 'com.ruoyi.system', 'system', 'orderinvoice', '订单发票', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (90, 'payment', '资产管理-收付款:收付款信息', NULL, NULL, 'Payment', 'crud', '', 'com.ruoyi.system', 'system', 'payment', '资产管理-收付款:收付款信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (91, 'productlevel', '产品级别管理', NULL, NULL, 'Productlevel', 'crud', '', 'com.ruoyi.system', 'system', 'productlevel', '产品级别管理', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (92, 'rebate', '供应商返利', NULL, NULL, 'Rebate', 'crud', '', 'com.ruoyi.system', 'system', 'rebate', '供应商返利', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (93, 'recovermoney', '资金回收', NULL, NULL, 'Recovermoney', 'crud', '', 'com.ruoyi.system', 'system', 'recovermoney', '资金回收', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (94, 'repayment', '还款记录', NULL, NULL, 'Repayment', 'crud', '', 'com.ruoyi.system', 'system', 'repayment', '还款记录', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (95, 'socialinsurance', '社保基金', NULL, NULL, 'Socialinsurance', 'crud', '', 'com.ruoyi.system', 'system', 'socialinsurance', '社保基金', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (96, 'storehouse', '仓库管理', NULL, NULL, 'Storehouse', 'crud', '', 'com.ruoyi.system', 'system', 'storehouse', '仓库管理', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (97, 'tableeditmessage', '表变动日志信息', NULL, NULL, 'Tableeditmessage', 'crud', '', 'com.ruoyi.system', 'system', 'tableeditmessage', '变动日志信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (98, 'virtualbankaccountchange', '虚拟银行账户变动信息', NULL, NULL, 'Virtualbankaccountchange', 'crud', '', 'com.ruoyi.system', 'system', 'virtualbankaccountchange', '虚拟银行账户变动信息', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 10:47:10', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (99, 'goodsorder', '订单', 'orderdetail', 'ordersNo', 'Goodsorder', 'sub', 'element-ui', 'org.dzu.system', 'system', 'goodsorder', '订单', 'ruoyi', '0', '/', '{}', 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21', NULL);
INSERT INTO `gen_table` VALUES (100, 'orderdetail', '订单详情', NULL, NULL, 'Orderdetail', 'crud', '', 'com.ruoyi.system', 'system', 'orderdetail', '订单详情', 'ruoyi', '0', '/', NULL, 'admin', '2024-07-19 11:35:04', '', NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2060 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1231, 65, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1232, 65, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1233, 65, 'moneyAmount', '金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1234, 65, 'company', '对方公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1235, 65, 'companyID', '对方公司ID', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1236, 65, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1237, 65, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1238, 65, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1239, 65, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1240, 65, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1241, 65, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1242, 65, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1243, 66, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1244, 66, 'operateDate', '操作日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1245, 66, 'billNo', '票据号码', 'varchar(55)', 'String', 'billNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1246, 66, 'issueDate', '出票日期', 'varchar(50)', 'String', 'issueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1247, 66, 'dueDate', '到期日期', 'varchar(50)', 'String', 'dueDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1248, 66, 'billAccount', '我方承兑账户', 'varchar(50)', 'String', 'billAccount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1249, 66, 'billDate', '票据日期', 'varchar(50)', 'String', 'billDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1250, 66, 'billType', '分类（收入、支出）', 'varchar(55)', 'String', 'billType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1251, 66, 'reason', '事由', 'varchar(155)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1252, 66, 'billAmount', '票据金额', 'double', 'Long', 'billAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1253, 66, 'inDiscountPoints', '贴息点数', 'double', 'Long', 'inDiscountPoints', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1254, 66, 'inDiscountAmount', '贴息金额', 'double', 'Long', 'inDiscountAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1255, 66, 'billCategory', '票据种类（电子/纸质）', 'varchar(55)', 'String', 'billCategory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1256, 66, 'origin', '来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1257, 66, 'endorser', '背书人', 'varchar(155)', 'String', 'endorser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1258, 66, 'endorsee', '被背书人', 'varchar(155)', 'String', 'endorsee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1259, 66, 'endorseReason', '背书事由（出卖/付货款）', 'varchar(255)', 'String', 'endorseReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (1260, 66, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1261, 66, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1262, 66, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1263, 66, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1264, 66, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1265, 66, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1266, 67, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1267, 67, 'companyName', '公司名称', 'varchar(50)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1268, 67, 'companyId', '对应公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1269, 67, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1270, 67, 'acountsName', '开户名称', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1271, 67, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1272, 67, 'acountsType', '账户类型（己方公司，客户，供应商，司机，其它）', 'varchar(50)', 'String', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1273, 67, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1274, 67, 'amount', '当前资金额', 'double', 'Long', 'amount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1275, 67, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1276, 68, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1277, 68, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1278, 68, 'tableName', '发生操作行为的表', 'varchar(80)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1279, 68, 'payNO', '发生操作行为的付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1280, 68, 'operateDate', '日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1281, 68, 'changeType', '变动类型（收入、支出）', 'varchar(15)', 'String', 'changeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1282, 68, 'moneyAmount', '金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1283, 68, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1284, 68, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1285, 68, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1286, 68, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1287, 68, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1288, 69, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1289, 69, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1290, 69, 'origin', '贷款来源', 'varchar(50)', 'String', 'origin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1291, 69, 'moneyAmount', '借入金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1292, 69, 'ratio', '贷款利率', 'double', 'Long', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1293, 69, 'loanDate', '贷款发放日期', 'varchar(50)', 'String', 'loanDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1294, 69, 'loanDuring', '贷款年限（年）', 'varchar(50)', 'String', 'loanDuring', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1295, 69, 'mortgageGuarantee', '抵押担保', 'varchar(200)', 'String', 'mortgageGuarantee', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1296, 69, 'acountsName', '打入账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1297, 69, 'bankNo', '打入账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1298, 69, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1299, 69, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1300, 69, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1301, 69, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1302, 69, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1303, 69, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1304, 70, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1305, 70, 'personnel', '出差人员', 'varchar(150)', 'String', 'personnel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1306, 70, 'starttime', '出差时间', 'varchar(50)', 'String', 'starttime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1307, 70, 'startMilesPhoto', '出发里程拍照', 'varchar(250)', 'String', 'startMilesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1308, 70, 'refuelPhoto', '加油拍照', 'varchar(250)', 'String', 'refuelPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1309, 70, 'endtime', '出差结束时间', 'varchar(50)', 'String', 'endtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1310, 70, 'endMilesPhoto', '结束里程拍照', 'varchar(250)', 'String', 'endMilesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1311, 70, 'feesPhoto', '出差费用拍照', 'varchar(250)', 'String', 'feesPhoto', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1312, 70, 'isReimburse', '是否已报销（0未报销，1已报销）', 'int(11)', 'Long', 'isReimburse', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1313, 70, 'comments', '备注', 'varchar(550)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1314, 70, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1315, 70, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1316, 70, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1317, 70, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1318, 70, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1319, 71, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1320, 71, 'applyDate', '申请时间', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1321, 71, 'applyUser', '申请人', 'varchar(25)', 'String', 'applyUser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1322, 71, 'department', '部门', 'varchar(25)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1323, 71, 'carNo', '车牌', 'varchar(20)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1324, 71, 'isUseOilCard', '是否携带油卡', 'int(11)', 'Long', 'isUseOilCard', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1325, 71, 'iolCardNo', '油卡号', 'varchar(55)', 'String', 'iolCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1326, 71, 'peers', '随同乘车人员', 'varchar(155)', 'String', 'peers', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1327, 71, 'startTime', '用车时间', 'varchar(55)', 'String', 'startTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1328, 71, 'endTime', '还车时间', 'varchar(55)', 'String', 'endTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1329, 71, 'ApplyPurpose', '用车事由', 'varchar(255)', 'String', 'ApplyPurpose', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1330, 71, 'startMile', '出车前里程', 'varchar(55)', 'String', 'startMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1331, 71, 'startCarState', '出车前车况（外观是否损坏，车胎等）', 'varchar(155)', 'String', 'startCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1332, 71, 'endMile', '回来后里程', 'varchar(55)', 'String', 'endMile', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1333, 71, 'endCarState', '回来后车况（外观是否损坏，车胎等）', 'varchar(255)', 'String', 'endCarState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1334, 71, 'miles', '用车里程数', 'varchar(55)', 'String', 'miles', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1335, 71, 'backStopPlace', '回程停靠位置', 'varchar(155)', 'String', 'backStopPlace', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1336, 71, 'violationsCount', '行程中违法次数', 'varchar(15)', 'String', 'violationsCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1337, 71, 'fine', '违章罚款金额金额', 'varchar(25)', 'String', 'fine', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1338, 71, 'isMaintenance', '行程中是否维修/保养', 'varchar(5)', 'String', 'isMaintenance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1339, 71, 'maintenanceMoney', '保养金额', 'varchar(15)', 'String', 'maintenanceMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1340, 71, 'refuelingFrequency', '行程中使用加油卡加油次数', 'varchar(15)', 'String', 'refuelingFrequency', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1341, 71, 'refuelingMoney', '加油金额', 'varchar(25)', 'String', 'refuelingMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1342, 71, 'oilCardSurplus', '加油卡余额', 'varchar(25)', 'String', 'oilCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1343, 71, 'isOilTicket', '加油小票记录是否交给公司管理车辆人员', 'varchar(5)', 'String', 'isOilTicket', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1344, 71, 'refuelingCash', '现金加油金额', 'varchar(25)', 'String', 'refuelingCash', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1345, 71, 'dispatchPerson', '派车人', 'varchar(25)', 'String', 'dispatchPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1346, 71, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1347, 71, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1348, 71, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1349, 71, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 31, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1350, 71, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 32, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1351, 71, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1352, 71, 'path', '附件路径', 'varchar(255)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1353, 72, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1354, 72, 'carNo', '车牌', 'varchar(20)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1355, 72, 'driver', '司机', 'varchar(20)', 'String', 'driver', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1356, 72, 'tel', '司机电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1357, 72, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1358, 72, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1359, 72, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1360, 72, 'acountsType', '账号类型（1收款，2付款）', 'int(11)', 'Long', 'acountsType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1361, 72, 'carType', '运输类型(陆运，海运)', 'varchar(50)', 'String', 'carType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1362, 72, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1363, 72, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1364, 72, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1365, 72, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1366, 72, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1367, 73, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1368, 73, 'company', '公司', 'varchar(550)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1369, 73, 'relationName', '联系人', 'varchar(50)', 'String', 'relationName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1370, 73, 'relationTel', '联系人电话', 'varchar(30)', 'String', 'relationTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1371, 73, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1372, 73, 'bankName', '开户行', 'varchar(50)', 'String', 'bankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1373, 73, 'acountsName', '开户名', 'varchar(50)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1374, 73, 'bankNo', '账号', 'varchar(50)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1375, 73, 'surplusMoney', '余额', 'double', 'Long', 'surplusMoney', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1376, 73, 'companyType', '客户类别（ 客户，供应商）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1377, 73, 'salesman', '业务员', 'varchar(55)', 'String', 'salesman', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1378, 73, 'leader', '老板', 'varchar(50)', 'String', 'leader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1379, 73, 'leaderTel', '联系人电话', 'varchar(30)', 'String', 'leaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1380, 73, 'region', '区域（省+市县+乡镇）', 'varchar(280)', 'String', 'region', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1381, 73, 'salesManager', '销售经理', 'varchar(55)', 'String', 'salesManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1382, 73, 'province', '省', 'varchar(55)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1383, 73, 'city', '市县', 'varchar(155)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1384, 73, 'county', '乡镇', 'varchar(155)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1385, 73, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1386, 73, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1387, 73, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1388, 73, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1389, 73, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 23, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1390, 73, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1391, 74, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1392, 74, 'province', '省', 'varchar(50)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1393, 74, 'city', '市县', 'varchar(50)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1394, 74, 'county', '乡镇（街道）', 'varchar(100)', 'String', 'county', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1395, 74, 'customer', '客户', 'varchar(550)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1396, 74, 'leaderName', '负责人', 'varchar(550)', 'String', 'leaderName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'textarea', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1397, 74, 'LeaderTel', '负责人电话', 'varchar(550)', 'String', 'LeaderTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1398, 74, 'equipment', '厂房设备', 'varchar(200)', 'String', 'equipment', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1399, 74, 'competitor', '竞争对手', 'varchar(200)', 'String', 'competitor', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1400, 74, 'localDealer', '当地经销商', 'varchar(200)', 'String', 'localDealer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1401, 74, 'monthlyConsumption', '月用货量（车数）', 'varchar(200)', 'String', 'monthlyConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1402, 74, 'whiteGlassFactory', '白玻用货习惯及厂家', 'varchar(200)', 'String', 'whiteGlassFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1403, 74, 'loweGlassConsumption', 'lowe玻璃用货厂家及用量', 'varchar(200)', 'String', 'loweGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1404, 74, 'colorGlassConsumption', '色玻、过度色玻璃用货厂家及用量', 'varchar(200)', 'String', 'colorGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1405, 74, 'specialGlassConsumption', '特色厚度、特殊尺寸、协议品用货厂家及用量', 'varchar(200)', 'String', 'specialGlassConsumption', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1406, 74, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1407, 74, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1408, 74, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1409, 74, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1410, 74, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 20, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1411, 74, 'visitDate', '走访日期', 'varchar(50)', 'String', 'visitDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1412, 74, 'checkState', '审核标志', 'int(11)', 'Long', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1413, 74, 'checkUserID', '审核人ID', 'int(11)', 'Long', 'checkUserID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1414, 74, 'checkUserName', '审核人', 'varchar(50)', 'String', 'checkUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1415, 74, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1416, 75, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1417, 75, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1418, 75, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1419, 75, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1420, 75, 'outDate', '出库日期', 'varchar(50)', 'String', 'outDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1421, 75, 'outAmount', '出库量（片数）', 'int(11)', 'Long', 'outAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1422, 75, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1423, 75, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1424, 75, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1425, 75, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1426, 75, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1427, 75, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1428, 76, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1429, 76, 'buyDate', '购入日期', 'varchar(50)', 'String', 'buyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1430, 76, 'assetNo', '资产编号', 'varchar(55)', 'String', 'assetNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1431, 76, 'assetName', '资产名称', 'varchar(155)', 'String', 'assetName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1432, 76, ' specification', '规格型号（车牌号）', 'varchar(100)', 'String', ' specification', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1433, 76, 'number', '数量', 'varchar(20)', 'String', 'number', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1434, 76, 'measurementUnit ', '计量单位', 'varchar(55)', 'String', 'measurementUnit ', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1435, 76, 'amountIncludeTax', '含税金额', 'double', 'Long', 'amountIncludeTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1436, 76, 'amountNoTax', '不含税金额', 'double', 'Long', 'amountNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1437, 76, 'account', '户名名称（公户/个人）', 'varchar(55)', 'String', 'account', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1438, 76, 'department', '使用部门', 'varchar(55)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1439, 76, 'scrapDate', '固定资产清理时间', 'varchar(50)', 'String', 'scrapDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1440, 76, 'saleAmount', '清理/变卖价值', 'double', 'Long', 'saleAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1441, 76, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1442, 76, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1443, 76, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1444, 76, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1445, 76, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1446, 76, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1447, 77, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1448, 77, 'fName', '车队名称', 'varchar(50)', 'String', 'fName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1449, 77, 'fLeader', '车队经理', 'varchar(50)', 'String', 'fLeader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1450, 77, 'tel', '车队经理电话', 'varchar(30)', 'String', 'tel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1451, 77, 'address', '地址', 'varchar(250)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1452, 77, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1453, 77, 'editTime', '编辑时间', 'varchar(55)', 'String', 'editTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1454, 77, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1493, 79, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1494, 79, 'goodsOrderID', '原订单ID', 'int(11)', 'Long', 'goodsOrderID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1495, 79, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1496, 79, 'orderDate', '日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1497, 79, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1498, 79, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1499, 79, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1500, 79, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1501, 79, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1502, 79, 'landDriverName', '陆地司机姓名', 'varchar(55)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1503, 79, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1504, 79, 'seaCarNo', '海运车牌', 'varchar(50)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1505, 79, 'seaDriverTel', '海运司机电话', 'varchar(50)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1506, 79, 'seaDriverName', '海运司机姓名', 'varchar(55)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1507, 79, 'checkUserId', '审核人编号', 'int(11)', 'Long', 'checkUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1508, 79, 'checkState', '审核状态（已审核、未审核）', 'varchar(20)', 'String', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1509, 79, 'invoiceState', '开票状态（未开票，部分开票，已开票）', 'varchar(20)', 'String', 'invoiceState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1510, 79, 'path', '附件路径', 'varchar(250)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1511, 79, 'PaymentState', '打款状态(已打款，未打款)', 'varchar(20)', 'String', 'PaymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1512, 79, 'landBankName', '陆运银行户名', 'varchar(50)', 'String', 'landBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 20, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1513, 79, 'landBankNo', '陆运银行账号', 'varchar(50)', 'String', 'landBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1514, 79, 'seaBankName', '海运银行户名', 'varchar(50)', 'String', 'seaBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 22, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1515, 79, 'seaBankNo', '海运银行账号', 'varchar(50)', 'String', 'seaBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1516, 79, 'receiveProof', '收到条附件路径', 'text', 'String', 'receiveProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 24, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1517, 79, 'saleManager', '销售经理', 'varchar(25)', 'String', 'saleManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1518, 79, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1519, 79, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1520, 79, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1521, 79, 'isAdjust', '是否调整单（是  否）', 'varchar(10)', 'String', 'isAdjust', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1522, 79, 'adjustOrderid', '原订单编号', 'int(11)', 'Long', 'adjustOrderid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1523, 79, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1524, 79, 'customerIsInvoice', '客户是否开票', 'int(11)', 'Long', 'customerIsInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1525, 79, 'isSupplierInvoice', '供应商是否开票', 'int(11)', 'Long', 'isSupplierInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1526, 79, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1527, 79, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1528, 79, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1529, 79, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1530, 79, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 38, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1531, 79, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 39, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1532, 80, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1533, 80, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1534, 80, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1535, 80, 'storeDate', '入库日期', 'varchar(50)', 'String', 'storeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1536, 80, 'stockNumber', '库存量（片数）', 'int(11)', 'Long', 'stockNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1537, 80, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1538, 80, 'supplierId', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1539, 80, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1540, 80, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1541, 80, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1542, 80, 'height', '厚度', 'double', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1543, 80, 'length', '长度', 'double', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1544, 80, 'width', '宽度', 'double', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1545, 80, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1546, 80, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1547, 80, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1548, 80, 'price', '出厂单价', 'double', 'Long', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1549, 80, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1550, 80, 'sundryCost', '杂费', 'double', 'Long', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1551, 80, 'paymentFactory', '出厂货款', 'double', 'Long', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1552, 80, 'paymentUnload', '卸货价', 'double', 'Long', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1553, 80, 'isIncludeTaxSale', '销售是否含税（0不含税，1含税）', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1554, 80, 'payments', '总货款', 'varchar(20)', 'String', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1555, 80, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1556, 80, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1557, 80, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1558, 80, 'landDriverName', '陆地司机姓名', 'varchar(255)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 27, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1559, 80, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1560, 80, 'seaCarNo', '海运车牌', 'varchar(550)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 29, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1561, 80, 'seaDriverTel', '海运司机电话', 'varchar(550)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 30, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1562, 80, 'seaDriverName', '海运司机姓名', 'varchar(255)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 31, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1563, 80, 'erro', '误差', 'double', 'Long', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1564, 80, 'tonnage', '吨位', 'double', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1565, 80, 'landFreightPrice', '陆运费单价', 'double', 'Long', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1566, 80, 'landFreight', '陆运费', 'double', 'Long', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1567, 80, 'seaFreight', '海运费', 'double', 'Long', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1568, 80, 'freight', '运费（海运费+陆运费）', 'double', 'Long', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1569, 80, 'otherCost', '其他费用', 'double', 'Long', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1570, 80, 'profit', '利润', 'double', 'Long', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1571, 80, 'profitNoTax', '不含税利润', 'double', 'Long', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1572, 80, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1573, 80, 'paymentsWithSundry', '总货款杂费', 'double', 'Long', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1574, 80, 'additionalFees', '加费', 'double', 'Long', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1575, 80, 'rebate', '返利金额', 'double', 'Long', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1576, 80, 'customerCommission', '客户佣金', 'double', 'Long', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1577, 80, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1578, 80, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1579, 80, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 48, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1580, 80, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 49, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1581, 80, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 50, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1582, 80, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 51, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1583, 80, 'showFlag', '订单仓库选择时是否显示（ 显示， 不显示）', 'int(11)', 'Long', 'showFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 52, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1584, 81, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1585, 81, 'inventory_id', '原货物存储ID', 'int(11)', 'Long', 'inventoryId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1586, 81, 'storeHouseid', '仓库ID', 'int(11)', 'Long', 'storeHouseid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1587, 81, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1588, 81, 'storeDate', '入库日期', 'varchar(50)', 'String', 'storeDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1589, 81, 'stockNumber', '库存量（片数）', 'int(11)', 'Long', 'stockNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1590, 81, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1591, 81, 'supplierId', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1592, 81, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1593, 81, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1594, 81, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1595, 81, 'height', '厚度', 'double', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1596, 81, 'length', '长度', 'double', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1597, 81, 'width', '宽度', 'double', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1598, 81, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1599, 81, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1600, 81, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1601, 81, 'price', '出厂单价', 'double', 'Long', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1602, 81, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1603, 81, 'sundryCost', '杂费', 'double', 'Long', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1604, 81, 'paymentFactory', '出厂货款', 'double', 'Long', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1605, 81, 'paymentUnload', '卸货价', 'double', 'Long', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1606, 81, 'isIncludeTaxSale', '销售是否含税（0不含税，1含税）', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1607, 81, 'payments', '总货款', 'varchar(20)', 'String', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1608, 81, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1609, 81, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1610, 81, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1611, 81, 'landDriverName', '陆地司机姓名', 'varchar(255)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 28, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1612, 81, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1613, 81, 'seaCarNo', '海运车牌', 'varchar(550)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 30, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1614, 81, 'seaDriverTel', '海运司机电话', 'varchar(550)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 31, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1615, 81, 'seaDriverName', '海运司机姓名', 'varchar(255)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 32, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1616, 81, 'erro', '误差', 'double', 'Long', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1617, 81, 'tonnage', '吨位', 'double', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1618, 81, 'landFreightPrice', '陆运费单价', 'double', 'Long', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1619, 81, 'landFreight', '陆运费', 'double', 'Long', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1620, 81, 'seaFreight', '海运费', 'double', 'Long', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1621, 81, 'freight', '运费（海运费+陆运费）', 'double', 'Long', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1622, 81, 'otherCost', '其他费用', 'double', 'Long', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1623, 81, 'profit', '利润', 'double', 'Long', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1624, 81, 'profitNoTax', '不含税利润', 'double', 'Long', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1625, 81, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1626, 81, 'paymentsWithSundry', '总货款杂费', 'double', 'Long', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1627, 81, 'additionalFees', '加费', 'double', 'Long', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1628, 81, 'rebate', '返利金额', 'double', 'Long', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1629, 81, 'customerCommission', '客户佣金', 'double', 'Long', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1630, 81, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1631, 81, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 48, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1632, 81, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 49, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1633, 81, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 50, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1634, 81, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 51, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1635, 81, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 52, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1636, 81, 'showFlag', '订单仓库选择时是否显示（ 显示， 不显示）', 'int(11)', 'Long', 'showFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 53, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1637, 82, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1638, 82, 'futuresNO', '借出款编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1639, 82, 'futuresMarginCompany', '期货保证金公司', 'varchar(80)', 'String', 'futuresMarginCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1640, 82, 'target', '对象(员工、外面公司在我公司借款)', 'varchar(50)', 'String', 'target', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1641, 82, 'moneyAmount', '保证金金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1642, 82, 'targetAcountsName', '对方账户', 'varchar(80)', 'String', 'targetAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1643, 82, 'targetBankNo', '对方账号', 'varchar(80)', 'String', 'targetBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1644, 82, 'targetBankName', '对方开户行', 'varchar(80)', 'String', 'targetBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1645, 82, 'selfAcountsName', '我方支付账户', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1646, 82, 'selfBankNo', '我方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1647, 82, 'selfBankName', '我方开户行', 'varchar(80)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1648, 82, 'futuresDate', '支付期货保证金时间', 'varchar(50)', 'String', 'futuresDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1649, 82, 'reason', '事由', 'varchar(200)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1650, 82, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1651, 82, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1652, 82, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1653, 82, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1654, 82, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1655, 82, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1656, 83, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1657, 83, 'OffsetNO', '冲抵编号（UUID）', 'varchar(50)', 'String', 'OffsetNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1658, 83, 'operateDate', '操作时间', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1659, 83, 'operateType', '冲抵类型（收入、支出）', 'varchar(50)', 'String', 'operateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1660, 83, 'moneyAmount', '金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1661, 83, 'company', '公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1662, 83, 'company_id', '公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1663, 83, 'companyType', '公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1664, 83, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1665, 83, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1666, 83, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1667, 83, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1668, 83, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1669, 83, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1670, 84, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1671, 84, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1672, 84, 'oilType', '加油卡类别（主卡、副卡）', 'varchar(15)', 'String', 'oilType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1673, 84, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1674, 84, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1675, 84, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1676, 84, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1677, 84, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1678, 84, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1679, 85, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1680, 85, 'oilCardNo', '加油卡卡号', 'varchar(55)', 'String', 'oilCardNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1681, 85, 'useDate', '使用加油卡时间', 'varchar(50)', 'String', 'useDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1682, 85, 'carNo', '使用加油卡车辆车牌号', 'varchar(55)', 'String', 'carNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1683, 85, 'destination', '地点、事由', 'varchar(155)', 'String', 'destination', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1684, 85, 'startCardSurplus', '期初余额', 'varchar(55)', 'String', 'startCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:09', '', NULL);
INSERT INTO `gen_table_column` VALUES (1685, 85, 'toPlusCardMoney', '主卡转副卡充值金额', 'varchar(55)', 'String', 'toPlusCardMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1686, 85, 'refuelingNumber', '加油量（升）', 'varchar(255)', 'String', 'refuelingNumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1687, 85, 'unitPrice', '单价', 'varchar(255)', 'String', 'unitPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1688, 85, 'refuelingMoney', '加油金额(元）', 'varchar(255)', 'String', 'refuelingMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1689, 85, 'rechargeMoney', '充值金额', 'varchar(255)', 'String', 'rechargeMoney', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1690, 85, 'isTicket', '是否有小票', 'varchar(255)', 'String', 'isTicket', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1691, 85, 'endCardSurplus', '加油卡余额', 'varchar(255)', 'String', 'endCardSurplus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1692, 85, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1693, 85, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1694, 85, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1695, 85, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 17, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1696, 85, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 18, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1697, 85, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1746, 87, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1747, 87, 'orderId', '原订单详情ID', 'int(11)', 'Long', 'orderId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1748, 87, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1749, 87, 'orderDate', '订单日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1750, 87, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1751, 87, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1752, 87, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1753, 87, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1754, 87, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1755, 87, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1756, 87, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1757, 87, 'height', '厚度', 'double', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1758, 87, 'length', '长度', 'double', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1759, 87, 'width', '宽度', 'double', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1760, 87, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1761, 87, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1762, 87, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1763, 87, 'price', '出厂单价', 'double', 'Long', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1764, 87, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1765, 87, 'sundryCost', '杂费', 'double', 'Long', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1766, 87, 'paymentFactory', '出厂货款', 'double', 'Long', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1767, 87, 'paymentUnload', '卸货价', 'double', 'Long', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1768, 87, 'isIncludeTaxSale', '销售是否含税', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1769, 87, 'payments', '总货款', 'double', 'Long', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1770, 87, 'erro', '误差', 'double', 'Long', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1771, 87, 'tonnage', '吨位', 'double', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1772, 87, 'landFreightPrice', '陆运费单价', 'double', 'Long', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1773, 87, 'landFreight', '陆运费', 'double', 'Long', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1774, 87, 'seaFreight', '海运费', 'double', 'Long', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1775, 87, 'freight', '总运费', 'double', 'Long', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1776, 87, 'otherCost', '其他费用', 'double', 'Long', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1777, 87, 'profit', '利润', 'double', 'Long', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1778, 87, 'profitNoTax', '不含税利润', 'double', 'Long', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1779, 87, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1780, 87, 'paymentsWithSundry', '总货款杂费', 'double', 'Long', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1781, 87, 'additionalFees', '加费', 'double', 'Long', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1782, 87, 'storeHouseID', '仓库ID', 'int(11)', 'Long', 'storeHouseID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 37, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1783, 87, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 38, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1784, 87, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1785, 87, 'logisticsProfit', '物流利润', 'double', 'Long', 'logisticsProfit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1786, 87, 'customerCommission', '客户佣金', 'double', 'Long', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1787, 87, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1788, 87, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1789, 87, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1790, 87, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1791, 87, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1792, 87, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 47, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1793, 87, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 48, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1794, 87, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 49, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1795, 88, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1796, 88, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1797, 88, 'freightState', '运费类型（ 陆运、海运）', 'varchar(55)', 'String', 'freightState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1798, 88, 'moneyAmount', '金额', 'varchar(55)', 'String', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1799, 88, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1800, 88, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1801, 88, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1802, 88, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1803, 88, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1804, 88, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1805, 88, 'content', '备注', 'varchar(150)', 'String', 'content', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1806, 88, 'paymentState', '支付状态（ 已支付、 未支付、  申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1807, 88, 'driverName', '司机姓名', 'varchar(150)', 'String', 'driverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1808, 88, 'driverId', '司机ID', 'int(11)', 'Long', 'driverId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1809, 88, 'CarNo', '车牌号', 'varchar(20)', 'String', 'CarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1810, 88, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1811, 88, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1812, 88, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1813, 88, 'applyUserId', '申请人员ID', 'int(11)', 'Long', 'applyUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1814, 88, 'applyUserName', '申请人员姓名', 'varchar(50)', 'String', 'applyUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 20, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1815, 88, 'applyDate', '申请日期', 'varchar(50)', 'String', 'applyDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1816, 88, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1817, 88, 'payUserId', '付款人员ID', 'int(11)', 'Long', 'payUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1818, 88, 'payUserName', '付款人员姓名', 'varchar(50)', 'String', 'payUserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1819, 88, 'payDate', '付款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1820, 88, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1821, 88, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1822, 88, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 28, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1823, 88, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1824, 89, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1825, 89, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1826, 89, 'invoiceDate', '开票日期', 'varchar(55)', 'String', 'invoiceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1827, 89, 'invoiceType', '开票类型（购入、卖出）', 'double', 'Long', 'invoiceType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1828, 89, 'invoiceAmount', '应开票金额', 'double', 'Long', 'invoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1829, 89, 'companyType', '公司类别（客户、供应商）', 'varchar(20)', 'String', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1830, 89, 'companyName', '公司名称', 'varchar(120)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1831, 89, 'companyID', '公司名称', 'int(11)', 'Long', 'companyID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1832, 89, 'invoiceCompanyName', '票据单位名称', 'varchar(120)', 'String', 'invoiceCompanyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1833, 89, 'actualInvoiceAmount', '实际开票金额', 'double', 'Long', 'actualInvoiceAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1834, 89, 'ticketPoint', '票点', 'double', 'Long', 'ticketPoint', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1835, 89, 'ticketPointAmount', '票点金额（实际开票金额*票点）', 'double', 'Long', 'ticketPointAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1836, 89, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1837, 89, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1838, 89, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1839, 89, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1840, 89, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1841, 89, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1842, 90, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1843, 90, 'payCategory', '收付款类型（收款，付款）', 'varchar(55)', 'String', 'payCategory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1844, 90, 'payNO', '付款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1845, 90, 'fundsDate', '日期', 'varchar(50)', 'String', 'fundsDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1846, 90, 'payType', '支付类型', 'varchar(55)', 'String', 'payType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1847, 90, 'moneyAmount', '金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1848, 90, 'selfAcountsName', '己方户名', 'varchar(80)', 'String', 'selfAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1849, 90, 'selfBankNo', '己方账号', 'varchar(80)', 'String', 'selfBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1850, 90, 'selfBankName', '己方开户行', 'varchar(150)', 'String', 'selfBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1851, 90, 'selfBankID', '己方账号ID', 'varchar(150)', 'String', 'selfBankID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1852, 90, 'otherAcountsName', '对方户名', 'varchar(80)', 'String', 'otherAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1853, 90, 'otherBankNo', '对方账号', 'varchar(80)', 'String', 'otherBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1854, 90, 'otherBankName', '对方开户行', 'varchar(150)', 'String', 'otherBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1855, 90, 'paymentState', '支付状态（已支付、未支付、申请中）', 'varchar(55)', 'String', 'paymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1856, 90, 'company', '对方公司', 'varchar(150)', 'String', 'company', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1857, 90, 'company_id', '对方公司ID', 'int(11)', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1858, 90, 'companyType', '对方公司类型（1、客户 2、供应商）', 'int(11)', 'Long', 'companyType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 17, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1859, 90, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1860, 90, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1861, 90, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1862, 90, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1863, 90, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 22, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1864, 90, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1865, 91, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1866, 91, 'levelNo', '级别编码', 'varchar(20)', 'String', 'levelNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1867, 91, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1868, 91, 'categoryNo', '分类编号', 'int(11)', 'Long', 'categoryNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1869, 91, 'categoryName', '分类名称', 'varchar(80)', 'String', 'categoryName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1870, 91, 'height', '厚度', 'double', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1871, 91, 'length', '长度', 'double', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1872, 91, 'width', '宽度', 'double', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1873, 91, 'tonnage', '吨位', 'double', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1874, 91, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1875, 91, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1876, 91, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1877, 91, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1878, 91, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1879, 92, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1880, 92, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1881, 92, 'rebateDate', '日期', 'varchar(50)', 'String', 'rebateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1882, 92, 'rebate', '金额', 'double', 'Long', 'rebate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1883, 92, 'rebateType', '返利类型（返利、降价、售后质量赔偿）', 'varchar(80)', 'String', 'rebateType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1884, 92, 'inAcountsName', '收款户名', 'varchar(80)', 'String', 'inAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1885, 92, 'inBankNo', '收款账号', 'varchar(80)', 'String', 'inBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1886, 92, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1887, 92, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1888, 92, 'outAcountsName', '付款户名', 'varchar(80)', 'String', 'outAcountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1889, 92, 'outBankNo', '付款款账号', 'varchar(80)', 'String', 'outBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1890, 92, 'rebateReason', '返利原因', 'varchar(55)', 'String', 'rebateReason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1891, 92, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1892, 92, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1893, 92, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1894, 92, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 16, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1895, 92, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1896, 92, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1897, 93, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1898, 93, 'futuresNO', '借出款编号（UUID）', 'varchar(50)', 'String', 'futuresNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1899, 93, 'recoverNO', '还款编号（UUID）', 'varchar(50)', 'String', 'recoverNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1900, 93, 'moneyAmount', '收回金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1901, 93, 'recoverDate', '收回日期', 'varchar(50)', 'String', 'recoverDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1902, 93, 'acountsName', '收回账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1903, 93, 'bankNo', '收回账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1904, 93, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1905, 93, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1906, 93, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1907, 93, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1908, 93, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1909, 93, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1910, 94, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1911, 94, 'loanNO', '贷款编号（UUID）', 'varchar(50)', 'String', 'loanNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1912, 94, 'payNO', '还款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1913, 94, 'moneyAmount', '还（本）金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1914, 94, 'ratio', '付息（金额）', 'double', 'Long', 'ratio', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1915, 94, 'payDate', '还款日期', 'varchar(50)', 'String', 'payDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1916, 94, 'acountsName', '还款账户', 'varchar(80)', 'String', 'acountsName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1917, 94, 'bankNo', '还款账号', 'varchar(80)', 'String', 'bankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1918, 94, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1919, 94, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1920, 94, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1921, 94, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1922, 94, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1923, 94, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1924, 95, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1925, 95, 'basicSocialInsurance', '社保缴纳基数', 'double', 'Long', 'basicSocialInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1926, 95, 'basicHousingFund', '公积金基数', 'double', 'Long', 'basicHousingFund', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1927, 95, 'depName', '部门', 'varchar(50)', 'String', 'depName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1928, 95, 'employeeName', '姓名', 'varchar(15)', 'String', 'employeeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1929, 95, 'employeeID', '人员编号', 'varchar(15)', 'String', 'employeeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1930, 95, 'insuranceDate', '缴费时间', 'varchar(50)', 'String', 'insuranceDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1931, 95, 'isRecruiting', '是否增员（是，否）', 'varchar(10)', 'String', 'isRecruiting', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1932, 95, 'isDepletion', '是否减员', 'varchar(10)', 'String', 'isDepletion', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1933, 95, 'healthySecuritySelf', '基本医疗保险-个人', 'double', 'Long', 'healthySecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1934, 95, 'healthySecurityCompany', '基本医疗保险-公司', 'double', 'Long', 'healthySecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1935, 95, 'injuryInsurance', '工伤保险', 'double', 'Long', 'injuryInsurance', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1936, 95, 'unemploymentSecuritySelf', '失业保险-个人', 'double', 'Long', 'unemploymentSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1937, 95, 'unemploymentSecurityCompany', '失业保险-公司', 'double', 'Long', 'unemploymentSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1938, 95, 'retirementSecuritySelf', '养老保险-个人', 'double', 'Long', 'retirementSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1939, 95, 'retirementSecurityCompany', '养老保险-公司', 'double', 'Long', 'retirementSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1940, 95, 'largeMedicalSecuritySelf', '大额医保-个人', 'double', 'Long', 'largeMedicalSecuritySelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1941, 95, 'largeMedicalSecurityCompany', '大额医保-公司', 'double', 'Long', 'largeMedicalSecurityCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1942, 95, 'housingFundSelf', '公积金-个人', 'double', 'Long', 'housingFundSelf', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1943, 95, 'housingFundCompany', '公积金-公司', 'double', 'Long', 'housingFundCompany', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1944, 95, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1945, 95, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1946, 95, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1947, 95, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 24, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1948, 95, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 25, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1949, 95, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1950, 96, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1951, 96, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1952, 96, 'address', '地址', 'varchar(100)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1953, 96, 'delFlag', '删除标记', 'int(11)', 'Long', 'delFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1954, 97, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1955, 97, 'tableName', '表名', 'varchar(50)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1956, 97, 'modifyTime', '修改时间', 'varchar(80)', 'String', 'modifyTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1957, 97, 'reason', '修改原因', 'varchar(280)', 'String', 'reason', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1958, 97, 'tid', '修改表对应信息的id', 'int(11)', 'Long', 'tid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1959, 97, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1960, 97, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1961, 97, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1962, 98, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1963, 98, 'companyId', '公司ID', 'varchar(80)', 'String', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1964, 98, 'tableName', '发生操作行为的表', 'varchar(80)', 'String', 'tableName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1965, 98, 'payNO', '发生操作行为的冲抵款编号（UUID）', 'varchar(50)', 'String', 'payNO', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1966, 98, 'operateDate', '日期', 'varchar(50)', 'String', 'operateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1967, 98, 'changeType', '变动类型（收入、支出）', 'varchar(15)', 'String', 'changeType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1968, 98, 'moneyAmount', '金额', 'double', 'Long', 'moneyAmount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1969, 98, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1970, 98, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1971, 98, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1972, 98, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 11, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1973, 98, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2024-07-19 10:47:10', '', NULL);
INSERT INTO `gen_table_column` VALUES (1974, 99, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1975, 99, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1976, 99, 'orderDate', '日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1977, 99, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1978, 99, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1979, 99, 'landCar_id', '陆运车辆ID', 'int(11)', 'Long', 'landcarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1980, 99, 'landCarNo', '陆运车牌', 'varchar(50)', 'String', 'landCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1981, 99, 'landDriverTel', '陆运司机电话', 'varchar(50)', 'String', 'landDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1982, 99, 'landDriverName', '陆地司机姓名', 'varchar(55)', 'String', 'landDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1983, 99, 'seaCar_id', '海运车辆ID', 'int(11)', 'Long', 'seacarId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1984, 99, 'seaCarNo', '海运车牌', 'varchar(50)', 'String', 'seaCarNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1985, 99, 'seaDriverTel', '海运司机电话', 'varchar(50)', 'String', 'seaDriverTel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1986, 99, 'seaDriverName', '海运司机姓名', 'varchar(55)', 'String', 'seaDriverName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 13, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1987, 99, 'checkUserId', '审核人编号', 'int(11)', 'Long', 'checkUserId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1988, 99, 'checkState', '审核状态（已审核、未审核）', 'varchar(20)', 'String', 'checkState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1989, 99, 'invoiceState', '开票状态（未开票，部分开票，已开票）', 'varchar(20)', 'String', 'invoiceState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1990, 99, 'path', '附件路径', 'varchar(250)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1991, 99, 'PaymentState', '打款状态(申请中，已打款，未打款)', 'varchar(20)', 'String', 'PaymentState', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1992, 99, 'landBankName', '陆运银行户名', 'varchar(50)', 'String', 'landBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 19, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1993, 99, 'landBankNo', '陆运银行账号', 'varchar(50)', 'String', 'landBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1994, 99, 'seaBankName', '海运银行户名', 'varchar(50)', 'String', 'seaBankName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 21, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1995, 99, 'seaBankNo', '海运银行账号', 'varchar(50)', 'String', 'seaBankNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1996, 99, 'receiveProof', '收到条附件路径', 'text', 'String', 'receiveProof', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 23, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1997, 99, 'saleManager', '销售经理', 'varchar(25)', 'String', 'saleManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1998, 99, 'fleet', '车队', 'varchar(50)', 'String', 'fleet', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (1999, 99, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2000, 99, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2001, 99, 'isAdjust', '是否调整单（是  否）', 'varchar(10)', 'String', 'isAdjust', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2002, 99, 'adjustOrderid', '原订单编号', 'int(11)', 'Long', 'adjustOrderid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2003, 99, 'isedit', '是否可编辑', 'int(11)', 'Long', 'isedit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2004, 99, 'customerIsInvoice', '客户是否开票', 'int(11)', 'Long', 'customerIsInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2005, 99, 'isSupplierInvoice', '供应商是否开票', 'int(11)', 'Long', 'isSupplierInvoice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2006, 99, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2007, 99, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2008, 99, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2009, 99, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2010, 99, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 37, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2011, 99, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 38, 'admin', '2024-07-19 11:34:37', '', '2024-07-19 11:36:21');
INSERT INTO `gen_table_column` VALUES (2012, 100, 'id', NULL, 'int(11)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2013, 100, 'ordersNo', '订单编号（UUID）', 'varchar(50)', 'String', 'ordersNo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2014, 100, 'orderDate', '订单日期', 'varchar(50)', 'String', 'orderDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2015, 100, 'supplier', '供应商', 'varchar(150)', 'String', 'supplier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2016, 100, 'supplier_id', '供应商ID', 'int(11)', 'Long', 'supplierId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2017, 100, 'customer', '客户', 'varchar(150)', 'String', 'customer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2018, 100, 'customer_id', '客户ID', 'int(11)', 'Long', 'customerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2019, 100, 'levelID', '级别编码', 'int(11)', 'Long', 'levelID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2020, 100, 'levelName', '级别名称', 'varchar(80)', 'String', 'levelName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2021, 100, 'countingUnit', '计量单位', 'varchar(25)', 'String', 'countingUnit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2022, 100, 'height', '厚度', 'double', 'Long', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2023, 100, 'length', '长度', 'double', 'Long', 'length', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2024, 100, 'width', '宽度', 'double', 'Long', 'width', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2025, 100, 'pieces', '出厂片数', 'int(11)', 'Long', 'pieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2026, 100, 'piecesPerPack', '每包片数', 'int(11)', 'Long', 'piecesPerPack', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2027, 100, 'packs', '包数', 'int(11)', 'Long', 'packs', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2028, 100, 'price', '出厂单价', 'double', 'Long', 'price', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2029, 100, 'isIncludeTaxFactory', '出厂是否含税', 'int(11)', 'Long', 'isIncludeTaxFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2030, 100, 'sundryCost', '杂费', 'double', 'Long', 'sundryCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2031, 100, 'paymentFactory', '出厂货款', 'double', 'Long', 'paymentFactory', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 20, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2032, 100, 'paymentUnload', '卸货价', 'double', 'Long', 'paymentUnload', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2033, 100, 'isIncludeTaxSale', '销售是否含税', 'int(11)', 'Long', 'isIncludeTaxSale', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2034, 100, 'payments', '总货款', 'double', 'Long', 'payments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2035, 100, 'erro', '误差', 'double', 'Long', 'erro', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2036, 100, 'tonnage', '吨位', 'double', 'Long', 'tonnage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2037, 100, 'landFreightPrice', '陆运费单价', 'double', 'Long', 'landFreightPrice', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 26, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2038, 100, 'landFreight', '陆运费', 'double', 'Long', 'landFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2039, 100, 'seaFreight', '海运费', 'double', 'Long', 'seaFreight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2040, 100, 'freight', '总运费', 'double', 'Long', 'freight', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 29, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2041, 100, 'otherCost', '其他费用', 'double', 'Long', 'otherCost', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2042, 100, 'profit', '利润', 'double', 'Long', 'profit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 31, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2043, 100, 'profitNoTax', '不含税利润', 'double', 'Long', 'profitNoTax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 32, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2044, 100, 'actualPieces', '实际片数', 'int(11)', 'Long', 'actualPieces', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 33, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2045, 100, 'paymentsWithSundry', '总货款杂费', 'double', 'Long', 'paymentsWithSundry', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 34, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2046, 100, 'additionalFees', '加费', 'double', 'Long', 'additionalFees', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 35, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2047, 100, 'storeHouseID', '仓库ID', 'int(11)', 'Long', 'storeHouseID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 36, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2048, 100, 'storeHouseName', '仓库名称', 'varchar(100)', 'String', 'storeHouseName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 37, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2049, 100, 'storeID', '仓库存储的货物ID', 'int(11)', 'Long', 'storeID', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 38, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2050, 100, 'logisticsProfit', '物流利润', 'double', 'Long', 'logisticsProfit', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 39, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2051, 100, 'customerCommission', '客户佣金', 'double', 'Long', 'customerCommission', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 40, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2052, 100, 'isAdjusted', '是否被调整单（ 是  否）', 'varchar(10)', 'String', 'isAdjusted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 41, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2053, 100, 'adjustDate', '调整日期', 'varchar(50)', 'String', 'adjustDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 42, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2054, 100, 'cancelFlag', '作废标记', 'int(11)', 'Long', 'cancelFlag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 43, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2055, 100, 'comments', '备注', 'varchar(200)', 'String', 'comments', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 44, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2056, 100, 'addtime', '添加时间', 'varchar(50)', 'String', 'addtime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 45, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2057, 100, 'userId', '操作人员ID', 'int(11)', 'Long', 'userId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 46, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2058, 100, 'UserName', '操作人员姓名', 'varchar(50)', 'String', 'UserName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 47, 'admin', '2024-07-19 11:35:04', '', NULL);
INSERT INTO `gen_table_column` VALUES (2059, 100, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 48, 'admin', '2024-07-19 11:35:04', '', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 125 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2192 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-07-19 10:12:49', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-07-19 10:12:49', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-07-19 10:12:49', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, 'DZU官网', 0, 4, 'http://dzu.vip', NULL, '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-07-19 10:12:49', '', NULL, 'DZU官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-07-19 10:12:49', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-07-19 10:12:49', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-07-19 10:12:49', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-07-19 10:12:49', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-07-19 10:12:49', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-07-19 10:12:49', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-07-19 10:12:49', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-07-19 10:12:49', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-07-19 10:12:49', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-07-19 10:12:49', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-07-19 10:12:49', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-07-19 10:12:49', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-07-19 10:12:49', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-07-19 10:12:49', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-07-19 10:12:49', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-07-19 10:12:49', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-07-19 10:12:49', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-07-19 10:12:49', '', NULL, '系统接口菜单');
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
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
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
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-07-19 10:12:49', '', NULL, '');
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
INSERT INTO `sys_menu` VALUES (2006, '平账', 3, 1, 'balanceaccounts', 'system/balanceaccounts/index', NULL, 1, 0, 'C', '0', '0', 'system:balanceaccounts:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '平账菜单');
INSERT INTO `sys_menu` VALUES (2007, '平账查询', 2006, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '平账新增', 2006, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '平账修改', 2006, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '平账删除', 2006, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '平账导出', 2006, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:balanceaccounts:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '商业票据、银行承兑', 3, 1, 'bankacceptance', 'system/bankacceptance/index', NULL, 1, 0, 'C', '0', '0', 'system:bankacceptance:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '商业票据、银行承兑菜单');
INSERT INTO `sys_menu` VALUES (2013, '商业票据、银行承兑查询', 2012, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '商业票据、银行承兑新增', 2012, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '商业票据、银行承兑修改', 2012, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '商业票据、银行承兑删除', 2012, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '商业票据、银行承兑导出', 2012, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankacceptance:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '银行卡资金变动', 3, 1, 'bankaccountchange', 'system/bankaccountchange/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccountchange:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '银行卡资金变动菜单');
INSERT INTO `sys_menu` VALUES (2019, '银行卡资金变动查询', 2018, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '银行卡资金变动新增', 2018, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '银行卡资金变动修改', 2018, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '银行卡资金变动删除', 2018, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '银行卡资金变动导出', 2018, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccountchange:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '银行卡管理', 3, 1, 'bankaccount', 'system/bankaccount/index', NULL, 1, 0, 'C', '0', '0', 'system:bankaccount:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '银行卡管理菜单');
INSERT INTO `sys_menu` VALUES (2025, '银行卡管理查询', 2024, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '银行卡管理新增', 2024, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '银行卡管理修改', 2024, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '银行卡管理删除', 2024, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '银行卡管理导出', 2024, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:bankaccount:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '从外部借入款、贷款', 3, 1, 'borrowedmoney', 'system/borrowedmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:borrowedmoney:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '从外部借入款、贷款菜单');
INSERT INTO `sys_menu` VALUES (2031, '从外部借入款、贷款查询', 2030, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '从外部借入款、贷款新增', 2030, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '从外部借入款、贷款修改', 2030, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '从外部借入款、贷款删除', 2030, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '从外部借入款、贷款导出', 2030, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:borrowedmoney:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '出差登记', 3, 1, 'businesstrip', 'system/businesstrip/index', NULL, 1, 0, 'C', '0', '0', 'system:businesstrip:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '出差登记菜单');
INSERT INTO `sys_menu` VALUES (2037, '出差登记查询', 2036, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '出差登记新增', 2036, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '出差登记修改', 2036, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '出差登记删除', 2036, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '出差登记导出', 2036, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:businesstrip:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '车辆派出管理', 3, 1, 'carapply', 'system/carapply/index', NULL, 1, 0, 'C', '0', '0', 'system:carapply:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '车辆派出管理菜单');
INSERT INTO `sys_menu` VALUES (2043, '车辆派出管理查询', 2042, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '车辆派出管理新增', 2042, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '车辆派出管理修改', 2042, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '车辆派出管理删除', 2042, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '车辆派出管理导出', 2042, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:carapply:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '车辆管理', 3, 1, 'cars', 'system/cars/index', NULL, 1, 0, 'C', '0', '0', 'system:cars:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '车辆管理菜单');
INSERT INTO `sys_menu` VALUES (2049, '车辆管理查询', 2048, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '车辆管理新增', 2048, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '车辆管理修改', 2048, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '车辆管理删除', 2048, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '车辆管理导出', 2048, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:cars:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '客户管理', 3, 1, 'company', 'system/company/index', NULL, 1, 0, 'C', '0', '0', 'system:company:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '客户管理菜单');
INSERT INTO `sys_menu` VALUES (2055, '客户管理查询', 2054, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '客户管理新增', 2054, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '客户管理修改', 2054, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '客户管理删除', 2054, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '客户管理导出', 2054, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:company:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '走访记录', 3, 1, 'customervisit', 'system/customervisit/index', NULL, 1, 0, 'C', '0', '0', 'system:customervisit:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '走访记录菜单');
INSERT INTO `sys_menu` VALUES (2061, '走访记录查询', 2060, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '走访记录新增', 2060, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '走访记录修改', 2060, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '走访记录删除', 2060, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '走访记录导出', 2060, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:customervisit:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2066, '出库', 3, 1, 'exwarehouse', 'system/exwarehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:exwarehouse:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '出库菜单');
INSERT INTO `sys_menu` VALUES (2067, '出库查询', 2066, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '出库新增', 2066, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '出库修改', 2066, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '出库删除', 2066, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '出库导出', 2066, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:exwarehouse:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '固定资产', 3, 1, 'fixedassets', 'system/fixedassets/index', NULL, 1, 0, 'C', '0', '0', 'system:fixedassets:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '固定资产菜单');
INSERT INTO `sys_menu` VALUES (2073, '固定资产查询', 2072, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2074, '固定资产新增', 2072, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2075, '固定资产修改', 2072, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2076, '固定资产删除', 2072, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2077, '固定资产导出', 2072, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fixedassets:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2078, '车队管理', 3, 1, 'fleet', 'system/fleet/index', NULL, 1, 0, 'C', '0', '0', 'system:fleet:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '车队管理菜单');
INSERT INTO `sys_menu` VALUES (2079, '车队管理查询', 2078, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2080, '车队管理新增', 2078, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2081, '车队管理修改', 2078, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2082, '车队管理删除', 2078, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2083, '车队管理导出', 2078, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:fleet:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2084, '订单', 3, 1, 'goodsorder', 'system/goodsorder/index', NULL, 1, 0, 'C', '0', '0', 'system:goodsorder:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '订单菜单');
INSERT INTO `sys_menu` VALUES (2085, '订单查询', 2084, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2086, '订单新增', 2084, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2087, '订单修改', 2084, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2088, '订单删除', 2084, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2089, '订单导出', 2084, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:goodsorder:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2090, '货物入库', 3, 1, 'inventory', 'system/inventory/index', NULL, 1, 0, 'C', '0', '0', 'system:inventory:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '货物入库菜单');
INSERT INTO `sys_menu` VALUES (2091, '货物入库查询', 2090, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2092, '货物入库新增', 2090, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2093, '货物入库修改', 2090, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2094, '货物入库删除', 2090, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2095, '货物入库导出', 2090, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:inventory:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2096, '资金借出（期货）', 3, 1, 'lendmoney', 'system/lendmoney/index', NULL, 1, 0, 'C', '0', '0', 'system:lendmoney:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '资金借出（期货）菜单');
INSERT INTO `sys_menu` VALUES (2097, '资金借出（期货）查询', 2096, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2098, '资金借出（期货）新增', 2096, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2099, '资金借出（期货）修改', 2096, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2100, '资金借出（期货）删除', 2096, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2101, '资金借出（期货）导出', 2096, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:lendmoney:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2102, '资金调整单信息', 3, 1, 'offsetting', 'system/offsetting/index', NULL, 1, 0, 'C', '0', '0', 'system:offsetting:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '资金调整单信息菜单');
INSERT INTO `sys_menu` VALUES (2103, '资金调整单信息查询', 2102, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2104, '资金调整单信息新增', 2102, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2105, '资金调整单信息修改', 2102, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2106, '资金调整单信息删除', 2102, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2107, '资金调整单信息导出', 2102, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:offsetting:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2108, '基础信息-加油卡主卡登记', 3, 1, 'oilcardmain', 'system/oilcardmain/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcardmain:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '基础信息-加油卡主卡登记菜单');
INSERT INTO `sys_menu` VALUES (2109, '基础信息-加油卡主卡登记查询', 2108, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '基础信息-加油卡主卡登记新增', 2108, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '基础信息-加油卡主卡登记修改', 2108, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '基础信息-加油卡主卡登记删除', 2108, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '基础信息-加油卡主卡登记导出', 2108, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcardmain:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '加油卡', 3, 1, 'oilcard', 'system/oilcard/index', NULL, 1, 0, 'C', '0', '0', 'system:oilcard:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '加油卡菜单');
INSERT INTO `sys_menu` VALUES (2115, '加油卡查询', 2114, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2116, '加油卡新增', 2114, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2117, '加油卡修改', 2114, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2118, '加油卡删除', 2114, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2119, '加油卡导出', 2114, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:oilcard:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '订单详情', 3, 1, 'orderdetail', 'system/orderdetail/index', NULL, 1, 0, 'C', '0', '0', 'system:orderdetail:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '订单详情菜单');
INSERT INTO `sys_menu` VALUES (2121, '订单详情查询', 2120, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '订单详情新增', 2120, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2123, '订单详情修改', 2120, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2124, '订单详情删除', 2120, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2125, '订单详情导出', 2120, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderdetail:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2126, '订单运费', 3, 1, 'orderfreight', 'system/orderfreight/index', NULL, 1, 0, 'C', '0', '0', 'system:orderfreight:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '订单运费菜单');
INSERT INTO `sys_menu` VALUES (2127, '订单运费查询', 2126, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2128, '订单运费新增', 2126, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2129, '订单运费修改', 2126, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, '订单运费删除', 2126, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, '订单运费导出', 2126, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderfreight:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, '订单发票', 3, 1, 'orderinvoice', 'system/orderinvoice/index', NULL, 1, 0, 'C', '0', '0', 'system:orderinvoice:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '订单发票菜单');
INSERT INTO `sys_menu` VALUES (2133, '订单发票查询', 2132, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2134, '订单发票新增', 2132, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2135, '订单发票修改', 2132, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2136, '订单发票删除', 2132, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2137, '订单发票导出', 2132, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:orderinvoice:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2138, '资产管理-收付款:收付款信息', 3, 1, 'payment', 'system/payment/index', NULL, 1, 0, 'C', '0', '0', 'system:payment:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '资产管理-收付款:收付款信息菜单');
INSERT INTO `sys_menu` VALUES (2139, '资产管理-收付款:收付款信息查询', 2138, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2140, '资产管理-收付款:收付款信息新增', 2138, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2141, '资产管理-收付款:收付款信息修改', 2138, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2142, '资产管理-收付款:收付款信息删除', 2138, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2143, '资产管理-收付款:收付款信息导出', 2138, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:payment:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2144, '产品级别管理', 3, 1, 'productlevel', 'system/productlevel/index', NULL, 1, 0, 'C', '0', '0', 'system:productlevel:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '产品级别管理菜单');
INSERT INTO `sys_menu` VALUES (2145, '产品级别管理查询', 2144, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2146, '产品级别管理新增', 2144, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2147, '产品级别管理修改', 2144, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2148, '产品级别管理删除', 2144, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2149, '产品级别管理导出', 2144, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:productlevel:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2150, '供应商返利', 3, 1, 'rebate', 'system/rebate/index', NULL, 1, 0, 'C', '0', '0', 'system:rebate:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '供应商返利菜单');
INSERT INTO `sys_menu` VALUES (2151, '供应商返利查询', 2150, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2152, '供应商返利新增', 2150, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2153, '供应商返利修改', 2150, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2154, '供应商返利删除', 2150, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2155, '供应商返利导出', 2150, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:rebate:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2156, '资金回收', 3, 1, 'recovermoney', 'system/recovermoney/index', NULL, 1, 0, 'C', '0', '0', 'system:recovermoney:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '资金回收菜单');
INSERT INTO `sys_menu` VALUES (2157, '资金回收查询', 2156, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2158, '资金回收新增', 2156, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2159, '资金回收修改', 2156, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2160, '资金回收删除', 2156, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2161, '资金回收导出', 2156, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:recovermoney:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2162, '还款记录', 3, 1, 'repayment', 'system/repayment/index', NULL, 1, 0, 'C', '0', '0', 'system:repayment:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '还款记录菜单');
INSERT INTO `sys_menu` VALUES (2163, '还款记录查询', 2162, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2164, '还款记录新增', 2162, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2165, '还款记录修改', 2162, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2166, '还款记录删除', 2162, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2167, '还款记录导出', 2162, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:repayment:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2168, '社保基金', 3, 1, 'socialinsurance', 'system/socialinsurance/index', NULL, 1, 0, 'C', '0', '0', 'system:socialinsurance:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '社保基金菜单');
INSERT INTO `sys_menu` VALUES (2169, '社保基金查询', 2168, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2170, '社保基金新增', 2168, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2171, '社保基金修改', 2168, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2172, '社保基金删除', 2168, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2173, '社保基金导出', 2168, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:socialinsurance:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2174, '仓库管理', 3, 1, 'storehouse', 'system/storehouse/index', NULL, 1, 0, 'C', '0', '0', 'system:storehouse:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '仓库管理菜单');
INSERT INTO `sys_menu` VALUES (2175, '仓库管理查询', 2174, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2176, '仓库管理新增', 2174, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2177, '仓库管理修改', 2174, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2178, '仓库管理删除', 2174, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2179, '仓库管理导出', 2174, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:storehouse:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2180, '变动日志信息', 3, 1, 'tableeditmessage', 'system/tableeditmessage/index', NULL, 1, 0, 'C', '0', '0', 'system:tableeditmessage:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '变动日志信息菜单');
INSERT INTO `sys_menu` VALUES (2181, '变动日志信息查询', 2180, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2182, '变动日志信息新增', 2180, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2183, '变动日志信息修改', 2180, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2184, '变动日志信息删除', 2180, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2185, '变动日志信息导出', 2180, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tableeditmessage:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2186, '虚拟银行账户变动信息', 3, 1, 'virtualbankaccountchange', 'system/virtualbankaccountchange/index', NULL, 1, 0, 'C', '0', '0', 'system:virtualbankaccountchange:list', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '虚拟银行账户变动信息菜单');
INSERT INTO `sys_menu` VALUES (2187, '虚拟银行账户变动信息查询', 2186, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:query', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2188, '虚拟银行账户变动信息新增', 2186, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:add', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2189, '虚拟银行账户变动信息修改', 2186, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:edit', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2190, '虚拟银行账户变动信息删除', 2186, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:remove', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2191, '虚拟银行账户变动信息导出', 2186, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:virtualbankaccountchange:export', '#', 'admin', '2024-07-19 10:53:23', '', NULL, '');

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
) ENGINE = InnoDB AUTO_INCREMENT = 150 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2024-07-19 10:12:49', '', NULL, '普通角色');

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
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_user` VALUES (1, NULL, 'admin', 'admin', '00', '', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2024-07-20 20:56:15', '', NULL, '', '2024-07-20 20:56:14', NULL, 'admin', 'admin', '1', '', '', '', '', '', '', '', '', '', 'asd', 'asd', 'asd', 'awsd', 'awd', 'awsda', 'awsd', 'awsd', 'awsd');

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
