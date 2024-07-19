/*
 Navicat Premium Data Transfer

 Source Server         : 订单系统
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44-log)
 Source Host           : 47.121.126.94:3306
 Source Schema         : orderdb

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44-log)
 File Encoding         : 65001

 Date: 19/07/2024 14:38:36
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
  `moneyAmount` float NULL DEFAULT 0 COMMENT '金额',
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
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
